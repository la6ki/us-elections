import numpy as np
from nonstationary_t_regression import *

class ElectionAnalysis(object):
    def __init__(self):
        self.t_regression = NonstationaryTRegression()

    def _get_date(self, date):
        days_in_month = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
        cumulative_days = [int(np.sum(days_in_month[0:index])) for index in range(0, len(days_in_month))]

        poll_day = date["day"]
        poll_month = date["month"]
        poll_day_of_year = poll_day + cumulative_days[poll_month - 1]
        normalized_date = poll_day_of_year / float(days_in_month[poll_month - 1])

        return normalized_date

    def _transform_state_polls(self, polls):
        state_data = {}

        fraction_voters_unsorted = {}
        sample_size_unsorted = {}
        dates_unsorted = {}
        candidates = []

        for poll in polls:
            percentages = poll["percentages"]
            sample = int(poll['sample'])
            date = self._get_date(poll["date"])

            for candidate in percentages:
                candidates.append(candidate)

                if not candidate in fraction_voters_unsorted:
                    fraction_voters_unsorted[candidate] = []
                if not candidate in sample_size_unsorted:
                    sample_size_unsorted[candidate] = []
                if not candidate in dates_unsorted:
                    dates_unsorted[candidate] = []

                fraction_voters_unsorted[candidate].append(percentages[candidate])
                sample_size_unsorted[candidate].append(sample)
                dates_unsorted[candidate].append(date)

        for candidate in candidates:
            dates_unsorted[candidate] = np.array(dates_unsorted[candidate])
            sorting_indices = np.argsort(dates_unsorted[candidate])

            fraction_voters = np.array(fraction_voters_unsorted[candidate])[sorting_indices] / 100.
            sample_size = np.array(sample_size_unsorted[candidate])[sorting_indices]
            dates = dates_unsorted[candidate][sorting_indices]
            candidate_voters = np.around(np.multiply(sample_size, fraction_voters))

            state_data[candidate] = {"number_voters": candidate_voters, "sample_size": sample_size,
                                     "training_time": dates, "fraction_voters": fraction_voters}

        return state_data

    def _transoform_polls(self, all_state_polls):
        data = {}

        for state in all_state_polls:
            data[state] = self._transform_state_polls(all_state_polls[state])

        return data

    def _get_candidate_results(self, target_time, polls, t_regression_parameters):
        results = self.t_regression.run_analysis(polls, target_time, t_regression_parameters)
        results["dates"] = polls["training_time"]
        results["number_voters"] = polls["number_voters"]
        results["fraction_voters"] = polls["fraction_voters"]

        return results

    def _get_results(self, polls, target_time, t_regression_parameters):
        analysis_results = {}

        for state in polls:
            analysis_results[state] = {}
            for candidate in polls[state]:
                candidate_polls = polls[state][candidate]
                candidate_results = self._get_candidate_results(target_time, candidate_polls, t_regression_parameters)
                analysis_results[state][candidate] = candidate_results

        return analysis_results

    def _sample_state_results(self, state_results, df, number_samples):
        sampled_probabilities = []

        for sample_number in range(0, number_samples):
            sample = {}

            normalizer = 0
            for candidate in state_results:
                mean_probability = float(state_results[candidate]["expectation"][-1])
                scale_probability = float(df - 2) / float(df) * float(state_results[candidate]["variance"][-1])
                sample[candidate] = mean_probability + np.sqrt(scale_probability) * np.random.standard_t(df)
                normalizer += sample[candidate]

            for candidate in sample:
                sample[candidate] /= normalizer
            sampled_probabilities.append(sample)

        return sampled_probabilities

    def _sample_results(self, analysis_results, sampling_df, number_samples):
        samples = {}

        for state in analysis_results:
            samples[state] = self._sample_state_results(analysis_results[state], sampling_df, number_samples)

        return samples

    def analyze_polls(self, all_state_polls, target_time_parameters, t_regression_parameters):
        polls = self._transoform_polls(all_state_polls)
        target_time = np.arange(target_time_parameters["start"], target_time_parameters["stop"],
                                target_time_parameters["step"])

        return self._get_results(polls, target_time, t_regression_parameters)

    def calculate_state_distributions(self, analysis_results, sampling_df, number_samples):
        state_distributions = {}

        sampled_data = self._sample_results(analysis_results, sampling_df, number_samples)
        for state in sampled_data:
            state_distributions[state] = {}
            state_samples = sampled_data[state]
            for sample in state_samples:
                if len(sample.keys()) > 0:
                    winner = max(sample, key=sample.get)
                    if not winner in state_distributions[state]:
                        state_distributions[state][winner] = 0
                    state_distributions[state][winner] += 1

        return state_distributions
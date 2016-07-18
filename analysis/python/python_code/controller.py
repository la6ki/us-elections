from election_analysis import *
from plot import *

class Controller(object):
    def __init__(self):
        self.plot = Plot()
        self.analysis = ElectionAnalysis()

    def process_input(self, input):
        target_time_parameters = input["parameters"]["target_time_parameters"]
        number_samples = input["parameters"]["number_samples"]
        t_regression_parameters = input["parameters"]["t_regression"]

        national_polls = input["data"]["national"]
        state_polls = input["data"]["state"]

        analysis_results = self.analysis.analyze_polls(state_polls, target_time_parameters, t_regression_parameters)
        self.plot.generate_plots(analysis_results, target_time_parameters)

        df = input["parameters"]["t_regression"]["df"]
        state_distributions = self.analysis.calculate_state_distributions(analysis_results, df, number_samples)

        return state_distributions
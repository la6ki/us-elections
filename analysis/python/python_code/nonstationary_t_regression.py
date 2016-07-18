import numpy as np
import scipy.special as special
from gp_tools import *

class NonstationaryTRegression(object):
    def __init__(self):
        self.rw_cov_function = lambda t1, t2, a, l: a ** 2 * (
            -l ** 2 - np.sqrt(2) * np.sqrt(np.pi) * l * (
                -np.sqrt(2) * l * np.exp(-t1 ** 2 / (2 * l ** 2)) / np.sqrt(np.pi) - t1 * special.erf(
                    np.sqrt(2) * t1 / (2 * l))) / 2 + np.sqrt(2) * np.sqrt(np.pi) * l * (
                np.sqrt(2) * l * np.exp(-t2 ** 2 / (2 * l ** 2)) / np.sqrt(np.pi) + t2 * special.erf(
                    np.sqrt(2) * t2 / (2 * l))) / 2 + np.sqrt(2) * np.sqrt(np.pi) * l * (
                -np.sqrt(2) * l * np.exp(-t1 ** 2 / (2 * l ** 2)) * np.exp(-t2 ** 2 / (2 * l ** 2)) * np.exp(
                    t1 * t2 / l ** 2) / np.sqrt(np.pi) - t1 * special.erf(
                    np.sqrt(2) * t1 / (2 * l) - np.sqrt(2) * t2 / (2 * l)) + t2 * special.erf(
                    np.sqrt(2) * t1 / (2 * l) - np.sqrt(2) * t2 / (2 * l))) / 2)
        self.const_cov_function = lambda t1, t2, a: a ** 2
        self.amp_prior = lambda a, scale, shape: (1/(special.gamma(scale)*scale**shape))*a**(shape - 1)*np.exp(-a/scale)
        self.ts_prior = lambda l: 1/l

        self.tools = GPTools()

    def _get_likelihoods(self, sample_size, prior_expectation):
        noise_covariance = prior_expectation * (1 - prior_expectation)*np.diag(sample_size)
        observation_model = np.diag(sample_size)

        return {"noise_covariance": np.matrix(noise_covariance), "observation_model": np.matrix(observation_model)}

    def _compute_marginal_likelihood(self, data, likelihoods, training_matrices, df, jitter):
        # Robustness check
        training_data = np.matrix(np.reshape(np.array(data), (len(data), 1)))
        number_training_points = len(training_matrices["expectation"])
        training_expectation_array = np.array(training_matrices["expectation"])
        training_expectation_reshaped = np.reshape(training_expectation_array, (number_training_points, 1))
        training_expectation = np.matrix(training_expectation_reshaped)
        training_covariance = np.matrix(training_matrices["covariance"])
        noise_covariance = likelihoods["noise_covariance"]
        observation_model = likelihoods["observation_model"]

        # Posterior computation
        cholesky_term_1 = observation_model * training_covariance * observation_model.T
        cholesky_argument = cholesky_term_1 + noise_covariance + jitter * np.identity(len(training_data))
        cholesky_factor = np.linalg.cholesky(cholesky_argument)

        solution = np.linalg.solve(cholesky_factor, (training_data - observation_model * training_expectation))
        modified_data = np.matrix(solution)
        data_variance = float(modified_data.T * modified_data)
        studenT_data_factor = np.log(1 + data_variance / (df - 2.))
        log_determinant = 2 * np.sum(np.log(np.diag(cholesky_factor)))
        log_marginal_likelihood = -0.5*log_determinant - 0.5*(df + len(modified_data))*studenT_data_factor

        return (log_marginal_likelihood)

    def _get_training_matrices(self, training_time, prior_expectation, cov_function):
        training_grid_x, training_grid_y = np.meshgrid(training_time, training_time)
        training_prior_covariance = np.matrix(cov_function(training_grid_x, training_grid_y))
        training_expectation = prior_expectation * np.ones(shape=(len(training_time), 1))

        return {
            "covariance": training_prior_covariance,
            "expectation": training_expectation
        }

    def _get_posterior_hyper_parameters(self, data, training_time, likelihoods, parameters):
        prior_expectation = parameters["prior_expectation"]
        df = parameters["df"]
        jitter = parameters["jitter"]["base"] ** parameters["jitter"]["exponent"]
        constant_amp = parameters["constant_amp"]
        prior_amp_shape = parameters["prior_amp_shape"]
        prior_amp_scale = parameters["prior_amp_scale"]
        amp_range = parameters["amp_range"]["base"] ** np.arange(parameters["amp_range"]["exponent_start"],
                                                                 parameters["amp_range"]["exponent_stop"],
                                                                 parameters["amp_range"]["exponent_step"])
        ts_range = np.arange(parameters["ts_range"]["start"], parameters["ts_range"]["stop"],
                             parameters["ts_range"]["step"])

        # Compute marginal likelihood
        log_likelihoods = []
        for ts in ts_range:
            likelihood_row = []
            for amp in amp_range:
                cov_function = self._get_cov_function(amp, ts, constant_amp)
                training_matrices = self._get_training_matrices(training_time, prior_expectation, cov_function)

                log_likelihood = self._compute_marginal_likelihood(data, likelihoods, training_matrices, df, jitter)
                log_ts_prior = np.log(self.ts_prior(ts))
                log_amp_prior = np.log(
                    self.amp_prior(amp, prior_amp_scale, prior_amp_shape))
                likelihood_row.append(log_likelihood + log_ts_prior + log_amp_prior)

            log_likelihoods.append(likelihood_row)
        log_likelihoods = np.array(log_likelihoods)

        # Normalize posterior
        alpha = np.max(log_likelihoods)
        probability = np.exp(log_likelihoods - alpha)/np.sum(np.exp(log_likelihoods - alpha))

        # Compute posterior expectations
        amp_mass = np.multiply(probability, amp_range)
        ts_mass = np.transpose(np.multiply(np.transpose(probability), np.transpose(ts_range)))

        amp = np.sum(np.sum(amp_mass, 0), 0)
        ts = np.sum(np.sum(ts_mass, 0), 0)

        return {"amp": amp, "ts": ts, "probability": probability}

    def _get_cov_function(self, amp, ts, constant_amp):
        return lambda t1, t2: self.const_cov_function(t1, t2, constant_amp) + self.rw_cov_function(t1, t2, amp, ts)

    def _get_prior_matrices(self, training_time, target_time, prior_expectation, cov_function):
        # Time difference matrices
        training_grid_x, training_grid_y = np.meshgrid(training_time, training_time)
        target_grid_x, target_grid_y = np.meshgrid(target_time, target_time)
        extrapolation_grid_x, extrapolation_grid_y = np.meshgrid(target_time, training_time)

        # Covariance matrices
        training_prior_covariance = np.matrix(cov_function(training_grid_x, training_grid_y))
        target_prior_covariance = np.matrix(cov_function(target_grid_x, target_grid_y))
        extrapolation_covariance = np.matrix(cov_function(extrapolation_grid_x, extrapolation_grid_y))

        # Expectations
        training_expectation = prior_expectation*np.ones(shape = (len(training_time),1))
        target_expectation = prior_expectation*np.ones(shape = (len(target_time),1))

        return {
            "training_covariance": training_prior_covariance,
            "target_covariance": target_prior_covariance,
            "extrapolation_covariance": extrapolation_covariance,
            "training_expectation": training_expectation,
            "target_expectation": target_expectation
        }

    def _studentT_regression(self, data, likelihoods, prior_matrices, df):
        # Robustness check
        training_data = np.matrix(np.reshape(np.array(data), (len(data), 1)))
        target_covariance = np.matrix(prior_matrices["target_covariance"])
        extrapolation_covariance = np.matrix(prior_matrices["extrapolation_covariance"])
        training_covariance = np.matrix(prior_matrices["training_covariance"])
        noise_covariance = likelihoods["noise_covariance"]
        observation_model = likelihoods["observation_model"]

        # Posterior computation
        GP_posterior = self.tools.GP_regression(prior_matrices["training_expectation"],
                                                prior_matrices["target_expectation"], training_covariance,
                                                target_covariance, extrapolation_covariance, noise_covariance,
                                                observation_model, training_data)
        demeaned_data = training_data - observation_model * prior_matrices["training_expectation"]
        data_variance = float(demeaned_data.T * self.tools.matrix_division(
            divider=observation_model * training_covariance * observation_model.T + noise_covariance,
            divided=demeaned_data,
            side="left", cholesky="yes"))
        scaling_factor = (df - 2. + data_variance) / (df - 2. + len(training_data))

        posterior_expectation = GP_posterior["posterior_expectation"]
        posterior_covariance = scaling_factor * GP_posterior["posterior_covariance"]
        return {"expectation": posterior_expectation, "covariance": posterior_covariance}

    def run_analysis(self, polls, target_time, parameters):
        number_voters = polls["number_voters"]
        sample_size = polls["sample_size"]
        training_time = polls["training_time"]
        df = parameters["df"]
        prior_expectation = parameters["prior_expectation"]
        constant_amp = parameters["constant_amp"]

        likelihoods = self._get_likelihoods(sample_size, prior_expectation)
        hyper_parameters = self._get_posterior_hyper_parameters(number_voters, training_time, likelihoods, parameters)
        cov_function = self._get_cov_function(hyper_parameters["amp"], hyper_parameters["ts"], constant_amp)
        prior_matrices = self._get_prior_matrices(training_time, target_time, prior_expectation, cov_function)
        results = self._studentT_regression(number_voters, likelihoods, prior_matrices, df)

        return {
            "expectation": results["expectation"],
            "variance": np.diag(results["covariance"]),
            "hyper_posterior_probability": hyper_parameters["probability"]
        }
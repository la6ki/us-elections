import numpy as np

class GPTools(object):
    def __init__(self):
        identity = "GP_tools"

    def matrix_division(self, divider, divided, side, cholesky):
        X = np.matrix(divided)

        if cholesky is "yes":
            M = np.matrix(np.linalg.cholesky(divider))
            if side is "right":
                first_division = np.linalg.solve(M,X.T).T
                return np.linalg.solve(M.T,first_division.T).T
            elif side is "left":
                first_division = np.linalg.solve(M,X)
                return np.linalg.solve(M.T,first_division)
            else:
                print "The side should be either left or right"
                return

        M = np.matrix(divider)
        if side is "right":
            return np.linalg.solve(M.T, X.T).T
        elif side is "left":
            return np.linalg.solve(M, X)

        print "The side should be either left or right"

    def GP_regression(self, training_mean, target_mean, training_covariance, target_covariance, extrapolation_covariance, noise_covariance, observation_model, training_data):
        # Robustness check
        number_training_points = len(training_data)
        training_data_arr = np.array(training_data)
        training_data_reshaped = np.reshape(training_data_arr, (number_training_points,1))
        training_data = np.matrix(training_data_reshaped)

        target_covariance = np.matrix(target_covariance)
        extrapolation_covariance = np.matrix(extrapolation_covariance)
        training_covariance = np.matrix(training_covariance)
        noise_covariance = np.matrix(noise_covariance)
        observation_model = np.matrix(observation_model)

        # Posterior computation
        divider = observation_model*training_covariance*observation_model.T + noise_covariance
        divided = extrapolation_covariance.T * observation_model.T
        filter_matrix = self.matrix_division(divider, divided, side = "right", cholesky = "yes")

        posterior_expectation = target_mean + filter_matrix*(training_data - observation_model*training_mean)
        posterior_covariance = target_covariance - filter_matrix*observation_model*extrapolation_covariance

        # Return results
        return {"posterior_expectation": posterior_expectation, "posterior_covariance": posterior_covariance}
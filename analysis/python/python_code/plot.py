import os, time
import matplotlib.pyplot as plt
import numpy as np

PLOTS_FOLDER_PATH = "../../../www/plots/"
PLOT_FILE_EXTENSION = "png"
PLOT_X_LIM_LOW = 0
PLOT_X_LIM_HIGH = 11.27
PLOT_FILL_ALPHA = 0.2
STATE_ABBREVIATIONS = {
    'Alaska': 'ak',
    'Delaware': 'de',
    'District of Columbia': 'dc',
    'Montana': 'mt',
    'North Dakota': 'nd',
    'South Dakota': 'sd',
    'Vermont': 'vt',
    'Wyoming': 'wy',
    'Hawaii': 'hi',
    'Idaho': 'id',
    'Maine': 'me',
    'New Hampshire': 'nh',
    'Rhode Island': 'ri',
    'Nebraska': 'ne',
    'New Mexico': 'nm',
    'West Virginia': 'wv',
    'Arkansas': 'ar',
    'Iowa': 'ia',
    'Kansas': 'ks',
    'Mississippi': 'ms',
    'Nevada': 'nv',
    'Utah': 'ut',
    'Connecticut': 'ct',
    'Oklahoma': 'ok',
    'Oregon': 'or',
    'Kentucky': 'ky',
    'Louisiana': 'la',
    'Alabama': 'al',
    'Colorado': 'co',
    'South Carolina': 'sc',
    'Maryland': 'md',
    'Minnesota': 'mn',
    'Missouri': 'mo',
    'Wisconsin': 'wi',
    'Arizona': 'az',
    'Indiana': 'in',
    'Massachusetts': 'ma',
    'Tennessee': 'tn',
    'Washington': 'wa',
    'Virginia': 'va',
    'New Jersey': 'nj',
    'North Carolina': 'nc',
    'Georgia': 'ga',
    'Michigan': 'mi',
    'Ohio': 'oh',
    'Illinois': 'il',
    'Pennsylvania': 'pa',
    'Florida': 'fl',
    'New York': 'ny',
    'Texas': 'tx',
    'California': 'ca'
}

class Plot(object):
    def __init__(self):
        identity = "Plotting tools"

    def _create_folder(self, path):
        if not os.path.exists(path):
            os.makedirs(path)

    def _save_plot(self, data, target_time, file_path):
        expectation_raw = data["expectation"]
        expectation = np.array(expectation_raw).flatten()
        expectation_sd = np.sqrt(np.array(np.diag(data["expectation"]))).flatten()
        sd_low_bound = expectation - expectation_sd
        sd_high_bound = expectation + expectation_sd

        plt.plot(target_time, expectation)
        plt.fill_between(target_time, sd_low_bound, sd_high_bound, alpha=PLOT_FILL_ALPHA)
        plt.scatter(data["dates"], data["fraction_voters"], c=data["number_voters"])
        plt.xlim([PLOT_X_LIM_LOW, PLOT_X_LIM_HIGH])
        plt.colorbar()

        plt.savefig(file_path)
        plt.clf()

    def _get_plot_file_path(self, state, candidate):
        date = time.strftime("%m-%d-%y")
        state_lc = state.lower().replace(" ", "-")
        state_path = PLOTS_FOLDER_PATH + state_lc + "/" + date
        state_abr = STATE_ABBREVIATIONS[state]
        file_name = candidate.lower() + "-" + state_abr + "-" + date + "." + PLOT_FILE_EXTENSION

        return state_path + "/" + file_name

    def _get_plot_state_path(self, state):
        date = time.strftime("%m-%d-%y")
        state_lc = state.lower().replace(" ", "-")

        return PLOTS_FOLDER_PATH + state_lc + "/" + date

    def generate_plots(self, results, target_time_parameters):
        target_time = np.arange(target_time_parameters["start"], target_time_parameters["stop"],
                                target_time_parameters["step"])

        for state in results:
            state_path = self._get_plot_state_path(state)
            self._create_folder(state_path)
            for candidate in results[state]:
                file_path = self._get_plot_file_path(state, candidate)
                self._save_plot(results[state][candidate], target_time, file_path)
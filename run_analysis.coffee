pollAnalysis = require './analysis/analyze_polls'

#election simulation parameters
NUM_SIMULATION_RUNS = 100000

#python parameters
NUMBER_SAMPLES = 10000

SAMPLING_DF = 4
START_TIME = 0
STOP_TIME = 11.27
STEP = 0.2

JITTER_BASE = 10
JITTER_EXPONENT = -8

PRIOR_EXPECTATION = 0.5

CONSTANT_AMPLITUDE = 0.1
PRIOR_AMPLITUDE_SHAPE = 1
PRIOR_AMPLITUDE_SCALE = 0.01

AMPLITUDE_RANGE_BASE = 10
AMPLITUDE_RANGE_EXPONENT_START = -3
AMPLITUDE_RANGE_EXPONENT_STOP = -1
AMPLITUDE_RANGE_EXPONENT_STEP = 0.1

TIME_SCALE_RANGE_START = 1
TIME_SCALE_RANGE_STOP = 6
TIME_SCALE_RANGE_STEP = 0.1

pollAnalysis.analyze
  numberOfSimulations: NUM_SIMULATION_RUNS
  pythonParameters:
    number_samples: NUMBER_SAMPLES
    target_time_parameters:
      start: START_TIME, stop: STOP_TIME, step: STEP
    t_regression:
      df: SAMPLING_DF
      jitter: base: JITTER_BASE, exponent: JITTER_EXPONENT
      prior_expectation: PRIOR_EXPECTATION
      constant_amp: CONSTANT_AMPLITUDE
      prior_amp_shape: PRIOR_AMPLITUDE_SHAPE
      prior_amp_scale: PRIOR_AMPLITUDE_SCALE
      amp_range:
        base: AMPLITUDE_RANGE_BASE
        exponent_start: AMPLITUDE_RANGE_EXPONENT_START
        exponent_stop: AMPLITUDE_RANGE_EXPONENT_STOP
        exponent_step: AMPLITUDE_RANGE_EXPONENT_STEP
      ts_range:
        start: TIME_SCALE_RANGE_START
        stop: TIME_SCALE_RANGE_STOP
        step: TIME_SCALE_RANGE_STEP

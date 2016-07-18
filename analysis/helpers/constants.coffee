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

exports.analysisParameters =
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

exports.candidates = ["Trump", "Clinton", "Johnson", "Stein"]

exports.dbCollections = [
  'national_polls'
  'state_polls'
  'state_distributions'
  'results'
]

exports.statePollURLs2012 =
  'Alaska': 'http://www.realclearpolitics.com/epolls/2012/president/ak/alaska_romney_vs_obama-3365.html#polls'
  'Delaware': 'http://www.realclearpolitics.com/epolls/2012/president/de/delaware_romney_vs_obama-3387.html#polls'
  'District of Columbia': 'http://www.realclearpolitics.com/epolls/2012/president/dc/district_of_columbia_romney_vs_obama-3419.html#polls'
  'Montana': 'http://www.realclearpolitics.com/epolls/2012/president/mt/montana_romney_vs_obama-1780.html#polls'
  'North Dakota': 'http://www.realclearpolitics.com/epolls/2012/president/nd/north_dakota_romney_vs_obama-3238.html#polls'
  'South Dakota': 'http://www.realclearpolitics.com/epolls/2012/president/sd/south_dakota_romney_vs_obama-1980.html#polls'
  'Vermont': 'http://www.realclearpolitics.com/epolls/2012/president/vt/vermont_romney_vs_obama-2880.html#polls'
  'Wyoming': 'http://www.realclearpolitics.com/epolls/2012/president/wy/wyoming_romney_vs_obama-3389.html#polls'
  'Hawaii': 'http://www.realclearpolitics.com/epolls/2012/president/hi/hawaii_romney_vs_obama-2954.html#polls'
  'Idaho': 'http://www.realclearpolitics.com/epolls/2012/president/id/idaho_romney_vs_obama-3388.html#polls'
  'Maine': 'http://www.realclearpolitics.com/epolls/2012/president/me/maine_romney_vs_obama-2097.html#polls'
  'New Hampshire': 'http://www.realclearpolitics.com/epolls/2012/president/nh/new_hampshire_romney_vs_obama-2030.html#polls'
  'Rhode Island': 'http://www.realclearpolitics.com/epolls/2012/president/ri/rhode_island_romney_vs_obama-2072.html#polls'
  'Nebraska': 'http://www.realclearpolitics.com/epolls/2012/president/ne/nebraska_romney_vs_obama-1976.html#polls'
  'New Mexico': 'http://www.realclearpolitics.com/epolls/2012/president/nm/new_mexico_romney_vs_obama-2027.html#polls'
  'West Virginia': 'http://www.realclearpolitics.com/epolls/2012/president/wv/west_virginia_romney_vs_obama-1970.html#polls'
  'Arkansas': 'http://www.realclearpolitics.com/epolls/2012/president/ar/arkansas_romney_vs_obama-2918.html#polls'
  'Iowa': 'http://www.realclearpolitics.com/epolls/2012/president/ia/iowa_romney_vs_obama-1922.html#polls'
  'Kansas': 'http://www.realclearpolitics.com/epolls/2012/president/ar/arkansas_romney_vs_obama-2918.html#polls'
  'Mississippi': 'http://www.realclearpolitics.com/epolls/2012/president/ms/mississippi_romney_vs_obama-2122.html#polls'
  'Nevada': 'http://www.realclearpolitics.com/epolls/2012/president/nv/nevada_romney_vs_obama-1908.html#polls'
  'Utah': 'http://www.realclearpolitics.com/epolls/2012/president/ut/utah_romney_vs_obama-1763.html#polls'
  'Connecticut': 'http://www.realclearpolitics.com/epolls/2012/president/ct/connecticut_romney_vs_obama-2906.html#polls'
  'Oklahoma': 'http://www.realclearpolitics.com/epolls/2012/president/ok/oklahoma_romney_vs_obama-3215.html#polls'
  'Oregon': 'http://www.realclearpolitics.com/epolls/2012/president/or/oregon_romney_vs_obama-2749.html#polls'
  'Kentucky': 'http://www.realclearpolitics.com/epolls/2012/president/ky/kentucky_romney_vs_obama-2889.html#polls'
  'Louisiana': 'http://www.realclearpolitics.com/epolls/2012/president/la/louisiana_romney_vs_obama-2942.html#polls'
  'Alabama': 'http://www.realclearpolitics.com/epolls/2012/president/al/alabama_romney_vs_obama-3364.html#polls'
  'Colorado': 'http://www.realclearpolitics.com/epolls/2012/president/co/colorado_romney_vs_obama-2023.html#polls'
  'South Carolina': 'http://www.realclearpolitics.com/epolls/2012/president/sc/south_carolina_romney_vs_obama-1999.html#polls'
  'Maryland': 'http://www.realclearpolitics.com/epolls/2012/president/md/maryland_romney_vs_obama-3218.html#polls'
  'Minnesota': 'http://www.realclearpolitics.com/epolls/2012/president/mn/minnesota_romney_vs_obama-1823.html#polls'
  'Missouri': 'http://www.realclearpolitics.com/epolls/2012/president/mo/missouri_romney_vs_obama-1800.html#polls'
  'Wisconsin': 'http://www.realclearpolitics.com/epolls/2012/president/wi/wisconsin_romney_vs_obama-1871.html#polls'
  'Arizona': 'http://www.realclearpolitics.com/epolls/2012/president/az/arizona_romney_vs_obama-1757.html#polls'
  'Indiana': 'http://www.realclearpolitics.com/epolls/2012/president/in/indiana_romney_vs_obama-3167.html#polls'
  'Massachusetts': 'http://www.realclearpolitics.com/epolls/2012/president/ma/massachusetts_romney_vs_obama-1804.html#polls'
  'Tennessee': 'http://www.realclearpolitics.com/epolls/2012/president/tn/tennessee_romney_vs_obama-2047.html#polls'
  'Washington': 'http://www.realclearpolitics.com/epolls/2012/president/wa/washington_romney_vs_obama-2708.html#polls'
  'Virginia': 'http://www.realclearpolitics.com/epolls/2012/president/va/virginia_romney_vs_obama-1774.html#polls'
  'New Jersey': 'http://www.realclearpolitics.com/epolls/2012/president/nj/new_jersey_romney_vs_obama-1912.html#polls'
  'North Carolina': 'http://www.realclearpolitics.com/epolls/2012/president/nc/north_carolina_romney_vs_obama-1784.html#polls'
  'Georgia': 'http://www.realclearpolitics.com/epolls/2012/president/ga/georgia_romney_vs_obama-2150.html#polls'
  'Michigan': 'http://www.realclearpolitics.com/epolls/2012/president/mi/michigan_romney_vs_obama-1811.html#polls'
  'Ohio': 'http://www.realclearpolitics.com/epolls/2012/president/oh/ohio_romney_vs_obama-1860.html#polls'
  'Illinois': 'http://www.realclearpolitics.com/epolls/2012/president/il/illinois_romney_vs_obama-2955.html#polls'
  'Pennsylvania': 'http://www.realclearpolitics.com/epolls/2012/president/pa/pennsylvania_romney_vs_obama-1891.html#polls'
  'Florida': 'http://www.realclearpolitics.com/epolls/2012/president/fl/florida_romney_vs_obama-1883.html#polls'
  'New York': 'http://www.realclearpolitics.com/epolls/2012/president/ny/new_york_romney_vs_obama-2868.html#polls'
  'Texas': 'http://www.realclearpolitics.com/epolls/2012/president/tx/texas_romney_vs_obama-1945.html#polls'
  'California': 'http://www.realclearpolitics.com/epolls/2012/president/ca/california_romney_vs_obama-2009.html#polls'

exports.statePollURLs2016 =
  'Alaska': 'http://www.realclearpolitics.com/epolls/2016/president/ak/alaska_trump_vs_clinton-5884.html#polls'
  'Delaware': 'http://www.realclearpolitics.com/epolls/2016/president/de/delaware_trump_vs_clinton-5900.html#polls'
  'District of Columbia': 'http://www.realclearpolitics.com/epolls/2016/president/dc/district_of_columbia_trump_vs_clinton-5901.html#polls'
  'Montana': 'http://www.realclearpolitics.com/epolls/2016/president/mt/montana_trump_vs_clinton-5893.html#polls'
  'North Dakota': 'http://www.realclearpolitics.com/epolls/2016/president/nd/north_dakota_trump_vs_clinton-5907.html#polls'
  'South Dakota': 'http://www.realclearpolitics.com/epolls/2016/president/sd/south_dakota_trump_vs_clinton-5910.html#polls'
  'Vermont': 'http://www.realclearpolitics.com/epolls/2016/president/vt/vermont_trump_vs_clinton-5912.html#polls'
  'Wyoming': 'http://www.realclearpolitics.com/epolls/2016/president/wy/wyoming_trump_vs_clinton-5913.html#polls'
  'Hawaii': 'http://www.realclearpolitics.com/epolls/2016/president/hi/hawaii_trump_vs_clinton-5902.html#polls'
  'Idaho': 'http://www.realclearpolitics.com/epolls/2016/president/id/idaho_trump_vs_clinton-5903.html#polls'
  'Maine': 'http://www.realclearpolitics.com/epolls/2016/president/me/maine_trump_vs_clinton-5896.html#polls'
  'New Hampshire': 'http://www.realclearpolitics.com/epolls/2016/president/nh/new_hampshire_trump_vs_clinton-5596.html#polls'
  'Rhode Island': 'http://www.realclearpolitics.com/epolls/2016/president/ri/rhode_island_trump_vs_clinton-5909.html#polls'
  'Nebraska': 'http://www.realclearpolitics.com/epolls/2016/president/ne/nebraska_trump_vs_clinton-5905.html#polls'
  'New Mexico': 'http://www.realclearpolitics.com/epolls/2016/president/nm/new_mexico_trump_vs_clinton-5894.html#polls'
  'West Virginia': 'http://www.realclearpolitics.com/epolls/2016/president/wv/west_virginia_trump_vs_clinton-5885.html#polls'
  'Arkansas': 'http://www.realclearpolitics.com/epolls/2016/president/ar/arkansas_trump_vs_clinton-5899.html#polls'
  'Iowa': 'http://www.realclearpolitics.com/epolls/2016/president/ia/iowa_trump_vs_clinton-5597.html#polls'
  'Kansas': 'http://www.realclearpolitics.com/epolls/2016/president/ar/arkansas_trump_vs_clinton-5899.html#polls'
  'Mississippi': 'http://www.realclearpolitics.com/epolls/2016/president/ms/mississippi_trump_vs_clinton-5857.html#polls'
  'Nevada': 'http://www.realclearpolitics.com/epolls/2016/president/nv/nevada_trump_vs_clinton-5891.html#polls'
  'Utah': 'http://www.realclearpolitics.com/epolls/2016/president/ut/utah_trump_vs_clinton-5834.html#polls'
  'Connecticut': 'http://www.realclearpolitics.com/epolls/2016/president/ct/connecticut_trump_vs_clinton-5720.html#polls'
  'Oklahoma': 'http://www.realclearpolitics.com/epolls/2016/president/ok/oklahoma_trump_vs_clinton-5908.html#polls'
  'Oregon': 'http://www.realclearpolitics.com/epolls/2016/president/or/oregon_trump_vs_clinton-5892.html#polls'
  'Kentucky': 'http://www.realclearpolitics.com/epolls/2016/president/ky/kentucky_trump_vs_clinton-5523.html'
  'Louisiana': 'http://www.realclearpolitics.com/epolls/2016/president/la/louisiana_trump_vs_clinton-5696.html#polls'
  'Alabama': 'http://www.realclearpolitics.com/epolls/2016/president/al/alabama_trump_vs_clinton-5898.html#polls'
  'Colorado': 'http://www.realclearpolitics.com/epolls/2016/president/co/colorado_trump_vs_clinton-5751.html#polls'
  'South Carolina': 'http://www.realclearpolitics.com/epolls/2016/president/sc/south_carolina_trump_vs_clinton-5748.html#polls'
  'Maryland': 'http://www.realclearpolitics.com/epolls/2016/president/md/maryland_trump_vs_clinton-5859.html#polls'
  'Minnesota': 'http://www.realclearpolitics.com/epolls/2016/president/mn/minnesota_trump_vs_clinton-5591.html#polls'
  'Missouri': 'http://www.realclearpolitics.com/epolls/2016/president/mo/missouri_trump_vs_clinton-5609.html#polls'
  'Wisconsin': 'http://www.realclearpolitics.com/epolls/2016/president/wi/wisconsin_trump_vs_clinton-5659.html#polls'
  'Arizona': 'http://www.realclearpolitics.com/epolls/2016/president/az/arizona_trump_vs_clinton-5832.html#polls'
  'Indiana': 'http://www.realclearpolitics.com/epolls/2016/president/in/indiana_trump_vs_clinton-5878.html#polls'
  'Massachusetts': 'http://www.realclearpolitics.com/epolls/2016/president/ma/massachusetts_trump_vs_clinton-5863.html#polls'
  'Tennessee': 'http://www.realclearpolitics.com/epolls/2016/president/tn/tennessee_trump_vs_clinton-5911.html#polls'
  'Washington': 'http://www.realclearpolitics.com/epolls/2016/president/wa/washington_trump_vs_clinton-5895.html#polls'
  'Virginia': 'http://www.realclearpolitics.com/epolls/2016/president/va/virginia_trump_vs_clinton-5542.html#polls'
  'New Jersey': 'http://www.realclearpolitics.com/epolls/2016/president/nj/new_jersey_trump_vs_clinton-5872.html#polls'
  'North Carolina': 'http://www.realclearpolitics.com/epolls/2016/president/nc/north_carolina_trump_vs_clinton-5538.html#polls'
  'Georgia': 'http://www.realclearpolitics.com/epolls/2016/governor/ga/georgia_trump_vs_clinton-5741.html#polls'
  'Michigan': 'http://www.realclearpolitics.com/epolls/2016/president/mi/michigan_trump_vs_clinton-5533.html#polls'
  'Ohio': 'http://www.realclearpolitics.com/epolls/2016/president/oh/ohio_trump_vs_clinton-5634.html#polls'
  'Illinois': 'http://www.realclearpolitics.com/epolls/2016/president/il/illinois_trump_vs_clinton-5583.html#polls'
  'Pennsylvania': 'http://www.realclearpolitics.com/epolls/2016/president/pa/pennsylvania_trump_vs_clinton-5633.html#polls'
  'Florida': 'http://www.realclearpolitics.com/epolls/2016/president/fl/florida_trump_vs_clinton-5635.html#polls'
  'New York': 'http://www.realclearpolitics.com/epolls/2016/president/ny/new_york_trump_vs_clinton-5792.html#polls'
  'Texas': 'http://www.realclearpolitics.com/epolls/2016/president/tx/texas_trump_vs_clinton-5694.html#polls'
  'California': 'http://www.realclearpolitics.com/epolls/2016/president/ca/california_trump_vs_clinton-5849.html#polls'

exports.nationalPollURLs =
  '2-way': "http://www.realclearpolitics.com/epolls/2016/president/us/general_election_trump_vs_clinton-5491.html#polls"
  '3-way': "http://www.realclearpolitics.com/epolls/2016/president/us/general_election_trump_vs_clinton_vs_johnson-5949.html#polls"
  '4-way': "http://www.realclearpolitics.com/epolls/2016/president/us/general_election_trump_vs_clinton_vs_johnson_vs_stein-5952.html#polls"

exports.states = [
  'Alaska'
  'Delaware'
  'District of Columbia'
  'Montana'
  'North Dakota'
  'South Dakota'
  'Vermont'
  'Wyoming'
  'Hawaii'
  'Idaho'
  'Maine'
  'New Hampshire'
  'Rhode Island'
  'Nebraska'
  'New Mexico'
  'West Virginia'
  'Arkansas'
  'Iowa'
  'Kansas'
  'Mississippi'
  'Nevada'
  'Utah'
  'Connecticut'
  'Oklahoma'
  'Oregon'
  'Kentucky'
  'Louisiana'
  'Alabama'
  'Colorado'
  'South Carolina'
  'Maryland'
  'Minnesota'
  'Missouri'
  'Wisconsin'
  'Arizona'
  'Indiana'
  'Massachusetts'
  'Tennessee'
  'Washington'
  'Virginia'
  'New Jersey'
  'North Carolina'
  'Georgia'
  'Michigan'
  'Ohio'
  'Illinois'
  'Pennsylvania'
  'Florida'
  'New York'
  'Texas'
  'California'
]

exports.stateDelegates =
  'Alaska': 3
  'Delaware': 3
  'District of Columbia': 3
  'Montana': 3
  'North Dakota': 3
  'South Dakota': 3
  'Vermont': 3
  'Wyoming': 3
  'Hawaii': 4
  'Idaho': 4
  'Maine': 4
  'New Hampshire': 4
  'Rhode Island': 4
  'Nebraska': 5
  'New Mexico': 5
  'West Virginia': 5
  'Arkansas': 6
  'Iowa': 6
  'Kansas': 6
  'Mississippi': 6
  'Nevada': 6
  'Utah': 6
  'Connecticut': 7
  'Oklahoma': 7
  'Oregon': 7
  'Kentucky': 8
  'Louisiana': 8
  'Alabama': 9
  'Colorado': 9
  'South Carolina': 9
  'Maryland': 10
  'Minnesota': 10
  'Missouri': 10
  'Wisconsin': 10
  'Arizona': 11
  'Indiana': 11
  'Massachusetts': 11
  'Tennessee': 11
  'Washington': 12
  'Virginia': 13
  'New Jersey': 14
  'North Carolina': 15
  'Georgia': 16
  'Michigan': 16
  'Ohio': 18
  'Illinois': 20
  'Pennsylvania': 20
  'Florida': 29
  'New York': 29
  'Texas': 38
  'California': 55
import sys, json
from python_code.controller import *

controller = Controller()

def read_in():
    lines = sys.stdin.readlines()
    return json.loads(lines[0])

def handle_node_input(input):
    output = controller.process_input(input)
    send_to_node(output, "data")

def send_to_node(data, type):
    output = {}
    output["data"] = data
    output["type"] = type
    output_json = json.dumps(output)
    print(output_json)

input = read_in()
handle_node_input(input)
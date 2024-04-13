import json
from Levenshtein import distance


def read_json(file_name):
    with open(file_name, 'r') as file:
        return json.load(file)


def find_similar_string(target, string_list):
    min_distance = float('inf')
    most_similar = None
    for string in string_list:
        dist = distance(target, string)
        if dist < min_distance:
            min_distance = dist
            most_similar = string
    return most_similar

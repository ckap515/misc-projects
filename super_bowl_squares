#!/bin/sh

#  Script.sh
#  squares
#
#  Created by craig kaplan on 2/4/17.
#
### For running in IPython Notebook

import random

def assign_squares(players=['player1', 'player2', 'player3', 'player4', 'player5']):
    all_combinations = [[x,y] for x in range(10) for y in range(10)]
    assigned_squares = {}
    assigned_numbers = {}
    for player in players:
        assigned_squares[player] = []
        for square in range(100/len(players)):
            assigned_squares[player].append(all_combinations.pop(random.randint(0,(len(all_combinations)-1))))
        assigned_squares[player] = sorted(assigned_squares[player])
        for pair in assigned_squares[player]:
            assigned_numbers[str(pair[0]) + str(pair[1])] = player
    return assigned_numbers


### For running in terminal

import random

def assign_squares(players=['player1', 'player2', 'player3', 'player4', 'player5']):
    all_combinations = [[x,y] for x in range(10) for y in range(10)]
    assigned_squares = {}
    assigned_numbers = {}
    for player in players:
        assigned_squares[player] = []
        for square in range(100/len(players)):
            assigned_squares[player].append(all_combinations.pop(random.randint(0,(len(all_combinations)-1))))
        assigned_squares[player] = sorted(assigned_squares[player])
        for pair in assigned_squares[player]:
            assigned_numbers[str(pair[0]) + str(pair[1])] = player
    for pair in sorted(assigned_numbers):
        print pair + ': ' + assigned_numbers[pair]
    return assigned_numbers

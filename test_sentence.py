import nltk
import json
import yaml
from random import choice
from stat_parser import Parser, display_tree
parser = Parser()
d = json.load(open('tree_ship_words.json'))
f = open("ships.yml")
ships = yaml.load(f.read())
name = choice(ships)
print name.lower()
#tree = parser.parse("Anticipation of a new lover's arrival")
tree = parser.parse("they had good pretzels")
display_tree(tree)

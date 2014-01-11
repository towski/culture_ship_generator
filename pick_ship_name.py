import nltk
import json
import yaml
from random import choice
from stat_parser import Parser, display_tree
parser = Parser()
d = json.load(open('tree_ship_words.json'))
f = open("ships.yml")
ships = yaml.load(f.read())

keywords = {}
keys = []

def is_leaf(tree):
  if len(tree.leaves()) == 1:
    return True
  else:
    return False

def check_for_roll(tree):
  leaves = list(tree)
  key = ""
  words = []
  for leaf in leaves:
    if is_leaf(leaf):
      bottom = leaf
      while type(bottom) not in [str, unicode]:
        leaf = bottom
        bottom = list(leaf)[0]
      key += leaf.node
      words.append(leaf.leaves()[0])
    else: #roll is broken
      keys.append(key)
      keywords[key] = " ".join(words)
      key = ""
      words = []
      check_for_roll(leaf)
  if key != "":
    keys.append(key)
    keywords[key] = " ".join(words)

name = choice(ships)
tree = parser.parse(name.lower())
check_for_roll(tree)
while len(keys) == 1:
  keys = []
  name = choice(ships)
  tree = parser.parse(name.lower())
  check_for_roll(tree)

str = []
for key in keys:
  pick = choice(list(set(d[key])))
  if pick == keywords[key]:
    pick = choice(list(set(d[key])))
  str.append(pick)

print " ".join(str)

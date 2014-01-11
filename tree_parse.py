import nltk
import json
import yaml
import pdb

from stat_parser import Parser, display_tree
f = open("ships.yml")
f2 = open("ships2.yml")
all_tokens = []
ships = yaml.load(f.read())
ships2 = yaml.load(f2.read())
d = dict()
parser = Parser()

def is_leaf(tree):
  if len(tree.leaves()) == 1:
    return True
  else:
    return False

def top_level_leaves(tree):
  leaves = list(tree)
  is_top_level = True
  for leaf in leaves:
    if not is_leaf(leaf):
      is_top_level = False
  return is_top_level

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
      if key in d:
        d[key].append(" ".join(words))
      else:
        d[key] = [" ".join(words)]
      key = ""
      words = []
      check_for_roll(leaf)
  if key != "":
    if key in d:
      d[key].append(" ".join(words))
    else:
      d[key] = [" ".join(words)]

def get_key(tree):
  leaves = list(tree)
  key = ""
  if len(leaves) == 1:
    return tree.node
  else:
    for leaf in leaves:
      key += get_key(leaf)
    return key

for ship in ships + ships2:
  try:
    tree = parser.parse(ship.lower())
    check_for_roll(tree)
  except TypeError:
    print "danger "
    print ship
    tree = parser.parse(ship)
    check_for_roll(tree)

  #leaves = list(tree)
#for leaf in leaves:
#  addition = " ".join(leaf.leaves())
#  if get_key(leaf) in d:
#    d[get_key(leaf)].append(addition)
#  else:
#    d[get_key(leaf)] = [addition]

json.dump(d, open("tree_ship_words.json", "w"))
#nouns = []
#verbs = []
#for tuple in pos_tagged_tokens:
#  if tuple[1][0] == "N":
#    nouns.append(tuple[0].replace(".", ""))
#  elif tuple[1][0] == "V":
#    verbs.append(tuple[0].replace(".", ""))
#
#set_nouns = set(nouns)
#set_verbs = set(verbs)
#
#json.dump(list(set_nouns), open("nouns.json", "w"))
#json.dump(list(set_verbs), open("verbs.json", "w"))

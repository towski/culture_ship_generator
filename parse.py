import nltk
import json
import yaml
f = open("ships.yml")
all_tokens = []
ships = yaml.load(f.read())
for ship in ships:
  tokens = nltk.word_tokenize(ship)
  pos_tagged_tokens = nltk.pos_tag(tokens)
  all_tokens.append(pos_tagged_tokens)

all_tokens = [item for sublist in all_tokens for item in sublist]
d = dict()
for tuple in all_tokens:
  print tuple
  word = tuple[0]
  word_type = tuple[1]
  if word_type in d:
      d[word_type].append(word)
  else:
      d[word_type] = [word]

json.dump(d, open("ship_words.json", "w"))
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

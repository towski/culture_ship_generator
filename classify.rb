require 'rubygems'
require 'yaml'
require 'stemmer'
require 'classifier'
require 'ruby-debug'

# Load previous classifications
funny       = YAML::load_file('ships.yml')
ships2       = YAML::load_file('ships2.yml')

# Create our Bayes / LSI classifier
classifier = Classifier::Bayes.new('Not Funny', 'Funny')

funny.each { |good_one| classifier.train_funny good_one }
if File.exists? 'consider_phlebas.txt'
  novel = File.read("consider_phlebas.txt")
  classifier.train_funny novel
end
ships2.each { |good_one| classifier.train_funny good_one }

# Train the classifier
('a'..'z').each do |letter|
  not_funny = YAML::load_file("#{letter}.yml")
  not_funny.each { |boo| classifier.train_not_funny boo }
end
#not_funny = YAML::load_file("english.yml")
#not_funny.each { |boo| classifier.train_not_funny boo }
cl = classifier 
debugger

# Let's classify some new quotes
# puts classifier.classify ""

# Print the classifier itself
p classifier

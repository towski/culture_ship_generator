require 'rubygems'
require 'yaml'
require 'stemmer'
require 'classifier'
require 'json'
require 'ruby-debug'

class CultureShipClassifier
  def self.dump
    f = File.open("bayes.marshal", "w")
    f.write Marshal.dump(@classifier)
    f.close
  end

  def self.start
    # Create our Bayes / LSI classifier
    if File.exists?('bayes.marshal')
      @classifier = Marshal.load(File.read('bayes.marshal'))
    else
      @classifier = Classifier::Bayes.new('Not a Ship', 'Ship')

      # Train the classifier
      ('a'..'z').each do |letter|
        not_funny = YAML::load_file("#{letter}.yml")
        not_funny.each { |boo| @classifier.train_not_a_ship boo }
      end
      #not_funny = YAML::load_file("english.yml")
      #not_funny.each { |boo| classifier.train_not_a_ship boo }

      # Load previous classifications
      funny       = YAML::load_file('ships.yml')
      ships2       = YAML::load_file('ships2.yml')
      verbs = JSON.parse File.read('verbs.json')
      nouns = JSON.parse File.read('nouns.json')
      if File.exists? 'consider_phlebas.txt'
        novel = File.read("consider_phlebas.txt")
        #@classifier.train_ship novel
      end
      funny.each { |good_one| @classifier.train_ship good_one }
      ships2.each { |good_one| @classifier.train_ship good_one }
      verbs.each { |good_one| @classifier.train_ship good_one }
      nouns.each { |good_one| @classifier.train_ship good_one }
    end
  end

  def self.classifier
    @classifier
  end
end

# Let's classify some new quotes
# puts classifier.classify ""

# Print the classifier itself

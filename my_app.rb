require "rubygems"
at_exit { 
  puts "DUMPING"
  CultureShipClassifier.dump 
}
require "sinatra/base"
require 'cgi'
require 'htmlentities'
require_relative 'classify'

CultureShipClassifier.start

class MyApp < Sinatra::Base
  get '/' do
    classifier = CultureShipClassifier.classifier
    begin
      generated_ship = `python pick_ship_name.py`
      result = classifier.classify(generated_ship)
    end while result != "Ship"
    generated_ship.sub!(/ (i+)$/){|b| b.upcase }
    string = "<h1>" + generated_ship + "</h1>"
    string += "<h4>" + classifier.classify(generated_ship) + "</h4>"
    string += "<!-- #{classifier.classifications(generated_ship).inspect} -->"
    string += "<form action='/train' method='post'><input type='hidden' name='q' value='#{HTMLEntities.new.encode generated_ship}'/><input type='submit' value='good'/></form>"
    string += "<form action='/untrain' method='post'><input type='hidden' name='q' value='#{HTMLEntities.new.encode generated_ship}'/><input type='submit' value='bad'/></form>"
  end

  post '/train' do
    q = URI.unescape params[:q]
    CultureShipClassifier.classifier.train_ship q
    redirect to('/')
  end

  post '/untrain' do
    q = URI.unescape params[:q]
    CultureShipClassifier.classifier.train_not_a_ship q
    redirect to('/')
  end

  get '/train' do
    q = URI.unescape params[:q]
    classifier = CultureShipClassifier.classifier
    classifier.train_not_a_ship q
    string = "<h1>" + q + "</h1>"
    string += "<h4>" + classifier.classify(q) + "</h4>"
    string += "#{classifier.classifications(q).inspect}"
    string += "<form action='/test'><input type='text' name='q' value='#{HTMLEntities.new.encode q}'/><input type='submit' value='test'/></form>"
  end

  get '/untrain' do
    q = URI.unescape params[:q]
    classifier = CultureShipClassifier.classifier
    classifier.train_not_a_ship q
    string = "<h1>" + q + "</h1>"
    string += "<h4>" + classifier.classify(q) + "</h4>"
    string += "#{classifier.classifications(q).inspect}"
    string += "<form action='/test'><input type='text' name='q' value='#{HTMLEntities.new.encode q}'/><input type='submit' value='test'/></form>"
  end

  get '/test' do
    classifier = CultureShipClassifier.classifier
    q = URI.unescape params[:q]
    string = "<h1>" + q + "</h1>"
    string += "<h4>" + classifier.classify(q) + "</h4>"
    string += "#{classifier.classifications(q).inspect}"
    string += "<form action='/test'><input type='text' name='q' value='#{HTMLEntities.new.encode q}'/><input type='submit' value='test'/></form>"
  end
end

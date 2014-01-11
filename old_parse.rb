require 'treat'
require 'ruby-debug'

include Treat::Core::DSL

d = document 'test.txt'
d.apply :chunk
d.apply :segment
d.apply :parse
d.apply :category
puts section.noun_count

debugger
puts 'a'

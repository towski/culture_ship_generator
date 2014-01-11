('a'..'z').each do |letter|
  `wget "http://www2.10000boatnames.com/index.php?option=com_displayltr&task=res&letter=#{letter.upcase}&Itemid=20" -O #{letter}.html`
  # cat file | grep -o "<td><B><I>[^<]*</I>" | sed s/\<td\>\<B\>\<I\>// | sed s/\<\\/I\>// | sed s/^/-\ /
  command = %q(cat %s.html | grep -o '<td><B><I>[^<]*</I>' | sed s/\<td\>\<B\>\<I\>// | sed s/\<\\\\/I\>// | sed s/^/-\ / | sed s/://g > %s.yml)
  puts command % [letter, letter]
  system(command % [letter, letter])
  system('sed -i \'1s/^/---\n/\' %s.yml' % letter)
end

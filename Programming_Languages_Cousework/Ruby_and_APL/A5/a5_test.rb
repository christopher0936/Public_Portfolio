require "./a5.rb"

# This script assumes that to_s is working correctly.

tests = []
f = MySet.new([1, 2, 3, 2, 1.5])
tests[0] = f.to_s == "[1, 1.5, 2, 3]"
f.insert 3
f.insert -1
tests[1] = f.to_s == "[-1, 1, 1.5, 2, 3]"

p = ""
f.each { |i| p += "_#{i}" }
tests[2] = p == '_-1_1_1.5_2_3'
tests[3] = f.map { |x| x.round%2 } == [1, 1, 0, 0, 1]
tests[4] = f.count == 5
tests[5] = f.class == MySet
tests[6] = f.is_a?(Array) == false

tests[7] = (f | MySet.new([1, -2])).to_s == '[-2, -1, 1, 1.5, 2, 3]'
tests[8] = (f & MySet.new([1, 2, 5])).to_s == '[1, 2]'
tests[9] = f.to_s == '[-1, 1, 1.5, 2, 3]'

f = MySet.new([1, 2, 3, 2, 1.5]) { |a,b| -(a<=>b) }
tests[10] = f.to_s == '[3, 2, 1.5, 1]'

tests = tests.map {|i| if i then 1 else 0 end}
puts "\nPoints:"
print('1.1: ', (tests[0] + tests[10] + tests[5] + tests[6]) * (3/4.0), "\n")
print('1.2: ', tests[0] * 3, "\n")
print('1.3: ', tests[1] * 3, "\n")
print('1.4: ', (tests[2] + tests[3] + tests[4]) * 1, "\n")
print('1.5: ', (tests[7] + tests[8] + tests[9]) * 1, "\n")


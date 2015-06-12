#!/usr/bin/env ruby

# Andy Chu
# andy.ik.chu@gmail.com
# June 11, 2015 for Insight Data Engineering fellows program
# Tested on ruby 1.9.3

# Counts the number of times each word occurs in text files of a given directory
# Outputs the sorted, unique list of words found in all texts with the count of occurrences.

# Method: hash each word found in texts as the hash key, and increment its correponding value as the count

#for simplicity, option parsers, checks that input directory exists, input text files exists, and output file can be created are skipped
indir=ARGV[0]
outfile=ARGV[1]

dict = Hash.new(0) #hash tracking counts of all words, with counts initialized to 0
Dir.glob("#{indir}/*.txt") do |file|
	infh = File.open(file, "r")
	while line = infh.gets
		line.strip!
		line.downcase!
		line.split.each do |word|
			word.delete!('^a-z') #remove non-alphabetic characters from word
			dict[word] += 1
		end
	end
	infh.close
end

outfh = File.open(outfile, "w")
dict.keys.sort.each do |word|
	outfh.puts "#{word}\t#{dict[word]}\n"
end
outfh.close

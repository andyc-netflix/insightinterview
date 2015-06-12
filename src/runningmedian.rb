#!/usr/bin/env ruby

# Andy Chu
# andy.ik.chu@gmail.com
# June 11, 2015 for Insight Data Engineering fellows program
# Tested on ruby 1.9.3

# Reads in a set of text files in a directory in sorted file name order.
# For each line in each file, output the median number of words per line seen across all lines in all texts processed so far.

# Method: rather than implementing a generic running median algorithm that tracks n values for n lines processed, take advantage of the fact that most texts have a small number of words per line and a tight distribution of that number. ie. the vast majority of lines will have approximately 12 words per line, with a bi-modal distribution at 0 to 3 words per line for blanks or titles, and the lines of text to process is much greater than the maximum number of words in one line.
# Use an array to store numbers of words per line. For each line read, the array index i represents the number of words, and the value at i is incremented to represent the running total of number of lines that have i words. The median can then be found by summing array[0], array[1]... until the sum is equal to n/2, then using the array index position as the value of the median (details of dealing with even number of lines described in comments below).
# For the average case with a maximum of k words per line, where k << n, this will yield performance of O(1) for count insertion, O(k) for calculating median, and memory requirements of O(k).

#for simplicity, option parsers, checks that input directory exists, input text files exists, and output file can be created are skipped
indir=ARGV[0]
outfile=ARGV[1]

numlines = 0 #total number of lines processed across all files
wordcounts = Array.new()
outfh = File.open(outfile, "w")
Dir.glob("#{indir}/*.txt").sort.each do |file|
	infh = File.open(file, "r")
	while line = infh.gets
		numwords = line.split.length
		numlines += 1
		if wordcounts.length <= numwords then wordcounts.fill(0, wordcounts.length..numwords) end #extend array with zeroes initialized if necessary
		wordcounts[numwords] += 1

		linesums = 0 #running sum of lines counted before median is reached
		i = -1 #index for tracking each words per line count
		prev_i = -1 #records the last words per line with a non-zero count, used for averaging 2 numbers to get median
		while (linesums < (numlines/2).floor + 1) do
			if wordcounts[i] > 0 then prev_i = i end
			i += 1
			linesums += wordcounts[i]
		end

		#after count has incremented past the halfway point of counts at i, then i is the median when:
		#a) the total count is odd, or
		#b) the total count is even and numlines/2 and numlines/2 + 1 sits in i
		#otherwise, i represents the numlines/2 + 1 part of the median, and prev_i is the numlines/2 part
		if (numlines %2 == 0 && linesums - wordcounts[i] == numlines/2) then
			median = (i + prev_i).to_f/2
		else
			median = i
		end
		outfh.puts median.to_f.round(2)
	end
	infh.close
end
outfh.close

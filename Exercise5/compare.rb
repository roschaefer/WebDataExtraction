#!/usr/bin/ruby
require 'csv'
require 'levenshtein'
require 'trollop'


opts = Trollop::options do
    version "Compare 1.0 (c) 2012 Robert Schaefer"
    banner <<-EOS
This program evaluates two string comparison algorithms:
    Levenshtein Distance
    Levenshtein Distance on Soundex
Usage:
    compare.rb [options] 
where [options] are:
EOS
    opt :infile, "Input csv file - mandatory", :type => String
    opt :outfile, "Output csv file", :type => String
    opt :columns, "Index of string columns", :default => [0,1]
end

Trollop::die :infile, "must be given" unless opts[:infile] and File.exist?(opts[:infile]) 
Trollop::die :columns, "exact two indices of string columns must be given" if opts[:columns] and opts[:columns].length != 2

def soundexComparison(string1, string2)
    # this makes the program brittle of course
    # execution depends on the presence of the soundex program in the same folder and on its output
    soundex1 = %x"./soundex '#{string1}'".split[1]
    soundex2 = %x"./soundex '#{string2}'".split[1]
    return Levenshtein.normalized_distance(soundex1, soundex2)
end

i = opts[:columns][0]
j = opts[:columns][1]


csv_string = CSV.generate do |csv|
    CSV.foreach(opts[:infile]) do |row| 
        if row[i] === nil or row[j] === nil 
            puts "Malformed csv file, string values missing in a row"; exit(1)
        end
        lvst = Levenshtein.normalized_distance(row[i], row[j])
        soundex = soundexComparison(row[i], row[j])
        csv << row.push(lvst).push(soundex)
    end
end

if opts[:outfile] 
    f = File.new(opts[:outfile], "wb")
    f.write(csv_string)
    f.close
else 
    puts csv_string
end

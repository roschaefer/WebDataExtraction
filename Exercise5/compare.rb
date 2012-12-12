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
end

Trollop::die :infile, "must be given" unless opts[:infile] and File.exist?(opts[:infile]) 


def soundexComparison(string1, string2)
    # this makes the program brittle of course
    # execution depends on the presence of the soundex program in the same folder and on its output
    soundex1 = %x"./soundex #{string1}".split[1]
    soundex2 = %x"./soundex #{string2}".split[1]
    return Levenshtein.normalized_distance(soundex1, soundex2)
end



csv_string = CSV.generate do |csv|
    CSV.foreach(opts[:infile]) do |row| 
        if row[0] === nil or row[1] === nil 
            puts "Malformed csv file, first two values missing in a row"; exit(1)
        end
        lvst = Levenshtein.normalized_distance(row[0], row[1])
        soundex = soundexComparison(row[0], row[1])
        csv << [row[0], row[1], lvst, soundex]
    end
end

if opts[:outfile] 
    f = File.new(opts[:outfile], "wb")
    f.write(csv_string)
    f.close
else 
    puts csv_string
end

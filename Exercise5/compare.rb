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
    opt :infile, "Input csv file", :type => String
    opt :outfile, "Output csv file", :type => String
end

Trollop::die :infile, "must be given" unless opts[:infile] and File.exist?(opts[:infile]) 

def soundexComparison(string1, string2)
    soundex1 = %x"./soundex #{string1}".split[1]
    soundex2 = %x"./soundex #{string2}".split[1]
    return Levenshtein.normalized_distance(soundex1, soundex2)
end

def output(row)
        lvst = Levenshtein.normalized_distance(row[0], row[1])
        soundex = soundexComparison(row[0], row[1])
        return [row[0], row[1], lvst, soundex]
end


CSV.open(opts[:outfile], "wb") do |csv|
    CSV.foreach(opts[:infile]) do |row| 
        csv << output(row)
    end
end

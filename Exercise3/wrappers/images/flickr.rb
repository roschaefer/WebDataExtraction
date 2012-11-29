#Gems
require 'optparse'
require 'rubygems'
require 'nokogiri'
require 'open-uri'

#Handle command line options / arguments
options = {}

optparse = OptionParser.new do |opts|
    opts.banner = "Usage: flickr.rb [options]"
    
    opts.on("-a", "--artist ARTIST", "Specify the artist whose images you would like to fetch") do |a|
        options[:artist] = a 
    end
end

begin
  optparse.parse!
  mandatory = [:artist]                                                  # Enforce the presence of artist
  missing = mandatory.select{ |param| options[param].nil? }              # source : http://stackoverflow.com/questions/1541294/how-do-you-specify-a-required-switch-not-argument-with-ruby-optionparser
  if not missing.empty?                                                  #
    puts "Missing options: #{missing.join(', ')}"                        #
    puts optparse                                                        #
    exit                                                                 #
  end                                                                    #
rescue OptionParser::InvalidOption, OptionParser::MissingArgument        #
  puts $!.to_s                                                           # Friendly output when parsing fails
  puts optparse                                                          #
  exit                                                                   #
end   


#Get html document and open it with Nokogiri gem
url = "http://www.flickr.com/search/?q=" + options[:artist].gsub!(' ','+') + "&f=hp"
doc = Nokogiri::HTML(open(url))

#Create a new html file that will contain images inside leon_agatic div
fileXml = File.new("flickr.xml", "w+")
fileXml.puts '<?xml version="1.0" encoding="UTF-8"?>'
fileXml.puts "<flickr>"

#Get images with class pc_img and fill html document with them
doc.css(".pc_img").each_with_index do |item, i|
  fileXml.puts '<img src="' + item.attribute("src") + '"/>'
  break if i==9
end

#Close leon_agatic div and html file
fileXml.puts "</flickr>"
fileXml.close()

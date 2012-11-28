#!/usr/bin/env/ ruby


require 'optparse'
require 'mechanize'

options = {}

optparse = OptionParser.new do |opts|
    opts.banner = "Usage: discogsExtractor.rb [options]"
    
    opts.on("-a", "--artist ARTIST", "Specify the artist whose discography you would like to fetch") do |a|
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




agent = Mechanize.new { |agent|
      agent.user_agent_alias = 'Mac Safari' # discogs sends bad request without user agent, fu
}
agent.read_timeout=15

page = agent.get('http://www.discogs.com')
search_form = page.form_with(:id => 'site_search')
search_form.q = options[:artist]
search_results = agent.submit(search_form, search_form.buttons.first)

artists = search_results.link_with(:text => 'Artist').click

artist = artists.link_with(:class => /search_result_title/).click
#TODO fetch more than the default size of albums


doc = Nokogiri::HTML(artist.body)
rows = doc.css('table.discography tbody tr.main')
albums = rows.collect do |row|
  album = {}
  [
    [:title, 'td[2]//a/text()'],
    [:year, 'td[4]//text()'],
    [:labels, 'td[3]//text()']
  ].each do |name, xpath|
    album [name] = row.at_xpath(xpath).to_s.strip
  end
  album 
end

builder = Nokogiri::XML::Builder.new do |xml|
    xml.albums {
        albums.each do |a|
        xml.album {
            xml.title_ a[:title]
            xml.year_  a[:year]
            xml.labels_  a[:labels]
        }
        end 
    }
end

puts builder.to_xml





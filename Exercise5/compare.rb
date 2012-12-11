require 'csv'
require 'levenshtein'



def soundexComparison(string1, string2)
    soundex1 = %x"./soundex #{string1}".split[1]
    soundex2 = %x"./soundex #{string2}".split[1]
    return Levenshtein.distance(soundex1, soundex2)
end

CSV.open("./output.csv", "wb") do |csv|
    CSV.foreach("./input.csv") do |row| 
        lvst = Levenshtein.distance(row[0], row[1])
        soundex = soundexComparison(row[0], row[1])
        csv << [row[0], row[1], lvst, soundex]
    end
end

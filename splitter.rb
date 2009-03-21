#!/usr/bin/env ruby
require 'time'

if ARGV.size < 1
    puts "No log specificed, looking for default log"
    # TODO - windows support
    file = "/Applications/World of Warcraft/Logs/WoWCombatLog.txt"
else
    file = ARGV[0]
end

if !File.exist? file
    puts "Usage: #{$0} <combatlog name>"
    exit
end

last_timestamp = nil
output = nil
lines = 0
open(file) do |file|
    while !file.eof?
        line = file.readline
        lines += 1
        date, time = line.split(/\s/)
        timestamp = Time.parse(date + " " + time)
        puts "   #{ lines } #{ timestamp }" if lines % 10000 == 0
        if last_timestamp.nil? or timestamp - last_timestamp > 600
            puts "New combatlog started at #{ timestamp }"
            if output
                output.close
            end
            filename = "combatlog_#{ timestamp.iso8601 }.txt"
            #while File.exist? filename
            #    filename.gsub!(/.txt$/, "#{ rand(10000) }.txt")
            #end
            puts "   writing to #{ filename }"
            output = open(filename, "w")
            lines = 0
        end
        output.write( line )
        last_timestamp = timestamp
    end
end
output.close


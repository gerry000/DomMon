#!/usr/bin/env ruby

fact_lookup = "operatingsystemrelease" 
cmd = "mco facts #{fact_lookup}"
Facts = Hash.new

def read_mco (cmd)
	returns = `#{cmd}`
	
	returns.each_line do |line|
		line.gsub(/\s+/,"")
		results, junk, value = line.split()
		Facts.merge!(results => value)if results !~ /Report|Finished/
	end
	return Facts
end

read_mco(cmd)
Facts.each do |key, value|
	puts "#{key}:#{value}" if (key !~ /Report|Finished|\n/)
end


#!/usr/bin/env ruby

Key_facts = /operatingsystem\s|operatingsystemrelease|kernelrelease|environment|hardwareisa|shellshock|waiting_updates/
cmd_serverlist = "mco find -v"
Facts = Hash.new

def serverlist (cmd)
	outputs = `#{cmd}`
	
	outputs.each_line do |line|
		line.gsub(/\s+/,"")
		servers = line.split()
		Facts.merge!(servers =>  Hash.new) if servers !~ /Discovered|''/
	end
end

def read_facts (cmd)
	outputs = `#{cmd}`
	fact, junk , value = ""
	server ="influx-netapp.shef.ac.uk"
	temp_hash = Hash.new
	
	outputs.each_line do |line|
		line.chomp
		fact, junk , value = line.split() if line =~ Key_facts
		temp_hash.merge!(fact => value)
		Facts[server] = temp_hash
	end
	return temp_hash
end

serverlist(cmd_serverlist)

Facts.each do |key, value|
#	puts "#{key} #{value}" 
	read_facts("mco inventory #{key}")
end

def read_back_hash (hash)
	hash.each do |key, value|
	#	puts "#{key} #{value}" 
		puts key
	end
end

read_back_hash(Facts)

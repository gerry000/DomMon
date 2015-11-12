require 'active_record'  
require 'yaml'  

Debug_lvl = 0

dbconfig = YAML::load(File.open('config/database.yml'))  
$blade_status_globpath = '/var/rails/DomMon/mnt/ldoms/shared/tmp/*.blade.status'
Bladestat = Hash.new
current_node,state, flags, cons, vcpu, memory, util, norm, uptime = ""

## Read blade output files to get the status of me and cpu

Dir.glob($blade_status_globpath) do |my_text_file|
	puts "working on: #{my_text_file}..." if Debug_lvl != 0
	
	current_node = my_text_file.gsub(%r{.*/|\..*$},'')
	memsum = 0
	cpus = 0

	File.open(my_text_file) do |f|
		f.each_line do |line|
			line.chomp!
			if line =~ /pid=/
				line.split('|').each do |x|
					k,pid = x.split('=')
					cpus = pid.to_i + 1 if k == "pid"
				end
			elsif line =~ /size=/
				line.split('|').each do |x|
					k,mem = x.split('=')
					memsum = memsum + (mem.to_i / 1024 / 1024 / 1024) if k == "size"
				end
			end
			Bladestat[current_node] = {:vcpus => cpus, :mem => memsum}
		end
	end
end

## Opens the database connection from the rails config
## assignes the class and clears the last set of records

ActiveRecord::Base.establish_connection( dbconfig['development'] )

class Nodes < ActiveRecord::Base
end

Nodes.delete_all()

# Populates the table with the latest data in the hash

Bladestat.each do |key, value|
	Nodes.create(:nodename => key, 
		:Vcpus => value[:vcpus], 
		:max_memory => value[:mem]
	)
end

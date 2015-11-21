require 'active_record'  
require 'yaml'  

Debug_lvl = 0 ## 0 = No Debuge, 1 = Code Output, 2 = 1 + Hash Contents

dbconfig = YAML::load(File.open('config/database.yml'))  

$ldom_single_truth = '/var/rails/DomMon/mnt/ldoms/shared/etc/default_layout'
$ldom_status_globpath = '/var/rails/DomMon/mnt/ldoms/shared/tmp/*.ldoms.status'
$storage_globpath = '/var/rails/DomMon/mnt/ldoms/*_2'

$ldom_enviroment = Hash.new
$ldom_home = Hash.new
Ldomstat = Hash.new
current_node,state, flags, cons, vcpu, memory, util, norm, uptime = ""

## Creates a hash of ldoms from the single truth file stored on the NetApp

File.open($ldom_single_truth) do |f|
        f.each_line do |line|
                line.chomp!
                hostname, home_node = line.split()
                $ldom_home.merge!(hostname => home_node)
        end
end

if Debug_lvl >= 2 
	$ldom_home.each do |key, value|
		puts "#{key}:#{value}"
	end
end

## Creates a hash of ldom's running enviroment location on the NetApp

Dir.glob($storage_globpath) do |storage_points|
	puts "working on: #{storage_points}..." if Debug_lvl != 0
	
   mount_point = storage_points.gsub(%r{.*/|\..*$},'')
   Dir.foreach(storage_points) do |guest|
      $ldom_enviroment.merge!(guest => "Prod") if mount_point =~/PROD/ && guest !~ /\./
      $ldom_enviroment.merge!(guest => "QA") if mount_point =~/QA/ && guest !~ /\./
      $ldom_enviroment.merge!(guest => "Dev") if mount_point =~/DEV/ && guest !~ /\./
   end
end

## Read node output files to get the status of Ldoms

Dir.glob($ldom_status_globpath) do |my_text_file|
	puts "working on: #{my_text_file}..." if Debug_lvl != 0
	
	current_node = my_text_file.gsub(%r{.*/|\..*$},'')
	File.open(my_text_file) do |f|
		f.each_line do |line|
			line.chomp!
			if line =~ /active/ && line !~ /primary/
				hostname, state, flags, cons, vcpu, memory, util, norm, uptimed, uptimeh, uptimem = line.split()
				uptime = [uptimed, uptimeh, uptimem].join
				default_node = $ldom_home[hostname]
				env = $ldom_enviroment[hostname]
				puts "ldom #{hostname} D #{default_node} C #{current_node} #{env} #{state} #{flags} #{cons} #{vcpu} #{memory} #{util} #{norm} #{uptimed} #{uptime}" if Debug_lvl != 0
				Ldomstat[hostname] = {:default_node => default_node, :current_node => current_node, :env => env, :state => state, :flags => flags, :cons => cons, :vcpu => vcpu.to_i, :memory => memory.to_i, :util => util, :norm => norm, :uptime => uptime}
			end
		end
	end
end

if Debug_lvl >= 2 
	Ldomstat.each do |key, value|
		puts "#{key}:#{value}"
	end
end

## Opens the database connection from the rails config
## assignes the classes and clears the last set of ldom records

ActiveRecord::Base.establish_connection( dbconfig['development'] )

class Ldoms < ActiveRecord::Base
end

Ldoms.delete_all()

class Nodes < ActiveRecord::Base
end

Nodes.update_all "Used_vcpus = 4, Used_mem = 0, Num_guests = 0"

## Populates the table with the latest data in the hash

Ldomstat.each do |key, value|
	Ldoms.create(:hostname => key, 
		:env => value[:env],
		:default_node => value[:default_node], 
		:running_node => value[:current_node], 
		:vcpu => value[:vcpu], 
		:flags => value[:flags], 
		:allocated_mem => value[:memory], 
		:util => value[:util], 
		:norm => value[:norm], 
		:uptime => value[:uptime]
	)
	
	node = Nodes.find_by(nodename:  value[:current_node]) 
	node.Used_vcpus = node.Used_vcpus + value[:vcpu] if node.nodename == value[:current_node]
	node.Used_mem = node.Used_mem + value[:memory] if node.nodename == value[:current_node]
	node.Num_guests = node.Num_guests + 1 if node.nodename == value[:current_node]
	node.save
end

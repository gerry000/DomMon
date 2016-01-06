module FactsHelper
	def facts_lookup( fact_queried )
			$cmd = %x(mco 2>&1)
#			$cmd = %x(mco facts #{fact_queried} 2>&1)
#		$cmd = %x(scripts/mco_helper.rb 2>&1)
		return $cmd
	end
end

#		facts = Hash.new
#		cmd_out = `#{cmd}`
#		cmd_out.each_line do |line|
#			line.chomp
#			results, junk, value = line.split()
#			facts.merge!(results => value)
#		end


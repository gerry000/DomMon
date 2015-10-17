require 'net/ssh'
require 'net/scp'

Net::SSH.start(
	'nn-bl0c', 'sa_cs1dgw',
	:host_key => "ssh-rsa",
	:keys => [ "/var/rails/DomMon/config/DomMon.key" ],
	) do |ssh|

	# capture all stderr and stdout output from a remote process
#	output = ssh.exec!("hostname")

	# capture only stdout matching a particular pattern
#	stdout = ""
#	ssh.exec!("ls /tmp/"
#	) do |channel, stream, data|
#	    stdout << data if stream == :stdout
#	end
#	puts stdout
	
	ssh.scp.download! "/tmp/ldoms.status", "/var/rails/DomMon/tmp/"
end

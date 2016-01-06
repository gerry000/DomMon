class NodesController < ApplicationController
	def index
		@nodes = Node.order(:nodename)
		@ldoms = Ldom
	end

end

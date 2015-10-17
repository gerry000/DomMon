class NodesController < ApplicationController
	def index
		@nodes = Node.all
	end

	def new
		@node = Node.new
	end

	def create
		@node = Node.new(node_params)
		if @node.save
			redirect_to nodes_path
		else
			redirect_to new_node_path
		end
	end
	
	private
		def node_params
			params.required(:node).permit(:nodename, :bladenumber, :processor_type, :max_memory)
		end
end

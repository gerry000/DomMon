class LdomController < ApplicationController
	def index
                @ldoms	 = Ldom.all
        end

        def new
                @ldom = Ldom.new
        end

        def create
                @ldom = Ldom.new(node_params)
                if @ldom.save
                        redirect_to ldoms_path
                else
                        redirect_to new_ldoms_path
                end
        end

        private
                def node_params
                        params.required(:node).permit(:nodename, :bladenumber, :processor_type, :max_memory)
                end
end

class LdomController < ApplicationController
	helper_method :sort_column, :sort_direction

	def index
                @ldoms	 = Ldom.order(sort_column + " " + sort_direction)
   end

	private
  
	def sort_column
		Ldom.column_names.include?(params[:sort]) ? params[:sort] : "Hostname"
	end
  
	def sort_direction
  		%w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
	end

#        def new
#                @ldom = Ldom.new
#        end
#
#        def create
#                @ldom = Ldom.new(node_params)
#                if @ldom.save
#                        redirect_to ldoms_path
#                else
#                        redirect_to new_ldoms_path
#                end
#        end
#
#        private
#                def node_params
#                        params.required(:node).permit(:nodename, :bladenumber, :processor_type, :max_memory)
#                end
end

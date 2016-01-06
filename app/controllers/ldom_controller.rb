class LdomController < ApplicationController
	helper_method :sort_column, :sort_direction

	def index
		flash.now[:notice] = "Refreshing data"
		@refresh = %x(scripts/data_extract.rb)
		@ldoms = Ldom.order(sort_column + " " + sort_direction)
   end

	def new
	end

	private
  
	def sort_column
		Ldom.column_names.include?(params[:sort]) ? params[:sort] : "Hostname"
	end
  
	def sort_direction
  		%w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
	end
end

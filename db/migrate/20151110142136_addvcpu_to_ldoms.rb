class AddvcpuToLdoms < ActiveRecord::Migration
  def change
	 add_column :ldoms, :vcpu, :integer
  end
end

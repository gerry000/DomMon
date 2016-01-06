class AddUsedMemToNodes < ActiveRecord::Migration
  def change
    add_column :nodes, :Used_mem, :integer
  end
end

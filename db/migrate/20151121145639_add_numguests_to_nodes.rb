class AddNumguestsToNodes < ActiveRecord::Migration
  def change
    add_column :nodes, :Num_guests, :integer
  end
end

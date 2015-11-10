class AddToLdom < ActiveRecord::Migration
  def change
	add_column :ldoms, :flags, :string
  end
end

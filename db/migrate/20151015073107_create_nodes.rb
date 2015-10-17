class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
	t.string   :nodename
	t.integer  :bladenumber
	t.string   :processor_type
	t.integer  :max_memory
	t.timestamps null: false
    end
  end
end

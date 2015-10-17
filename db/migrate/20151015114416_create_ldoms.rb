class CreateLdoms < ActiveRecord::Migration
  def change
    create_table :ldoms do |t|
	t.string   :hostname
	t.string   :default_node
	t.string   :running_node
        t.integer  :allocated_mem
        t.integer  :used_mem
        t.integer  :util
        t.integer  :norm
        t.string   :uptime
	

      t.timestamps null: false
    end
  end
end

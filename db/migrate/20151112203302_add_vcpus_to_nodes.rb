class AddVcpusToNodes < ActiveRecord::Migration
  def change
    add_column :nodes, :Vcpus, :integer
  end
end

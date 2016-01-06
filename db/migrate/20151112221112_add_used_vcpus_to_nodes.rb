class AddUsedVcpusToNodes < ActiveRecord::Migration
  def change
    add_column :nodes, :Used_vcpus, :integer
  end
end

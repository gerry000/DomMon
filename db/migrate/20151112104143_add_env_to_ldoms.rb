class AddEnvToLdoms < ActiveRecord::Migration
  def change
    add_column :ldoms, :env, :string
  end
end

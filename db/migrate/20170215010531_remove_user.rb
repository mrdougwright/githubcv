class RemoveUser < ActiveRecord::Migration[5.0]
  def self.up
    drop_table :users
  end

  def self.down
    create_table :users
  end
end

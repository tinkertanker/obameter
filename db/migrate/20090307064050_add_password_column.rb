class AddPasswordColumn < ActiveRecord::Migration
  def self.up
    add_column :people, :hashed_password, :string
    add_column :people, :salt, :string
  end

  def self.down
    remove_column :people, :hashed_password
    remove_column :people, :salt
  end
end

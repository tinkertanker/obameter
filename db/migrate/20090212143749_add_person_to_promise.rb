class AddPersonToPromise < ActiveRecord::Migration
  def self.up
    add_column :promises, :person_id, :integer
  end

  def self.down
    remove_column :promises, :person_id
  end
end

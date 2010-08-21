class CreatePromises < ActiveRecord::Migration
  def self.up
    create_table :promises do |t|
      t.text :description
      t.datetime :expiry_date
      t.datetime :implementation_date

      t.timestamps
    end
  end

  def self.down
    drop_table :promises
  end
end

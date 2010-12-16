class AddTimestampToPerbs < ActiveRecord::Migration
  def self.up
    add_column :perbs, :created_at, :datetime
  end

  def self.down
    remove_column :perbs, :created_at
  end
end

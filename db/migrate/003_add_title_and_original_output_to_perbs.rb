class AddTitleAndOriginalOutputToPerbs < ActiveRecord::Migration
  def self.up
    add_column :perbs, :title, :string
    add_column :perbs, :original_output, :text
  end

  def self.down
    remove_column :perbs, :title
    remove_column :perbs, :original_output
  end
end

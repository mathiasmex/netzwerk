class CreateFeedEntries < ActiveRecord::Migration
  def self.up
    create_table :feed_entries do |t|
      t.string   :name
      t.text     :summary
      t.string   :url
      t.datetime :published_at
      t.string   :guid
      t.integer  :group_id

      t.timestamps
    end

    add_column :groups, :website_url, :string

  end

  def self.down
    remove_column :group, :website_url, :string
    drop_table :feed_entries
  end
end

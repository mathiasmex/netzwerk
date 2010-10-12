class ExtendPreferencesPrivacy < ActiveRecord::Migration
  def self.up
    add_column :preferences, :impressum, :text
    add_column :preferences, :privacy_policy, :text
  end

  def self.down
    remove_column :preferences, :impressum
    remove_column :preferences, :privacy_policy
  end
end

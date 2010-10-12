class FeedEntry < ActiveRecord::Base

require 'feedzirra'

  belongs_to :group

  def self.update_from_feed(feed_url)
    feed_urls = @group.website_url
    feeds = Feedzirra::Feed.fetch_and_parse(feed_urls)
    add_entries(feed.entries)
  end
  
  def self.update_from_feed_continuously(feed_url, delay_interval = 15.minutes)
    feed_urls = @group.website_url
    feeds = Feedzirra::Feed.fetch_and_parse(feed_urls)
    add_entries(feed.entries)
    loop do
      sleep delay_interval
      feed = Feedzirra::Feed.update(feed)
      add_entries(feed.new_entries) if feed.updated?
    end
    self.delay.add_entries(feed.entries) 
  end
  
  private
  
  def self.add_entries(entries)
    entries.each do |entry|
      unless exists? :guid => entry.id
        create!(
          :name         => entry.title,
          :summary      => entry.summary,
          :url          => entry.url,
          :published_at => entry.published,
          :guid         => entry.id
        )
      end
    end
  end

end

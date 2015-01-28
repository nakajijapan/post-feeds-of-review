# coding: utf-8
require 'yaml'
require 'pp'
require 'feedjira'
require 'active_support/all'
require 'carrier-pigeon'


module Feedjira
  module Parser
    # Parser for dealing with Atom feed entries.
    class AtomEntry
      element :"im:rating", :as => :rating
      element :"im:version", :as => :version
    end
  end
end


# read configration
load File::expand_path('', File::dirname(__FILE__)) + '/config.rb'

feeds_file = File::expand_path('', File::dirname(__FILE__)) + '/feeds.yml'

urls = YAML.load(File.read(feeds_file))
pp urls

urls.each do |item|

  feed = Feedjira::Feed.fetch_and_parse(item['url'])

  # using attributes
  #   entry.title
  #   entry.published
  #   entry.author
  #   entry.content
  #   entry.rating
  #   entry.version
  feed.entries.each_with_index do |entry, i|

    now = Time.now
    updated = entry.published.getlocal

    next if i == 0

    if updated >= 10.minute.ago

        rating_image = ''
        for i in 1..entry.rating.to_i do
          rating_image += "\u{2B50} "
        end

        system("curl -F channel=\##{$IRC_CHANNEL} -F message=\"#{rating_image} [#{entry.version}] #{entry.author} #{entry.published}\" #{$IRC_URL}")
        system("curl -F channel=\##{$IRC_CHANNEL} -F message=\"#{entry.title} - #{entry.content} #{}\" #{$IRC_URL}")

    end

  end

end

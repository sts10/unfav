require 'twitter'
require 'pry'
require_relative 'secrets.rb'

stream_object = STREAMING
rest_object = REST

puts "Enter Tweet ID of Tweet to listen to"
tweet_id = gets.chomp.to_i
faving_users = []

stream_object.user do |object|
  case object
  when Twitter::Tweet
    puts "It's a tweet from #{object.user.screen_name} that says: " + object.text
    #binding.pry
  when Twitter::Streaming::Event
    puts "It's a Streaming::Event called #{object.name}! Not really sure what this means!"
    if object.name == :favorite 
      faving_user = object.source
      faved_tweet = object.target_object

      if faved_tweet.id == tweet_id
        faving_users << faving_user
        faving_users = faving_users.uniq{|u| u.id}
      end
      puts "faving users has #{faving_users.size} users in it"
      if faved_tweet.favorite_count 
        faves = faved_tweet.favorite_count.to_i
      else
        faves = 0
      end
      puts "tweet has #{faved_tweet.favorite_count} favs currently"
    end

    if object.name == :unfavorite
      faved_tweet = object.target_object

      puts "faving users has #{faving_users.size} users in it"
      if faved_tweet.favorite_count 
        faves = faved_tweet.favorite_count.to_i
      else
        faves = 0
      end
      puts "tweet has #{faved_tweet.favorite_count} favs currently"
    end
    #binding.pry
  when Twitter::Streaming::StallWarning
    puts "Falling behind!"
  end
end

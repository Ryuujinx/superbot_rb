#!/usr/bin/env ruby

require 'rubygems'
require 'discordrb'
require 'yaml'
require './random.rb'
require './config.rb'
require 'net/http'
require 'uri'
require 'aws-sdk-s3'



tempyaml = YAML.load_file 'quotes.yml'
r = Rand.new(tempyaml.size)
s3 = Aws::S3::Client.new(profile: S3PROFILE, region: S3REGION)
bot = Discordrb::Commands::CommandBot.new(token: DISCORD_TOKEN, client_id: DISCORD_CLIENT_ID, prefix: PREFIX)
Dir.mkdir('tmp') unless Dir.exists?('tmp')

puts "This bot's invite URL is #{bot.invite_url}"
#puts 'Click on it to invite it to your server.'


bot.command(:help, min_args: 0) do |event|
  event.respond "Commands:
#{PREFIX}help: Prints this information
#{PREFIX}quote [<ID>]: Gets a quote, if ID is specified retrieves the requested quote ID.
#{PREFIX}addquote <QUOTE>: Adds a quote to the database.
#{PREFIX}grepquote <QUERY>: Searches the database for <QUERY>, maximum of 10 results will be returned. Supports regex.
#{PREFIX}sergequote: Gets a random serge quote.
#{PREFIX}deletequote <ID>: Starts the process to delete a quote.
#{PREFIX}sergebox: Gives you a sergebox.
#{PREFIX}gdq: Gives a random GDQ quote."
end


bot.command(:quote, min_args: 0, max_args: 1) do |event, args|
  yml = YAML.load_file 'quotes.yml'
  r.size = yml.size
  if args.nil?
    num = r.next
  else
    num = args.to_i
    if num < 0
      num = yml.count + num
    end
  end
  response = yml[num]
  if response.nil?
    event.respond "I was unable to find a quote with ID #{num}, therefore I am generating a random quote instead."
    num = r.next
    response = yml[num]
  end
  event.respond "Quote ID #{num}: #{response}"
end



bot.command(:addquote, min_args: 1) do |event, *args|
  yml = YAML.load_file 'quotes.yml'
  size = yml.size
  File.open("quotes.yml", "w") do |file|
    yml[size] = args.join(' ')
    file.write(yml.to_yaml)
  end
  r.size = yml.size
  event.respond "Quote had been added as Quote ID #{size}!"
end

bot.command(:quoteadd, min_args: 1) do |event, *args|
  yml = YAML.load_file 'quotes.yml'
  size = yml.size
  File.open("quotes.yml", "w") do |file|
    yml[size] = args.join(' ')
    file.write(yml.to_yaml)
  end
  r.size = yml.size
  event.respond "Quote had been added as Quote ID #{size}!"
end



bot.command(:grepquote, min_args: 1) do |event, *args|
   yml = YAML.load_file 'quotes.yml'
   cnt = 0
   matches_hash = Hash.new
   yml.each_pair do |key, value|
     if value.downcase =~ /#{args.join(' ').downcase}/
       cnt += 1
       matches_hash[key] = value 
     end
   end
   if cnt == 0
     event.respond "No matches found for #{args.join(' ')}, try again."
   elsif cnt < 10
     matches = "Match found:\n"
     matches_hash.each_pair do |key, value|
       matches = matches + "#{key}: #{value}\n"
     end
     event.respond "#{matches}"
   else
     File.open("tmp/grepquote-#{event.message.id}.txt", "w") do |file|
       file.write(matches_hash.to_yaml)
     end
     event.respond "More then 10 matches found, uploading text."
     File.open("tmp/grepquote-#{event.message.id}.txt", "rb") do |file|
       s3.put_object(bucket: S3BUCKET, key: "grepquote-#{event.message.id}.txt", body: file)
     end
     File.delete("tmp/grepquote-#{event.message.id}.txt")
     event.respond "https://#{S3BUCKET}.s3-#{S3REGION}.amazonaws.com/grepquote-#{event.message.id}.txt"
  end
end



bot.command(:sergequote, min_args: 0, max_args:0) do |event|
  yml = YAML.load_file 'quotes.yml'
  cnt = 0
  sergequotes = Array.new
  yml.each_pair do |key, value|
    if value.downcase =~ /serge/
      cnt += 1
      sergequotes << key
    end
  end
  s = Rand.new(cnt)
  s.size = cnt
  num = s.next
  id = sergequotes[num]
  response = yml[id]
  event.respond "Quote ID #{id}: #{response}"
end


bot.command(:gdq) do |event|
  event.respond "#{Net::HTTP.get(URI('https://taskinoz.com/gdq/api/'))}"
end


bot.command(:sergebox) do |event|
  event.respond "https://imgur.com/M3W3pQ3"
end

bot.command(:reparsequotedb) do |event|
  yml = YAML.load_file 'quotes.yml'
  yml2 = {}
  File.open("quotes.yml", "w") do |file|
    yml.keys.each_with_index do |var,i|
      yml2[i] = yml[var]
    end
    file.write(yml2.to_yaml)
  end
  r.size = yml.size
  event.respond "Reparsed DB"
end


bot.command(:deletequote, min_args:1, max_args:1) do |event, *args|
  qid = args.join(' ')
  yml = YAML.load_file 'quotes.yml'
  quote = yml[qid.to_i]
  yike_emoji = bot.emoji(489347848450867210)
  pika_emoji = bot.emoji(524010864467116048)
  message = event.respond("Delete quote?\n #{qid}: #{quote}\n#{yike_emoji} to confirm, #{pika_emoji} to cancel.")
  message.react yike_emoji
  message.react pika_emoji
  while true
    reaction = bot.add_await!(Discordrb::Events::ReactionAddEvent, {emoji: [489347848450867210, 524010864467116048]})
    if message == reaction.message
      break
    end
  end
  if reaction.emoji == yike_emoji
    yml = YAML.load_file 'quotes.yml'
    if yml[qid.to_i] == quote
      yml.delete(qid.to_i)
      File.open("quotes.yml", "w") do |file|
        file.write(yml.to_yaml)
      end
      yml = YAML.load_file 'quotes.yml'
      yml2 = {}
      File.open("quotes.yml", "w") do |file|
        yml.keys.each_with_index do |var,i|
        yml2[i] = yml[var]
        end
        file.write(yml2.to_yaml)
      end
      event.respond "Quote #{qid} Deleted."
    else
      event.respond "DB Changed! Deletion canceled, try again."
    end
    message.delete
  elsif reaction.emoji == pika_emoji
    event.respond "Delete Canceled."
    message.delete
  end
end



bot.run





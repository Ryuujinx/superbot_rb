#!/usr/bin/env ruby

require 'rubygems'
require 'discordrb'
require 'yaml'
require 'net/http'
require 'uri'
require 'aws-sdk-s3'
Dir["lib/*.rb"].each {|file| load file}
Dir["lib/commands/*.rb"].each {|file| load file}
Dir["lib/events/*.rb"].each {|file| load file}
Dir.mkdir('tmp') unless Dir.exists?('tmp')




bot = Discordrb::Commands::CommandBot.new(token: DISCORD_TOKEN, client_id: DISCORD_CLIENT_ID, prefix: PREFIX)

cmd = Commands.new
Commands.instance_methods(false).each do |x|
  cmd.send(x, bot)
end

events = BotEvents.new
BotEvents.instance_methods(false).each do |x|
  cmd.send(x, bot)
end

#puts "This bot's invite URL is #{bot.invite_url}"

bot.run

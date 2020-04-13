#!/usr/bin/env ruby

require 'rubygems'
require 'discordrb'
require 'yaml'
require './random.rb'
require './config.rb'
require 'net/http'
require 'uri'
require 'aws-sdk-s3'


Dir["lib/commands/*.rb"].each {file| load file}
Dir["lib/config/*.rb"].each {file| load file}


r = Rand.new(YAML.load_file('data/quotes.yml').size)
s3 = Aws::S3::Client.new(profile: S3PROFILE, region: S3REGION)
bot = Discordrb::Commands::CommandBot.new(token: DISCORD_TOKEN, client_id: DISCORD_CLIENT_ID, prefix: PREFIX)
Dir.mkdir('tmp') unless Dir.exists?('tmp')

cmd = Commands.new

Commands.instance_methods(false).each do |x|
  cmd.send(x, bot)
end

#puts "This bot's invite URL is #{bot.invite_url}"

bot.run

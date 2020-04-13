#!/usr/bin/env ruby

require 'rubygems'
require 'discordrb'
require 'yaml'
require 'net/http'
require 'uri'
require 'aws-sdk-s3'
Dir["lib/*.rb"].each {|file| load file}
Dir["lib/commands/*.rb"].each {|file| load file}
Dir["lib/config/*.rb"].each {|file| load file}
Dir.mkdir('tmp') unless Dir.exists?('tmp')



cmd = Commands.new
Commands.instance_methods(false).each do |x|
  cmd.send(x, bot)
end

#puts "This bot's invite URL is #{bot.invite_url}"

bot.run

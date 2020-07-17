class Events < Bot
  def execute_timer(bot)
    timers = YAML.load_file 'data/timers.yml'
    timers.each do |timer|     
      @@scheduler.cron timer[0] do
        channels = bot.servers[BOT_SERVER].channels
        channels.each do |channel|
          if channel.name == BOT_CHANNEL
            bot.send_message(channel.id, timer[1])
          end
        end
      end
    end
  end
end

class Commands < Bot
  def addtimer(bot)
    bot.command(:addtimer, min_args: 6) do |event, *args|
      timers = YAML.load_file 'data/timers.yml'
      cron_time = "#{args[0]} #{args[1]} #{args2} #{args3} #{args4}"
      cron_command = args[5..-1].join(' ')
      @@scheduler.cron cron_time do
        channels = bot.servers[BOT_SERVER].channels
        channels.each do |channel|
          if channel.name == BOT_CHANNEL
            bot.send_message(channel.id, cron_command)
          end
        end
      end
      timers << [cron_time, cron_command]
      File.open('data/timers.yml', 'w') do |f|
        f.write(timers.to_yaml)
      end
      event.respond("Timer Added.")
    end
  end
end
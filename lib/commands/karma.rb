class Commands < Bot
  def karma(bot)
    bot.command(:karma, min_args: 0, max_args: 1) do |event, args|
      yml = YAML.load_file 'data/karma.yml'
      if args.nil?
        sortedkarma = yml.sort_by { |user, karma| -karma }
        event.respond "Top 5 users by karma: 
        * #{sortedkarma[0][0]}: #{sortedkarma[0][1]}
        * #{sortedkarma[1][0]}: #{sortedkarma[1][1]}
        * #{sortedkarma[2][0]}: #{sortedkarma[2][1]}
        * #{sortedkarma[3][0]}: #{sortedkarma[3][1]}
        * #{sortedkarma[4][0]}: #{sortedkarma[4][1]}"
      else
        response = yml[args]
        if response.nil?
          event.respond "That user is not in the karma DB"
        else
          event.respond "Karma for #{args}: #{yml[args]}"
        end
      end
    end
  end
end
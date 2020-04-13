class Commands
  def deletequote(bot)
    bot.command(:deletequote, min_args:1, max_args:1) do |event, *args|
    qid = args.join(' ')
    yml = YAML.load_file 'data/quotes.yml'
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
      yml = YAML.load_file 'data/quotes.yml'
      if yml[qid.to_i] == quote
        yml.delete(qid.to_i)
        File.open("data/quotes.yml", "w") do |file|
          file.write(yml.to_yaml)
        end
        yml = YAML.load_file 'data/quotes.yml'
        yml2 = {}
        File.open("data/quotes.yml", "w") do |file|
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
end
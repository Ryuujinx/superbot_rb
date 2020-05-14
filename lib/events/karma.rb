class Events < Bot
  def karma_change(bot)  
    bot.message(with_text: /(?<user>\<@!\d+>|\w+)\s?(?<op>\+\+|--)\s?$/) do |event, match|
      puts event.text
      puts match[:user]
      event.respond event.text
    end
  end
end
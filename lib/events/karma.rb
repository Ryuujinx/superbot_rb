class Events < Bot
  def karma_change(bot)  
    bot.message(with_text: /test.*/) do |event|
      puts event.text
      event.respond event.text
    end
  end
end
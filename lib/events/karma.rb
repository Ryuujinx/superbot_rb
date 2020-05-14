class Events < Bot
  def karma_change(bot)  
    bot.message(with_text: /test.*/) do |event|
      event.respond event.text
    end
  end
end
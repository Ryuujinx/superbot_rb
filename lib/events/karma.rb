class Events < Bot
  def karma_change(bot)  
    bot.message(with_text: /\<@!\d+>\s?(?:\+\+|--)\s?$/) do |event|
      matchdata = /(?<user>\<@!\d+>)\s?(?<op>\+\+|--)\s?$/.match(event.text)  #There's no way to get match from the first regex without doing gross things, so we check here.
      event.respond "<!@#{event.user.id}> is trying to change #{matchdata[:user]} karma: #{matchdata[:op]}"
      puts matchdata[:user]
    end
  end
end
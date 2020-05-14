class Events < Bot
  def karma_change(bot)  
    bot.message(with_text: /\<@!\d+>\s?(?:\+\+|--)\s?$/) do |event|
      matchdata = /(?<user>\<@!\d+>)\s?(?<op>\+\+|--)\s?$/.match(event.text)  #There's no way to get match from the first regex without doing gross things like using globals, so we check here.
      if matchdata[:user] != "<@!#{event.user.id}>" #Don't allow users to modify their own karma.
        yml = YAML.load_file 'data/quotes.yml'
        if matchdata[:op] == "++"
          puts yml[matchdata[:user]]
          yml[matchdata[:user]] += 1
          event.respond "<@!#{event.user.id}> gave #{matchdata[:user]} karma! New karma total: #{yml[matchdata[:user]]}"
        elsif matchdata[:op] == "--"
          yml[matchdata[:user]] -= 1
          event.respond "<@!#{event.user.id}> removed karma from #{matchdata[:user]}! New karma total: #{yml[matchdata[:user]]}"
        else
          event.respond "You should never see this, if you are then contact the bot owner." #We check for ++/--, we should never hit this branch.
        end
        event.respond "<@!#{event.user.id}> is trying to change #{matchdata[:user]} karma: #{matchdata[:op]}"
      else
        event.respond "You can't change your own karma!"
      end
    end
  end
end
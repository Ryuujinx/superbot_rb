class Commands
  def gdq(bot) 
    bot.command(:gdq) do |event|
      event.respond "#{Net::HTTP.get(URI('https://taskinoz.com/gdq/api/'))}"
    end
  end
end
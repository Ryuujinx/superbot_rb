class Commands
  def listroles(bot)
    bot.command(:listroles) do |event|
      if event.channel.name == ROLE_CHANNEL
        server_roles = event.server.roles.map {|role| role.name}
        roles = server_roles.select {|role| ! ROLE_BLACKLIST.include?(role)}
        event.respond "#{roles.join(', ')}"
      end
    end
  end
end
class Commands < Bot
  def quote(bot)
    bot.command(:quote, min_args: 0, max_args: 1) do |event, args|
      yml = YAML.load_file 'data/quotes.yml'
      if args.nil?
        num = @@r.next
      else
        num = args.to_i
        if num < 0
          num = yml.count + num
        end
      end
      response = yml[num]
      if response.nil?
        event.respond "I was unable to find a quote with ID #{num}, therefore I am generating a random quote instead."
        num = @@r.next
        response = yml[num]
      end
      event.respond "Quote ID #{num}: #{response}"
    end
  end
end
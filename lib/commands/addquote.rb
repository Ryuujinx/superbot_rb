class Commands
    def addquote(bot)        
        bot.command(:addquote, min_args: 1) do |event, *args|
            yml = YAML.load_file 'data/quotes.yml'
            size = yml.size
            File.open("data/quotes.yml", "w") do |file|
            yml[size] = args.join(' ')
            file.write(yml.to_yaml)
            end
            r.size = yml.size
            event.respond "Quote had been added as Quote ID #{size}!"
        end
        
        bot.command(:quoteadd, min_args: 1) do |event, *args|
            yml = YAML.load_file 'data/quotes.yml'
            size = yml.size
            File.open("data/quotes.yml", "w") do |file|
            yml[size] = args.join(' ')
            file.write(yml.to_yaml)
            end
            r.size = yml.size
            event.respond "Quote had been added as Quote ID #{size}!"
        end
    end
end
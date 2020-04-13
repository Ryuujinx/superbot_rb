class Commands
  def sergequote(bot)
    bot.command(:sergequote, min_args: 0, max_args:0) do |event|
    yml = YAML.load_file 'data/quotes.yml'
    cnt = 0
    sergequotes = Array.new
    yml.each_pair do |key, value|
      if value.downcase =~ /serge/
        cnt += 1
        sergequotes << key
      end
    end
    s = Rand.new(cnt)
    s.size = cnt
    num = s.next
    id = sergequotes[num]
    response = yml[id]
    event.respond "Quote ID #{id}: #{response}"
  end 
end
# encoding: utf-8

module Prodam::Idealize

module ViewHelper
  def version
    Prodam::Idealize::VERSION
  end

  def version_info
    Prodam::Idealize.info
  end

  def timestamp
    Date.parse(Prodam::Idealize::TIMESTAMP)
  end

  def view(path, options = {})
    @page && @page[:layout] && options.update(layout: @page[:layout].to_sym)
    partial(path, options)
  end

  def partial(path, options = {})
    erb(path.to_sym, options)
  end

  def message
    session[:message] ||= { level: :information, text: nil, url: nil }
    session[:message]
  end

  def data(filename)
    Prodam::Idealize.load_data(filename)
  end

  def remove_html_tags(text)
    text.gsub(/<("[^"]*"|'[^']*'|[^'">])*>/, '')
  end

  def letters
    Hash[('A'..'Z').to_a.map{|i| [i, []]}]
  end

  def sanitize_letter(letter)
    case letter
    when /ÁÀÄÔÃáàäôã/ then 'A'
    when /ÉÈËÊéèëê/   then 'E'
    when /ÍÌÏÎíìïî/   then 'I'
    when /ÓÒÖÔÕóòöôõ/ then 'O'
    when /ÚÙÜÛŨúùüûũ/ then 'U'
    else letter
    end
  end

  def username_pattern
    Usuario::USERNAME_PATTERN
  end

  def email_pattern
    Usuario::EMAIL_PATTERN
  end

  def profiles
    Usuario::PROFILES
  end
end

end # Prodam::Idealize

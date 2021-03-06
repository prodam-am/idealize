# encoding: utf-8

require 'digest'

module Prodam::Idealize

class Usuario < Model[:usuario]
  EMAIL_PATTERN = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  USERNAME_PATTERN = /^[a-zA-Z][a-zA-Z0-9\-_\.]{6,32}$/
  PROFILES = %w{
    administrador
    moderador
    avaliador
  }.freeze

  COLUMNS = %w{
    nome_usuario
    nome
    email
  }.freeze

  plugin :validation_helpers
  set_allowed_columns *(COLUMNS+PROFILES).map(&:to_sym)

  def validate
    super
    validates_presence :nome_usuario, message: 'deve ser atribuído'
    validates_unique :nome_usuario, message: 'já existe'
    validates_min_length 6, :nome_usuario, message: lambda{ |n| "deve ter no mínimo #{n} caracteres" }
    validates_max_length 32, :nome_usuario, message: lambda{ |n| "deve ser de até #{n} caracteres" }
    validates_format USERNAME_PATTERN, :nome_usuario, message: 'deve possuir um formato válido'

    validates_presence :nome, message: 'deve ser atribuído'
    validates_max_length 64, :nome, message: lambda{ |n| "deve ser de até #{n} caracteres" }

    validates_presence :email, message: 'deve ser atribuído'
    validates_unique :email, message: 'já foi registrado'
    validates_max_length 256, :email, message: lambda{ |n| "deve ser de até #{n} caracteres" }
    validates_format EMAIL_PATTERN, :email, message: 'deve possuir um formato válido'

    validates_password_changed
  end

  def set_password(password, confirmation)
    if @password_matched = confirm_password(password, confirmation)
      self[:senha_salt] = encript(self[:nome].downcase.tr(' ', ''), self[:email])
      self[:senha_encriptada] = encript(password, self[:senha_salt])
    end
    self
  end

  def validates_password_changed
    if (!@password_matched.nil? && !@password_matched)
      errors.add(:senha, 'não combina com a confirmação ou está vazia')
    else
      @password_matched
    end
  end

  def authenticate?(password)
    senha_encriptada == encript(password, senha_salt)
  end

  def profiles
    PROFILES.map(&:to_sym).select do |profile|
      self[profile] && (self[profile] =~ /S/i)
    end << :usuario
  end
  alias perfis profiles

  def has_profile?(nome)
    profiles.include? nome
  end
  alias perfil? has_profile?

  def param_name
    "#{id}-#{nome_usuario.downcase}"
  end

private

  def encript(text, salt = nil)
    Digest::MD5.hexdigest(salt ? "#{salt}:#{text}" : text)
  end

  def confirm_password(password, confirmation)
    ((password && confirmation) && !(password.empty? && confirmation.empty?)) && (password == confirmation)
  end

  class << self
    def authenticate(options)
      usuario = find nome_usuario: options[:nome_usuario]
      usuario && (usuario.authenticate? options[:senha]) && usuario
    end

    def by_letra_inicial(*letras)
      where("UPPER(SUBSTR(nome, 1, 1)) IN ?",  letras.map(&:upcase))
    end

    def search(termo)
      regexp_like(nome_usuario: termo, nome: termo)
    end

  private

    def regexp_like(hash)
      expressao = hash.map do |field, pattern|
        format("REGEXP_LIKE(#{field}, '%s', 'i')", pattern.to_s)
      end.join(' OR ')
      where(expressao)
    end
  end
end

end # module

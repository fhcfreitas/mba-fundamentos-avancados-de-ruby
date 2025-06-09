class Settings
  def initialize
    @configurations = {}
  end

  def add(key, value)
    @configurations[key.to_s] = value

    define_singleton_method(key) do
      @configurations[key.to_s]
    end    
  end

  def method_missing(method_name, *args, &block)
    if @configurations.key?(method_name.to_s)
      send(method_name)
    else
      "Configuração '#{method_name}' não existe."
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    @configurations.key?(method_name.to_s) || super
  end
end

settings = Settings.new

# Definindo configurações dinamicamente
settings.add(:timeout, 30)
settings.add(:mode, "production")

# Acessando configurações via método
puts settings.timeout # => 30
puts settings.mode  # => "production"

# Tentando acessar configuração inexistente
puts settings.retry # => "Configuração 'retry' não existe."

# Checando se um método está disponível
puts settings.respond_to?(:timeout) # => true
puts settings.respond_to?(:retry) # => false

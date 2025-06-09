class Settings
  def initialize
    @configurations = {}
  end

  def add(key, value, alias_name: nil, readonly: false)
    key_str = key.to_s
    @configurations[key_str] = value

    # Getter
    define_singleton_method(key) do
      @configurations[key_str]
    end

    # Setter se não for readonly
    unless readonly
      define_singleton_method("#{key}=") do |new_value|
        @configurations[key_str] = new_value
      end
    end

    # Alias opcional
    if alias_name
      alias_str = alias_name.to_s
      define_singleton_method(alias_str) do
        @configurations[key_str]
      end
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
    @configurations.keys.include?(method_name) || super
  end

  def all 
    @configurations
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


#BONUS
puts "----------- BONUS -----------"
settings_2 = Settings.new

# Definindo configurações com alias e readonly
settings_2.add(:timeout, 30, alias_name: :espera)

# Acessando configurações com alias
puts settings_2.timeout # => 30
puts settings_2.espera  # => 30

settings_2.add(:api_key, "SECRET", readonly: true)

settings_2.api_key = "HACKED"

puts settings_2.api_key # => "SECRET"

puts settings_2.all

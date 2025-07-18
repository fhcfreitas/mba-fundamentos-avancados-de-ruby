class Settings
  def initialize()
    @values = {}
  end 
  
  def add(key, value)
    @values[key] = value
    define_singleton_method(key) do 
      @values[key]
    end
  end
end

settings = Settings.new
settings.add(:timeout, 30)
settings.add(:mode, "production")

puts settings.timeout
puts settings.mode

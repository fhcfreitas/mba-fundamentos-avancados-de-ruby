module Dsl
  class TaskDefinition
    attr_reader :name, :task_type, :params, :dependencies, :position_value

    def initialize(name, task_type, options = {})
      @name = name.to_s
      @task_type = task_type.to_s
      @params = options[:params] || {}
      @dependencies = []
    end

    def depends_on(*task_names)
      @dependencies = task_names.flatten.map(&:to_s)
    end

    def position(value)
      @position_value = value
    end

    def param(key, value)
      @params[key.to_s] = value
    end

    def to_h
      {
        name: @name,
        task_type: @task_type,
        params: @params,
        depends_on: @dependencies,
        position: @position_value
      }
    end
  end
end

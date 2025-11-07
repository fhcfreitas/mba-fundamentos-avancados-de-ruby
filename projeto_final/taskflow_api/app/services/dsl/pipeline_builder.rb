module Dsl
  class PipelineBuilder
    attr_reader :pipeline_name, :pipeline_description, :pipeline_config, :tasks_definitions

    def initialize
      @pipeline_config = {}
      @tasks_definitions = []
    end

    def pipeline(name, description: nil, **options, &block)
      @pipeline_name = name
      @pipeline_description = description
      @pipeline_config = options
      instance_eval(&block) if block_given?
      self
    end

    def task(name, task_type, **options, &block)
      task_def = TaskDefinition.new(name, task_type, options)
      task_def.instance_eval(&block) if block_given?
      @tasks_definitions << task_def
      self
    end

    def create_pipeline
      raise "Pipeline name is required" if @pipeline_name.nil?

      pipeline = Pipeline.create!(
        name: @pipeline_name,
        description: @pipeline_description,
        configuration: @pipeline_config,
        status: :active
      )

      @tasks_definitions.each_with_index do |task_def, index|
        task_attrs = task_def.to_h
        task_attrs[:position] ||= index
        pipeline.tasks.create!(task_attrs)
      end

      pipeline
    end
  end
end

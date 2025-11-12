class PipelineExecutor
  attr_reader :pipeline, :results

  def initialize(pipeline)
    @pipeline = pipeline
    @results = []
    @mutex = Mutex.new
  end

  def run
    tasks = pipeline.tasks.to_a

    @tasks_map = tasks.index_by(&:name)

    independent_tasks = tasks.select { |task| task.depends_on.empty? }
    dependent_tasks = tasks.select { |task| task.depends_on.any? }

    execute_concurrently(independent_tasks)
    execute_sequentially(dependent_tasks)

    ResultsProcessor.new(@results).process
  end

  private

  def execute_concurrently(tasks)
    threads = tasks.map do |task|
      Thread.new do
        result = execute_task(task)
        @mutex.synchronize { @results << result }
      end
    end
    threads.each(&:join)
  end

  def execute_sequentially(tasks)
    successful = @results.select { |res| res[:status] == "success" }.map { |res| res[:task_name] }.to_set

    tasks.each do |task|
      dependencies_met = task.depends_on.all? { |dep_name| successful.include?(dep_name) }

      if dependencies_met
        result = execute_task(task)
        @mutex.synchronize do
          @results << result
          successful << task.name if result[:status] == "success"
        end
      else
        @mutex.synchronize do
          @results << {
            task_id: task.id,
            task_name: task.name,
            status: "skipped",
            reason: "Unmet dependencies",
            executed_at: Time.current
          }
        end
      end
    end
  end

  def execute_task(task)
    start_time = Time.now

    output = case task.task_type
    when "http_request"
      perform_http_request(task.params)
    when "data_processing"
      perform_data_processing(task.params)
    when "email_sending"
      perform_email_sending(task.params)
    else
      raise "Unknown task type: #{task.task_type}"
    end

    {
      task_id: task.id,
      task_name: task.name,
      task_type: task.task_type,
      status: "success",
      output: output,
      duration: (Time.current - start_time).round(3),
      executed_at: Time.current,
      thread_id: Thread.current.object_id
    }
  rescue => e
    {
      task_id: task.id,
      task_name: task.name,
      status: "failed",
      error: e.message,
      executed_at: Time.current
    }
  end

  def perform_http_request(params)
    sleep(rand(0.1..0.5))
    {
      url: params["url"],
      code: 200,
      body: { data: "simulated response", size: 1024 },
      timestamp: Time.current
    }
  end

  def perform_data_processing(params)
    sleep(rand(0.1..0.3))
    data = params["data"] || "default_data"
    {
      original: data,
      processed: data.reverse,
      length: data.length,
      operation: params["operation"] || "reverse"
    }
  end

  def perform_email_sending(params)
    sleep(rand(0.2..0.4))
    {
      to: params["to"],
      subject: params["subject"],
      status: "sent",
      sent_at: Time.current,
      message_id: SecureRandom.uuid
    }
  end
end

require 'thread'

class PriorityQueue
  PRIORITY_ORDER = [:high, :medium, :low]

  PRIORITY_ALIASES = {
    default: :medium
  }

  def initialize
    @queues = Hash.new { |hash, key| hash[key] = Queue.new }
    @mutex = Mutex.new
  end

  def enqueue(item, priority)
    raise ArgumentError, "Prioridade inválida: #{priority}. Use :high, :medium, ou :low." unless PRIORITY_ORDER.include?(priority)

    @mutex.synchronize do
      @queues[priority] << item
    end
  end

  def dequeue
    @mutex.synchronize do
      PRIORITY_ORDER.each do |priority|
        queue = @queues[priority]
        return queue.pop(true) unless queue.empty?
      end
      nil
    end
  rescue ThreadError
    nil
  end

  def empty?
    @mutex.synchronize do
      PRIORITY_ORDER.all? { |priority| @queues[priority].empty? }
    end
  end
end

class DynamicThreadPool
  INITAL_THREADS = 2
  def initialize(max_threads: 10)
    @queue = PriorityQueue.new
    @threads = []
    @max_threads = max_threads
    @mutex = Mutex.new
    @worker_cv = ConditionVariable.new
    @shutdown = false

    INITAL_THREADS.times { add_worker }
  end

  def shutdown
    @shutdown = true
    @threads.each(&:join)
    puts "ThreadPool finalizado."
  end

  def schedule(priority, &block)
    raise ArgumentError, "Prioridade inválida: #{priority}. Use :high, :default(or :medium), ou :low." unless PriorityQueue::PRIORITY_ORDER.include?(priority) || PriorityQueue::PRIORITY_ALIASES.key?(priority)

    @mutex.synchronize do
      return if @shutdown
      priority = PriorityQueue::PRIORITY_ALIASES[priority] || priority

      @queue.enqueue(block, priority)

      @threads.select!(&:alive?)

      if @threads.size < @max_threads
        add_worker
      end

      @worker_cv.signal
    end
  end

  def add_worker
    worker = Thread.new do
      loop do
        task = nil
        @mutex.synchronize do
          @worker_cv.wait(@mutex) while @queue.empty? && !@shutdown
          break if @shutdown && @queue.empty?

          task = @queue.dequeue
        end

        if task
          begin
            task.call
          rescue => e
            puts "Erro ao executar tarefa: #{e.message}"
          end
        end
      end
    end

    @threads << worker
  end
end

pool = DynamicThreadPool.new(max_threads: 3)

10.times do |i|
 pool.schedule(:default) { sleep 1; puts "Tarefa
padrão #{i} concluída" }
end

5.times do |i|
 pool.schedule(:high) { sleep 0.5; puts "Tarefa
prioritária #{i} concluída" }
end

pool.shutdown

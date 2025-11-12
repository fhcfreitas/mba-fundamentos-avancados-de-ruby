class ResultsProcessor
  include Enumerable

  def initialize(results)
    @results = results
  end

  def each(&block)
    @results.each(&block)
  end

  def process
    lazy_results = @results.lazy
      .select { |r| r[:status] == "success" }
      .map { |r| enrich_result(r) }
      .take_while { |r| r[:duration] < 10 }

    {
      summary: build_summary,
      successful_tasks: lazy_results.force,
      statistics: calculate_statistics
    }
  end

  private

  def enrich_result(result)
    result.merge(
      performance_level: performance_level(result[:duration]),
      timestamp_formatted: result[:executed_at]&.strftime("%Y-%m-%d %H:%M:%S")
    )
  end

  def build_summary
    {
      total: @results.size,
      successful: @results.count { |r| r[:status] == "success" },
      failed: @results.count { |r| r[:status] == "failed" },
      skipped: @results.count { |r| r[:status] == "skipped" }
    }
  end

  def calculate_statistics
    durations = @results
      .select { |r| r[:duration] }
      .map { |r| r[:duration] }

    return {} if durations.empty?

    {
      avg_duration: (durations.sum / durations.size).round(3),
      min_duration: durations.min,
      max_duration: durations.max,
      total_duration: durations.sum.round(3)
    }
  end

  def performance_level(duration)
    return "unknown" unless duration

    case duration
    when 0..0.5 then "excellent"
    when 0.5..1.0 then "good"
    when 1.0..2.0 then "acceptable"
    else "slow"
    end
  end

  def duration_category(duration)
    case duration
    when 0..0.5 then "fast"
    when 0.5..1.5 then "medium"
    else "slow"
    end
  end
end

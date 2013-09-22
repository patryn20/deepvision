module CpuUsage
  extend ActiveSupport::Concern

  module ClassMethods
    def available_cpu_time(first_time, second_time)
      second_time - first_time
    end

    def sum_utilized_cpu_time(*args)
      args.reduce(:+)
    end

    def utilized_cpu_time(first_time, second_time)
      second_time - first_time
    end

    def cpu_utilization_percent(available_cpu_time, utilized_cpu_time, cpu_cores)
      ((utilized_cpu_time/(available_cpu_time * 100.0 ))/cpu_cores *100.0).round(2)
    end
  end
end
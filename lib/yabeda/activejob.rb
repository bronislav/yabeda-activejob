require "yabeda"
require "yabeda/activejob/version"
require "yabeda/activejob/engine"

module Yabeda
  module ActiveJob
    LONG_RUNNING_JOB_RUNTIME_BUCKETS = [
      0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5, 10, # standard (from Prometheus)
      30, 60, 120, 300, 1800, 3600, 21_600, # In cases jobs are very long-running
    ].freeze

    def self.install!
      Yabeda.configure do
        group :activejob

        counter :job_executed_total, tags: %i[queue activejob executions], comment: "A counter of the total number of activejobs executed."
        counter :job_success_total, tags: %i[queue activejob executions], comment: "A counter of the total number of activejobs successfully processed."
        gauge :job_failed_total, tags: %i[queue activejob executions], comment: "A counter of the total number of jobs failed for an activejob."

        histogram :job_runtime, comment: "A histogram of the activejob execution time.",
                  unit: :seconds, per: :activejob,
                  tags: %i[queue activejob executions],
                  buckets: LONG_RUNNING_JOB_RUNTIME_BUCKETS

        histogram :job_latency, comment: "The job latency, the difference in seconds between enqueued and running time",
                  unit: :seconds, per: :activejob,
                  tags: %i[queue activejob executions],
                  buckets: LONG_RUNNING_JOB_RUNTIME_BUCKETS



        #successful job post event
        ActiveSupport::Notifications.subscribe "perform.active_job" do |*args|
          ::Rails.logger.debug("JOB COMPLETE")

          event = ActiveSupport::Notifications::Event.new(*args)
          labels = {
            activejob: event.payload[:job].class.to_s,
            queue: event.payload[:job].instance_variable_get(:@queue_name).to_s,
            executions: event.payload[:job].instance_variable_get(:@executions).to_s,
          }
          ::Rails.logger.info(labels.inspect)

          ::Rails.logger.info(activejob_job_success_total.increment(labels).inspect)
          activejob_job_runtime.measure(labels, Yabeda::ActiveJob.ms2s(event.duration))
        end

        #failed job event
        ActiveSupport::Notifications.subscribe "retry_stopped.active_job" do |*args|
          event = ActiveSupport::Notifications::Event.new(*args)
          ::Rails.logger.debug("JOB FAILED")

          labels = {
            activejob: event.payload[:job].class.to_s,
            queue: event.payload[:job].instance_variable_get(:@queue_name),
            executions: event.payload[:job].instance_variable_get(:@executions),
          }
          activejob_job_failed_total.set(labels)
        end

        # start job event
        ActiveSupport::Notifications.subscribe "perform_start.active_job" do |*args|
          event = ActiveSupport::Notifications::Event.new(*args)
          ::Rails.logger.debug("JOB START")

          labels = {
            activejob: event.payload[:job].class.to_s,
            queue: event.payload[:job].instance_variable_get(:@queue_name),
            executions: event.payload[:job].instance_variable_get(:@executions)
          }
          ::Rails.logger.info(labels.inspect)

          labels.merge!(event.payload.slice(*Yabeda.default_tags.keys - labels.keys))
          activejob_job_executed_total.increment(labels)
          activejob_job_latency.measure(labels, Yabeda::ActiveJob.ms2s(Yabeda::ActiveJob.job_latency(event)))
        end
      end
    end

    def self.job_latency(event)
      enqueue_time = event.payload[:job].instance_variable_get(:@enqueued_at)
      enqueue_time = Time.parse(enqueue_time).utc
      perform_at_time = Time.parse(event.end.to_s).utc
      (perform_at_time - enqueue_time)
    end

    def self.ms2s(milliseconds)
      (milliseconds.to_f / 1000).round(3)
    end
  end
end

# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe Yabeda::ActiveJob, type: :integration do
  include ActionDispatch::Integration::Runner
  include ActionDispatch::IntegrationTest::Behavior
  include ActiveJob::TestHelper

  before { ActiveJob::Base.queue_adapter = :inline }

  context "when job is successful" do
    it "increments successful job counter" do
      expect { HelloJob.perform_later }.to \
        increment_yabeda_counter(Yabeda.activejob.job_success_total)
        .with_tags(queue: "default", activejob: "HelloJob", executions: "1")
        .by(1)
    end

    it "does not increment failed job counter" do
      expect { HelloJob.perform_later }.to not_increment_yabeda_counter(Yabeda.activejob.job_failed_total)
    end

    it "increments executed job counter" do
      expect { HelloJob.perform_later }.to \
        increment_yabeda_counter(Yabeda.activejob.job_executed_total)
        .with_tags(queue: "default", activejob: "HelloJob", executions: "1")
        .by(1)
    end

    it "measures job runtime" do
      expect { LongJob.perform_later }.to \
        measure_yabeda_histogram(Yabeda.activejob.job_runtime)
        .with_tags(queue: "default", activejob: "LongJob", executions: "1")
        .with(be_between(0.005, 0.05))
    end

    it "measures job latency" do
      ActiveJob::Base.queue_adapter = :test
      expect { HelloJob.perform_later }.to have_enqueued_job.on_queue("default")
      sleep(1)
      expect { perform_enqueued_jobs }.to measure_yabeda_histogram(Yabeda.activejob.job_latency)
        .with_tags(queue: "default", activejob: "HelloJob", executions: "1")
        .with(be_between(1, 2))
    end
  end

  context "when job fails" do
    it "increments failed job counter" do
      expect { ErrorJob.perform_later }.to increment_yabeda_counter(Yabeda.activejob.job_failed_total)
        .with_tags(
          queue: "default",
          activejob: "ErrorJob",
          executions: "1",
          failure_reason: "StandardError,StandardError",
        ).by(1).and(raise_error(StandardError))
    end

    it "increments executed job counter" do
      expect { ErrorJob.perform_later }.to \
        increment_yabeda_counter(Yabeda.activejob.job_executed_total)
        .with_tags(queue: "default", activejob: "ErrorJob", executions: "1")
        .by(1).and(raise_error(StandardError))
    end

    it "does not increment success job counter" do
      expect { ErrorJob.perform_later }
        .to not_increment_yabeda_counter(Yabeda.activejob.job_success_total)
        .and(raise_error(StandardError))
    end

    it "measures job runtime" do
      expect { ErrorLongJob.perform_later }.to \
        measure_yabeda_histogram(Yabeda.activejob.job_runtime)
        .with_tags(queue: "default", activejob: "ErrorLongJob", executions: "1")
        .with(be_between(0.005, 0.05))
        .and(raise_error(StandardError))
    end
  end
end

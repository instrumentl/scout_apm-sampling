require "scout_apm/transaction"

module ScoutApm
  module Sampling
    module Callbacks
      DEFAULT_SCOUT_APM_SAMPLING_RATE = 1.0

      SCOUT_APM_SAMPLING_RATE = (
        ENV["SCOUT_APM_SAMPLING_RATE"].presence.try(:to_f) || DEFAULT_SCOUT_APM_SAMPLING_RATE
      ).abs

      SCOUT_APM_WORKER_SAMPLING_RATE = (
        ENV["SCOUT_APM_WORKER_SAMPLING_RATE"].presence.try(:to_f) || SCOUT_APM_SAMPLING_RATE
      ).abs

      def self.sample_requests_for_scout
        if rand >= SCOUT_APM_SAMPLING_RATE
          ScoutApm::Transaction.ignore!
        end
      end

      def self.sample_workers_for_scout
        if rand >= SCOUT_APM_WORKER_SAMPLING_RATE
          ScoutApm::Transaction.ignore!
        end
      end

      private

      def sample_requests_for_scout
        ScoutApm::Sampling::Callbacks.sample_requests_for_scout
      end

      def sample_workers_for_scout
        ScoutApm::Sampling::Callbacks.sample_workers_for_scout
      end
    end
  end
end

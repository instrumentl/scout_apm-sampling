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

      private

      def sample_requests_for_scout
        if rand >= SCOUT_APM_SAMPLING_RATE
          ScoutApm::Transaction.ignore!
        end
      end

      def sample_workers_for_scout
        if rand >= SCOUT_APM_WORKER_SAMPLING_RATE
          ScoutApm::Transaction.ignore!
        end
      end
    end
  end
end

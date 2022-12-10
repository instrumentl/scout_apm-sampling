require_relative "../callbacks"

module ScoutApm
  module Sampling
    module Sidekiq
      class ServerMiddleware
        include Callbacks

        # @param [Object] worker the worker instance
        # @param [Hash] job the full job payload
        #   * @see https://github.com/mperham/sidekiq/wiki/Job-Format
        # @param [String] queue the name of the queue the job was pulled from
        # @yield the next middleware in the chain or worker `perform` method
        # @return [Void]
        def call(worker, job, queue)
          sample_workers_for_scout
          yield
        end
      end
    end
  end
end

# json_reporter2.rb - ..

require 'json'
require 'minitest'
require 'minitest/reporters'

# TODO module documentation
module Minitest
  # TODO module documentation
module Reporters
  # TODO: class documentation
class JsonReporter2 < BaseReporter
  def initialize options={}
        super
        @passes = []
      end

        def record(result)
        super
        @passes << result if result.passed? && options[:verbose]
      end


      def report
        super
        @storage = {
          fails: failures_h,
          skips: skips_h
        }
        @storage[:passes] = passes_h if options[:verbose]

        io.write(JSON.dump(@storage))
      end

        def failures_h
        results.reject {|e| e.skipped? or e.passed? }.map {|e| result_h(e, (e.error? ? 'error' : 'failure')) }
      end


        def skips_h
        results.select {|e| e.skipped? }.map {|e| result_h(e, 'skipped') }
      end

      def passes_h
        @passes.map {|e| result_h(e, 'passed') }
      end


        def result_h(result, type)
        {
          type: type,
          class: result.class.name,
          name: result.name,
          time: result.time
        }
      end
end
end
end

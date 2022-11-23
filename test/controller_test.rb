require "test_helper"
require "scout_apm/transaction"

class ControllerTest < ActionController::TestCase
  class TestController < ActionController::Base
    def index
      head :ok
    end
  end

  tests TestController

  setup do
    @routes = ActionDispatch::Routing::RouteSet.new
    @routes.draw { get "index" => "controller_test/test#index" }
  end

  teardown do
    ENV.delete("SCOUT_APM_SAMPLING_RATE")
    ScoutApm::Sampling::Callbacks.const_set(:SCOUT_APM_SAMPLING_RATE, 1.0)
  end

  def reload_module
    load "lib/scout_apm/sampling/callbacks.rb"
  end

  def test_sampling_with_default_sampling_rate
    expect_transaction_not_ignored
  end

  def test_sampling_based_on_environment_variable
    ScoutApm::Sampling::Callbacks.const_set(:SCOUT_APM_SAMPLING_RATE, 0)

    expect_transaction_ignored
  end

  def test_negative_sampling_rate_revert_back_to_default
    ENV["SCOUT_APM_SAMPLING_RATE"] = "-1"
    reload_module

    expect_transaction_not_ignored
  end

  def test_empty_sampling_rate_revert_back_to_default
    ENV["SCOUT_APM_SAMPLING_RATE"] = ""
    reload_module

    expect_transaction_not_ignored
  end

  def test_support_for_decimal_with_no_leading_zero
    ENV["SCOUT_APM_SAMPLING_RATE"] = ".1"
    TestController.any_instance.stubs(:rand).returns(0.09)

    expect_transaction_not_ignored
  end

  def test_higher_than_1_sampling_rate_revert_back_to_default
    ENV["SCOUT_APM_SAMPLING_RATE"] = "1.1"

    expect_transaction_not_ignored
  end

  private

    def expect_transaction_ignored(&block)
      ScoutApm::Transaction.expects(:ignore!).once

      get :index
    end

    def expect_transaction_not_ignored(&block)
      ScoutApm::Transaction.expects(:ignore!).never

      get :index
    end
end

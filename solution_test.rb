require 'test_helper'

class SolutionTest < ActiveSupport::TestCase
  def test_should_find_highest_amount_within_each_hour_period
    test_clicks = [
        { ip:'22.22.22.22', timestamp:'3/11/2016 02:02:58', amount: 7.00 },
        { ip:'11.11.11.11', timestamp:'3/11/2016 02:12:32', amount: 6.50 },
        { ip:'11.11.11.11', timestamp:'3/11/2016 02:13:11', amount: 7.25 },
        { ip:'22.22.22.22', timestamp:'3/11/2016 02:13:54', amount: 2.75 }
         ]
    expect_result = [
        { ip:'22.22.22.22', timestamp:'3/11/2016 02:02:58', amount: 7.00 },
        { ip:'11.11.11.11', timestamp:'3/11/2016 02:13:11', amount: 7.25 }
        ]
    m = Solution.new
    m.find(test_clicks)
    assert_equal 2, m.result_set.length
    assert  (m.result_set - expect_result).empty?

  end

  def test_should_find_the_earliest_click_with_highest_amount_within_each_hour
    test_clicks = [
        { ip:'22.22.22.22', timestamp:'3/11/2016 02:02:58', amount: 5.00 },
        { ip:'11.11.11.11', timestamp:'3/11/2016 02:12:32', amount: 6.50 },
        { ip:'11.11.11.11', timestamp:'3/11/2016 02:13:11', amount: 7.25 },
        { ip:'22.22.22.22', timestamp:'3/11/2016 02:13:54', amount: 5.00 },
        { ip:'11.11.11.11', timestamp:'3/11/2016 02:15:11', amount: 8.25 },
        { ip:'11.11.11.11', timestamp:'3/11/2016 02:19:11', amount: 8.25 }
    ]
    expect_result = [
        { ip:'22.22.22.22', timestamp:'3/11/2016 02:02:58', amount: 5.00 },
        { ip:'11.11.11.11', timestamp:'3/11/2016 02:15:11', amount: 8.25 }
    ]
    m = Solution.new
    m.find(test_clicks)
    assert_equal 2, m.result_set.length
    assert  (m.result_set - expect_result).empty?
    assert_not m.result_set.include?({ ip:'11.11.11.11', timestamp:'3/11/2016 02:19:11', amount: 8.25 })

  end

  def test_should_remove_ip_from_result_set_if_appears_more_than_10
    test_clicks = [
        { ip:'22.22.22.22', timestamp:'3/11/2016 02:02:58', amount: 5.00 },
        { ip:'11.11.11.11', timestamp:'3/11/2016 02:12:32', amount: 6.50 },
        { ip:'11.11.11.11', timestamp:'3/11/2016 02:13:11', amount: 7.25 },
        { ip:'33.33.33.33', timestamp:'3/11/2016 04:13:54', amount: 9.00 },
        { ip:'11.11.11.11', timestamp:'3/11/2016 03:15:11', amount: 8.25 },
        { ip:'11.11.11.11', timestamp:'3/11/2016 04:19:11', amount: 8.25 },
        { ip:'11.11.11.11', timestamp:'3/11/2016 06:19:11', amount: 8.25 },
        { ip:'11.11.11.11', timestamp:'3/11/2016 06:19:11', amount: 8.25 },
        { ip:'11.11.11.11', timestamp:'3/11/2016 07:19:11', amount: 8.25 },
        { ip:'11.11.11.11', timestamp:'3/11/2016 09:19:11', amount: 8.25 },
        { ip:'11.11.11.11', timestamp:'3/11/2016 11:19:11', amount: 8.25 },
        { ip:'11.11.11.11', timestamp:'3/11/2016 11:19:11', amount: 8.25 },
        { ip:'11.11.11.11', timestamp:'3/11/2016 12:19:11', amount: 8.25 },
        { ip:'11.11.11.11', timestamp:'3/11/2016 13:19:11', amount: 8.25 },
        { ip:'11.11.11.11', timestamp:'3/11/2016 15:19:11', amount: 8.25 },
        { ip:'11.11.11.11', timestamp:'3/11/2016 21:19:11', amount: 8.25 },
        { ip:'11.11.11.11', timestamp:'3/11/2016 22:19:11', amount: 12.25 }
    ]
    expect_result = [
        { ip:'22.22.22.22', timestamp:'3/11/2016 02:02:58', amount: 5.00 },
        { ip:'33.33.33.33', timestamp:'3/11/2016 04:13:54', amount: 9.00 }
    ]
    m = Solution.new
    m.find(test_clicks)
    assert_equal 2, m.result_set.length
    assert  (m.result_set - expect_result).empty?
    assert_not m.result_set.include?({ ip:'11.11.11.11', timestamp:'3/11/2016 22:19:11', amount: 12.25 })
  end

end
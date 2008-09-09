require File.dirname(__FILE__) + '/../../../test_helper'

class OgoneNotificationTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Integrations

  OGONE_SHA1_SIGNATURE_IN = '08445a31a78661b5c746feff39a9db6e4e2cc5cf'

  def setup
    @ogone = Ogone::Notification.new(successfull_http_raw_data, {:signature => OGONE_SHA1_SIGNATURE_IN})
  end

  def test_accessors
    assert @ogone.complete?
    assert_equal "Completed", @ogone.status
#    assert_equal "2396925", @ogone.transaction_id
    assert_equal 5000, @ogone.gross
    assert_equal "EUR", @ogone.currency
#    assert @ogone.test?
  end

  def test_status_completed
    assert_equal "Completed", @ogone.status
  end

#  def test_compositions
#    assert_equal Money.new(3166, 'USD'), @ogone.amount
#  end

  def test_invalid_status_should_raise_an_error
    assert_raise(ActiveMerchant::OgoneError) {
      notification = Ogone::Notification.new(faulty_http_raw_data, {:signature => OGONE_SHA1_SIGNATURE_IN})      
    }
  end

  private
  def successfull_http_raw_data
    "orderID=order_342&currency=EUR&amount=50&PM=CreditCard&ACCEPTANCE=test123&STATUS=9&CARDNO=XXXXXXXXXXXX1111&PAYID=2396925&NCERROR=0&BRAND=VISA&IPCTY=BE&CCCTY=US&ECI=7&CVCCheck=NO&AAVCheck=NO&VC=NO&SHASIGN=FE220C6F4492165533488E35F47F231D6BC357FC&IP=82.146.99.233"
  end  

  def faulty_http_raw_data
    "orderID=order_342&currency=EUR&amount=50&PM=CreditCard&ACCEPTANCE=test123&STATUS=abc&CARDNO=XXXXXXXXXXXX1111&PAYID=2396925&NCERROR=0&BRAND=VISA&IPCTY=BE&CCCTY=US&ECI=7&CVCCheck=NO&AAVCheck=NO&VC=NO&SHASIGN=FE220C6F4492165533488E35F47F231D6BC357FC&IP=82.146.99.233"
  end  

end

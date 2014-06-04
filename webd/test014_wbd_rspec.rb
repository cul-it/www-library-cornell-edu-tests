require "selenium-webdriver"
require "rspec"
require_relative "helper"
include RSpec::Expectations

describe "The website" do
  include DriverHelper

  before(:each) do
   _before
  end
  
  after(:each) do
    _after
  end

  it "should have a link to 'Services' which describes Library Liaison program." do
    page_texts = [
     {"ptext"=>"Course Reserves","pcount"=>1}, 
     {"ptext"=>"Library Liaisons","pcount"=>1},
     ]
    @driver.get(@base_url + "/")
    # first we must expose the services area.
    @slink_text = "Services"
    @link_text = "For Faculty and Instructors"
    element_present?(:partial_link_text, @slink_text).should be_true,"expected to find '#{@link_text}' as link text and did not"
    @driver.find_element(:partial_link_text, @slink_text).click
    @body_text = @driver.find_element(:css, "BODY").text
    page_texts.each do |l|
      text_found?(l['ptext'], @body_text)
      links_present?( l['ptext'],l['pcount']).should be_true ,"expected #{l['pcount']} links for #{l['ptext']}, got #{links_present(l['ptext'])}"
    end
    @link_text = "Library Liaison Program"
    element_present?(:partial_link_text, @link_text).should be_true,"expected to find '#{@link_text}' as link text and did not"
    @driver.find_element(:partial_link_text, @link_text).click
    @body_text = @driver.find_element(:css, "BODY").text
    @link_text = "See all liaisons"
    element_present?(:partial_link_text, @link_text).should be_true,"expected to find '#{@link_text}' as link text and did not"
    @driver.find_element(:partial_link_text, @link_text).click
    @page_text = "Eric Acree"
    text_found?(@page_text,@driver.find_element(:css, "BODY").text)

  end

  
  def element_present?(how, what)
    @driver.find_element(how, what)
    true
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  end
  
  def alert_present?()
    @driver.switch_to.alert
    true
  rescue Selenium::WebDriver::Error::NoAlertPresentError
    false
  end
  
  def verify(&blk)
    yield
  rescue ExpectationNotMetError => ex
    @verification_errors << ex
  end
  
  def close_alert_and_get_its_text(how, what)
    alert = @driver.switch_to().alert()
    alert_text = alert.text
    if (@accept_next_alert) then
      alert.accept()
    else
      alert.dismiss()
    end
    alert_text
  ensure
    @accept_next_alert = true
  end
end

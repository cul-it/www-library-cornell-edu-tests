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

  it "should have a link to 'aboutus/culpartners' which shows links to partner categories" do
    @driver.get(@base_url + "/about/partnerships")
    # make sure regular exp char set, and body char set match
    text_found?('Cornell Faculty and Programs',@driver.find_element(:css, "BODY").text)
    text_found?('Other Universities and University Libraries',@driver.find_element(:css, "BODY").text)
    text_found?('Global Engagement',@driver.find_element(:css, "BODY").text)
    text_found?('Corporate Partnerships',@driver.find_element(:css, "BODY").text)
    text_found?('Other Grants Received Recently',@driver.find_element(:css, "BODY").text)
    text_found?('Previous Partnerships',@driver.find_element(:css, "BODY").text)
    element_present?(:link, "Cornell Faculty and Programs").should == true
    @driver.find_element(:link,'Cornell Faculty and Programs').click
    text_found?('Classic Works',@driver.find_element(:css, "BODY").text)
  end


end

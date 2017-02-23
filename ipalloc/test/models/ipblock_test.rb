require 'test_helper'

class IpblockTest < ActiveSupport::TestCase

  setup :set_ipalloc_path

  def teardown
    File.open(@@__datafile, 'w') do |f|
      f.puts "IpBlock,Address,Device"
    end
  end

  test "should initialize ipblock object without any errors" do
    ipalloc = Ipblock.new(ip: '1.2.3.4', device: 'test')
    assert_equal ipalloc.errors.size, 0
  end

  test "should initialize ipblock object with errors for out of range address" do
    ipalloc = Ipblock.new(ip: '11.2.3.4', device: 'test')
    assert_equal ipalloc.errors[0], "ip out of range of current block"
  end

  test "should initialize ipblock object with errors for invalid format" do
    ipalloc = Ipblock.new(ip: '12.3.4', device: 'test')
    assert_equal ipalloc.errors[0], "ip not in valid format"
  end

  test "should save if ipblock is valid and not used before" do
    ipalloc = Ipblock.new(ip: '1.2.11.111', device: 'testabcd')
    assert ipalloc.save, "error: ipblock not saved"
  end

  test "should not save if ipblock is valid and used before" do
    ipalloc = Ipblock.new(ip: '1.2.11.111', device: 'testabcd')
    ipalloc.save
    ipalloc2 = Ipblock.new(ip: '1.2.11.111', device: 'testabcd')
    assert_equal false, ipalloc2.save
  end

  test "should find ipblock that was saved before" do
    ipalloc = Ipblock.new(ip: '1.2.11.111', device: 'testabcd')
    ipalloc.save
    obj = Ipblock.find("1.2.11.111")
    assert_instance_of Ipblock, obj 
  end

  test "should return nil if ipblock not found" do
    assert_nil Ipblock.find("1.2.111.111")
  end


  private

  def set_ipalloc_path
    @@__datafile = "#{Rails.root}/test/ip.data"
  end


end

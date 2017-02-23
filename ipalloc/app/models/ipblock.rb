class Ipblock
  attr_reader :ip, :device, :errors

  def self.find(ipaddress)
    File.open(@@__datafile) do |file_read|
      file_read.each_line do |line|
        block, ipv, device = line.chomp.split(",")
        return self.new(ip: ipv, device: device) if ipv == ipaddress
      end
    end
    nil
  end

  def initialize(opts)
    @ip = opts[:ip] if opts.has_key? :ip
    @device = opts[:device] if opts.has_key? :device
    @errors = []
    validate
  end

  def save
    return false if self.errors.any? 
    if Ipblock.find(self.ip)
      @errors << "Address has been already assigned to a device"
      return false
    else
      file_write_with_lock do 
        File.open(fpath, "a") do |ff|
          ff.puts "#{ipblock},#{self.ip},#{self.device}"
        end
      end
      return true
    end
  end

  def validate
    in_format?
    in_range?
  end

private

  def in_range?
    v1,v2,v3,v4 = self.ip.split(".")
    if (v1.to_i != 1) or (v2.to_i != 2) or !((0..255) === v3.to_i) or !((0..255) === v4.to_i)
      @errors << "ip out of range of current block"
      return false
    end 
    true
  end

  def in_format?
    v1,v2,v3,v4 = self.ip.split(".")
    if !v1 or !v2 or !v3 or !v4
      @errors << "ip not in valid format"
      return false
    end
    true
  end

  def file_write_with_lock(&block) # :nodoc:
    if File.exist?(fpath)
      File.open(fpath) do |f|
      begin
        f.flock File::LOCK_EX
        yield
      ensure
        f.flock File::LOCK_UN
      end
      end
    else
      yield
    end
  end

  def fpath
    @@__datafile 
  end

  def ipblock
    "1.2.0.0/16"
  end

end

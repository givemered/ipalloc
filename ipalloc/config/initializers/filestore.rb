unless ENV['IPALLOC_DATAPATH'].present?
  abort "IPALLOC_DATAPATH environment variable missing."
end

Dir.chdir(ENV['IPALLOC_DATAPATH']) do
  Dir.glob('*').each do |fn|
    next unless File.file? fn
    @@__datafile = "#{Dir.pwd}/#{fn}"
    break;
  end
end

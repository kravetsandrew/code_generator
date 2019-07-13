module CodesGenerator
  def self.perform(args = {})
    all_codes = ("AAAA".."ZZZZ").to_a
    quantity = args[:quantity].to_s.to_i

    quantity = all_codes.count if quantity.zero?
    return all_codes.sample(quantity) if args[:not_ordered] == "true"

    all_codes.take(quantity)
  end
end

module WriteFile
  def self.perform(args = {})
    file_name = args[:output_file]

    unless file_name
      puts "CAUTION: Generated data won't be stored. Get file name to store data."
      return
    end

    data = args[:data]
    File.open(file_name, "w") do |f|
      data.each do |line|
        f.puts line
      end
    end

    puts "Yor codes write to #{file_name}"
  end
end

module HelpInfo
  OPTIONS = [
    ["--quantity", "to get exact number of codes", "--quantity 10"],
    ["--not_ordered", "to get random list of codes", "--not_ordered true"],
    ["--output_file", "to write result of script to desired file", "--output_file sample.txt"]
  ].freeze

  def self.perform(args = {})
    puts "Use folowing options to get desired result:"

    OPTIONS.each do |option, description, example|
      puts "\t#{option}\t#{description}"
      puts "\t\t\tExample:\t\t#{example}"
      puts
    end
  end
end

arguments = {}
ARGV.each_slice(2) do |option, value|
  key = option.gsub("-","").to_sym
  arguments[key] = value
end

[HelpInfo, CodesGenerator, WriteFile].each do |worker|
  data = worker.perform(arguments)
  arguments[:data] = data
end

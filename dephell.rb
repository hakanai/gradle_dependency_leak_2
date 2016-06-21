#!/usr/bin/ruby

def build
  system("gradle clean compileJava > build.log 2>&1")
  #more thorough: system("gradle clean build -x test > build.log 2>&1")
end

def collect_records
  results = []
  Dir.glob('**/build.gradle') do |file|
    original_contents = File.read(file)
    matches = original_contents.scan(/^\s*(compile\s*libraries\.\S+)\s*$/m)
    results += matches.map { |match| [file] + match }
  end
  results
end

def main
  records = collect_records

  puts "Performing initial build to make sure things work before making any changes."
  t0 = Time.new
  if !build
    $stderr.puts "Can't build even before making changes, aborting."
    exit 1
  end
  t1 = Time.new
  dt = t1 - t0
  puts "It built in #{dt} seconds."
  puts "There are #{records.size} lines to check, so this should take about #{records.size * dt} seconds to run."

  records.each do |record|
    file, line = record

    original_contents = File.read(file)
    modified_contents = original_contents.gsub(line, "// #{line}")
    File.write(file, modified_contents)

    if build
      puts "Dependency line in #{file} is INCORRECT: #{line} - REMOVED FROM FILE"
    else
      puts "Dependency line in #{file} is correct: #{line}"
      File.write(file, original_contents)
    end

  end
end

if $0 == __FILE__
  main
end

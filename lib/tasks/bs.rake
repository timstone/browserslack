require 'rubygems'
require 'cucumber'
require 'cucumber/rake/task'
require 'parallel'
require 'json'

@browsers = JSON.load(open('browsers.json'))
@parallel_limit = ENV["nodes"] || 5
@parallel_limit = @parallel_limit.to_i

task :cucumber do
  Parallel.each(@browsers, :in_processes => @parallel_limit) do |browser|
    begin
      puts "Running with: #{browser.inspect}"
      ENV['SELENIUM_BROWSER'] = browser['browser']
      ENV['SELENIUM_VERSION'] = browser['browser_version']
      ENV['BS_AUTOMATE_OS'] = browser['os']
      ENV['BS_AUTOMATE_OS_VERSION'] = browser['os_version']

      Rake::Task[:run_features].execute()
    rescue Exception => e
      puts "Error while running task"
    end
  end
end

Cucumber::Rake::Task.new(:run_features)
task :default => [:cucumber]
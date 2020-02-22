# frozen_string_literal: true

require 'logger'

class Logger
  def self.log
    if @logger.nil?
      Dir.mkdir('./logs') unless Dir.exist?('./logs')
      @log_file = File.open("./logs/debug_log.txt", "w")
      @logger = Logger.new MultiIO.new(STDOUT, @log_file)
      @logger.level = Logger::DEBUG
      @logger.datetime_format = '%Y-%m-%d %H:%M:%S '
    end
    @logger
  end
end

class MultiIO
  def initialize(*targets)
    @targets = targets
  end

  def write(*args)
    @targets.each { |t| t.write(*args); t.flush }
  end

  def close
    @targets.each(&:close)
  end
end

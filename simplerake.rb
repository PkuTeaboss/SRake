require './taskSupport'
require 'optparse'
require 'ostruct'

def parse(args)

    options = OpenStruct.new
    options.list = false
    options.srake_file = ""
	opt_parser = OptionParser.new do |opts|
		opts.banner = "Usage: ./simplerake.rb [options] srake_file [task]"

		opts.on_tail("-T","list task") do
			options.list = true
		end

		opts.on_tail("-h","print help") do
			puts opts
			exit
		end
	end

	opt_parser.parse!(args)

	if ARGV.length == 1 && File.readable?(ARGV[0])
		options.srake_file = ARGV[0]
	elsif ARGV.length == 2 && File.readable?(ARGV[1])
		options.srake_file = ARGV[1]
	else
		puts "InValid Command"
		exit
	end

    return options
end

def desc(text)
    TaskArray.instance.add_task Task.new(text)
end

def task(text,&cmd)
	if TaskArray.instance.last_task == nil or TaskArray.instance.last_task.if_read
      TaskArray.instance.add_task Task.new(text,cmd)
	else
      TaskArray.instance.last_task.task_detail(text,cmd)
    end
end

def sh(cmd)
	system(cmd)
end

def showlist
	TaskArray.instance.taskArray.each do |tasks|
		puts "#{tasks.task_name}             # #{tasks.description}" if tasks.task_name != :default
	end
end

def analysis
	puts "analysis"
end

options = parse(ARGV)
load(options.srake_file)    

if options.list
   	showlist
else
   	analysis
end

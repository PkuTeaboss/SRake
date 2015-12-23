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
    TaskArray.instance.add_hash(TaskArray.instance.last_task)
    $target = TaskArray.instance.last_task.pre_task if TaskArray.instance.last_task.task_name == :default
end

def sh(cmd)
	system(cmd)
end

def call_and_delete(current_task)
	TaskArray.instance.cmdHash[current_task].call if TaskArray.instance.cmdHash[current_task] != nil
    TaskArray.instance.cmdHash.delete(current_task)
end

def showlist
	TaskArray.instance.taskArray.each do |tasks|
		puts "#{tasks.task_name}             # #{tasks.description}" if tasks.task_name != :default
	end
end

def analysis(current_task)
    if current_task != nil
	    if TaskArray.instance.taskHash.keys.include? current_task
	    	if TaskArray.instance.taskHash[current_task].is_a? Array
	    		TaskArray.instance.taskHash[current_task].each do |pretask|
	    		   if TaskArray.instance.inprocess.include? pretask 
	    		   	 puts "Error: #{pretask} is in task circle"
	    		   	 exit
	    		   	else
	    		   	 TaskArray.instance.inprocess << pretask
	    		   	end
                   analysis(pretask)
                   TaskArray.instance.inprocess.delete(pretask)
	    		end
	    		call_and_delete(current_task)
	    	else
                 if TaskArray.instance.cmdHash.keys.include? current_task
                 	if TaskArray.instance.inprocess.include? TaskArray.instance.taskHash[current_task] 
	    		   	 puts "Error: #{TaskArray.instance.taskHash[current_task]} is in task circle"
	    		   	 exit
	    		   	else
	    		   	 TaskArray.instance.inprocess << TaskArray.instance.taskHash[current_task]
	    		   	end
                   analysis(TaskArray.instance.taskHash[current_task])
                   TaskArray.instance.inprocess.delete(TaskArray.instance.taskHash[current_task])
                   call_and_delete(current_task)
                 else
                   call_and_delete(current_task)
                 end
	    	end
	    else
	    	puts "Error, #{current_task} not found in the file"
	    	exit
	    end
    end
end

options = parse(ARGV)
$target = nil  
load(options.srake_file)  
if $target == nil
	puts "Error, :default not found"
	exit
end
if options.list
   	showlist
else
   	analysis($target)
end

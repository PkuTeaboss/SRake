require './taskSupport'


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


load 'test.rake'

TaskArray.instance.taskArray.each do |tasks|
	puts "taskname:#{tasks.task_name}"
	puts "taskdesc:#{tasks.description}" unless tasks.description == nil
 	#puts tasks.task_cmd unless tasks.task_cmd == nil
 	puts "pre_task:#{tasks.pre_task}" unless tasks.pre_task == nil
 	puts "/////"
end
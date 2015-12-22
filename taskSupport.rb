require 'singleton'

class TaskArray
    attr_accessor :taskArray
	include Singleton

	def initialize
		@taskArray = []
	end

    def add_task(task)
    	@taskArray << task
    end
    
    def last_task
        @taskArray.last
    end

end



class Task
 attr_accessor :task_name, :pre_task, :description, :task_cmd, :if_read
 def initialize(text,cmd = 'This is a desc')
 	@description = ""
 	@task_cmd = nil
 	@pre_task = nil
 	@if_read = false
 	cmd == 'This is a desc' ? @description = text : task_detail(text,cmd)
 end

 def task_detail(text,cmd)
   if text.is_a? Hash
	 @task_name = text.keys[0]
	 @pre_task = text.values[0]
   else
     @task_name = text
   end
   @task_cmd = cmd
   @if_read = true
 end
 
end

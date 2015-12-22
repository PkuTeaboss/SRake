def task(text,&cmd)
  puts "Just read a task: #{text}"
  if cmd != nil
   puts "Just read a cmd: #{cmd}"
   cmd.call 
  end
end

def sh(cmd)
  system(cmd)
end

def desc(text)
  puts "Just read a desc: #{text}"
end


load 'test.rake'


require 'fileutils'

# runs block in temp dir, purge it after all
def temp_dir temp='tmp/trash'
  FileUtils.rm_rf temp
  FileUtils.mkpath temp
  Dir.chdir(temp) { yield }
  FileUtils.rm_rf temp
end

# mkpath + touch
def mkfile file
  mkdir File.split(file)[0]
  FileUtils.touch file
end

def mkdir dir
  FileUtils.mkpath dir
end
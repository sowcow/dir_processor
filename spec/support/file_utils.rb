require 'fileutils'

# runs block in temp dir, purge it after all
def temp_dir temp='tmp/trash'
  FileUtils.mkpath temp
  Dir.chdir(temp) { yield }
  FileUtils.rm_rf temp
end

# mkpath + touch
def mkfile file
  FileUtils.mkpath File.split(file)[0]
  FileUtils.touch file
end
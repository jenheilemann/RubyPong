# loads all files in given directories
#
# This uses the concepts of the require_all gem to load all the files in given
# folders, as well as the subfolders. If a certain file throws a nameError, it's
# usually because of a dependancy error; the file is added to an array of failed
# files, and those files are looped through a second time to see if the errors
# are resolved. If there's an error that isn't getting resolved, the first
# error is thrown.

class Autoload
  def initialize
    @root_path = File.join(File.dirname(__FILE__), '..')
  end

  def require_all_files(folder)
    Dir[File.join(@root_path,folder,'*.rb')].each do |file|
      # puts file
      require file
    end
  end

  def require_all(folder, failed = [])
    files = (failed.empty?) ? get_all_files(folder) : failed
    count_before = failed.count
    failed = []
    first_file_error = nil

    files.each do |file|
      begin
        require file
      rescue NameError => ex
        first_file_error ||= ex
        failed << file
      end
    end

    # if the number of erroring files doesn't change from one run to the next, and
    #   there's at least one erroring file
    if failed.size == files.size
      # raise the exception from the first file, because we're in a loop
      raise first_file_error
    elsif !failed.empty?
      # if some failed but a different number than last time
      require_all(folder, failed)
    end

    true
  end

  def get_all_files(folder)
    list = Array.new
    Dir[File.join(@root_path,folder,'*')].each do |f|
      base = File.basename(f)
      if File.directory?(f)
        # puts "Folder: #{f}"
        list.concat(get_all_files(File.join(folder,base)))
      else
        # puts "File:   #{f}"
        list << f
      end
    end
    list
  end
end

autoload = Autoload.new
autoload.require_all('lib')
autoload.require_all('app')
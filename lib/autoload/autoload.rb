# loads all files in given directories
#
# This uses the concepts of the require_all gem to load all the files in given
# folders, as well as the subfolders. If a certain file throws a nameError, it's
# usually because of a dependancy error; the file is added to an array of failed
# files, and those files are looped through a second time to see if the errors
# are resolved. If there's an error that isn't getting resolved, the first
# error is thrown.

class Autoload

  # @param string the base location that we're doing all our file searching from.
  # If you initialize in root of the project, you can run it like this:
  #
  # autoload = Autoload.new(__FILE__)
  # autoload.require_all('app')       # Gets all the files and subfolders
  # autoload.require_files('lib')     # Gets just the files, without subfolders
  #
  # If you initialize in a subfolder, you should add "/../" to the end of the
  # string to get the base folder, as in:
  #
  # autoload = Autoload.new(File.join(__FILE__,'..'))
  def initialize(relative_to)
    @root_path = File.dirname(File.absolute_path(relative_to))
  end

  def require_files(folder)
    files = (Dir[File.join(@root_path,folder,'*.rb')]).map do |f|
      return f if File.file?(f)
    end.compact
    require_and_catch_errors(files)
  end

  def require_all(folder)
    files = get_all_files(folder)
    require_and_catch_errors(files)
  end

  def require_and_catch_errors(files)
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
    true if first_file_error.nil?

    if failed.size == files.size && !first_file_error.nil?
      # raise the exception from the first file, because we're in a loop
      raise first_file_error
    elsif !failed.empty?
      # if some failed but a different number than last time
      require_and_catch_errors(failed)
    end
  end

  def get_all_files(folder)
    list = Array.new
    Dir[File.join(@root_path,folder,'*')].each do |f|
      base = File.basename(f)
      if File.directory?(f)
        # puts "Folder: #{f}"
        list.concat(get_all_files(File.join(folder,base)))
      elsif File.file?(f) && File.extname(f) == '.rb'
        # testing for the file extension is a bit of a hack, but whatevs
        # puts "File: #{f}"
        list << f
      end
    end
    list
  end
end
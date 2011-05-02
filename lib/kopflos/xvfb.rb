require 'tempfile'

# heavily inspired by selenium-client
#   https://github.com/jodell/selenium-client/blob/da0f3dfbc05a6377c0cada09a3d650daf1261415/lib/xvfb/xvfb.rb
module Kopflos
  class Xvfb
    class NotInstalled < Exception
      def message
        msg = <<-MSG
          Could not find Xvfb in PATH.
          Try installing xvfb via `sudo apt-get install xvfb`.
          PATH: #{ENV['PATH']}
        MSG
      end
    end

    attr_accessor :font_path, :resolution, :screen, :redirect, 
        :background, :nohup, :xvfb_cmd

    def initialize(options = {})
      @font_path  = options[:font_path]      || determine_font_path
      @resolution = options[:resolution]     || '1024x768x24'
      @screen     = options[:screen]         || '1'
      @redirect   = options[:redirect]       || " &> /dev/null"
      @background = options[:background]     || true
      @background = options[:nohup]          || false
      @wait       = options[:wait]           || 5
      @manager    = options[:manager] || options[:wm]
    end

    def self.start(options={})
      xvfb = new(options)
      xvfb.start
      xvfb
    end

    def start
      authorize
      if @server = fork
        STDERR.puts "forked => #{@server}"
        sleep @wait
      else
        start_window_manager
        exec *command
      end
    end

    def stop
      Process.kill("USR1", @server)
      Process.wait
    end

    def screenshot(filename='screenshot.png')
      system 'import', '-window', 'root', filename
    end

    def command
      [
        executable,
        ":#{servernum}",
        "-fp", @font_path,
        '-screen', @screen,
        @resolution,
      ]
    end

    protected

      def executable
        return @executable if defined?(@executable)
        @executable = `which Xvfb`.chomp
        if @executable.empty?
          raise NotInstalled
        end
        @executable
      end

      def determine_font_path
        if RUBY_PLATFORM =~ /linux/
          case `cat /etc/issue`
          when /Debian|Ubuntu/
            return '/usr/share/fonts/X11/misc'
          else
            return ENV['XVFB_FONT_PATH'] if ENV['XVFB_FONT_PATH']
          end
        end
        raise "#{RUBY_PLATOFRM} not supported by default, Export $XVFB_FONT_PATH with a path to your X11 fonts/misc directory"
      end

      def authfile
        @authfile ||= Tempfile.new('kopflos_Xauthority')
      end

      def mcookie
        @mcookie ||= `mcookie`.chomp
      end

      def authorize
        ENV['XAUTHORITY'] = authfile.path
        ENV['DISPLAY'] = ":#{servernum}"
        IO.popen('xauth source -', 'w') do |xauth|
          xauth.puts %Q~add :#{servernum} . #{mcookie}~
        end
      end


      # Find a free server number by looking at .X*-lock files in /tmp.
      def find_free_servernum
        servernum  = 99
        while File.exists?("/tmp/.X#{servernum}-lock")
          servernum += 1
        end
        servernum
      end

      def servernum
        @servernum = find_free_servernum
      end

      def start_window_manager
        return unless @manager
        fork do
          system(@manager)
        end
      end

  end

end

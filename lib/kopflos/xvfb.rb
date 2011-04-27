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

    attr_accessor :font_path, :resolution, :display, :redirect, 
        :background, :nohup, :xvfb_cmd

    def initialize(options = {})
      @font_path  = options[:font_path]      || determine_font_path
      @resolution = options[:resolution]     || '1024x768x24'
      @display    = options[:display]        || ':1'
      @redirect   = options[:redirect]       || " &> /dev/null"
      @background = options[:background]     || true
      @background = options[:nohup]          || false
      @screenshot = options[:screenshot_dir] || false
    end

    def start

    end

    def stop

    end

    def screenshot

    end

    def command
      [
        executable,
        @display,
        "-fp #{@font_path}",
        "-screen #{@display}",
        @resolution,
      ] * ' ' 
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

  end

end

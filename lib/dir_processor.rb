require "dir_processor/version"
require 'def_dsl'

def DirProcessor &block
  DirProcessor.new &block
end

module DirProcessor
  def new &block
    DirProcessor.new &block
  end
  module_function :new

  class DirProcessor

    module RemembersBlock
      # def instance_eval &block; @block = block end
      def feed_block &block; @block = block end
    end

    module AcceptPattern
      def accept? file
        name = File.basename file
        regexp_pattern =~ name
      end

      private
      def regexp_pattern
        /^#{ Regexp.escape(pattern).gsub('\*','.*') }$/
      end      
    end

    # module UseBlockAndPattern
    #   def feed given
    #     @block.call given if accept? given
    #   end
    #   private
    # end

    # DSL definition
    class AFile < Struct.new :pattern
      @dsl = :file
      include RemembersBlock, AcceptPattern
      def feed given
        @block.call given if accept? given
      end      
    end
    class ADir < Struct.new :pattern
      @dsl = :dir
      ADir = ADir
      AFile = AFile
      include AcceptPattern

      class First
        include RemembersBlock
        def feed dir; @block.call dir end
      end

      def feed dir
        return unless accept? dir

        # Copy/Paste:
        crap = proc { |x| x == '.' || x == '..' }
        all = Dir.entries(dir).reject(&crap).group_by { |x| File.directory?(x) ? :dirs : :files }
        all_files = all[:files]
        all_dirs = all[:dirs]

        so2(:first).each do |processor|
          processor.feed dir
        end

        so2(:file).each do |processor|
          (all[:files] || []).each { |file| processor.feed long_name(dir,file) }
        end
        so2(:dir).each do |processor|
          (all[:dirs] || []).each { |f| processor.feed long_name(dir,f) }
        end
      end

      private
      def long_name dir,file
        File.join(dir,file).sub /^\.\//, ''
      end      
    end
    extend DefDSL
    def_dsl ADir, AFile

    def initialize &block
      # extend EasyDsl
      # def_dsl self.class
      raise unless block
      # dir '.', &block
      # @dir = so1 :dir
      instance_eval &block #yield
    end


      def feed dir
        # return unless accept? dir

        # Copy/Paste:
        crap = proc { |x| x == '.' || x == '..' }
        all = Dir.entries(dir).reject(&crap).group_by { |x| File.directory?(x) ? :dirs : :files }
        all_files = all[:files]
        all_dirs = all[:dirs]

        so2(:file).each do |processor|
          (all[:files] || []).each { |file| processor.feed long_name(dir,file) }
        end
        so2(:dir).each do |processor|
          (all[:dirs] || []).each { |f| processor.feed long_name(dir,f) }
        end
      end

      private
      def long_name dir,file
        File.join(dir,file).sub /^\.\//, ''
      end  
      
    # def feed dir
    #   # @so = @dir.feed(dir).send(:so)
    #   # p 123
    #   # p @so = ADir.new('.').feed(dir).send(:so)
    #   # ; crap = proc { |x| x == '.' || x == '..' }
    #   # all = Dir.entries(dir).reject(&crap).group_by { |x| File.directory?(x) ? :dirs : :files }
    #   # all_files = all[:files]
    #   # all_dirs = all[:dirs]

    #   #   so2(:file).each do |processor|
    #   #     (all[:files] || []).each { |file| processor.feed long_name(dir,file) }
    #   #   end
    #   #   so2(:dir).each do |processor|
    #   #     (all[:dirs] || []).each { |f| processor.feed long_name(dir,f) }
    #   #   end      
    # end

    # private
    # def long_name dir,file
    #   File.join(dir,file).sub /^\.\//, ''
    # end
  end
end

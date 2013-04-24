# do we need variant for lazy stuff??? (to get rid of dir~first do)
#
# (...)
# so1,so2: returns just last and array
# file,files: yields one by one and all as array

      # file - also one, or just one by one? and files - also array?
      # each_file '*.mp3' do
      # end
      # files ['*.mp3'] do # yields array of files?
      # end
      # file 'about.png' do |file| # optional - more dsl-ish?


describe 'DirProcessor method' do
  it 'takes block' do
    expect { DirProcessor() }.to raise_error
    DirProcessor(){}
  end

  it 'returns instance of dir processor' do
    DirProcessor(){}.class.should == DirProcessor::DirProcessor    
  end

  it 'is configured by block' do
    DirProcessor(){}.send(:so).should_not == DirProcessor(){ dir('.'){} }.send(:so)
  end

  example 'main' do
    data = {}
    this = DirProcessor do
      file 'about.png' do |file|
        data[:about] = file
      end
      dir 'mp3s' do
        first do |dir|
          Dir.exist?(dir).should == true
          (data[:dirs] ||= []) << dir
        end

        file '*.mp3' do |file|
          File.exist?(file).should == true
          (data[:mp3s] ||= []) << file 
        end
      end
      dir 'empty' do
        first do |dir|
          Dir.exist?(dir).should == true
          (data[:dirs] ||= []) << dir
        end
      end
    end

    temp_dir do
      mkfile 'about.png'
      mkfile 'any.other'

      mkfile 'mp3s/one.mp3'
      mkfile 'mp3s/two.mp3'
      mkfile 'mp3s/three.mp3'

      Dir.mkdir 'empty'

      this.feed '.'
    end

    data.keys.should =~ [:about, :dirs, :mp3s]
    data[:about].should == 'about.png'
    data[:mp3s].should =~ %w[ mp3s/one.mp3  mp3s/two.mp3  mp3s/three.mp3 ]
    data[:dirs].should =~ %w[ empty mp3s ]
  end

  example 'just empty dir case' do
    data = {}

    this = DirProcessor do
      dir 'empty' do
        first do |dir|
          Dir.exist?(dir).should == true
          (data[:dirs] ||= []) << dir
        end
      end
    end

    temp_dir do
      Dir.mkdir 'empty'
      this.feed '.'
    end

    data.keys.should =~ [:dirs]
    data[:dirs].should =~ %w[ empty ]    
  end

end
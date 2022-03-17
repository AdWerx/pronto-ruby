RSpec.describe 'all pronto runners' do
  it 'run without error' do
    Dir.chdir('spec/fixtures/test.git') do
      Pronto::CLI.start(%w(run))
    end
  end
end

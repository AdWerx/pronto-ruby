require_relative '../src/process_results'

RSpec.describe ProcessResults do

  before :all do
    ENV['GITHUB_TOKEN'] = 'abc'
  end

  describe '.run' do

    context 'with pronto results' do

      it 'concludes failure' do
        metadata = Metadata.new(
          event: JSON.parse(File.read('spec/event.json')),
          sha: 'ab2c4e',
          workspace: '/github/repo/workspace',
          action: 'adwerx/pronto-ruby',
        )
        post_stub = stub_request(
          :post,
          'https://api.github.com/repos/Codertocat/Hello-World/check-runs'
        ).with do |request|
          data = JSON.parse(request.body)
          expect(data['head_sha']).to eq metadata.sha
          expect(data['name']).to eq 'Pronto'
        end.to_return(status: 201, body: '{"id": 1}', headers: {})

        patch_stub = stub_request(
          :patch,
          'https://api.github.com/repos/Codertocat/Hello-World/check-runs/1'
        ).with do |request|
          data = JSON.parse(request.body)
          expect(data['conclusion']).to eq 'failure'
          expect(data['output']['title']).to eq 'Pronto'
          expect(data['output']['annotations'].size).to eq 9
        end.to_return(status: 200, body: '{}', headers: {})

        result = ProcessResults.run(metadata: metadata, results_io: File.open('spec/results.json'))

        expect(result.success?).to be false
        expect(post_stub).to have_been_requested
        expect(patch_stub).to have_been_requested
      end

    end

    context 'without pronto results' do

      it 'concludes failure' do
        metadata = Metadata.new(
          event: JSON.parse(File.read('spec/event.json')),
          sha: 'ab2c4e',
          workspace: '/github/repo/workspace',
          action: 'adwerx/pronto-ruby',
        )
        post_stub = stub_request(
          :post,
          'https://api.github.com/repos/Codertocat/Hello-World/check-runs'
        ).with do |request|
          data = JSON.parse(request.body)
          expect(data['head_sha']).to eq metadata.sha
          expect(data['name']).to eq 'Pronto'
        end.to_return(status: 201, body: '{"id": 1}', headers: {})

        patch_stub = stub_request(
          :patch,
          'https://api.github.com/repos/Codertocat/Hello-World/check-runs/1'
        ).with do |request|
          data = JSON.parse(request.body)
          expect(data['conclusion']).to eq 'success'
          expect(data['output']['title']).to eq 'Pronto'
          expect(data['output']['annotations'].size).to eq 0
        end.to_return(status: 200, body: '{}', headers: {})

        result = ProcessResults.run(metadata: metadata, results_io: StringIO.new('{}'))

        expect(result.success?).to be true
        expect(post_stub).to have_been_requested
        expect(patch_stub).to have_been_requested
      end

    end

  end

  describe '#print' do

    it 'prints to stderr' do
      metadata = Metadata.new(
        event: JSON.parse(File.read('spec/event.json')),
        sha: 'ab2c4e',
        workspace: '/github/repo/workspace',
        action: 'adwerx/pronto-ruby',
      )
      stub_request(
        :post,
        'https://api.github.com/repos/Codertocat/Hello-World/check-runs'
      ).to_return(status: 201, body: '{"id": 1}', headers: {})

      stub_request(
        :patch,
        'https://api.github.com/repos/Codertocat/Hello-World/check-runs/1'
      ).to_return(status: 200, body: '{}', headers: {})
      err_spy = spy('stderr', puts: true)
      result = ProcessResults.run(metadata: metadata, results_io: File.open('spec/results.json'))
      stub_const('STDERR', err_spy)

      result.print

      expect(err_spy).to have_received(:puts).with(<<~MSG)
Pronto
---
There are 9 issues raised by pronto runners.

Pronto::Rubocop warning
spec/process_results_spec.rb:88

Layout/EmptyLinesAroundBlockBody: Extra empty line detected at block body beginning.

-
Pronto::Rubocop warning
spec/process_results_spec.rb:94

Style/TrailingCommaInArguments: Avoid comma after the last parameter of a method call.

-
Pronto::Rubocop warning
spec/process_results_spec.rb:96

Lint/UselessAssignment: Useless assignment to variable - `post_stub`.

-
Pronto::Rubocop warning
spec/process_results_spec.rb:101

Lint/UselessAssignment: Useless assignment to variable - `patch_stub`.

-
Pronto::Rubocop warning
spec/process_results_spec.rb:106

Metrics/LineLength: Line is too long. [97/80]

-
Pronto::Rubocop warning
spec/process_results_spec.rb:112

Layout/IndentHeredoc: Use 2 spaces for indentation in a heredoc.

-
Pronto::Rubocop warning
spec/process_results_spec.rb:119

Layout/EmptyLinesAroundBlockBody: Extra empty line detected at block body end.

-
Pronto::Rubocop warning
spec/process_results_spec.rb:121

Layout/EmptyLinesAroundBlockBody: Extra empty line detected at block body end.

-
Pronto::Rubocop warning
src/process_results.rb:50

Style/StderrPuts: Use `warn` instead of `STDERR.puts` to allow such output to be disabled.

      MSG
    end

  end

end

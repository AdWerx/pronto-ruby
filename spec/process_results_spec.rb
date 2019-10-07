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
          expect(data['output']['annotations'].size).to eq 17
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

end

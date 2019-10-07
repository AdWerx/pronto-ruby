require_relative './client'

require 'json'
require 'time'

class CheckRun

  attr_accessor :metadata,
                :id

  def initialize(metadata:)
    @metadata = metadata
  end

  def path
    ['/repos', metadata.repo_fullname, 'check-runs', id].compact.join('/')
  end

  def create
    body = {
      name: 'Pronto',
      head_sha: metadata.sha,
      status: :in_progress,
      started_at: Time.now.iso8601,
    }
    resp = client.post(path, body)
    JSON.parse(resp.body).tap do |data|
      self.id = data.fetch('id')
    end
  end

  def complete(conclusion:, output:)
    body = {
      conclusion: conclusion,
      output: output,
      status: :completed,
      completed_at: Time.now.iso8601,
    }
    resp = client.patch(path, body)
    JSON.parse(resp.body)
  end

  def fail
    complete(conclusion: :failure, output: {})
  end

  private

  def client
    @client ||= Client.new
  end

end

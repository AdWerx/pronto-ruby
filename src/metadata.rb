
class Metadata

  attr_accessor :event,
                :sha,
                :workspace,
                :action

  def initialize(event:, sha:, workspace:, action:)
    @event = event
    @sha = sha
    @workspace = workspace
    @action = action
  end

  def repository
    @repository ||= event.fetch('repository')
  end

  def owner
    @owner ||= repository.fetch('owner').fetch('login')
  end

  def repo
    @repo ||= repository.fetch('name')
  end

  def repo_fullname
    @repo_fullname ||= "#{owner}/#{repo}"
  end

  private

end

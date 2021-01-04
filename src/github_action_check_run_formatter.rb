require 'pronto'
require_relative './annotation'

module Pronto
  module Formatter
    class GithubActionCheckRunFormatter < Base

      attr_accessor :messages, :repo, :sha, :check_run

      def format(messages, repo, _)
        self.messages = messages
        self.repo = repo
        self.sha = ENV.fetch('GITHUB_SHA') { repo.head_commit_sha }

        Runner.runners.each do |runner|
          create_check_run(runner, messages_by_runner[runner] || [])
        end

        "#{Runner.runners.size} Check Runs created"
      end

      def client
        @client ||= Octokit::Client.new(
          api_endpoint: config.github_api_endpoint,
          web_endpoint: config.github_web_endpoint,
          access_token: ENV.fetch('GITHUB_TOKEN') { config.github_access_token },
        )
      end

      def create_check_run(runner, runner_messages)
        line_annotations, no_line_annotations = runner_messages.map do |message|
          Annotation.new(message)
        end.partition(&:line?)
        output = OpenStruct.new(
          title: runner.title,
          summary: check_run_summary(runner, runner_messages),
          annotations: line_annotations.map(&:to_h),
        )
        if no_line_annotations.any?
          output.text = <<~TXT
| sha | level | message |
| --- | --- | --- |
#{no_line_annotations.map(&:to_markdown_s).join("\n")}
          TXT
        end
        client.create_check_run(
          repo_slug,
          runner.title,
          sha,
          output: output.to_h,
          conclusion: runner_messages.any? ? :failure : :success,
          started_at: Time.now.iso8601,
          status: :completed,
          completed_at: Time.now.iso8601,
          accept: 'application/vnd.github.antiope-preview+json',
        )
      end

      def check_run_summary(runner, runner_messages)
        if runner_messages.any?
          <<~TXT
            There are #{runner_messages.size} issues raised by the #{runner.title} runner.
            See the information below for details.
          TXT
        else
          "Great job! You're all set here."
        end
      end

      def repo_slug
        @repo_slug ||= if ENV.key?('GITHUB_EVENT_PATH')
                         event = JSON.parse(File.read(ENV.fetch('GITHUB_EVENT_PATH')))
                         event.fetch('repository').fetch('full_name')
                       else
                         config.github_slug || fail('no github.slug in pronto config')
                       end
      end

      def messages_by_runner
        @messages_by_runner ||= messages.uniq.group_by(&:runner)
      end

    end
  end
end

require_relative './metadata'
require_relative './check_run'
require_relative './client'

class ProcessResults

  attr_reader :metadata,
              :results_io,
              :conclusion,
              :output

  def initialize(metadata: metadata_from_env, results_io: ARGF)
    @metadata = metadata
    @results_io = results_io
    @output = OpenStruct.new(
      title: NAME,
      summary: '',
      text: '',
      annotations: [],
    )
  end

  def self.run(*args)
    self.new(*args).run
  end

  def run
    check_run.create
    @conclusion = collect_output
    check_run.complete(conclusion: conclusion, output: output.to_h)
    self
  rescue
    check_run.fail
    raise
  end

  def success?
    conclusion == :success
  end

  private

  def check_run
    @check_run ||= CheckRun.new(metadata: metadata)
  end

  def collect_output
    output.annotations = pronto_results.map do |result|
      {
        path: result.fetch('path'),
        start_line: result.fetch('line'),
        end_line: result.fetch('line'),
        annotation_level: annotation_conversion(result.fetch('level')),
        message: result.fetch('message'),
        title: result.fetch('runner'),
      }
    end

    output['summary'] = <<~TXT
      There are #{output.annotations.size} issues raised by pronto runners.
    TXT
    if output.annotations.any?
      :failure
    else
      :success
    end
  end

  def annotation_conversion(pronto)
    {
      'I' => :notice,
      'W' => :warning,
      'E' => :failure,
    }.fetch(pronto, :warning)
  end

  def pronto_results
    @pronto_results ||= JSON.parse(results_io.read)
  end

  def metadata_from_env
    Metadata.new(
      event: JSON.parse(File.read(ENV.fetch('GITHUB_EVENT_PATH'))),
      sha: ENV.fetch('GITHUB_SHA'),
      workspace: ENV.fetch('GITHUB_WORKSPACE'),
      action: ENV.fetch('GITHUB_ACTION'),
    )
  end

  def print
    annotation_text = annotations.each_with_object('') do |annotation, text|
      text += <<~MSG
#{annotation[:title]} #{annotation[:annotation_level]}
#{annotation[:path]}:#{annotation[:start_line]}

#{annotation[:message]}
      MSG
    end
    puts <<~MSG
#{output.title}
---
#{output.summary}
#{annotation_text.join("\n-")}
    MSG
  end

end

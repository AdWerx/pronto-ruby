class Annotation

  attr_reader :message

  def initialize(message)
    @message = message
  end

  def line?
    !message.line.nil?
  end

  def to_h
    lineno = message.line.new_lineno if message.line
    {
      path: message.path,
      start_line: lineno,
      end_line: lineno,
      annotation_level: level_for(message.level),
      message: message.msg,
      title: message.runner.title,
    }
  end

  def to_markdown_s
    <<~MARKDOWN
**#{message.runner.title}**
```
#{message.msg}
```
    MARKDOWN
  end

  def level_for(pronto_level)
    {
      info: :notice,
      warning: :warning,
      error: :failure,
      fatal: :failure,
    }.fetch(pronto_level, :warning)
  end

end

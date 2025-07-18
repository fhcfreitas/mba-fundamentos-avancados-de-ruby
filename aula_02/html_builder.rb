class HtmlBuilder
  def initialize(&block)
    @html = ""
    instance_eval(&block) if block_given?
  end

  def div(content = nil, &block)
    add_tag("div", content, &block)
  end

  def span(content = nil, &block)
    add_tag("span", content, &block)
  end

  def add_tag(name, content = nil, &block)
    @html << "<#{name}>"
    @html << (block ? instance_eval(&block) : content)
    @html << "</#{name}>\n"
  end

  def result
    @html
  end
 end

 builder = HtmlBuilder.new do
  div do
    div "Conteúdo em div"
    span "Nota em div"
  end
    span "Nota de rodapé"
 end

 puts builder.result

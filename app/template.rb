class Template
  def self.render(template, locals = {})
    self.new(template, locals).to_s
  end
  def initialize(template, locals = {})
    @html = Haml::Engine.new(File.read(File.join(RNK.root,"app/views/#{template}.html.haml"))).render(self, locals)
  end
  def render(template, locals = {})
    self.class.new(template,locals)
  end
  def to_s
    @html
  end
end

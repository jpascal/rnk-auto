class Document < Struct.new(:name, :inn, :ogrn, :email)
  def initialize(args)
    args.each do |key, value|
      self.send("#{key}=", value);
    end
    @save = false
  end
  def to_xml
    Nokogiri::XML::Builder.new(encoding: 'windows-1251') do |xml|
      xml.request do
        xml.requestTime Time.now.iso8601
        xml.operatorName self.name
        xml.inn self.inn
        xml.ogrn self.ogrn
        xml.email self.email
      end
    end.to_xml
  end
  def save
    tmp = File.join RNK.root, 'tmp', 'request'
    File.write(tmp+'.xml', self.to_xml)
    `csptestf -sfsign -sign -detached -add -in #{tmp}.xml -out #{tmp}.sig -my #{self.email}`
    @save = true
  end
  def destroy
    File.unlink self.request.path
    File.unlink self.sign.path
  end
  def request
    @save ? File.open(File.join(RNK.root, 'tmp', 'request.xml')) : raise('Document not saved')
  end
  def sign
    @save ? File.open(File.join(RNK.root, 'tmp', 'request.sig')) : raise('Document not saved')
  end
end
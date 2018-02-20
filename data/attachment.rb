class Attachment
  def initialize(url, filename, type, size)
    @url = url
    @filename = filename
    @type = type
    @size = size
  end

  def to_s
    "Attachment(url=#{@url}, filename=#{@filename}, type=#{@type}, size=#{@size})"
  end
end
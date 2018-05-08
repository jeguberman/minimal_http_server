CONTENT_TYPE_MAPPING = {
  'html' => "text/html",
  "txt" => 'text/plain',
  'png' => 'image/png',
  'jpg' => 'image/jpeg',
  'css' => 'text/css',
  'js' => 'text/js'
}
CONTENT_TYPE_MAPPING.default = 'application/octet-stream'#If the server don't know what it is, then it's a blob. ... And also a virus

STATUS_CODES = {
  200 => "OK",
  404 => "Not Found",
  408 => "Request Timeout"
}

def generateHTML(options={})

  params = {
    title: "index",
    banner: "index",
    status: 200
  }.merge options

  header = <<-HTML
    <head>
      <meta charset='utf-8'>
      <title>#{params[:title]}</title>
    </head>
  HTML


  body = <<-HTML
    <body>
      <h1>#{params[:banner]}</h1>

      <a href='speechless.png' download>
        <img src='speechless.png' width='150px' alt="">
      </a>

      <ul class='files'>
        #{generateFileList}
      </ul>
    </body>
  HTML

  html = <<-HTML
  <!DOCTYPE html>
    <html lang='en' dir='ltr'>
      #{header}
      #{body}
    </html>
  HTML


  responseHeader = "HTTP/1.1 200 OK\r\n" +
  "Content-Type: text/html\r\n" +
  "Content-Length: #{html.bytesize}\r\n" +
  "Connection: close\r\n"

  return responseHeader, html

end

def generateFileList
  home = Dir.pwd
  Dir.chdir WEB_ROOT
  list = ""
begin
  Dir.glob("*").each do |filename|
    if !File.directory? filename
      list += "<li><a href='#{filename}' download>#{filename}</a></li>"
    end
  end
rescue
  sputs "", error:true
end

  return list
end

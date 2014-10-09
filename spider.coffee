http = require 'http'
fs = require 'fs'
$ = require 'cheerio'
iconv = require 'iconv-lite'

url = 'http://www.qq.com'
chunks = []
size = 0

regs = 
	http: /http|\/\//

http.get url, (res) ->

	res.on 'data', (chunk) ->
		chunks.push(chunk)
		size += chunk.length

	res.on 'end', ->
		links = {}
		data = Buffer.concat chunks, size
		html = iconv.decode data, 'gbk'
		$html = $.load html
		$links = $html 'a[href]'
		result = ''
		$links.each (i, ele) ->
			href = $(ele).attr 'href'
			txt = $(ele).text().replace /\s|\t|\n/g, ''
			if regs.http.test href
				result += txt + ':' + href + '\n'
		fs.writeFile __dirname + '/links.txt', result
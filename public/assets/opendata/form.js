(function(){$(function(){return Opendata_ResourceForm.render(),Opendata_ResourceForm.toggleTsv()}),this.Opendata_ResourceForm=function(){function e(){}return e.render=function(){var t;return t=["AVI","BMP","CSV","DOC","DOCX","DOT","GIF","HTML","JPG","LZH","MOV","MP3","MPG","ODS","ODT","OTS","OTT","RAR","RTF","RDF","TAR","TGZ","TTL","TXT","WAV","XLS","XLT","XLSX","XML","ZIP"],$("#item_format").autocomplete({source:function(e,n){return n($.grep(t,function(t){return t.match(new RegExp("^"+e.term,"i"))}))}}),$("#item_in_file").change(function(){return e.autosetFilename(),e.toggleTsv()}),$("#item_format").change(function(){return e.toggleTsv()})},e.autosetFilename=function(){var e;return e=$("#item_in_file").val(),$("#item_name").val(e.replace(/.*[\\\/]/,"")),e.match(/\./)?$("#item_format").val(e.replace(/.*\./,"").toUpperCase()):void 0},e.toggleTsv=function(){return $("#item_format").val().match(/^(csv|tsv)$/i)?$(".in_tsv").hide():$(".in_tsv").show()},e}()}).call(this);
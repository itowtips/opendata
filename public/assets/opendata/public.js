(function(){$(function(){return Opendata_Tooltips.render()}),this.Opendata_Tooltips=function(){function t(){}return t.render=function(){var t;return t=$(".tooltip"),t.click(function(){var t,o,e,n,r;return $(".tooltip ul").hide(),o=$(this),e=o.find("ul").outerHeight(),n=o.offset(),n.top-e<0?(o.find("ul").css("bottom",-1*e-15+"px"),t="ul:after {border: 8px solid transparent; border-bottom-color:#fff; bottom:"+(e-5)+"px;}",r=$("<style>").append(document.createTextNode(t)),$(".tooltip ul style").remove(),o.find("ul").append(r)):(o.find("ul").css("bottom","18px"),t="ul:after {border: 8px solid transparent; border-top-color:#fff; bottom:-13px;}",r=$("<style>").append(document.createTextNode(t)),$(".tooltip ul style").remove(),o.find("ul").append(r)),o.find("ul").show()}),$(document).click(function(o){return t.is($(o.target).closest("div"))?void 0:$(".tooltip ul").hide()})},t}()}).call(this);
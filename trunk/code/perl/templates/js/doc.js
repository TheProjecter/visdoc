var Member = function (inElement, inDisplay) {
	this.element = inElement;
	this.display = inDisplay;
	this.items = [];
}
Member.prototype.element;
Member.prototype.display;


var PRIVATE = "private";
var TYPEINFO = "typeinfo";
var SUMMARIES = "summaries";
var SORT = "sort";

var VisDoc = {
	privateMembers:[],
	typeInfoMembers:[],
	summariesMembers:[],
	sortSections:[],
	initBody:function(el) {
		if (!el) el = document.getElementsByTagName('body')[0];
		$(el).addClass("hasJavascript");
		if (parent.location.href != self.location.href) {
			// page is framed
			// set body class to 'framed': <body class="framed">
			// to address css style 'framed'
			// so that the margins can be defined differently
			$(el).addClass("framed");
		}
	},
	showTOC:function(el) {
		parent.location = "index.html?" + self.location.href;
	},
	hideTOC:function(el) {
		parent.location = self.location;
	},
	
	add:function(inMode, el) {
		var member = new Member(el, el.style.display);
		if (inMode == PRIVATE) {
			this.privateMembers.push(member);
		}
		if (inMode == TYPEINFO) {
			this.typeInfoMembers.push(member);
		}
		if (inMode == SUMMARIES) {
			this.summariesMembers.push(member);
		}
		if (inMode == SORT) {
			this.sortSections.push(member);
			this.sortSections[el.id] = member;
		}
	},
	showMembers:function(inMode) {
		var members;
		if (inMode == PRIVATE) {
			members = this.privateMembers;
		}
		if (inMode == TYPEINFO) {
			members = this.typeInfoMembers;
		}
		if (inMode == SUMMARIES) {
			members = this.summariesMembers;
		}
		var i,ilen = members.length;
		for (i=0; i<ilen; ++i) {
			var member = members[i];
			member.element.style.display = member.display;
		}
	},
	hideMembers:function(inMode) {
		var members;
		if (inMode == PRIVATE) {
			members = this.privateMembers;
		}
		if (inMode == TYPEINFO) {
			members = this.typeInfoMembers;
		}
		if (inMode == SUMMARIES) {
			members = this.summariesMembers;
		}
		var i,ilen = members.length;
		for (i=0; i<ilen; ++i) {
			var member = members[i];
			member.element.style.display = "none";
		}
	},
	updateState:function(inMode, inState) {
		if (inState == "show") {
			this.showMembers(inMode);
			visdoc.Pref.setPref("show" + inMode, "1");
			return;
		} else if (inState == "hide") {
			this.hideMembers(inMode);
			visdoc.Pref.setPref("show" +inMode, "0");
			return;		
		}
		if (!inState) {
			var doShowPrivateMembers = visdoc.Pref.getPref("show" + inMode);
			if (doShowPrivateMembers == "0") {
				this.hideMembers(inMode);
			} else {
				this.showMembers(inMode);
			}
		}
	},
	/**
	inMode: either 'alphabetically' or 'sourceorder'
	*/
	updateSort:function(inMode) {
		if (inMode == "alphabetically") {
			this.sortMembers(inMode);
			visdoc.Pref.setPref(SORT, "1");
			return;
		} else if (inMode == "sourceorder") {
			this.sortMembers(inMode);
			visdoc.Pref.setPref(SORT, "0");
			return;		
		}
		if (!inMode) {
			var sortState = visdoc.Pref.getPref(SORT);
			if (sortState == "0") {
				this.sortMembers("sourceorder");
			} else {
				this.sortMembers("alphabetically");
			}
		}
	},
	/**
	inMode: either 'alphabetically' or 'sourceorder'
	*/
	sortMembers:function(inMode) {
		var i,ilen = this.sortSections.length;
		for (i=0; i<ilen; ++i) {
			var section = this.sortSections[i];
			var id = section.element.id;
			var elements = $('ul#' + id + ' li.sortli').remove().get();
			if (inMode == 'alphabetically') {
				elements.sort(this.compareAlphabetically);
			}
			if (inMode == 'sourceorder') {
				elements.sort(this.compareSourceOrder);
			}
			$(elements).appendTo('#' + id);
			
		}
	},
	compareAlphabetically:function (a,b) {
		var memberNameA = a.innerText.toLowerCase().split(" ")[0];
		var memberNameB = b.innerText.toLowerCase().split(" ")[0];
	    if (memberNameA < memberNameB) {
	        return -1;
	    }
	    if (memberNameA > memberNameB) {
	        return 1;
	    }
		return 0;
	},
	compareSourceOrder:function (a,b) {
		var re = new RegExp(/\blistnum([0-9]+)\b/);
		var memberNumA = parseInt(re.exec(a.className)[1]);
		var memberNumB = parseInt(re.exec(b.className)[1]);
	    if (memberNumA < memberNumB) {
	        return -1;
	    }
	    if (memberNumA > memberNumB) {
	        return 1;
	    }
		return 0;
	}
}

$(function() {
	$("body").each(function() {
		VisDoc.initBody(this);
	});
	$(".private").each(function() {
		VisDoc.add(PRIVATE, this);
	});
	$(".typeInfo").each(function() {
		VisDoc.add(TYPEINFO, this);
	});
	$(".memberSummaryPart ul.summary li").each(function() {
		VisDoc.add(SUMMARIES, this);
	});
	$(".memberSummaryPart ul.sortable").each(function() {
		VisDoc.add(SORT, this);
	});
	$("#twistyTOC_show a").click(function() {
		VisDoc.showTOC(this);
	});
	$("#twistyTOC_hide a").click(function() {
		VisDoc.hideTOC(this);
	});
	$("#twistyPrivate_show a").click(function() {
		VisDoc.updateState(PRIVATE, "hide");
	});
	$("#twistyPrivate_hide a").click(function() {
		VisDoc.updateState(PRIVATE, "show");
	});
	$("#twistySummaries_show a").click(function() {
		VisDoc.updateState(SUMMARIES, "hide");
	});
	$("#twistySummaries_hide a").click(function() {
		VisDoc.updateState(SUMMARIES, "show");
	});
	$("#twistyTypeInfo_show a").click(function() {
		VisDoc.updateState(TYPEINFO, "hide");
	});
	$("#twistyTypeInfo_hide a").click(function() {
		VisDoc.updateState(TYPEINFO, "show");
	});
	$("#twistySort_show a").click(function() {
		VisDoc.updateSort("sourceorder");
	});
	$("#twistySort_hide a").click(function() {
		VisDoc.updateSort("alphabetically");
	});
});

function initUpdateSort() {
	VisDoc.updateSort();
}

function initFromCookie () {
	VisDoc.updateState(PRIVATE);
	VisDoc.updateState(TYPEINFO);
	VisDoc.updateState(SUMMARIES);
	initUpdateSort();
	setTimeout(initUpdateSort, 200);
} 
/*
Tells the toc frame to update and highlight the link that corresponds to the shown page.
*/
function setCurrentPage() {
	var el = document.getElementsByTagName('body')[0];
	if (el) {
		var tocFrame;
		if (top.tocFrame && top.tocFrame.setCurrentDocPageId) {
			tocFrame = top.tocFrame;
		}
		if (top.packageTocFrame && top.packageTocFrame.tocFrame && top.packageTocFrame.tocFrame.setCurrentDocPageId) {
			tocFrame = top.packageTocFrame.tocFrame;
		}
		if (tocFrame) {
			tocFrame.setCurrentDocPageId(el.id);
		}
	}
}
$(document).ready(function() {
	setCurrentPage();
	initFromCookie();
});

/* Define innerText for Mozilla based browsers */
if((typeof HTMLElement != 'undefined') && (HTMLElement.prototype.__defineGetter__ != 'undefined'))   {
	HTMLElement.prototype.__defineGetter__("innerText", function () {
		var r = this.ownerDocument.createRange();       r.selectNodeContents(this);
		return r.toString();
	});
}

// VisDoc - Code documentation generator, http://visdoc.org
// This software is licensed under the MIT License
//
// The MIT License
//
// Copyright (c) 2010 Arthur Clemens, VisDoc contributors
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

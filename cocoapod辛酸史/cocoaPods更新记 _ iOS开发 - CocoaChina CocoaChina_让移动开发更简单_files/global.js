/*
 *对话框类。
 *使用举例：
 *@example
 new PwMenu('boxID').guide();
 *
 */
/**
 *@param String id 对话框的id，若不传递，则默认为pw_box
 */
PWMENU_ZINDEX=0;

function PwMenu(id){
	this.pid	= null;
	this.obj	= null;
	this.w		= null;
	this.h		= null;
	this.t		= 0;
	this.menu	= null;
	this.mid	= id;
	this.oCall  = null;
	this.init(id);
}

PwMenu.prototype = {

	init : function(id) {
		this.menu = getPWBox(id);
		var _ = this;
		document.body.insertBefore(this.menu,document.body.firstChild);
		_.menu.style.zIndex=PWMENU_ZINDEX+10+"";
		PWMENU_ZINDEX+=10;
	},

	guide : function() {
		this.menu=this.menu||getPWBox(this.mid);
		this.menu.className = '';
		this.menu.innerHTML = '<div class="popout"><table border="0" cellspacing="0" cellpadding="0"><tbody><tr><td class="bgcorner1"></td><td class="pobg1"></td><td class="bgcorner2"></td></tr><tr><td class="pobg4"></td><td><div class="popoutContent" style="padding:20px;"><img src="'+imgpath+'/loading.gif" align="absmiddle" /> 正在加载数据...</div></td><td class="pobg2"></td></tr><tr><td class="bgcorner4"></td><td class="pobg3"></td><td class="bgcorner3"></td></tr></tbody></table></div>';
		this.menupz(this.obj);
	},

	close : function() {
		var _=this;
		read.t = setTimeout(function() {
			_.menu?0:_.menu=read.menu;
			if (_.menu) {
				_.menu.style.display = 'none';
				_.menu.className = '';
				if (_.oCall && _.oCall.close) _.oCall.close();
			}
		}, 100);
	},

	setMenu : function(element,type,border,oCall) {
		if (this.IsShow() && this.oCall && this.oCall.close) {
			this.oCall.close();
		}
		if (type) {
			this.menu=this.menu||getPWBox(this.mid);
			var thisobj = this.menu;
		} else {
			var thisobj = getPWContainer(this.mid,border);
		}
		if (typeof(element) == 'string') {
			thisobj.innerHTML = element;
		} else {
			while (thisobj.hasChildNodes()) {
				thisobj.removeChild(thisobj.firstChild);
			}
			thisobj.appendChild(element);
		}
		this.oCall = null;
		if (typeof oCall == 'object' && oCall.open) {
			this.oCall = oCall;
			oCall.open();
		}
	},

	move : function(e) {
		if (is_ie) {
			document.body.onselectstart = function(){return false;}
		}
		var e  = is_ie ? window.event : e;
		var o  = this.menu||getPWBox(this.mid);
		var x  = e.clientX;
		var y  = e.clientY;
		this.w = e.clientX - parseInt(o.offsetLeft);
		this.h = e.clientY - parseInt(o.offsetTop);
		var _=this;
		document.onmousemove = function(e) {
			_.menu=_.menu||getPWBox(_.mid);
			var e  = is_ie ? window.event : e;
			var x  = e.clientX;
			var y  = e.clientY;
			_.menu.style.left = x - _.w + 'px';
			_.menu.style.top  = y - _.h + 'px';
		};
		document.onmouseup   = function() {
			if (is_ie) {
				document.body.onselectstart = function(){return true;}
			}
			document.onmousemove = '';
			document.onmouseup   = '';
		};
	},


	open : function(idName, object, type, pz, oCall) {
		if (typeof idName == 'string') {
			idName = getObj(idName);
		}
		if (idName == null) return false;
		this.menu=this.menu||getPWBox(this.mid);
		clearTimeout(read.t);
		if (typeof type == "undefined" || !type) type = 1;
		if (typeof pz == "undefined" || !pz) pz = 0;

		this.setMenu(idName.innerHTML, 1, 1, oCall);
		this.menu.className = idName.className;
		this.menupz(object,pz);
		var _=this;
		if (type == 3) {
			document.onmousedown = function (e) {
				var o = is_ie ? window.event.srcElement : e.target;
				if (!issrc(o)) {
					read.close();
					document.onmousedown = '';
				}
			}
		} else if (type != 2) {
			getObj(object).onmouseout = function() {_.close();getObj(object).onmouseout = '';};
			this.menu.onmouseout = function() {_.close();}
			this.menu.onmouseover = function() {clearTimeout(read.t);}
		}
	},

	menupz : function(obj,pz) {
		this.menu=this.menu||getPWBox(this.mid);
		this.menu.onmouseout = '';
		this.menu.style.display = '';
		//this.menu.style.zIndex	= 3000;
		this.menu.style.left	= '-500px';
		this.menu.style.visibility = 'visible';

		if (typeof obj == 'string') {
			obj = getObj(obj);
		}
		if (obj == null) {
			if (is_ie) {
				this.menu.style.top  = (ietruebody().offsetHeight - this.menu.offsetHeight)/3 + getTop() +($('upPanel')?$('upPanel').scrollTop:0)+ 'px';
				this.menu.style.left = (ietruebody().offsetWidth - this.menu.offsetWidth)/2 + 'px';
			} else {
				this.menu.style.top  = (ietruebody().clientHeight - this.menu.offsetHeight)/3 + getTop() + 'px';
				this.menu.style.left = (ietruebody().clientWidth - this.menu.offsetWidth)/2 + 'px';
			}
		} else {
			var top  = findPosY(obj);
			var left = findPosX(obj);
			var pz_h = Math.floor(pz/10);
			var pz_w = pz % 10;
			if (is_ie) {
				var offsetheight = ietruebody().offsetHeight;
				var offsethwidth = ietruebody().offsetWidth;
			} else {
				var offsetheight = ietruebody().clientHeight;
				var offsethwidth = ietruebody().clientWidth;
			}
			/*
			if (IsElement('upPanel') && is_ie) {
				var gettop = 0;
			} else {
				var gettop  = ;
			}
			*/
			var show_top = IsElement('upPanel') ? top - getObj('upPanel').scrollTop : top;

			if (pz_h!=1 && (pz_h==2 || show_top < offsetheight/2)) {
				top += getTop() + obj.offsetHeight;
			} else {
				top += getTop() - this.menu.offsetHeight;
			}
			if (pz_w!=1 && (pz_w==2 || left > (offsethwidth)*3/5)) {
				left -= this.menu.offsetWidth - obj.offsetWidth + getLeft();
			} else {
				left += getLeft();
			}
			this.menu.style.top = top + 'px';
			if (top < 0) {
				this.menu.style.top  = 0  + 'px';
			}
			this.menu.style.left = left + 'px';
			if (left + this.menu.offsetWidth > document.body.offsetWidth+ietruebody().scrollLeft) {
				this.menu.style.left = document.body.offsetWidth+ietruebody().scrollLeft-this.menu.offsetWidth-30 + 310 + 'px';
			}
		}
	},

	InitMenu : function() {
		var _=this;
		function setopen(a,b) {
			if (getObj(a)) {
				var type = null,pz = 0,oc;
				if (typeof window[a] == 'object') {
					oc = window[a];
					oc.type ? type = oc.type : 0;
					oc.pz ? pz = oc.pz : 0;
				}
				getObj(a).onmouseover = function(){_.open(b, a, type, pz, oc);};
				//getObj(a).onmouseover=function(){_.open(b,a);callBack?callBack(b):0};
				//try{getObj(a).parentNode.onfocus = function(){_.open(b,a);callBack?callBack(b):0};}catch(e){}
			}
		}
		for (var i in openmenu) {
			try{setopen(i,openmenu[i]);}catch(e){}
		}
	},

	IsShow : function() {
		this.menu=this.menu||getPWBox(this.mid);
		return (this.menu.hasChildNodes() && this.menu.style.display != 'none') ? true : false;
	}
};
var read = new PwMenu();

function closep() {
	read.menu.style.display = 'none';
	read.menu.className = '';
}
function findPosX(obj) {
	var curleft = 0;
	if (obj.offsetParent) {
		while (obj.offsetParent) {
			curleft += obj.offsetLeft
			obj = obj.offsetParent;
		}
	} else if (obj.x) {
		curleft += obj.x;
	}
	return curleft - getLeft();
}
function findPosY(obj) {
	var curtop = 0;
	if (obj.offsetParent) {
		while (obj.offsetParent) {
			curtop += obj.offsetTop
			obj = obj.offsetParent;
		}
	} else if (obj.y) {
		curtop += obj.y;
	}
	return curtop - getTop();
}
function in_array(str,a){
	for (var i=0; i<a.length; i++) {
		if(str == a[i])	return true;
	}
	return false;
}
function loadjs(path, code, id, callBack) {
	if (typeof id == 'undefined') id = '';
	if (id != '' && IsElement(id)) {
		try{callBack?callBack():0;}catch(e){}
		return false;
	}
	var header = document.getElementsByTagName("head")[0];
	var s = document.createElement("script");
	if (id) s.id  = id;
	if (path) {
		s.src = path;
	} else if (code) {
		s.text = code;
	}
	if (document.all) {
		s.onreadystatechange = function() {
			if (s.readyState == "loaded" || s.readyState == "complete") {
				callBack?callBack():0;
			}
		};
	} else {
		try{s.onload = callBack?callBack:null;}catch(e){callBack?callBack():0;}
	}
	header.appendChild(s);
	return true;
}
function keyCodes(e) {
	if (read.menu.style.display == '' && e.keyCode == 27) {
		read.close();
	}
}

function opencode(menu,td,id) {
	var id = id || 'ckcode';
	if (read.IsShow() && read.menu.firstChild.id == id) return;
	read.open(menu,td,2,11);
	getObj(id).src = 'ck.php?nowtime=' + new Date().getTime();

	document.body.attachEvent("onmousedown",function(e) {
		var o = is_ie ? window.event.srcElement : e.target;
        var f = is_ie ? false : true;//firefox  e.type = click by lh

		if( o!=getObj(id) && o!=td )
		{
		  return !!closep();
		}
		if (o == td || (f && e.type == "click")) {
			return;
		} else if (o.id == id) {
			getObj(id).src = 'ck.php?nowtime=' + new Date().getTime();
		} else {
			closep();
			document.body.onclick = null;
		}
	});
}

function getPWBox(type){
	if (getObj(type||'pw_box')) {
		return getObj(type||'pw_box');
	}
	var pw_box	= elementBind('div',type||'pw_box','','position:absolute');

	document.body.appendChild(pw_box);
	return pw_box;
}

function getPWContainer(id,border){
	if (typeof(id)=='undefined') id='';
	if (getObj(id||'pw_box')) {
		var pw_box = getObj(id||'pw_box');
	} else {
		var pw_box = getPWBox(id);
	}
	if (getObj(id+'box_container')) {
		return getObj(id+'box_container');
	}

	if (border == 1) {
		pw_box.innerHTML = '<div class="popout"><div id="'+id+'box_container"></div></div>';
	} else {
		pw_box.innerHTML = '<div class="popout"><table border="0" cellspacing="0" cellpadding="0"><tbody><tr><td class="bgcorner1"></td><td class="pobg1"></td><td class="bgcorner2"></td></tr><tr><td class="pobg4"></td><td><div class="popoutContent" id="'+id+'box_container"></div></td><td class="pobg2"></td></tr><tr><td class="bgcorner4"></td><td class="pobg3"></td><td class="bgcorner3"></td></tr></tbody></table></div>';
	}
	var popoutContent = getObj(id+'box_container');
	return popoutContent;
}
function elementBind(type,id,stylename,csstext){
	var element = document.createElement(type);
	if (id) {
		element.id = id;
	}
	if (typeof(stylename) == 'string') {
		element.className = stylename;
	}
	if (typeof(csstext) == 'string') {
		element.style.cssText = csstext;
	}
	return element;
}

function addChild(parent,type,id,stylename,csstext){
	parent = objCheck(parent);
	var child = elementBind(type,id,stylename,csstext);
	parent.appendChild(child);
	return child;
}

function delElement(id){
	id = objCheck(id);
	id.parentNode.removeChild(id);
}

function pwForumList(isLink,isPost,fid,handle,ifblank) {
	if (isLink == true) {
		if (isPost == true){
			if(ifblank == true) {
				window.open('post.php?fid='+fid);
			} else {
				window.location.href = 'post.php?fid='+fid;
			}
			if (is_ie) {
				window.event.returnValue = false;
			}
		} else {
			return true;
		}
	} else {
		if (gIsPost != isPost || read.menu.style.display=='none' || read.menu.innerHTML == '') {
			read.menu.innerHTML = '';
			if (isPost == true) {
				if (getObj('title_forumlist') == null) {
					showDialog('error','没有找到版块列表信息');
				}
				getObj('title_forumlist').innerHTML = '选择你要发帖的版块';
			} else {
				if (getObj('title_forumlist') == null) {
					showDialog('error','没有找到版块列表信息');
				}
				getObj('title_forumlist').innerHTML = '快速浏览';
			}
			gIsPost = isPost;
			if (handle.id.indexOf('pwb_')==-1) {
				read.open('menu_forumlist',handle,2);
			}

		} else {
			read.close();
		}
	}
	return false;
}
function char_cv(str){
	if (str != ''){
		str = str.replace(/</g,'&lt;');
		str = str.replace(/%3C/g,'&lt;');
		str = str.replace(/>/g,'&gt;');
		str = str.replace(/%3E/g,'&gt;');
		str = str.replace(/'/g,'&#39;');
		str = str.replace(/"/g,'&quot;');
	}
	return str;
}

function showDialog(type,message,autohide,callback) {
	var container	= elementBind('div','','','width:400px;');
	var title	= elementBind('div','','h b','padding:0 .6em');
	title.innerHTML = '提示';
	container.appendChild(title);
	var inner_div	= addChild(container,'div','','p10 tac');
	var p2 = addChild(inner_div,'p','','','margin:25px 0');
	if (type=='error'||type=='success'||type=='warning'||type=='confirm') {
		var img2 = elementBind('img');
		img2.setAttribute('src',imgpath+ '/'+ type +'_bg.gif');
		img2.setAttribute('align','absmiddle');
		p2.appendChild(img2);
	}
	p2.innerHTML += message;

	var tar	= addChild(container,'div','','pdD tar');
	if (type == 'confirm' && typeof(callback) == 'function') {
		var ok	= elementBind('input','','btn','margin:0 10px 8px 0;');
		ok.type	= 'button';
		ok.value= '确定';
		ok.onclick	= function () {
			closep();
			if (typeof(callback)=='function') {
				callback();
			}
		}
		tar.appendChild(ok);
	}
	if (autohide) {
		var show	= elementBind('span','','fl f12','padding:0 0 10px 10px;');
		show.innerHTML	= '本窗口'+autohide+'秒后关闭';
		tar.appendChild(show);
	}

	var cansel	= elementBind('input','','bt','margin:0 10px 8px 0;');
	cansel.type	= 'button';
	cansel.value= '关闭';
	cansel.onclick	= closep;
	tar.appendChild(cansel);
	read.setMenu(container);
	read.menupz();
	if (autohide) {
		window.setTimeout("closep()", (autohide * 1000));
	}
}

function checkFileType() {
	var fileName = getObj("uploadpic").value;
	if (fileName != '') {
		var regTest = /\.(jpe?g|gif|png)$/gi;
		var arrMactches = fileName.match(regTest);
		if (arrMactches == null) {
			getObj('fileTypeError').style.display = '';
			return false;
		} else {
			getObj('fileTypeError').style.display = 'none';
		}
	}
	return true;
}


var emoji_code = [
'001','002','003','004','005','006','007','008','009','00A','00B',
'00C','00D','00E','00F','010','011','012','013','014','015','016',
'017','018','019','01A','01B','01C','01D','01E','01F','020','021',
'022','023','024','025','026','027','028','029','02A','02B','02C',
'02D','02E','02F','030','031','032','033','034','035','036','037',
'038','039','03A','03B','03C','03D','03E','03F','040','041','042',
'043','044','045','046','047','048','049','04A','04B','04C','04D',
'04E','04F','050','051','052','053','054','055','056','057','058',
'059','05A','101','102','103','104','105','106','107','108','109',
'10A','10B','10C','10D','10E','10F','110','111','112','113','114',
'115','116','117','118','119','11A','11B','11C','11D','11E','11F',
'120','121','122','123','124','125','126','127','128','129','12A',
'12B','12C','12D','12E','12F','130','131','132','133','134','135',
'136','137','138','139','13A','13B','13C','13D','13E','13F','140',
'141','142','143','144','145','146','147','148','149','14A','14B',
'14C','14D','14E','14F','150','151','152','153','154','155','156',
'157','158','159','15A','201','202','203','204','205','206','207',
'208','209','20A','20B','20C','20D','20E','20F','210','211','212',
'213','214','215','216','217','218','219','21A','21B','21C','21D',
'21E','21F','220','221','222','223','224','225','226','227','228',
'229','22A','22B','22C','22D','22E','22F','230','231','232','233',
'234','235','236','237','238','239','23A','23B','23C','23D','23E',
'23F','240','241','242','243','244','245','246','247','248','249',
'24A','24B','24C','24D','24E','24F','250','251','252','253','301',
'302','303','304','305','306','307','308','309','30A','30B','30C',
'30D','30E','30F','310','311','312','313','314','315','316','317',
'318','319','31A','31B','31C','31D','31E','31F','320','321','322',
'323','324','325','326','327','328','329','32A','32B','32C','32D',
'32E','32F','330','331','332','333','334','335','336','337','338',
'339','33A','33B','33C','33D','33E','33F','340','341','342','343',
'344','345','346','347','348','349','34A','34B','34C','34D','401',
'402','403','404','405','406','407','408','409','40A','40B','40C',
'40D','40E','40F','410','411','412','413','414','415','416','417',
'418','419','41A','41B','41C','41D','41E','41F','420','421','422',
'423','424','425','426','427','428','429','42A','42B','42C','42D',
'42E','42F','430','431','432','433','434','435','436','437','438',
'439','43A','43B','43C','43D','43E','43F','440','441','442','443',
'444','445','446','447','448','449','44A','44B','44C','501','502',
'503','504','505','506','507','508','509','50A','50B','50C','50D',
'50E','50F','510','511','512','513','514','515','516','517','518',
'519','51A','51B','51C','51D','51E','51F','520','521','522','523',
'524','525','526','527','528','529','52A','52B','52C','52D','52E',
'52F','530','531','532','533','534','535','536','537'];

var emoji_begin = '<img src="emoji/emoji-E';
var emoji_end   = '.png" />';
var emoji_count;
var emoji_regs = '';

for(var n in emoji_code)
{
    emoji_regs += '\\uE' + emoji_code[n];
}

var emoji_regx = new RegExp('[' + emoji_regs + ']');

function emoji_translate(txt)
{
		if( txt == "" || txt == null )
			return "";
        else if (emoji_regx.test(txt))
        {
            for(var i in emoji_code)
            {
                var regx = new RegExp('\\uE' + emoji_code[i], 'g');
                txt = txt.replace(regx, emoji_begin + emoji_code[i] + emoji_end);
            }
           return txt;
        } else
        return txt;
}
function setTBodyInnerHTML(tbody, html) {
  var temp = tbody.ownerDocument.createElement('div');
  temp.innerHTML = '<table>' + html + '</table>';

  tbody.parentNode.replaceChild(temp.firstChild.firstChild, tbody);
}
function translateBody(fobj){
	var ajaxtableObj=document.getElementById("ajaxtable");
	if (ajaxtableObj!=null)
		if(ajaxtableObj.tagName == 'TABLE')
		{
			setTBodyInnerHTML(ajaxtableObj.getElementsByTagName('tbody')[0], emoji_translate(ajaxtableObj.innerHTML));
		}
		else
		{
			ajaxtableObj.innerHTML=emoji_translate(ajaxtableObj.innerHTML);
		}
	var ajaxtableObj2=document.getElementById("content");
	if (ajaxtableObj2!=null) 
		ajaxtableObj2.innerHTML=emoji_translate(ajaxtableObj2.innerHTML);
	var ajaxtableObj3=document.getElementById("breadcrumbs");
	if (ajaxtableObj3!=null) 
		ajaxtableObj3.innerHTML=emoji_translate(ajaxtableObj3.innerHTML);	
	var ajaxtableObj4=document.getElementById("header");
	if (ajaxtableObj4!=null) 
		ajaxtableObj4.innerHTML=emoji_translate(ajaxtableObj4.innerHTML);	
		
	var b=document.getElementsByName("delatc");
	if (b!=null){
		for (var iiii=0;iiii<b.length;iiii++){
			b[iiii].innerHTML=emoji_translate(b[iiii].innerHTML);
		}
	}
}
if((navigator.userAgent.match(/iPhone/i)) || (navigator.userAgent.match(/iPod/i))) {
	//do nothing if it's iphone
} else translateBody();
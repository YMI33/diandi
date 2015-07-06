function showedit(u,e){
	if (u>0){
		$("#ediv"+e).show();
		$("#vdiv"+e).hide();
		$("#jjclk"+e).html('<a href=\"javascript:;\" onclick=\"closeedit('+u+','+e+')\">取消编辑</a>');
	}else{
		$("#editwinbk").show();
		$("#editwin").show();
	}
}

function closeedit(u,e){
	$("#ediv"+e).hide();
	$("#vdiv"+e).show();
	$("#jjclk"+e).html('<a href=\"javascript:;\" onclick=\"showedit('+u+','+e+')\">编辑</a>');
}

function addedit(u,e){
	$("#ediv"+e).show();
}

function deledit(u,e){
	$("#ediv"+e).hide();
}
function onError(img) {
	img.src="/Public/web/images/nvimg1.jpg";
}
	function wkph(mt){
		$("li.dangqian").removeClass('dangqian');
		$("#"+mt+"li").addClass('dangqian');
		$("#weekdiv").hide();
		$("#mouthdiv").hide();
		$("#totaldiv").hide();
		$("#"+mt+"div").show();
	}
	function videoph(mt){
		$("li.videodangqian").removeClass('videodangqian');
		$("#"+mt+"li").addClass('videodangqian');
		$("#videoweekdiv").hide();
		$("#videomouthdiv").hide();
		$("#videototaldiv").hide();
		$("#"+mt+"div").show();
	}
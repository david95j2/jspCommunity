/* 토스트에디터 시작 */
/* 유튜브 플러그인 시작 */
function youtubePlugin() {
  toastui.Editor.codeBlockManager.setReplacer('youtube', youtubeId => {
    // Indentify multiple code blocks
    const wrapperId = `yt${Math.random().toString(36).substr(2, 10)}`;

    // Avoid sanitizing iframe tag
    setTimeout(renderYoutube.bind(null, wrapperId, youtubeId), 0);

    return `<div id="${wrapperId}"></div>`;
  });
}

function renderYoutube(wrapperId, youtubeId) {
  const el = document.querySelector(`#${wrapperId}`);

  el.innerHTML = `<div class="toast-ui-youtube-plugin-wrap"><iframe src="https://www.youtube.com/embed/${youtubeId}" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>`;
}
/* 유튜브 플러그인 끝 */

/* codepen 플러그인 시작 */
function codepenPlugin() {
  toastui.Editor.codeBlockManager.setReplacer('codepen', url => {
    const wrapperId = `yt${Math.random().toString(36).substr(2, 10)}`;

    // Avoid sanitizing iframe tag
    setTimeout(renderCodepen.bind(null, wrapperId, url), 0);

    return `<div id="${wrapperId}"></div>`;
  });
}

function renderCodepen(wrapperId, url) {
  const el = document.querySelector(`#${wrapperId}`);
  
  var urlParams = new URLSearchParams(url.split('?')[1]);
  var height = urlParams.get('height');

  el.innerHTML = `<div class="toast-ui-codepen-plugin-wrap"><iframe height="${height}" scrolling="no" src="${url}" frameborder="no" loading="lazy" allowtransparency="true" allowfullscreen="true"></iframe></div>`;
}
/* codepen 플러그인 끝 */

function Editor__init() {
  $('.toast-ui-editor').each(function(index, node) {
    var initialValue = $(node).prev().html().trim().replace(/t-script/gi, 'script');

	// 토스트 UI에
	// <br/> 두개 들어가는 버그를 없애기 위한 궁여지책
	if ( initialValue.length == 0 ) {
		initialValue = " ";
	}
	
	let height = 600;
	
	if ( $(node).attr('data-height') ) {
		height = parseInt($(node).attr('data-height'));
	}
	
	let previewStyle = 'vertical';
	
	if ( $(node).attr('data-previewStyle') ) {
		previewStyle = $(node).attr('data-previewStyle');
	}
	else {
		if ( $(window).width() < 600 ) {
			previewStyle = 'tab';
		}
	}
	
	var editor = new toastui.Editor({
      el: node,
      previewStyle: previewStyle,
      initialValue: initialValue,
      height:height,
      plugins: [toastui.Editor.plugin.codeSyntaxHighlight, youtubePlugin, codepenPlugin]
    });

	$(node).data('data-toast-editor', editor);
  });
}

function EditorViewer__init() {
  $('.toast-ui-viewer').each(function(index, node) {
    var initialValue = $(node).prev().html().trim().replace(/t-script/gi, 'script');
    var viewer = new toastui.Editor.factory({
      el: node,
      initialValue: initialValue,
      viewer:true,
      plugins: [toastui.Editor.plugin.codeSyntaxHighlight, youtubePlugin, codepenPlugin]
    });
  });
}

EditorViewer__init();
Editor__init();
/* 토스트에디터 끝 */



function iOS() {
	return [ 'iPad Simulator', 'iPhone Simulator', 'iPod Simulator', 'iPad', 'iPhone', 'iPod' ].includes(navigator.platform)
	// iPad on iOS 13 detection
	|| (navigator.userAgent.includes("Mac") && "ontouchend" in document)
}

var $html = $('html');

/* 발견되면 활성화시키는 라이브러리 시작 */
function ActiveOnVisible__init() {
  $(window).resize(ActiveOnVisible__initOffset);
  ActiveOnVisible__initOffset();

  $(window).scroll(ActiveOnVisible__checkAndActive);
  ActiveOnVisible__checkAndActive();
}

function ActiveOnVisible__initOffset() {
  $('.active-on-visible').each(function(index, node) {
    var $node = $(node);

    var offsetTop = $node.offset().top;
    $node.attr('data-active-on-visible-offsetTop', offsetTop);

    if ( !$node.attr('data-active-on-visible-diff-y') ) {
      $node.attr('data-active-on-visible-diff-y', '0');
    }

    if ( !$node.attr('data-active-on-visible-delay') ) {
      $node.attr('data-active-on-visible-delay', '0');
    }
  });

  ActiveOnVisible__checkAndActive();
}

function ActiveOnVisible__checkAndActive() { 
  $('.active-on-visible:not(.actived)').each(function(index, node) {
    var $node = $(node);

    var offsetTop = $node.attr('data-active-on-visible-offsetTop') * 1;
    var diffY = parseInt($node.attr('data-active-on-visible-diff-y'));
    var delay = parseInt($node.attr('data-active-on-visible-delay'));

    var callbackFuncName = $node.attr('data-active-on-visible-callback-func-name');

    if ( $(window).scrollTop() + $(window).height() + diffY > offsetTop ) {
      $node.addClass('actived');

      setTimeout(function() {
        $node.addClass('active');
        if ( window[callbackFuncName] ) {
          window[callbackFuncName]($node);
        }
      }, delay);
    }
  });
}

$(function() {
  ActiveOnVisible__init();
})
/* 발견되면 활성화시키는 라이브러리 끝 */

function TopBar__init() {
  // 
  var $subMenuBg = $('.top-bar .menu-box-1-sub-menu-bg');
  $('.top-bar .menu-box-1 > ul > li').mouseenter(function() {
    var height = $(this).find(' > ul').height();
    $subMenuBg.css('height', height);
  });
  
  $('.top-bar .menu-box-1 > ul > li').mouseleave(function() {
    $subMenuBg.css('height', 0);
  });
}

TopBar__init();

function MobileTopBar__init() {
  // 
  var $btnToggleMenuBox1 = $('.mobile-top-bar .btn-toggle-menu-box-1');
  
  $btnToggleMenuBox1.click(function() {
    var has = $html.hasClass('mobile-top-bar-menu-box-1-actived');
    
    if ( has ) {
      $html.removeClass('mobile-top-bar-menu-box-1-actived');
    }
    else {
      $html.addClass('mobile-top-bar-menu-box-1-actived');
    }
  });
}

MobileTopBar__init();
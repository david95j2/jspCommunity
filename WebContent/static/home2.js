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
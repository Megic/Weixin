<?php

return array(
    //模块名
    'name' => 'Weixin',
    //别名
    'alias' => '微信',
    //版本号
    'version' => '1.0.0',
    //是否商业模块,1是，0，否
    'is_com' => 0,
    //是否显示在导航栏内？  1是，0否
    'show_nav' => 1,
    //模块描述
    'summary' => '微信模块',
    //开发者
    'developer' => 'Megic',
    //开发者网站
    'website' => '#',
    //前台入口，可用U函数
    'entry' => 'Weixin/index/index',
    'admin_entry' => 'Admin/Weixin/config',

    'icon' => 'comments',

    'can_uninstall' => 1
);
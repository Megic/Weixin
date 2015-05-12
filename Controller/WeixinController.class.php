<?php
/**
 * Created by PhpStorm.
 * User: caipeichao
 * Date: 14-3-11
 * Time: PM5:41
 */

namespace Admin\Controller;

use Admin\Builder\AdminConfigBuilder;
use Admin\Builder\AdminListBuilder;
use Admin\Builder\AdminTreeListBuilder;


class WeixinController extends AdminController
{

    function _initialize()
    {
        parent::_initialize();
    }

    public function config()
    {
        $admin_config = new AdminConfigBuilder();
        $data = $admin_config->handleConfig();
        $admin_config->title('基本设置')
            ->keyInteger('MPNUM','默认允许添加公共号数量')
            ->buttonSubmit('', '保存')->data($data);
        $admin_config->display();
    }


}

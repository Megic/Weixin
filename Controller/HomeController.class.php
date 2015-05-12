<?php
/**
 * Created by PhpStorm.
 * User: megic
 * Date: 2015-05-11
 * Time: 22:49
 */
namespace Weixin\Controller;

use Think\Controller;

class HomeController extends CommonController
{
    public function _initialize()
    {
        parent::_initialize ();
        $this->needLogin();//需要先登录
        $this->getMpList();//公共号列表
    }
    public function index(){
     $this->display();
    }
}
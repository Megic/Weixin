<?php


namespace Weixin\Controller;

use Think\Controller;

class IndexController extends CommonController
{
   
    public function _initialize()
    {
        parent::_initialize ();
        $this->needLogin();
        $this->model = $this->getModel ( 'member_public' );
    }
public function help() {
        if (isset ( $_GET ['public_id'] )) {
            $map ['id'] = intval ( $_GET ['public_id'] );
            $info = M ( 'member_public' )->where( $map )->find ();
            $this->assign ( 'token', $info ['token'] );
        } else {
            $this->assign ( 'token', '你的公众号的Token' );
        }
        $this->display ();
    }
    public function index($page = 1, $issue_id = 0)
    {
       $map['uid'] = is_login();
        session ( 'common_condition', $map );
        parent::common_lists ( $this->model, 0, 'Common/lists' );
    }
    public function add() {
               $allow_add_count = getPublicMax ( $this->mid );
                $has_add_count = M ( 'member_public_link' )->where ( "uid='{$this->mid}'" )->getField ( 'sum(is_creator)' );
                if ($allow_add_count <= $has_add_count) {
                    $this->error ( '您最多只能创建 ' . $allow_add_count . ' 个公众号！' );
                    exit ();
                }
        parent::common_add ( $this->model, 'Common/add' );
    }
     public function edit() {
        $id = I ( 'id' );
        parent::common_edit ( $this->model, $id, 'Common/edit' );
    }
        public function del() {
        parent::common_del ( $this->model );
    }
    function changPublic() {
        $map ['id'] = I ( 'id', 0, 'intval' );
        $info = M ( 'member_public' )->where ( $map )->find ();
        unset ( $map );
        $map ['uid'] =$this->mid;
        M ( 'member_public_link' )->where ( $map )->setField ( 'is_use', 0 );
        $map ['mp_id'] = $info ['id'];
        M ( 'member_public_link' )->where ( $map )->setField ( 'is_use', 1 );
        get_token ( $info ['token'] );
        redirect ( U ( 'Home/index' ) );
    }
}
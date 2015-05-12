<?php


namespace Weixin\Controller;

use Think\Controller;

class CommonController extends Controller
{
   /* 空操作，用于输出404页面 */
  public function _empty(){
    $this->redirect('Index/index');
  }
    //初始化操作
  function _initialize() {
     $this->assign ( 'add_button', true);
     $this->assign ( 'check_all', true );
     $this->assign ( 'del_button', true );
      $this->mid=is_login();
    // $this->assign ( 'search_button', true );
    // $this->assign ( 'top_more_button',array ());
  }
    protected function needLogin(){
        if(!$this->mid){$this->redirect('ucenter/member/login');}
    }
    protected function getMpList(){
        // 管理中心里的公众号列表
        if ($this->mid) {
            $link = M ( 'member_public_link' )->where ( 'uid=' . $this->mid )->order ( 'is_use desc' )->select ();
            foreach ( $link as $l ) {
                $mp_ids [] = $l ['mp_id'];
                $is_use [$l ['mp_id']] = $l ['is_use'];
            }
            $mp_ids = getSubByKey ( $link, 'mp_id' );
            if (! empty ( $mp_ids )){
                $this->assign ( 'mp_ids_list', count ( $mp_ids ) );
                $mp_ids = implode ( ',', $mp_ids );
                $map ['id'] = array (
                    'in',
                    $mp_ids
                );
                $member_public_list = M ( 'member_public' )->where ( $map )->order ( 'FIND_IN_SET(id,"' . $mp_ids . '")' )->select ();
                $member_public = $member_public_list [0];
                $this->assign ( 'member_public', $member_public );

                $token = get_token ();
                if ($member_public ['token'] && ($is_use [$member_public ['id']] == 0 || $token == '' || $token == - 1)) {
                    get_token ( $member_public ['token'] );
                }

                unset ( $member_public_list [0] );
                $this->assign ( 'member_public_list', $member_public_list );
            } else {
                $this->assign ( 'mp_ids_list', 0 );
            }
        }
    }
  protected function getModel($model = null) {
    $model || $model = $_REQUEST ['_addons'];
    $model || $model = $_REQUEST ['model'];
    $model || $this->error ( '模型名标识必须！' );
    if (is_numeric ( $model )) {
      $model = M ( 'Model' )->find ( $model );
    } else {
      $model = M ( 'Model' )->getByName ( $model );
    }
    $this->assign ( 'model', $model );
    return $model;
  }
  protected function _search_map($model, $fields) {
    $map = array ();
    
    // 插件里的操作自动加上Token限制
    $token = get_token ();
    if (defined ( 'ADDON_PUBLIC_PATH' ) && ! empty ( $token )) {
      $map ['token'] = $token;
    }
   
    // 自定义的条件搜索
    $conditon = session ( 'common_condition' );
    if (! empty ( $conditon )) {
      $map = array_merge ( $map, $conditon );
    }
    session ( 'common_condition', null );

    // 关键字搜索
    $key = $model ['search_key'] ? $model ['search_key'] : 'title';
    $keyArr = explode ( ':', $key );
    $key = $keyArr [0];
    $placeholder = isset ( $keyArr [1] ) ? $keyArr [1] : '请输入关键字';
    $this->assign ( 'placeholder', $placeholder );
    $this->assign ( 'search_key', $key );
    
    if (isset ( $_REQUEST [$key] ) && ! isset ( $map [$key] )) {
      $map [$key] = array (
          'like',
          '%' . htmlspecialchars ( $_REQUEST [$key] ) . '%' 
      );
      unset ( $_REQUEST [$key] );
    }
    
    // 条件搜索
    foreach ( $_REQUEST as $name => $val ) {
      if (! isset ( $map [$name] ) && in_array ( $name, $fields )) {
        $map [$name] = $val;
      }
    }
    
    return $map;
  }

    // 获取模型列表数据
protected function _get_model_list($model = null, $page = 0, $order = 'id desc') {
    $page || $page = I ( 'p', 1, 'intval' ); // 默认显示第一页数据
                                             
    // 解析列表规则
    $list_data = $this->_list_grid ( $model );
    $grids = $list_data ['list_grids'];
    $fields = $list_data ['fields'];
    
    // 搜索条件
    $map = $this->_search_map ( $model, $fields );
    
    $row = empty ( $model ['list_row'] ) ? 20 : $model ['list_row'];
    
    // 读取模型数据列表
    if ($model ['extend']) {
      $name = get_table_name ( $model ['id'] );
      $parent = get_table_name ( $model ['extend'] );
      $fix = C ( "DB_PREFIX" );
      
      $key = array_search ( 'id', $fields );
      if (false === $key) {
        array_push ( $fields, "{$fix}{$parent}.id as id" );
      } else {
        $fields [$key] = "{$fix}{$parent}.id as id";
      }
      
      /* 查询记录数 */
      $count = M ( $parent )->join ( "INNER JOIN {$fix}{$name} ON {$fix}{$parent}.id = {$fix}{$name}.id" )->where ( $map )->count ();
      
      // 查询数据
      $data = M ( $parent )->join ( "INNER JOIN {$fix}{$name} ON {$fix}{$parent}.id = {$fix}{$name}.id" )->field ( empty ( $fields ) ? true : $fields )->where ( $map )->order ( "{$fix}{$parent}.{$order}" )->page ( $page, $row )->select ();
    } else {
      empty ( $fields ) || in_array ( 'id', $fields ) || array_push ( $fields, 'id' );
      $name = parse_name ( get_table_name ( $model ['id'] ), true );
      $data = M ( $name )->field ( empty ( $fields ) ? true : $fields )->where ( $map )->order ( $order )->page ( $page, $row )->select ();

      /* 查询记录总数 */
      $count = M ( $name )->where ( $map )->count ();
    }
    $list_data ['list_data'] = $data;
    
    // 分页
    if ($count > $row) {
      $page = new \Think\Page ( $count, $row );
      $page->setConfig ( 'theme', '%FIRST% %UP_PAGE% %LINK_PAGE% %DOWN_PAGE% %END% %HEADER%' );
      $list_data ['_page'] = $page->show ();
    }
    
    return $list_data;
  }
  protected function checkAttr($Model, $model_id) {
    $fields = get_model_attribute ( $model_id, false );
    $validate = $auto = array ();
    foreach ( $fields as $key => $attr ) {
      if ($attr ['is_must']) { // 必填字段
        $validate [] = array (
            $attr ['name'],
            'require',
            $attr ['title'] . '必须!' 
        );
      }
      // 自动验证规则
      if (! empty ( $attr ['validate_rule'] ) || $attr ['validate_type'] == 'unique') {
        $validate [] = array (
            $attr ['name'],
            $attr ['validate_rule'],
            $attr ['error_info'] ? $attr ['error_info'] : $attr ['title'] . '验证错误',
            0,
            $attr ['validate_type'],
            $attr ['validate_time'] 
        );
      }
      // 自动完成规则
      if (! empty ( $attr ['auto_rule'] )) {
        $auto [] = array (
            $attr ['name'],
            $attr ['auto_rule'],
            $attr ['auto_time'],
            $attr ['auto_type'] 
        );
      } elseif ('checkbox' == $attr ['type']) { // 多选型
        $auto [] = array (
            $attr ['name'],
            'arr2str',
            3,
            'function' 
        );
      } elseif ('datetime' == $attr ['type']) { // 日期型
        $auto [] = array (
            $attr ['name'],
            'strtotime',
            3,
            'function' 
        );
      } elseif ('date' == $attr ['type']) { // 日期型
        $auto [] = array (
            $attr ['name'],
            'strtotime',
            3,
            'function' 
        );
      }
    }
    return $Model->validate ( $validate )->auto ( $auto );
  }
    // 解析列表规则
  protected function _list_grid($model) {
    $fields = array ();
    $grids = preg_split ( '/[;\r\n]+/s', htmlspecialchars_decode ( $model ['list_grid'] ) );
    foreach ( $grids as &$value ) {
      // 字段:标题:链接
      $val = explode ( ':', $value );
      // 支持多个字段显示
      $field = explode ( ',', $val [0] );
      $value = array (
          'field' => $field,
          'title' => $val [1] 
      );
      if (preg_match ( '/^([0-9]*)%/', $val [1], $matches )) {
        $value ['title'] = str_replace ( $matches [0], '', $value ['title'] );
        $value ['width'] = $matches [1];
      }
      if (isset ( $val [2] )) {
        // 链接信息
        $value ['href'] = $val [2];
        // 搜索链接信息中的字段信息
        preg_replace_callback ( '/\[([a-z_]+)\]/', function ($match) use(&$fields) {
          $fields [] = $match [1];
        }, $value ['href'] );
      }
      if (strpos ( $val [1], '|' )) {
        // 显示格式定义
        list ( $value ['title'], $value ['format'] ) = explode ( '|', $val [1] );
      }
      foreach ( $field as $val ) {
        $array = explode ( '|', $val );
        $fields [] = $array [0];
      }
    }
    // 过滤重复和错误字段信息
    $model_fields = M ( 'attribute' )->where ( 'model_id=' . $model ['id'] )->field ( 'name' )->select ();
    $model_fields = getSubByKey ( $model_fields, 'name' );
    in_array ( 'id', $model_fields ) || array_push ( $model_fields, 'id' );
    $fields = array_intersect ( $fields, $model_fields );
    $res ['fields'] = array_unique ( $fields );
    
    $res ['list_grids'] = $grids;
    return $res;
  }
   protected function common_lists($model = null, $page = 0, $templateFile = '', $order = 'id desc') {
    // 获取模型信息
    is_array ( $model ) || $model = $this->getModel ( $model );
    
    $list_data = $this->_get_model_list ( $model, $page, $order );
    $this->assign ( $list_data );
    // dump($list_data);
    $this->meta_title = $model ['title'];
    $templateFile || $templateFile = $model ['template_list'] ? $model ['template_list'] : '';
    $this->display ( $templateFile );
  }
  protected  function common_del($model = null, $ids = null) {
    is_array ( $model ) || $model = $this->getModel ( $model );
    
    ! empty ( $ids ) || $ids =I ( 'get.id' );
    ! empty ( $ids ) || $ids = array_filter ( array_unique ( ( array ) I ( 'ids', 0 ) ) );
    ! empty ( $ids ) || $this->error ( '请选择要操作的数据!' );
    
    $Model = D ( get_table_name ( $model ['id'] ) );
    $map ['id'] = array (
        'in',
        $ids 
    );
    
    // 插件里的操作自动加上Token限制
    $token = get_token ();
    if (defined ( 'ADDON_PUBLIC_PATH' ) && ! empty ( $token )) {
      $map ['token'] = $token;
    }

    if ($Model->where ( $map )->delete ()) {
        if(method_exists($Model,'afterDel')){
            $Model->afterDel($ids);
        }
      $this->success ( '删除成功' ,'refresh');
    } else {
      $this->error ( '删除失败！','refresh' );
    }
  }
    protected  function common_edit($model = null, $id = 0, $templateFile = '') {
    is_array ( $model ) || $model = $this->getModel ( $model );
    $id || $id = I ( 'id' );
    
    // 获取数据
    $data = M ( get_table_name ( $model ['id'] ) )->find ( $id );
    $data || $this->error ( '数据不存在！' );
    
    $token = get_token ();
    if (isset ( $data ['token'] ) && $token != $data ['token'] && defined ( 'ADDON_PUBLIC_PATH' )) {
      $this->error ( '非法访问！' );
    }
    
    if (IS_POST) {
      $Model = D ( parse_name ( get_table_name ( $model ['id'] ), 1 ) );
      // 获取模型的字段信息
      $Model = $this->checkAttr ( $Model, $model ['id'] );

      if ($Model->create () && $Model->save ()) {
        // $this->_saveKeyword ( $model, $id );
        
        $this->success ( '保存' . $model ['title'] . '成功！', U ( 'lists?model=' . $model ['name'], $this->get_param ) );
      } else {
         $error=$Model->getError ();
        $this->error ( $error? $error:'内容不变' );
      }
    } else {
      $fields = get_model_attribute ( $model ['id'] );
      
      $this->assign ( 'fields', $fields );
      $this->assign ( 'data', $data );
      $this->meta_title = '编辑' . $model ['title'];
      
      $templateFile || $templateFile = $model ['template_edit'] ? $model ['template_edit'] : '';
      $this->display ( $templateFile );
    }
  }
  protected  function common_add($model = null, $templateFile = '') {
    is_array ( $model ) || $model = $this->getModel ( $model );
    if (IS_POST) {
      $Model = D ( parse_name ( get_table_name ( $model ['id'] ), 1 ) );

      // 获取模型的字段信息
      $Model = $this->checkAttr ( $Model, $model ['id'] );
       $_POST['uid'] = is_login();
      if ($Model->create () && $id = $Model->add ()) {
        // $this->_saveKeyword ( $model, $id );
          if(method_exists( $Model,'afterAdd')){
              $Model->afterAdd($id,$_POST['uid']);
          }
        $this->success ( '添加' . $model ['title'] . '成功！', U ( 'lists?model=' . $model ['name'], $this->get_param ) );
      } else {
        $this->error ( $Model->getError () );
      }
    } else {
      $fields = get_model_attribute ( $model ['id'] );
      $this->assign ( 'fields', $fields );
      $this->meta_title = '新增' . $model ['title'];
      
      $templateFile || $templateFile = $model ['template_add'] ? $model ['template_add'] : '';
      $this->display ( $templateFile );
    }
  }

}
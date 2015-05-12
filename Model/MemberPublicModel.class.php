<?php
/**
 * Created by PhpStorm.
 * User: megic
 * Date: 2015-05-11
 * Time: 20:18
 */
namespace Weixin\Model;
use Think\Model;
class MemberPublicModel extends Model {
    public function afterAdd($id,$uid){
        $data ['uid'] = $uid;
        $data ['mp_id'] = $id;
        $data ['is_creator'] = 1;
        M ( 'member_public_link' )->add( $data );
    }
    public function afterDel($ids){
        $map_link ['mp_id'] = array (
            'in',
            $ids
        );
        M ( 'member_public_link' )->where ( $map_link )->delete ();
    }
}
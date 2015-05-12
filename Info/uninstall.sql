
/*删除menu相关数据*/
set @tmp_id=0;
select @tmp_id:= id from `ocenter_menu` where `title` = '微信';
delete from `ocenter_menu` where  `id` = @tmp_id or (`pid` = @tmp_id  and `pid` !=0);
delete from `ocenter_menu` where  `title` = '微信';
/*删除相应的后台菜单*/
delete from `ocenter_menu` where  `url` like 'Weixin/%';
/*删除相应的权限节点*/
delete from `ocenter_auth_rule` where  `module` = 'Weixin';

/*删除字段*/
ALTER TABLE `ocenter_member` DROP `public_count`;

DELETE FROM `ocenter_attribute` WHERE model_id = (SELECT id FROM `ocenter_model` WHERE `name`='member_public' ORDER BY id DESC LIMIT 1);
DELETE FROM `ocenter_model` WHERE `name`='member_public' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `ocenter_member_public`;
DELETE FROM `ocenter_attribute` WHERE model_id = (SELECT id FROM `ocenter_model` WHERE `name`='member_public_group' ORDER BY id DESC LIMIT 1);
DELETE FROM `ocenter_model` WHERE `name`='member_public_group' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `ocenter_member_public_group`;
DELETE FROM `ocenter_attribute` WHERE model_id = (SELECT id FROM `ocenter_model` WHERE `name`='member_public_link' ORDER BY id DESC LIMIT 1);
DELETE FROM `ocenter_model` WHERE `name`='member_public_link' ORDER BY id DESC LIMIT 1;
DROP TABLE IF EXISTS `ocenter_member_public_link`;
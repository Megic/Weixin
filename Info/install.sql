-- phpMyAdmin SQL Dump
-- version phpStudy 2014
-- http://www.phpmyadmin.net
--
-- 主机: localhost
-- 生成日期: 2014 年 11 月 18 日 13:30
-- 服务器版本: 5.5.38
-- PHP 版本: 5.3.28

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


--
-- 转存表中的数据 `ocenter_issue_content`
--
INSERT INTO `ocenter_menu` (`title`, `pid`, `sort`, `url`, `hide`, `tip`, `group`, `is_dev`) VALUES
( '微信', 0, 22, 'Weixin/issue', 1, '', '', 0);

set @tmp_id=0;
select @tmp_id:= id from `ocenter_menu` where title = '微信';

INSERT INTO `ocenter_menu` ( `title`, `pid`, `sort`, `url`, `hide`, `tip`, `group`, `is_dev`) VALUES
( '公共设置', @tmp_id, 0, 'Weixin/config', 0, '', '微信模块设置', 0);

-- INSERT INTO `ocenter_auth_rule` ( `module`, `type`, `name`, `title`, `status`, `condition`) VALUES
-- ( 'Weixin', 1, 'addWeixinContent', '微信投稿权限', 1, ''),
-- ( 'Weixin', 1, 'editWeixinContent', '编辑微信内容（管理）', 1, '');
-- 修改数据库增加公共号字段
ALTER TABLE  `ocenter_member` ADD  `public_count` SMALLINT( 5 ) NOT NULL DEFAULT  '1' COMMENT  '公共号数量';


CREATE TABLE IF NOT EXISTS `ocenter_member_public` (
`id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
`token`  varchar(100) NOT NULL  COMMENT 'Token',
`uid`  int(10) NULL   COMMENT '用户ID',
`public_name`  varchar(50) NOT NULL  COMMENT '公众号名称',
`public_id`  varchar(100) NOT NULL  COMMENT '公众号原始id',
`wechat`  varchar(100) NOT NULL  COMMENT '微信号',
`interface_url`  varchar(255) NOT NULL  COMMENT '接口地址',
`headface_url`  varchar(255) NOT NULL  COMMENT '公众号头像',
`area`  varchar(50) NOT NULL  COMMENT '地区',
`addon_config`  text NOT NULL  COMMENT '插件配置',
`addon_status`  text NOT NULL  COMMENT '插件状态',
`type`  char(10) NOT NULL  DEFAULT 0 COMMENT '公众号类型',
`appid`  varchar(255) NOT NULL  COMMENT 'AppID',
`secret`  varchar(255) NOT NULL  COMMENT 'AppSecret',
`group_id`  int(10) unsigned NOT NULL   DEFAULT 0 COMMENT '等级',
`encodingaeskey`  varchar(255) NOT NULL  COMMENT 'EncodingAESKey',
PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci CHECKSUM=0 ROW_FORMAT=DYNAMIC DELAY_KEY_WRITE=0;
INSERT INTO `ocenter_model` (`name`,`title`,`extend`,`relation`,`need_pk`,`field_sort`,`field_group`,`attribute_list`,`template_list`,`template_add`,`template_edit`,`list_grid`,`list_row`,`search_key`,`search_list`,`create_time`,`update_time`,`status`,`engine_type`) VALUES ('member_public','公众号管理','0','','1','{"1":["public_name","public_id","wechat","type","appid","secret","encodingaeskey"]}','1:基础','','','','','id:公众号ID\r\npublic_name:公众号名称\r\ntype|get_name_by_status:类型\r\ngroup_id|get_public_group_name:等级\r\ntoken:Token\r\nuid:管理员\r\nids:操作:[EDIT]|编辑,[DELETE]|删除,changPublic&id=[id]|切换为当前公众号,help&public_id=[id]#weixin_set|接口配置','20','public_name','','1391575109','1416973450','1','MyISAM');
INSERT INTO `ocenter_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('token','Token','varchar(100) NOT NULL','string','','','0','','0','0','1','1402453598','1391597344','','3','','regex','','3','function');
INSERT INTO `ocenter_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('uid','用户ID','int(10) NULL ','num','','','0','','0','1','1','1391575873','1391575210','','3','','regex','get_mid','1','function');
INSERT INTO `ocenter_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('public_name','公众号名称','varchar(50) NOT NULL','string','','','1','','0','1','1','1391576452','1391575955','','3','','regex','','3','function');
INSERT INTO `ocenter_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('public_id','公众号原始id','varchar(100) NOT NULL','string','','请正确填写，保存后不能再修改，且无法接收到微信的信息','1','','0','1','1','1402453976','1391576015','','1','公众号原始ID已经存在，请不要重复增加','unique','','3','function');
INSERT INTO `ocenter_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('wechat','微信号','varchar(100) NOT NULL','string','','','1','','0','1','1','1391576484','1391576144','','3','','regex','','3','function');
INSERT INTO `ocenter_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('interface_url','接口地址','varchar(255) NOT NULL','string','','','0','','0','0','1','1392946881','1391576234','','3','','regex','','3','function');
INSERT INTO `ocenter_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('headface_url','公众号头像','varchar(255) NOT NULL','picture','','','0','','0','0','1','1416920109','1391576300','','3','','regex','','3','function');
INSERT INTO `ocenter_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('area','地区','varchar(50) NOT NULL','string','','','0','','0','0','1','1392946934','1391576435','','3','','regex','','3','function');
INSERT INTO `ocenter_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('addon_config','插件配置','text NOT NULL','textarea','','','0','','0','0','1','1391576537','1391576537','','3','','regex','','3','function');
INSERT INTO `ocenter_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('addon_status','插件状态','text NOT NULL','textarea','','','0','','0','0','1','1391576571','1391576571','','3','','regex','','3','function');
INSERT INTO `ocenter_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('type','公众号类型','char(10) NOT NULL','radio','0','','1','0:普通订阅号\r\n1:认证订阅号/普通服务号\r\n2:认证服务号','0','0','1','1416904702','1393718575','','3','','regex','','3','function');
INSERT INTO `ocenter_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('appid','AppID','varchar(255) NOT NULL','string','','应用ID','1','','0','0','1','1416904750','1393718735','','3','','regex','','3','function');
INSERT INTO `ocenter_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('secret','AppSecret','varchar(255) NOT NULL','string','','应用密钥','1','','0','0','1','1416904771','1393718806','','3','','regex','','3','function');
INSERT INTO `ocenter_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('group_id','等级','int(10) unsigned NOT NULL ','select','0','','0','','0','0','1','1393753499','1393724468','','3','','regex','','3','function');
INSERT INTO `ocenter_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('encodingaeskey','EncodingAESKey','varchar(255) NOT NULL','string','','安全模式下必填','1','','0','0','1','1416817970','1416817924','','3','','regex','','3','function');
UPDATE `ocenter_attribute` SET model_id= (SELECT MAX(id) FROM `ocenter_model`) WHERE model_id=0;


CREATE TABLE IF NOT EXISTS `ocenter_member_public_group` (
`id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
`title`  varchar(50) NOT NULL  COMMENT '等级名',
`addon_status`  text NOT NULL  COMMENT '插件权限',
PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci CHECKSUM=0 ROW_FORMAT=DYNAMIC DELAY_KEY_WRITE=0;
INSERT INTO `ocenter_model` (`name`,`title`,`extend`,`relation`,`need_pk`,`field_sort`,`field_group`,`attribute_list`,`template_list`,`template_add`,`template_edit`,`list_grid`,`list_row`,`search_key`,`search_list`,`create_time`,`update_time`,`status`,`engine_type`) VALUES ('member_public_group','公众号等级','0','','1','{"1":["title","addon_status"]}','1:基础','','','','','id:等级ID\r\ntitle:等级名\r\naddon_status:授权的插件\r\npublic_count:公众号数\r\nid:操作:editPublicGroup&id=[id]|编辑,delPublicGroup&id=[id]|删除','10','title','','1393724788','1393730663','1','MyISAM');
INSERT INTO `ocenter_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('title','等级名','varchar(50) NOT NULL','string','','','1','','0','0','1','1393724854','1393724854','','3','','regex','','3','function');
INSERT INTO `ocenter_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('addon_status','插件权限','text NOT NULL','checkbox','','','1','1:好人\r\n2:环境','0','0','1','1393731903','1393725072','','3','','regex','','3','function');
UPDATE `ocenter_attribute` SET model_id= (SELECT MAX(id) FROM `ocenter_model`) WHERE model_id=0;

CREATE TABLE IF NOT EXISTS `ocenter_member_public_link` (
`id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
`uid`  int(10) NULL   COMMENT '管理员UID',
`mp_id`  int(10) unsigned NOT NULL   COMMENT '公众号ID',
`is_creator`  tinyint(2) NOT NULL  DEFAULT 0 COMMENT '是否为创建者',
`addon_status`  text NOT NULL  COMMENT '插件权限',
`is_use`  tinyint(2) NOT NULL  DEFAULT 0 COMMENT '是否为当前管理的公众号',
PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci CHECKSUM=0 ROW_FORMAT=DYNAMIC DELAY_KEY_WRITE=0;
INSERT INTO `ocenter_model` (`name`,`title`,`extend`,`relation`,`need_pk`,`field_sort`,`field_group`,`attribute_list`,`template_list`,`template_add`,`template_edit`,`list_grid`,`list_row`,`search_key`,`search_list`,`create_time`,`update_time`,`status`,`engine_type`) VALUES ('member_public_link','公众号与管理员的关联关系','0','','1','{"1":["uid","addon_status"]}','1:基础','','','','','uid|get_nickname:管理员\r\naddon_status:授权的插件\r\nids:操作:[EDIT]|编辑,[DELETE]|删除','10','','','1398933192','1398947067','1','MyISAM');
INSERT INTO `ocenter_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('uid','管理员UID','int(10) NULL ','num','','可以在用户>用户信息页面的列表第一找到管理员的UID','1','','0','1','1','1398944756','1398933236','','3','','regex','','3','function');
INSERT INTO `ocenter_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('mp_id','公众号ID','int(10) unsigned NOT NULL ','num','','','4','','0','1','1','1398933300','1398933300','','3','','regex','','3','function');
INSERT INTO `ocenter_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('is_creator','是否为创建者','tinyint(2) NOT NULL','bool','0','','0','0:不是\r\n1:是','0','0','1','1398933380','1398933380','','3','','regex','','3','function');
INSERT INTO `ocenter_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('addon_status','插件权限','text NOT NULL','checkbox','','','1','','0','0','1','1398933475','1398933475','','3','','regex','','3','function');
INSERT INTO `ocenter_attribute` (`name`,`title`,`field`,`type`,`value`,`remark`,`is_show`,`extra`,`model_id`,`is_must`,`status`,`update_time`,`create_time`,`validate_rule`,`validate_time`,`error_info`,`validate_type`,`auto_rule`,`auto_time`,`auto_type`) VALUES ('is_use','是否为当前管理的公众号','tinyint(2) NOT NULL','bool','0','','0','0:不是\r\n1:是','0','0','1','1398996982','1398996975','','3','','regex','','3','function');
UPDATE `ocenter_attribute` SET model_id= (SELECT MAX(id) FROM `ocenter_model`) WHERE model_id=0;

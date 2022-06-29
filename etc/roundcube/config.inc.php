<?php


$config = array();
$config['db_dsnw'] = 'sqlite:////home/roundcube/roundcube.db?mode=0646';
$config['log_dir']='/home/roundcube/logs';
$config['temp_dir']='/home/roundcube/temp';
$config['session_lifetime'] = 30;  	// 30 min

$config['default_host'] = 'localhost';
$config['smtp_server'] = 'localhost';
$config['smtp_port'] = 25;
$config['smtp_user'] = '';     
$config['smtp_pass'] = '';     
$config['product_name'] = 'Roundcube Webmail';
$config['des_key'] = 'SuperGeheim2345678901234'; // must be 24 characters

// List of active plugins (in plugins/ directory)
$config['plugins'] = array(
    'archive',
    'zipdownload',
);

// skin name: folder from skins/
$config['skin'] = 'larry';
$config['create_default_folders'] = true; 
$config['mail_pagesize'] = 100;
$config['htmleditor'] = 1;
$config['logout_purge'] = true;                                                                                      
$config['logout_expunge'] = true;
$config['preview_pane'] = true;
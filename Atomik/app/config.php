<?php

Atomik::set(array(

    'plugins' => array(
		'Db' => array(
			'dsn'      => 'mysql:host=localhost;dbname=TDMDev',
			'username' => 'root',
			'password' => ''
		),
        'DebugBar' => array(
            // if you don't include jquery yourself as it is done in the
            // skeleton, comment out this line (the debugbar will include jquery)
            'include_vendors' => 'css'
        ),
        'Errors' => array(
            'catch_errors' => true
        ),
        'Session',
        'Flash',
        'Controller',
    ),

    'app.layout' => '_layout',
	
	'atomik.url_rewriting' => true,

    // WARNING: change this to false when in production
    'atomik.debug' => true
    
));

Atomik::set('app.routes', array(
    'index' => array(
        'controller' => 'index',
        'action' => 'view'
    ),
    'api' => array(
        'controller' => 'index',
        'action' => 'api'
    )
));
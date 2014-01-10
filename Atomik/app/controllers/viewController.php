<?php

class ViewController extends Atomik\Controller\Controller
{
	public $msg = "toto";
    public function index()
    {
		Atomik::setView('index');
    }
	
    public function msg()
    {
		$msg = isset($_GET['msg']) ? $_GET['msg'] : "";
		Atomik::setView('msg');
		return array('msg' => $msg);
    }
	
    public function json()
    {
		$db = Atomik::get('db');
		$data = $db->select('player', 'playerId=1');
		
		Atomik::disableLayout();
		Atomik::setView('json');
		return array('data' => $data);
    }
}

?>
<?php

foreach (glob("app/classes/*.php") as $filename) include $filename;

class ApiController extends Atomik\Controller\Controller
{
	private $player;

    public function index()
    {
		return $this->jsonResult(null);
    }
	
    public function login()
    {
		try {
			$this->checkPlayer();
			$this->checkPassword();
		} catch (Exception $e) { return $this->jsonError($e->getMessage()); }
		
		$db = Atomik::get('db');
		$updates = array();
		$updates['authKeyExpires'] = $db->toDate(time() + 20);
		$updates['authKey'] = md5($this->player['playerId'].'#'.$updates['authKeyExpires']);
		
		$db->update('player', $updates, 'playerId='.$this->player['playerId']);
		
		return $this->jsonResult(array('playerId' => $this->player['playerId'], 'authKey' => $updates['authKey']));
    }
	
    public function getPlayerInfos()
    {
		try {
			$this->checkPlayer();
			$this->checkAuthKey();
		} catch (Exception $e) { return $this->jsonError($e->getMessage()); }
		
		return $this->jsonResult($this->player);
    }
	
	private function checkParam($param) {
		if ( !isset($_REQUEST[$param]) ) throw new Exception('Missing parameter : '.$param);
	}
	
	private function checkPlayer() {
		$this->checkParam('playerId');
		$db = Atomik::get('db');
		$this->player = $db->selectOne('player', 'playerId='.$_REQUEST['playerId']);
		if( !$this->player ) throw new Exception('Player not found');
	}
	
	private function checkPassword() {
		$this->checkParam('password');
		if( $this->player['password'] !== $_REQUEST['password'] ) throw new Exception('Invalid password');
	}
	
	private function checkAuthKey() {
		$this->checkParam('authKey');
		if ( $this->player['authKey'] != $_REQUEST['authKey'] ) throw new Exception('Invalid authKey');
		$dt = new DateTime($this->player['authKeyExpires']);
		$dtAuthKey = $dt->getTimestamp();
		if( $dtAuthKey < time() ) throw new Exception('authKey expired');
	}
	
	private function jsonError($error) {
		Atomik::disableLayout();
		Atomik::setView('json');
		return array('data' => array('error' => $error));
	}
	
	private function jsonResult($data) {
		Atomik::disableLayout();
		Atomik::setView('json');
		return array('data' => $data);
	}
}

?>
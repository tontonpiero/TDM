<?php

foreach (glob("app/classes/*.php") as $filename) include $filename;

class TDMController extends Atomik\Controller\Controller
{
	protected $player;

    public function index() {
		return $this->jsonResult(null);
    }
	
	protected function checkParam($param) {
		if ( !isset($_REQUEST[$param]) ) throw new Exception('Missing parameter : '.$param);
	}
	
	protected function checkPlayer() {
		$this->checkParam('playerId');
		$db = Atomik::get('db');
		$this->player = $db->selectOne('player', 'playerId='.$_REQUEST['playerId']);
		if( !$this->player ) throw new Exception('Player not found');
	}
	
	protected function checkPassword() {
		$this->checkParam('password');
		if( $this->player['password'] !== $_REQUEST['password'] ) throw new Exception('Invalid password');
	}
	
	protected function checkAuthKey() {
		return; // no authKey check for testing purpose
		$this->checkParam('authKey');
		if ( $this->player['authKey'] != $_REQUEST['authKey'] ) throw new Exception('Invalid authKey');
		$dt = new DateTime($this->player['authKeyExpires']);
		$dtAuthKey = $dt->getTimestamp();
		if( $dtAuthKey < time() ) throw new Exception('authKey expired');
	}
	
	protected function jsonError($error) {
		Atomik::disableLayout();
		Atomik::setView('json');
		return array('data' => array('error' => $error));
	}
	
	protected function jsonResult($data) {
		Atomik::disableLayout();
		Atomik::setView('json');
		return array('data' => $data);
	}
}

?>
<?php

foreach (glob("app/classes/*.php") as $filename) include $filename;

class TDMController extends Atomik\Controller\Controller
{
	protected $player;

    public function index() {
		return $this->jsonResult(null);
    }
	
	protected function getParam($name, $optional = false) {
		$ret = isset($_REQUEST[$name]) ? $_REQUEST[$name] : null;
		if ( !$optional && !$ret ) throw new Exception('Missing parameter : '.$name, 1);
		return $ret;
	}
	
	protected function getHeader($name, $optional = false) {
		$headers = Util::getHeaders();
		$ret = isset($headers[$name]) ? $headers[$name] : null;
		if ( !$optional && !$ret ) throw new Exception('Missing header : '.$name, 2);
		return $ret;
	}
	
	protected function checkPlayer() {
		$this->getParam('playerId');
		$db = Atomik::get('db');
		$this->player = $db->selectOne('player', 'playerId='.$_REQUEST['playerId']);
		if( !$this->player ) throw new Exception('Player not found', 5);
	}
	
	protected function checkAuthKey() {
		//return; // no authKey check for testing purpose
		$authKey = $this->getHeader('Authkey');
		$db = Atomik::get('db');
		$this->player = $db->selectOne('player', "authKey='$authKey'");
		if( !$this->player ) throw new Exception('Player not found', 5);
		if ( $this->player['authKey'] != $authKey ) throw new Exception('Invalid authKey', 3);
		$dt = new DateTime($this->player['authKeyExpires']);
		$dtAuthKey = $dt->getTimestamp();
		if( $dtAuthKey < time() ) throw new Exception('AuthKey expired', 4);
	}
	
	protected function jsonError($error, $code = 0) {
		Atomik::disableLayout();
		Atomik::setView('json');
		return array('data' => array('error' => $error, 'errorCode' => $code));
	}
	
	protected function jsonResult($data) {
		Atomik::disableLayout();
		Atomik::setView('json');
		return array('data' => $data);
	}
}

?>
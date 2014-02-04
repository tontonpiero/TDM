<?php

include "_TDMController.php";

class ApiController extends TDMController
{
    public function index()
    {
		return $this->jsonResult(array('status' => 'on'));
    }
	
    public function auth()
    {
		try {
			$id = $this->getParam('id');
		} catch (Exception $e) { return $this->jsonError($e->getMessage(), $e->getCode()); }
		
		$db = Atomik::get('db');
		$device = $db->selectOne('device', "identifier='$id'");
		if( !$device ) return $this->jsonError('Player not found', 4);
		
		$this->player = $db->selectOne('player', 'playerId='.$device['playerId']);
		
		$updates = array();
		$updates['authKeyExpires'] = $db->toDate(time() + 20);
		$updates['authKey'] = md5($this->player['playerId'].'#'.$updates['authKeyExpires']);
		
		$db->update('player', $updates, 'playerId='.$this->player['playerId']);
		
		return $this->jsonResult(array('playerId' => $this->player['playerId'], 'authKey' => $updates['authKey']));
    }
	
    public function me()
    {
		try {
			$this->checkAuthKey();
		} catch (Exception $e) { return $this->jsonError($e->getMessage(), $e->getCode()); }
		
		return $this->jsonResult($this->player);
    }
	
    public function levels()
    {
		try {
			$this->checkAuthKey();
		} catch (Exception $e) { return $this->jsonError($e->getMessage(), $e->getCode()); }
		
		$db = Atomik::get('db');
		$levels = $db->select('level');
		
		return $this->jsonResult($levels);
    }
}

?>
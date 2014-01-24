<?php

include "_TDMController.php";

class ApiController extends TDMController
{
    public function index()
    {
		return $this->jsonResult(Util::test());
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
	
    public function getLevels()
    {
		try {
			$this->checkPlayer();
			$this->checkAuthKey();
		} catch (Exception $e) { return $this->jsonError($e->getMessage()); }
		
		
		
		return $this->jsonResult(array());
    }
}

?>
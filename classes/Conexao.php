<?php
class Conexao{

    private $url;
    private $usuario;
    private $senha;
    private $baseDeDados;


    public function __construct() {
        $this->url = "db";
        $this->usuario = "dev";
        $this->senha = 'devpass';
        $this->baseDeDados = 'petclin';
    }

    public function getConexao() {
        return  new mysqli( 
            $this->url, 
            $this->usuario, 
            $this->senha, 
            $this->baseDeDados
        );
    }
}

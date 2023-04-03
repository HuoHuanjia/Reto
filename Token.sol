// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Token is ERC20, ERC20Burnable, Ownable {

    struct clientes {

        uint inversion;
        uint tipo;        
        uint tiempos;
        uint[] entregado;                       
        uint total;
    }

    mapping (address => clientes) public balances;
    uint inicio;

    constructor() ERC20("Token", "ToK") {
        inicio=block.timestamp;
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function recibir (uint porcent, uint tip) public payable{
        
        balances[msg.sender].inversion=msg.value;
        balances[msg.sender].tipo=tip;
        balances[msg.sender].tiempos=block.timestamp;        
        balances[msg.sender].total += msg.value;
        if (balanceOf(msg.sender)>0){
            transfer(msg.sender,uint(balanceOf(msg.sender)*porcent/100));
        }
    }    

    function transXsend(address destino,uint monto) public {
        payable(destino).transfer(monto);        
    }

    function tiempo(uint init) public view returns(uint){
        uint fin=block.timestamp;        
        return fin-init;
    }

    function entrega1(address destino)public{        
        uint div1=uint(tiempo(balances[destino].tiempos)/3600/24/45)-balances[destino].entregado.length;
        uint div2=uint(tiempo(balances[destino].tiempos)/3600/24/180)-balances[destino].entregado.length;

        if (balances[destino].tipo==1 && div1>=1){                
            uint mont=uint(balances[destino].inversion*18/100);
            transXsend(destino,mont);
            balances[destino].entregado.push(mont);
        }
        else if (balances[destino].tipo==2 && div2>=1){
            uint mont=uint(balances[destino].inversion*48/100);
            transXsend(destino,mont);
            balances[destino].entregado.push(mont);
        }
    }    
}

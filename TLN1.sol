pragma solidity ^0.4.23;
 
/**
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/179
 */
contract ERC20Basic {
  function totalSupply() public view returns (uint256);
  function balanceOf(address who) public view returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}
 
/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20 is ERC20Basic {
  function allowance(address owner, address spender)
    public view returns (uint256);

  function transferFrom(address from, address to, uint256 value)
    public returns (bool);

  function approve(address spender, uint256 value) public returns (bool);
  event Approval(
    address indexed owner,
    address indexed spender,
    uint256 value
  );
}
 
/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
    if (a == 0) {
      return 0;
    }
    c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    // uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return a / b;
  }

  /**
  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
    c = a + b;
    assert(c >= a);
    return c;
  }
}
 
/**
 * @title Basic token
 * @dev Basic version of StandardToken, with no allowances. 
 */
contract BasicToken is ERC20Basic {
  using SafeMath for uint256;

  mapping(address => uint256) balances;

  uint256 totalSupply_;

  /**
  * @dev total number of tokens in existence
  */
  function totalSupply() public view returns (uint256) {
    return totalSupply_;
  }

  /**
  * @dev transfer token for a specified address
  * @param _to The address to transfer to.
  * @param _value The amount to be transferred.
  */
  function transfer(address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value <= balances[msg.sender]);

    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    emit Transfer(msg.sender, _to, _value);
    return true;
  }

  /**
  * @dev Gets the balance of the specified address.
  * @param _owner The address to query the the balance of.
  * @return An uint256 representing the amount owned by the passed address.
  */
  function balanceOf(address _owner) public view returns (uint256) {
    return balances[_owner];
  }
}
 
/**
 * @title Standard ERC20 token
 *
 * @dev Implementation of the basic standard token.
 * @dev https://github.com/ethereum/EIPs/issues/20
 * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 */
contract StandardToken is ERC20, BasicToken {

  mapping (address => mapping (address => uint256)) internal allowed;


  /**
   * @dev Transfer tokens from one address to another
   * @param _from address The address which you want to send tokens from
   * @param _to address The address which you want to transfer to
   * @param _value uint256 the amount of tokens to be transferred
   */
  function transferFrom(
    address _from,
    address _to,
    uint256 _value
  )
    public
    returns (bool)
  {
    require(_to != address(0));
    require(_value <= balances[_from]);
    require(_value <= allowed[_from][msg.sender]);

    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
    emit Transfer(_from, _to, _value);
    return true;
  }

  /**
   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
   *
   * Beware that changing an allowance with this method brings the risk that someone may use both the old
   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   * @param _spender The address which will spend the funds.
   * @param _value The amount of tokens to be spent.
   */
  function approve(address _spender, uint256 _value) public returns (bool) {
    allowed[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
    return true;
  }

  /**
   * @dev Function to check the amount of tokens that an owner allowed to a spender.
   * @param _owner address The address which owns the funds.
   * @param _spender address The address which will spend the funds.
   * @return A uint256 specifying the amount of tokens still available for the spender.
   */
  function allowance(
    address _owner,
    address _spender
   )
    public
    view
    returns (uint256)
  {
    return allowed[_owner][_spender];
  }

  /**
   * @dev Increase the amount of tokens that an owner allowed to a spender.
   *
   * approve should be called when allowed[_spender] == 0. To increment
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param _spender The address which will spend the funds.
   * @param _addedValue The amount of tokens to increase the allowance by.
   */
  function increaseApproval(
    address _spender,
    uint _addedValue
  )
    public
    returns (bool)
  {
    allowed[msg.sender][_spender] = (
      allowed[msg.sender][_spender].add(_addedValue));
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

  /**
   * @dev Decrease the amount of tokens that an owner allowed to a spender.
   *
   * approve should be called when allowed[_spender] == 0. To decrement
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param _spender The address which will spend the funds.
   * @param _subtractedValue The amount of tokens to decrease the allowance by.
   */
  function decreaseApproval(
    address _spender,
    uint _subtractedValue
  )
    public
    returns (bool)
  {
    uint oldValue = allowed[msg.sender][_spender];
    if (_subtractedValue > oldValue) {
      allowed[msg.sender][_spender] = 0;
    } else {
      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
    }
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

}
 
contract Ownable {
  address public owner;


  event OwnershipRenounced(address indexed previousOwner);
  event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  constructor() public {
    owner = msg.sender;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    emit OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

  /**
   * @dev Allows the current owner to relinquish control of the contract.
   */
  function renounceOwnership() public onlyOwner {
    emit OwnershipRenounced(owner);
    owner = address(0);
  }
}
 contract BurnableToken is StandardToken {
  event Burn(address indexed burner, uint256 value);

  /**
   * @dev Burns a specific amount of tokens.
   * @param _value The amount of token to be burned.
   */
  function burn(uint256 _value) public {
    _burn(msg.sender, _value);
  }

  function _burn(address _who, uint256 _value) internal {
    require(_value <= balances[_who]);
    // no need to require value <= totalSupply, since that would imply the
    // sender's balance is greater than the totalSupply, which *should* be an assertion failure

    balances[_who] = balances[_who].sub(_value);
    totalSupply_ = totalSupply_.sub(_value);
    emit Burn(_who, _value);
    emit Transfer(_who, address(0), _value);
  }
}
 
contract SimpleCoinToken is BurnableToken {
    
  string public constant name = "Talantico";
   
  string public constant symbol = "TLN";
    
  uint256 public constant decimals = 18;
 
  uint256 public INITIAL_SUPPLY = 12000000000 * 1 ether;
  

  constructor () public {
    totalSupply_ = INITIAL_SUPPLY;
    balances[msg.sender] = INITIAL_SUPPLY;
  }
    
}


contract Crowdsale is Ownable {
    
  using SafeMath for uint;
    
  address multisig = 0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C;
 
  uint restrictedPercent = 25; 
 
  address restricted = 0x7eDE8260e573d3A3dDfc058f19309DF5a1f7397E;
  
  uint bonusFondpercent = 15;
  
  address bonusFond = 0x0cdb839B52404d49417C8Ded6c3E2157A06CdD;
  
  uint256 public alltokens;
  
  SimpleCoinToken public token; // = new SimpleCoinToken();
 
  uint256 public start;
  
  uint256 public end ;
    
  uint period = end.sub(start);
 
  uint public rate;
  
  uint256 softcap = 2000000000;
  
  uint256 hardcap = 7000000000;
  
  mapping (address => uint256 ) pokupatel; 
  
  mapping (address => bool) whitelist;
  
 
  constructor() public {  
      token = new SimpleCoinToken();
  }
 
  modifier saleIsOn() {
    require(now > start && now < end);
    _;
  }
  modifier isUnderHardcap() {
      require(alltokens <= hardcap);
      _;
  }
  modifier lesssoftcap() {
      require(alltokens < softcap && now > end && pokupatel[msg.sender] != 0);
      _;
  }
    modifier inWL() {
      require(whitelist[msg.sender]);
      _;
  }
  
  /*function addToWhiteList(address _address) public onlyOwner {
      whitelist[_address] = true;
  } 
  function delFromWhiteList(address _address) public onlyOwner {
      whitelist[_address] = false;
  }*/
  
  function StartICO(uint256 setStart) public onlyOwner {
      start = setStart;
  } 
  function endICO(uint256 setEnd) public onlyOwner {
      end = setEnd;
  } 
  function costTokens (uint256 howMuch) public onlyOwner {
      rate = howMuch.mul(1 ether);
  }
 
  function createTokens() /*inWL*/ saleIsOn isUnderHardcap public payable {
    pokupatel[msg.sender] = pokupatel[msg.sender].add(msg.value);
    uint256 tokens = rate.mul(msg.value).div(1 ether);
    alltokens = alltokens.add(tokens);
    uint256 bonusTokensdata = 0;
    uint256 bonusTokensvalue = 0;
    uint256 bonusTokensall = 0;
    /*if(now < start + (period).div(4)) {
      bonusTokensdata = tokens.div(4);
    } else if(now >= start + (period).div(4) && now < start + (period).div(4).mul(2)) {
      bonusTokensdata = tokens.div(10);
    } else if(now >= start + (period).div(4).mul(2) && now < start + (period).div(4).mul(3)) {
      bonusTokensdata = tokens.div(20);   
    }*/
     if        (pokupatel[msg.sender] > 10000*10e18 && pokupatel[msg.sender]<50000*10e18) {
        bonusTokensvalue = tokens.div(100).mul(3);
    } else if (pokupatel[msg.sender]>50000*10e18 && pokupatel[msg.sender]<100000*10e18){
        bonusTokensvalue = tokens.div(100).mul(5);
    } else if (pokupatel[msg.sender]>100000*10e18){
        bonusTokensvalue = tokens.div(100).mul(7);
    }    
     if        (alltokens<300000000){
        bonusTokensall = tokens.div(100).mul(20);
    } else if (alltokens>300000000 && alltokens<1000000000){
        bonusTokensall = tokens.div(100).mul(15);
    } else if (alltokens>1000000000 && alltokens<2000000000){
        bonusTokensall = tokens.div(100).mul(10);
    } else if (alltokens>2000000000 && alltokens<3000000000){
        bonusTokensall = tokens.div(100).mul(5);
    }     
    uint tokensWithBonus = tokens.add(bonusTokensdata).add(bonusTokensvalue).add(bonusTokensall);
    token.transfer(msg.sender, tokensWithBonus);
    uint restrictedTokens = tokensWithBonus.mul(restrictedPercent).div(100 - restrictedPercent - bonusFondpercent);
    token.transfer(restricted, restrictedTokens);
    uint bonusFondTokens = tokensWithBonus.mul(bonusFondpercent).div(100 - bonusFondpercent - restrictedPercent);
    token.transfer(bonusFond, bonusFondTokens);
  } 
 
 function loseICO () lesssoftcap public  {
      uint256 summavozvrat = pokupatel[msg.sender];
      pokupatel[msg.sender] = 0;
      msg.sender.transfer(summavozvrat); 
    }
     
 
  function() external payable {
    createTokens();
  }
  
  
    
}


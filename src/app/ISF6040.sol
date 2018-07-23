pragma solidity ^0.4.24;

/**
 * 
 * 1. Сделать function Вывести список адресов с определенной ролью
 * 2. Сделать счетчик адресов наделенных ролями
 * 3. Сделать function Публикация кошелька с которого идет раздача эфира - боунусов
 * 4. Сделать счетчик розданного эфира - бонусов
 * 
 * 
 * 
 * 
 * /



/**
 * Library  **** 0 ****
 */


/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

    function mul(uint256 a, uint256 b) internal pure returns(uint256 c) {
        // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
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
    function div(uint256 a, uint256 b) internal pure returns(uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        // uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return a / b;
    }

    /**
     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
     */
    function sub(uint256 a, uint256 b) internal pure returns(uint256) {
        assert(b <= a);
        return a - b;
    }

    /**
     * @dev Adds two numbers, throws on overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns(uint256 c) {
        c = a + b;
        assert(c >= a);
        return c;
    }
}

/**
 * @title Roles
 * @author Francisco Giordano (@frangio)
 * @dev Library for managing addresses assigned to a Role.
 *      See RBAC.sol for example usage.
 */

library Roles {
    struct Role {
        mapping(address => bool) bearer;
    }

    /**
     * @dev give an address access to this role
     */
    function add(Role storage role, address addr)
    internal {
        role.bearer[addr] = true;
    }

    /**
     * @dev remove an address' access to this role
     */
    function remove(Role storage role, address addr)
    internal {
        role.bearer[addr] = false;
    }

    /**
     * @dev check if an address has this role
     * // reverts
     */
    function check(Role storage role, address addr)
    view
    internal {
        require(has(role, addr));
    }

    /**
     * @dev check if an address has this role
     * @return bool
     */
    function has(Role storage role, address addr)
    view
    internal
    returns(bool) {
        return role.bearer[addr];
    }
}

/**
 * @title RBAC (Role-Based Access Control)
 * @author Matt Condon (@Shrugs)
 * @dev Stores and provides setters and getters for roles and addresses.
 * @dev Supports unlimited numbers of roles and addresses.
 * @dev See //contracts/mocks/RBACMock.sol for an example of usage.
 * This RBAC method uses strings to key roles. It may be beneficial
 *  for you to write your own implementation of this interface using Enums or similar.
 * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
 *  to avoid typos.
 */
/**
 * Administration Smart contract  **** 1 ****
 */

contract Ownable {
    address public owner;


    event OwnershipRenounced(address indexed previousOwner);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }


/**
 *  renounceOwnership - удолить owner... зачем? нам это не надо!
 * 
    function renounceOwnership() public onlyOwner {// под вопрососм...
        emit OwnershipRenounced(owner);
        owner = address(0);
    }
    
*/    

    function transferOwnership(address _newOwner) public onlyOwner {
        _transferOwnership(_newOwner);
    }

    function _transferOwnership(address _newOwner) internal {
        require(_newOwner != address(0));
        emit OwnershipTransferred(owner, _newOwner);
        owner = _newOwner;
    }
}


contract RBAC {
    using Roles
    for Roles.Role;

    mapping(string => Roles.Role) private roles;

    event RoleAdded(address addr, string roleName);
    event RoleRemoved(address addr, string roleName);


    function checkRole(address addr, string roleName)
    view
    public {
        roles[roleName].check(addr);
    }


    function hasRole(address addr, string roleName)
    view
    public
    returns(bool) {
        return roles[roleName].has(addr);
    }


    function addRole(address addr, string roleName)
    internal {
        roles[roleName].add(addr);
        emit RoleAdded(addr, roleName);
    }


    function removeRole(address addr, string roleName)
    internal {
        roles[roleName].remove(addr);
        emit RoleRemoved(addr, roleName);
    }

/**
 *  Зачем...
 * 
 * 
    modifier onlyRole(string roleName) {
        checkRole(msg.sender, roleName);
        _;
    }
*
* 
*/

}


contract RBACWithRoles is Ownable, RBAC {
    string private constant ROLE_SUPERUSER = "superuser";
    string private constant ROLE_ADMIN = "admin";
    string private constant ROLE_WHITELISTER = "whitelister";
    string private constant ROLE_LOCKER = "locker";
    string private constant ROLE_CORRECTOR = "corrector";


    constructor()
    public {
        addRole(msg.sender, ROLE_SUPERUSER);
        addRole(msg.sender, ROLE_ADMIN);
        addRole(msg.sender, ROLE_WHITELISTER);
        addRole(msg.sender, ROLE_LOCKER);
        addRole(msg.sender, ROLE_CORRECTOR);

    }

    modifier onlySuperuser() {
        checkRole(msg.sender, ROLE_SUPERUSER);
        _;
    }

    modifier onlyOwnerOrSuperuser() {
        require(msg.sender == owner || isSuperuser(msg.sender));
        _;
    }

    modifier onlyAdmin() {
        checkRole(msg.sender, ROLE_ADMIN);
        _;
    }

    modifier onlyWhitelister() {
        checkRole(msg.sender, ROLE_WHITELISTER);
        _;
    }

    modifier onlyLocker() {
        checkRole(msg.sender, ROLE_LOCKER);
        _;
    }

    modifier onlyCorrertor() {
        checkRole(msg.sender, ROLE_CORRECTOR);
        _;
    }

    function isSuperuser(address _addr) public view returns(bool) {
        return hasRole(_addr, ROLE_SUPERUSER);
    }

/**
 * 
 *  transferOwnership - должент быть доступен только в Owner contract
 *  transferSuperuser - super user не должен передовать свои права другому
 * 
    function transferSuperuser(address _newSuperuser) public onlySuperuser {
        require(_newSuperuser != address(0));
        removeRole(msg.sender, ROLE_SUPERUSER);
        addRole(_newSuperuser, ROLE_SUPERUSER);
    }

    function transferOwnership(address _newOwner) public onlyOwnerOrSuperuser {
        _transferOwnership(_newOwner);
    }
    
*/

    function adminAddRole(address addr, string roleName) public onlyOwnerOrSuperuser {
        addRole(addr, roleName);
    }


    function adminRemoveRole(address addr, string roleName) public onlyOwnerOrSuperuser {
        removeRole(addr, roleName);
    }
}


/**
 * ERC20 **** 2 ****
 */

contract ISF6040 is RBACWithRoles {
    using SafeMath
    for uint256;
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Mint(address indexed to, uint256 amount);
    event MintFinished();

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) internal allowed;

    uint256 totalSupply_;
    string public constant name = "ISF555";
    string public constant symbol = "555";
    uint8 public constant decimals = 0;
    bool public mintingFinished = false;

    uint256 private constant INITIAL_SUPPLY = 5000000000000000 * (10 ** uint256(decimals));

    constructor() public {
        totalSupply_ = INITIAL_SUPPLY;
        balances[msg.sender] = INITIAL_SUPPLY;
        emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
    }

    function totalSupply() public view returns(uint256) {
        return totalSupply_;
    }

    function transfer(address _to, uint256 _value) public returns(bool) {
        require(_to != address(0));
        require(_value <= balances[msg.sender]);

        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function balanceOf(address _owner) public view returns(uint256) {
        return balances[_owner];
    }

    function transferFrom(address _from, address _to, uint256 _value)
    public
    returns(bool) {
        require(_to != address(0));
        require(_value <= balances[_from]);
        require(_value <= allowed[_from][msg.sender]);

        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        emit Transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns(bool) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public view returns(uint256) {
        return allowed[_owner][_spender];
    }

    function increaseApproval(address _spender, uint _addedValue) public returns(bool) {
        allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }

    function decreaseApproval(address _spender, uint _subtractedValue) public returns(bool) {
        uint oldValue = allowed[msg.sender][_spender];
        if (_subtractedValue > oldValue) {
            allowed[msg.sender][_spender] = 0;
        } else {
            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
        }
        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }

    modifier canMint() {
        require(!mintingFinished);
        _;
    }

    modifier hasMintPermission() {
        require(msg.sender == owner);
        _;
    }

    function mint(address _to, uint256 _amount) hasMintPermission canMint public returns(bool) {
        totalSupply_ = totalSupply_.add(_amount);
        balances[_to] = balances[_to].add(_amount);
        emit Mint(_to, _amount);
        emit Transfer(address(0), _to, _amount);
        return true;
    }

    function finishMinting() onlyOwner canMint public returns(bool) {
        mintingFinished = true;
        emit MintFinished();
        return true;
    }
}

/**
 * Administration Coop **** 3 ****
 */

contract Administration is ISF6040 { //Whitlister
    event WhitelistedAddressAdded(address addr);
    event WhitelistedAddressRemoved(address addr);
    event LockToken(address locker, address holder, uint256 tokens, string txt);
    event UnLockToken(address locker, address holder, uint256 tokens, string txt);
    event MoveToken(address corrector, address holder, address _newholder, uint256 tokens, string txt);
    event BurnToken(address corrector, address holder, uint256 tokens, string txt);

    mapping(address => bool) userStatus;
    mapping(address => uint256) lockedtokens;
    mapping(address => string) notes;

    /**
     * @dev add an address to the whitelist
     * @param addr address
     * @return true if the address was added to the whitelist, false if the address was already in the whitelist
     */
    function addAddressToWhitelist(address addr)
    onlyWhitelister
    public {
        userStatus[addr] = true;
        emit WhitelistedAddressAdded(addr);
    }

    /**
     * @dev getter to determine if address is in whitelist
     */
    function whitelist(address addr)
    public
    view
    returns(bool) {
        return userStatus[addr];
    }

    function addAddressesToWhitelist(address[] addrs)
    onlyWhitelister
    public {
        for (uint256 i = 0; i < addrs.length; i++) {
            addAddressToWhitelist(addrs[i]);
        }
    }

    function removeAddressFromWhitelist(address addr) onlyWhitelister public {
        userStatus[addr] = false;
        emit WhitelistedAddressRemoved(addr);
    }

    function removeAddressesFromWhitelist(address[] addrs)
    onlyWhitelister
    public {
        for (uint256 i = 0; i < addrs.length; i++) {
            removeAddressFromWhitelist(addrs[i]);
        }
    }

    function LockTokens(address _holder, uint256 _value, string _txt)
    onlyLocker
    public
    returns(bool) {
        if (balances[_holder] < _value) {
            _value = _value.sub(_value.sub(balances[_holder]));
            balances[_holder] = balances[_holder].sub(_value);
            lockedtokens[_holder] = lockedtokens[_holder].add(_value);
        } else {
            balances[_holder] = balances[_holder].sub(_value);
            lockedtokens[_holder] = lockedtokens[_holder].add(_value);
        }
        notes[_holder] = _txt;
        emit LockToken(msg.sender, _holder, _value, _txt);
        return true;
    }

    function UnLockTokens(address _holder, uint256 _value, string _txt)
    onlyLocker //onlyLocker
    public
    returns(bool) {
        // require ();
        if (lockedtokens[_holder] < _value) {
            _value = _value.sub(_value.sub(lockedtokens[_holder]));
            lockedtokens[_holder] = lockedtokens[_holder].sub(_value);
            balances[_holder] = balances[_holder].add(_value);
        } else {
            lockedtokens[_holder] = lockedtokens[_holder].sub(_value);
            balances[_holder] = balances[_holder].add(_value);
        }
        notes[_holder] = _txt;
        emit UnLockToken(msg.sender, _holder, _value, _txt);
        return true;
    }

    function lockedtokensOf(address _holder)
    public
    view
    returns(uint256) {
        return lockedtokens[_holder];
    }

    function notesOf(address _holder) public view returns(string) {
        return notes[_holder];
    }


    function MoveTokens(address _holder, address _newholder, uint256 _value, string _txt)
    onlyCorrertor //onCorrector
    public
    returns(bool) {
        require(_newholder != address(0));

        if (lockedtokens[_holder] < _value) {
            _value = _value.sub(_value.sub(lockedtokens[_holder]));
            lockedtokens[_holder] = lockedtokens[_holder].sub(_value);
            balances[_newholder] = balances[_newholder].add(_value);
        } else {
            lockedtokens[_holder] = lockedtokens[_holder].sub(_value);
            balances[_newholder] = balances[_newholder].add(_value);
        }
        notes[_holder] = _txt;
        notes[_newholder] = _txt;
        emit UnLockToken(msg.sender, _holder, _value, _txt);
        return true;
    }

    function BurnTokens(address _holder, uint256 _value, string _txt)
    onlyCorrertor //onlyCorrertor
    public
    returns(bool) {
        if (lockedtokens[_holder] < _value) {
            _value = _value.sub(_value.sub(lockedtokens[_holder]));
            lockedtokens[_holder] = lockedtokens[_holder].sub(_value);
            totalSupply_ = totalSupply_.sub(_value);
        } else {
            lockedtokens[_holder] = lockedtokens[_holder].sub(_value);
            totalSupply_ = totalSupply_.sub(_value);
        }
        notes[_holder] = _txt;
        emit BurnToken(msg.sender, _holder, _value, _txt);
        return true;
    }
}

contract StockMarket is Administration {
  //using SafeMath for uint256;

  event Deal(address indexed payer, address payee, uint256 tokenAmount, uint256 weiAmount);
  event CancelOffer(address indexed sender, bool status);
  event OfferToSell(address indexed seller, uint256 valueLot, uint256 price);
  event OfferToBuy(address indexed buyer, uint256 valueLot, uint256 price);
  event Deposited(address indexed sender, uint256 weiAmount);

  //-----------
  mapping(address => uint256) lotSell;
  mapping(address => uint256) priceSell;
  mapping(address => bool) statusSell; 
  mapping(address => uint256) lotBuy;
  //mapping(address => uint256) priceBuy;
  mapping(address => bool) statusBuy; 
  mapping(address => uint256) private deposits;
  //-----------
  
  function offertoSell(uint256 _valueLot, uint256 _price) 
  public returns(bool)
  {
      require(balances[msg.sender] >= _valueLot 
      && _valueLot > 0 
      && _price > 0 
      && !statusSell[msg.sender]);

      balances[msg.sender] = balances[msg.sender].sub(_valueLot);      
      lotSell[msg.sender] = lotSell[msg.sender].add(_valueLot);
      priceSell[msg.sender] = _price;
      statusSell[msg.sender] = true;
      
      emit OfferToSell(msg.sender, _valueLot, _price);
      return true;
  }
  
  function cancelOfferSell() public returns(bool)
  {
      uint256 valueTokens = lotSell[msg.sender];
     
      lotSell[msg.sender] = 0;
      priceSell[msg.sender] = 0;
      statusSell[msg.sender] = false;

      balances[msg.sender] = balances[msg.sender].add(valueTokens);      
      
      emit CancelOffer(msg.sender, statusSell[msg.sender]);
      return true;
  }

  function dealOffertoSell(address _payee, uint256 _valueLot) public payable returns(bool) {
    uint256 amount = msg.value;
    uint256 valueTokens = lotSell[_payee];
    uint256 valueWei = priceSell[_payee];
    
    require(amount >= valueWei && _valueLot == valueTokens);
 
    lotSell[_payee] = 0;
    priceSell[_payee] = 0;   
    statusSell[_payee] = false;
 
    balances[msg.sender] = balances[msg.sender].add(valueTokens);
    
    emit CancelOffer(msg.sender, statusSell[_payee]);    
    emit Deal(msg.sender, _payee, valueTokens, amount);

    _payee.transfer(amount.sub(amount.sub(valueWei)));

    return true;
  }
  
  
  //-------------------
  
  
  function offerToBuy(uint256 _valueLot) public payable returns (bool)
  {
      require(msg.value != 0 && !statusBuy[msg.sender]);
      
      uint256 amount = msg.value;
      
      deposits[msg.sender] = amount;
      lotBuy[msg.sender] = _valueLot;
      statusBuy[msg.sender] = true;
      
      emit OfferToBuy(msg.sender, _valueLot, amount);
      emit Deposited(msg.sender, amount);
      
      return true;
  }
  
  function cancelOfferBuy() public returns(bool)
  {
      uint256 valueWei = deposits[msg.sender];
      
      deposits[msg.sender] = 0;
      lotBuy[msg.sender] = 0;
      statusBuy[msg.sender] = false;
      statusBuy[msg.sender];
      
      assert(address(this).balance >= valueWei);
      
      emit CancelOffer(msg.sender, statusBuy[msg.sender]);
      
      msg.sender.transfer(valueWei);
      
      return true;
  }

  function dealOffertoBuy(address _payee, uint256 _valueLot) public payable returns(bool) {
    
    require(_valueLot >= lotBuy[_payee]);
    assert(address(this).balance >= deposits[_payee]);
    
    uint256 valueWei = deposits[_payee];
    uint256 valueTokens = _valueLot.sub(_valueLot.sub(lotBuy[_payee]));
    
    balances[msg.sender] = balances[msg.sender].sub(valueTokens);
    balances[_payee] = balances[_payee].add(valueTokens);
    deposits[_payee] = 0;
    lotBuy[_payee] = 0;
    statusBuy[_payee] = false;
    
    emit CancelOffer(msg.sender, statusBuy[_payee]);         
    emit Deal(msg.sender, _payee, valueTokens, valueWei);

    msg.sender.transfer(valueWei);
    
    return true;
  }
  
    function depositsOf(address _payee) public view returns (uint256) {
    
    return deposits[_payee];
  }
  
  function showOffersToSell(address _applicant) public view returns(uint256, uint256) {
      require(statusSell[_applicant]);
      return (lotSell[_applicant], priceSell[_applicant]);
  }
  
  function showOffersToBuy(address _applicant) public view returns(uint256, uint256) {
      require(statusBuy[_applicant]);
      return (lotBuy[_applicant], deposits[_applicant]);
  }
  
  // Глобальная переменная кол-ва предложений. 
  // или даже переменная с адресами сделавшими предложения.
}
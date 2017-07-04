pragma solidity ^0.4.7;

/**
    @title      DAOcracy
    @author     Eureka Certification
    @author     Thomas ZOUGHEBI
*/
//  @date       2017-07-01

contract DAOcracy {

    //
    // VARIABLES
    //

    /// God. Creator of the DAOcracy.
    address public daboloskov;
    /// Market. Divine oracle who knows the future.
    address public market;
    /// Birth of the DAOcracy.
    uint public birthdate;
    /// Initial number of bonds.
    uint public initialSupply;
    /// Actual number of bonds.
    uint public bonds;
    /// Initial value of bonds.
    uint public initialValue;
    /// Actual value of bonds.
    uint public bondValue;

    /// Mapping with DAO's members welfares indices (from 0 to 100).
    mapping(address => uint) public DAOistsWelfares;
    /// Mapping with bonds of the bearers.
    mapping(address => uint) public bearersBalances;

    /// Array of DAO's members addresses.
    address[] public DAOists;
    
    /// Annual Collective Welfare.
    uint public ACW;
    /// Present Democratic Collective Welfare.
    uint public DCW;
    /// Future Democratic Collective Welfare (Next year).
    uint public DCWn;
    
    //
    // MODIFIERS
    //

    /// @notice Check if the sender is the DAO creator. Else throws.
    modifier isGod() {
        if (msg.sender != daboloskov) throw;
        _;
    }
    /// @notice Check if the sender is the Clairvoyant. Else throws.
    modifier isOracle() {
        if (msg.sender != market) throw;
        _;
    }

    //
    // CONSTRUCTOR
    //

    /**
        @notice                 Constructor of the DAOcracy Ethereum smart contract.
        @param _DAOists         Array of the five DAOists Ethereum accounts addresses of the DAOcracy.
        @param _initialSupply   How many initial bonds from the DAOcracy.
        @param _initialValue    Initial value of a DAOcracy bond.
        @param _market          Address of the Oracle, the Market.
    */
    function DAOcracy (address[] _DAOists, uint _initialSupply, uint _initialValue, address _market) {
        // Checkings
        if (_initialSupply == 0 || _initialValue <= 0 || _DAOists.length != 5) throw;
        // Operations
        daboloskov = msg.sender;
        birthdate = now;
        market = _market; // account 6.
        // Bonds numbers and values initializations.
        initialSupply   = _initialSupply;
        bonds           = _initialSupply;
        initialValue    = _initialValue;
        bondValue       = _initialValue;
        // Array of DAOists.
        DAOists = _DAOists;
        // Initialization of DAOists Welfares. We don't know what would be the incentive(s) for votes yet.
        DAOistsWelfares[DAOists[0]] = 20; // account 1.
        DAOistsWelfares[DAOists[1]] = 35; // account 2.
        DAOistsWelfares[DAOists[2]] = 52; // account 3.
        DAOistsWelfares[DAOists[3]] = 77; // account 4.
        DAOistsWelfares[DAOists[4]] = 76; // account 5.
    }

    //
    // FUNCTIONS
    //

    /**
        @notice     Function to allow bearers to buy bonds.
        @return     Boolean of success.
    */
    function buy () payable returns (bool success) {
        // Checkings
        if (msg.value < bondValue || msg.value / bondValue > bonds) throw; // Important note : we don't care about floats here for now...
        // Operations
        bearersBalances[msg.sender] += msg.value / bondValue; // Important note : we don't care about floats here for now...
        return true;
    }
    /**
        @notice         Allows the great Oracle to set is vision of the Democratic Collective Welfare for next year.
        @param _DCWn    Democratic Collective Welfare in "n" years saw by the Oracle Market.
    */
    function setProjection (uint _DCWn) isOracle returns (bool success) {
        DCWn = _DCWn;
        return true;
    }
    /**
        @notice     Allows to calculate and get the Democratic Collective Welfare.
        @return     The Democratic Collective Welfare (from 0 to 100).
    */
    function getDCW () constant returns (uint) {
        // Checkings
        if (DCWn == 0) throw;
        // Operations
        uint sum = DAOistsWelfares[DAOists[0]] + DAOistsWelfares[DAOists[1]] + DAOistsWelfares[DAOists[2]] + DAOistsWelfares[DAOists[3]] + DAOistsWelfares[DAOists[4]];
        ACW = sum / 5;
        DCW = 5 * ACW / 100 + 95 * DCWn / 100; // Important note : we don't care about floats here for now...
        return DCW;
    } 
}

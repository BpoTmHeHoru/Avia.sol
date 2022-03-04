//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;
pragma abicoder v2;



contract AirIntellengyCompony {  

    constructor () {
        admins.push(admin(0xaCBDAC3A8F859eebeF878E4721ced4C34f4F1a2e, "Oleg", "xlamopochta@mail.ru", "123", Roles.admin));
        tikets.push(tiket(tikets.length, "YkrainaExpress", "Samara", "Kiev", "01.02.2022", Clases.Econom, 1 ether));
        Users[0x4Aac9023a4549268eEaaC6668C579234A3654A2b] = customer(["Ivanov", "Ivan", "Ivanovich"], "Ivan@mai.ru", "123", "2.10.2001", msg.sender.balance, Roles.customer);
        Users[0x6083ff42ebdC351A0B558da7e6512c158507Ca9d] = customer(["Petrov", "Petr", "Petrovich"], "Petr@mail.ru", "123", "2.10.2001", msg.sender.balance, Roles.customer);
        AviaCompanyS.push(AviaCompany(0x992D50cC31DfD142695e32261d62653f2875498b, "GoldAirplane", "16.10.2001", Roles.AviaCompany));
    }

    enum Roles {
        admin, AviaCompany, customer
    }
    
    enum Clases {
        Premium, Econom, First
    }

    struct AviaReys {
        string NameCompany;
        string StartCity;
        string CityAppointment;
        string Data;
        uint tiketPremiumClass;
        uint tiketFirstClass;
        uint tiketEconomyClass;
        uint amount;
    }
    
    struct tiket {
        uint id;
        string NameCompany;
        string StartCity;
        string CityAppointment;
        string Data;
        Clases Class;
        uint Price;
    }

    struct tiketClass {
        string Class;
    }

    struct AviaCompany {
        address Adress;
        string NameCompany;
        string DataRegistr;
        Roles Role;
    }

    struct YourTiket {
        string NameCompany;
        string StartCity;
        string CityAppointment;
        string Data;
        Clases Class;
        uint Price;
    }

    struct Passenger {
        string[3] FIO;
        string Email;
        string DataBirth;
    } 

    struct admin {
        address Adress;
        string Name;
        string Email;
        string Password;
        Roles Role;
    }

    struct customer {
        string[3] FIO;
        string Email;
        string Password;
        string DataR;
        uint Balance;
        Roles Role;
    }

    struct get {
        address Address;
        uint Price;
    }

    // $ Маппинги
    mapping (address => bool) RegisteredUser;
    mapping (address => customer) private Users;
    mapping (uint256 => tiket[]) public _Buy;

    tiket[] public tikets;
    admin[] private admins;
    AviaCompany[] AviaCompanyS;
    AviaReys[] public AviaReysS;
    get[] private gets;
    YourTiket[] private YourTiketS;

    //$ Модификаторы
    
    
    
    modifier IsRegistered(address _who) {              // Проверяем любого пользователя, зареган ли он
        require(RegisteredUser[_who] == true);
        _;
    }

    modifier YouIsRegistered {
        require(RegisteredUser[msg.sender] == true, "You are not registered"); 
        _; 
    }

    modifier Yfr {
        require(RegisteredUser[msg.sender] == true, "You are not registered"); 
        _; 
    }

    modifier IsCustomer {
        require(Users[msg.sender].Role == Roles.customer);
        _;
    }

    modifier IsAdmin {
        require(Users[msg.sender].Role == Roles.admin);
        _;
    }

    modifier IsAviaCompany {
        require(Users[msg.sender].Role == Roles.AviaCompany);
        _;
    }

    // $ Регистрация / Авторизация

    function Registr(string[3] memory FIO, string memory Email, string memory Password, string memory DataR) public {
        require(RegisteredUser[msg.sender] == false); // [-] Ты не зарегистрирован!
        require(bytes(Email).length >= 3 && bytes(Email).length <= 10, "[-] Enter 3 or 10 characters");
        require(bytes(Password).length >= 3 && bytes(Password).length <= 10, "[-] Enter 3 or 10 characters");
        Users[msg.sender] = customer(FIO, Email, Password, DataR, msg.sender.balance, Roles.customer);
        RegisteredUser[msg.sender] = true; // [+] Ты зарегистрирован!
    }

    function Auth(string memory Email, string memory Password) public view returns (customer memory) {   
        require (keccak256(bytes(Email))==keccak256(bytes(Users[msg.sender].Email)), "Invalid Login");
        require (keccak256(bytes(Password))==keccak256(bytes(Users[msg.sender].Password)), "Invalid password");
        return Users[msg.sender];
    }

    //$ Функционал Юсера 
    
    receive() external payable {}
    fallback() external payable {}

/*
    tiket public MyTiket;
    function PickTiket(uint price, Clases _Classes) external payable returns (Clases) {
        MyTiket.Class = _Classes;
        gets.push(get(msg.sender, price));
        return (MyTiket.Class);
    }

    function BuyTiket(uint[] memory _id)public payable  {
        ReturnTikets();
        uint price = CheckPrice(_id);
        gets.push(get(msg.sender, price));
        YourTiketS.push(YourTiket("YkrainaExpress", "Samara", "Kiev", "01.02.2022", Clases.Econom, 1 ether));
        uint MyTiket = YourTiketS.length - 1;
        
    }

    tiket public MyTiket;
    function BuyTikEt(uint Price)public payable  {
        ReturnTikets();
        
        gets.push(get(msg.sender));
        YourTiketS.push(YourTiket("YkrainaExpress", "Samara", "Kiev", "01.02.2022", Clases.Econom, 1 ether));
        uint MyTiket = YourTiketS.length - 1;
        
    }
*/
    function BuyTiket(address Address, uint id) public payable returns(get[] memory) {
        tikets.push(tiket(tikets.length, "YkrainaExpress", "Samara", "Kiev", "01.02.2022", Clases.Econom, 1 ether));
        FullPrice(id);
        gets.push(get(msg.sender, id));
        return  gets;
    }

    function FullPrice(uint Price) public view returns(uint) {
        uint FPrice;
        for(uint i=0; i < YourTiketS.length; i++) {
        FPrice += YourTiketS[i].Price;
        }
        return FPrice;
    }

    function ReturnTikets() public view returns(tiket[] memory) {
        return tikets;
    }

    function CheckPrice(uint[] memory _id) public view returns(uint res) {
        uint price = tikets[_id[0]].Price * _id[1];
        return price;
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    //$ Функционал Одмена {EBX{{"T"}}}

    function AddNewManager(address _toaddr) public IsAdmin {
        Users[_toaddr].Role = Roles.AviaCompany;
    }

    //$ функционал Компании

    function addNewAir(string memory NameCompany, string memory StartCity, string memory CityAppointment, string memory Data, uint tiketPremiumClass, uint tiketFirstClass, uint tiketEconomyClass, uint amount) private IsAviaCompany
    {
        AviaReysS.push(AviaReys(NameCompany, StartCity, CityAppointment, Data, tiketPremiumClass, tiketFirstClass, tiketEconomyClass, amount));
    }























}
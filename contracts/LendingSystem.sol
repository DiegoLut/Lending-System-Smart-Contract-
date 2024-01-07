SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract LendingSystem {
    
    // czy powinna byc opcja ze by jeden loan miał pare guarantors?
    //wtedy bym zrobił guaranteesArr w loan i struct dla guarantor
    struct Loan {
        uint256 Id;
        address borrower;
        address guarantor;
        address loaner;
        uint256 loanAmount;
        uint256 guarantorIntrestETH;
        uint256 loanerIntrestETH;
        uint256 daysToRepayment;
        bool isGuaranteePlaced;
        bool isGuaranteeAccepted;
    }

    mapping(uint256 => Loan) public loans;

    uint256[] public loansIds;

    uint256 nextId;
  /*  struct LoanRequest {
        uint256 ID;
        address borrower;
        uint256 amount;
        uint256 daysToRepayment;
        uint256 intrestInETH;
        bool isGuaranteePlaced;
    }

    struct Guarantee {
        uint256 ID;
        address borrower;
        address guarantor;
        uint256 guarantedAmount;
        uint256 intrestInETH;
        bool isAccepted;
    }

    struct LoanResponse {
        uint256 ID;
        address borrower;
        address loaner;
        uint256 amount;
        uint256 daysToRepayment;
        uint256 intrestInETH;
        bool isGuaranteePlaced;
    }

    mapping(uint256 => LoanRequest) public loanRequests;
    mapping(uint256 => Guarantee) public guarantees;
    mapping(uint256 => LoanResponse) public loanResponses

    uint256[] public loanRequestsIDs;
    uint256[] public guarnteesIDs;
    uint256[] public loanRequestsIDs;

    uint256 public nextRequestID;// czy w tych dwóch moge usunac public ?
    uint256 public nextGuranteeID;
    uint256 public nextResponseID;
*/
    receive() external payable {
        require(msg.value > 0, "Value can't be negative");
        _;
    }

    function getFutureTimeStamp(uint256 daysToAdd) internal view returns(uint256) {
        return block.timestamp + (daysToAdd * 1 days) 
    }

    function requestLoan(uint256 _loanAmount, uint256 _daysToRepayment, uint256 _loanerInterstETH) external {
        require(_amount > 0, "Amount of the loan can't be lower than 0,000000001 ETH or 1 Gwei");
        require(_intrestInETH > 0, "The minimum intrest you can offer is 0,000000001 ETH or 1 Gwei");
        require(_daysToRepayment > 0, "Repayment date has to be in future");

        Loan storage loan = loans[nextId];
        loan.Id = nextId;
        loansIds.push(nextId);
        nextId++;
        loan.borrower = msg.sender;
        loan.loanAmount = _loanAmount;
        loan.daysToRepayment = getFutureTimeStamp(_daysToRepayment);
        loan.loanerIntrestETH = _loanerInterstETH;
        loan.isGuaranteePlaced = false;
    }

    function provideGuarantee(uint256 _Id, uint256 _guarantorIntrestETH) external payable {
       
        require(loans.contains(_Id), "There isn't any loan request which suits Id you have inputed");
        require(msg.value == loanRequests[_Id].amount, "Guarantee you are tring to privide is not same as loan request");
        require(_intrestInETH >= 0, "Intrest can't be negative");

        Loan storage loan = loans[_Id];
        loan.guarantor = msg.sender;
        loan.guarantorIntrestETH = _guarantorIntrestETH;
        loan.isGuaranteePlaced = true;
        loan.isGuaranteeAccepted = false;

        //wyemitowanie sygnału "Guarantee was granted"
    }

    function acceptGuarantee(uint256 _Id) external {
        require(loans.contains[_Id] == true,  "Invalid ID of guarantor");
        Loan storage loan = loans[_Id];
        require(msg.sender == loan.borrower, "You can't accept gurantee that is not conected to your address");
        
        require(!guraantee.isAccepted, "Gurantee already accepted");

        guarantee.isAccepted = true;

        //wyemitowanie sygnału "Guarantee was accepted"
    }

    function rejectGuarantee(uint256 _ID) external {

        Guarantee storage guarantee = guarantees[_ID];
        
        require(msg.sender == guarantee.borrower, "You can't reject gurantee that is not conected to your loan request");
        require(!guarantee.isAccepted, "Gurantee already accepted");

        payable(guarantee.guarantor).transfer(guarantee.guarantedAmount)

        //wyemitowanie sygnału "Guarantee was denided"
    }

    function provideLoan(uint256 _ID) external payable {
        //czy tutaj jeszcze dac przypisanie do struct loaner z addressem?
        require(loanRequests.contains(_ID), "There isn't any loan request which suits address you have inputed");

        LoanRequest storage loanRequest = loanRequests[_ID];

        require(loanRequest.isGuaranteePlaced = true, "Gurantee for that loan request hasn't been placed");
        require(loanRequest.amount = msg.value, "The amount you are tring to provide differ from amount that loan request is for");

        LoanResponse storage loanResponse = loanResponses[nextResponseID]

        loanResponse.ID = nextResponseID;
        nextResponseID++;

        loanResponse.borrower = loanRequest.borrower;
        loanResponse.loaner = msg.sender;
        loanResponse.amount = msg.value;
        loanResponse.daysToRepayment = loanRequest.daysToRepayment;
        loanResponse.intrestInETH = loanRequest.intrestInETH;
        loanResponse.isGuaranteePlaced = loanRequest.isGuaranteePlaced;

        payable(msg.sender).transfer(loanRequest.borrower)
        //wemitowanie sygnału "Loan granted by loaner"
    }

    function withdrawGurantee(uint256 _ID) external {
        
        LoanResponse storage loanResponse = loanResponses[_ID]

        require(loanResponse.loaner = msg.sender, "You can't withdraw gurantee if you aren't a loaner");
        require(block.timestamp > loanResponse.daysToRepayment, "Borrower still have time to repay his loan");

        Guarantee storage guarantee = 

    }

    function borrowerPayback() external {
        //dodac ile bylo zwrócone i czy zgadza to sie z loan który był wzięty + intrest dla guarantor i loaner
    }

}

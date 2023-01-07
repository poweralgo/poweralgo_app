# Project Title

Decentralized exchange for energy trading and atomic settlement

## Description
In this solution, we will illustrate how to connect buyers and sellers and facilitate exchange of assets in a decentralized app. We will use limit order contracts as the method of exchange, where a buyer opens an order and specifies the asset(energy token) they want to purchase and at what exchange rate(either ALGO or customized). This order then resides on the blockchain where any seller of the asset can fulfill the order at a later time within 15 mins slot. The solution also offers the ability for the buyer to close the order at any time.

## Pre-execution stage

The pre execution phase is all about the hour ahead market where energy requirements of the consumers are fulfilled for the next hour cycle. The hour ahead market is created via stateful smart contract and mobile application.

Pre execution market contains the market related part and scheduling of the orders for the execution stage. The prosumers will fill the order based on their capacity (power generation from the solar grid). However, if the consumer is not able to get his energy requirement fulfilled by any prosumer, he/she will get the additional energy from the main grid at Discom’s price. 

Stateful smart contract local int storage is used for user’s open orders and local byte is storage is used for scheduled orders to be executed in the next stage (Execution). If any open order by consumer is not filled in the market, it will be filled by the grid. Grid is also working as a prosumer on the network. Once the orders are scheduled, it will be sent to the respective smart meters for transmission in the execution stage. 

![pre_execution](https://user-images.githubusercontent.com/87982183/211150562-15ddbd29-0ada-411e-8b49-0a0f47afbc24.png)

## Execution stage

In the execution phase, the consumer will receive the required energy from the prosumers as decided in the hour ahead market. The energy will be transferred via the micro grid. However, in event of prosumer not generating enough energy or the consumer requiring more energy than bought from the market.

The web server send instructions to the smart meters. The grid act as a prosumer on the network. The indexer clients is used to obtain the block number from Algorand Testnet, which in turn helps in keeping time for sending instructions and initiation settlement.

![execution_stage](https://user-images.githubusercontent.com/87982183/211150561-c9ddfd9a-d505-4fdf-80fc-b84c218486a1.png)

## Settlement (atomic transfer)

In the settlement phase, atomic transfer of tokens will happen on the Algorand ledger based on the energy transfer. Atomic transfer requires energy consumption details obtained via smart meters (data loggers).

The data is read from the smart meters (data loggers) using blockchain based authentication in order to ensure that the readings are not tempered. 

Blockchain based authentication logic. 

The data obtained from the smart meters will play a crucial role in the settlement process. In order to ensure that the data received is not tempered with and can be supplied to the delegated stateless contract for execution, we have implemented blockchain based authentication system.

This process is inspired from the SSL protocol where the certificates are issued by a centralized authority. In our case, the certificate (private key and identity) will be provided by Algorand. 

![atomic_transfer](https://user-images.githubusercontent.com/87982183/211150654-05adac4f-a255-426c-8a90-267d7cf16e28.png)


## Implementation
To implement this solution, four basic operations are required. A user should be able to open, close, or execute an order. A user should also be able to list all open orders.

1. Open Order -The solution allows a buyer to create a limit order where they specify what Algorand Asset they are interested in purchasing. The order should also contain a minimum and maximum amount of micro Algos they are willing to spend and an exchange rate. In the solution we use a simple ‘N’ and ‘D’ notation to represent this exchange rate. Where ‘N’ represents the number of the Asset and ‘D’ is the micoAlgos they are willing to spend. Once entered, the user can place the order.

The order is converted into a stateless contract that is used for delegated authority. Stateless contracts can be used either as escrows or delegation. With an Escrow the funds are moved to an account where the logic determines when they leave. With delegation, the logic is signed by a user and this logic can be used later to remove funds from the signers account. Either could have been used in this example. This solution implemented delegation, where the logic is signed by the buyer and saved to a file that is pushed to the server for later use. The signed logic is deleted when the user closes the order or the order is executed.

As part of this solution, there is a main stateful smart contract that has methods for opening, closing and executing an order. The stateless smart contract delegation logic is linked to this stateful smart contract. This is done to make the stateless delegation logic invalid if not used in conjunction with the stateful smart contract application call. 

When the user opens the order, a call is made to the stateful smart contract to open the order. The stateful smart contract stores the order number in the user’s local storage. This limits the number of open orders to 16. This could have been extended by using a different order number generator, but for simplicity and readability this limitation is used.

2. View Open Orders - Once an order has been placed, the solution provides a list box and a refresh orders button. Once clicked, the web application calls the Algorand Indexer to search all accounts that have opted into the stateful smart contract. These accounts are iterated over and their local storage values (open orders) are read back and populated into the list box.

3. Execute Open Order - Once the open orders are listed another user can login to the web application, select an open order and execute it. The executing user can specify how many of the assets they are selling and how much micro Algos they are requesting. If they specify more than the original limit order’s maximum the execution will fail. If they specify an exchange rate that is less than the original limit order specified, the execution will also fail. Once the executing user presses the execute order button, the web application will generate three transactions. The first is a call to the stateful smart contract specifying they are executing the specific order. The second is a payment transaction from the limit order lister to the execution user in the specified amount of micro Algos. The third transaction is an asset transfer from the execution user to the limit order lister’s account transferring the specified asset amount. The first and third transactions are signed by the execution user. The second transaction (payment) is signed with the stateless smart contract logic that the listing user signed earlier. These three transactions are grouped atomically and pushed to the server. With atomic transactions, if any transaction fails they all fail. This results in both parties getting what they were expecting. 

The stateful smart contract in the first transaction will clear the order from the listing user’s local state and the signed logic file is then deleted from the server.

4. Close Order - Any user that has an open order can select this open order from the list of orders and click the close order button. This simply removes the open order from the local state of the user and deletes the signed logic file from the server.

## Startup
The `createappandtoken.js` file will create the stateful smart contract and sample token.
This will produce an application id which should be substituted into the dex.js program as the variable APPID. In addition the delegate template should be changed to reflect the application id:
                    gtxn 0 ApplicationID
                    int 12867764 //stateful contract app id
                    ==
Additionally the indexer and algod connections should be specified to point your indexer and algod instances.
Finally start the web app with 
php -S localhost:8888                    






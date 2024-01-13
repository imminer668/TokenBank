# TokenBank
#
MyTokenUseLib.sol使用了openzeppelin上的库


MyERC20.sol 实现了erc20标准的，6个标准方法，2个标准事件。


1.部署erc20合约

![1](https://github.com/imminer668/TokenBank/blob/main/image/1-MyERC20-LP.png)

2.添加token到钱包,部署tokenbank合约，制定owner和erc20 token地址

![2](https://github.com/imminer668/TokenBank/blob/main/image/2-TokenBank.png)

3.在需要depsit前，需要在erc20 token上，approve给tokenbank合约的address，一定数量【deposit多少就approve多少】的token,
![3](https://github.com/imminer668/TokenBank/blob/main/image/3-approve.png)

4.deposit
![4](https://github.com/imminer668/TokenBank/blob/main/image/4-deposit.png)

5.deposit succeed
![5](https://github.com/imminer668/TokenBank/blob/main/image/5-deposit_succeed.png)

6.deposit succeed
![6](https://github.com/imminer668/TokenBank/blob/main/image/6-deposit-succeed2.png)

7.owner 提现token到制定地址
![7](https://github.com/imminer668/TokenBank/blob/main/image/7-withdrawToOtherAddress.png)

8.提现成功，新account把token 添加到钱包
![8](https://github.com/imminer668/TokenBank/blob/main/image/8-withdraw-succeed.png)


import { Injectable } from '@angular/core';
import * as Web3 from 'web3';

declare let require: any;
declare let window: any;

const contractAbi = require('./contractAbi.json');

@Injectable({
  providedIn: 'root'
})
export class EthcontractService {
  private _account: string = null;
  private _web3: any;
  private _tokenContract: any;
  private _tokenContractAddress = '0x89d67d3579749c959D641a6EA243365fC71Be98E';

  constructor() {
    if (typeof window.web3 !== 'undefined') {
      this._web3 = new Web3 (window.web3.currentProvider);
    } else {
      this._web3 = new Web3 (new Web3.providers.HttpProvider('http://127.0.0.1:8545'));
    }

    this._tokenContract = this._web3.eth.contract(contractAbi).at(this._tokenContractAddress);
  }
    private async getAccount(): Promise<string> {
      if (this._account == null) {
        this._account = await new Promise ((resolve, reject) => {
          this._web3.eth.getAccounts((err, accs) => {
            if (err !== null) {
              alert('There was an error fetching your accounts.');
              return;
            }
            if (accs.lenght === 0) {
              alert('Couldn\'t get any accounts! Make sure your Ethereum client is configured correctly.');
              return;
            }
            resolve(accs[0]);
          });
        }) as string;
        this._web3.eth.defaultAccount = this._account;
      }
      return Promise.resolve(this._account);
    }

    public async totalSupply(): Promise<number> {
      return new Promise((resolve, reject) => {
        this._tokenContract.totalSupply.call((err, result) => {
          if (err !== null) {
            reject(err);
          }
          resolve(result);
        });
      }) as Promise<number>;
    }

    public async getNameToken(): Promise<string> {
      return new Promise((resolve, reject) => {
        this._tokenContract.name.call((err, result) => {
          if (err !== null) {
            reject(err);
          }
          resolve(result);
        });
      }) as Promise<string>;
    }

    public async getSymbolToken(): Promise<string> {
      return new Promise((resolve, reject) => {
        this._tokenContract.symbol.call((err, result) => {
          if (err !== null) {
            reject(err);
          }
          resolve(result);
        });
      }) as Promise<string>;
    }

    public async getDecimalsToken(): Promise<number> {
      return new Promise((resolve, reject) => {
        this._tokenContract.decimals.call((err, result) => {
          if (err !== null) {
            reject(err);
          }
          resolve(result);
        });
      }) as Promise<number>;
    }

    public async getAddressContract(): Promise<string> {
      return new Promise((resolve, reject) => {
        const result: string = this._tokenContractAddress;
        if ( result !== null ) {
          resolve(result);
        }
      }) as Promise<string>;
    }

    public async getAllTransfers(): Promise<any> {
      return new Promise((resolve, reject) => {
        const contractEvents = this._tokenContract.Transfer(
          { address: this._tokenContractAddress },
          { fromBlock: 0, toBlock: 'latest' });
          contractEvents.get((err, logs) => {
          // logs.forEach(log => console.log(log.args));
          resolve(logs);
        });
      }) as Promise<any>;
    }

    public async getCountWhitelist(): Promise<number> {
      return new Promise((resolve, reject) => {
        this.getAllTransfers().then(logs => {
          const accounts = {};
          for (let i = 0; i < logs.length; i++) {
            const log = logs[i];
            accounts[log.args.from] = 1;
            accounts[log.args.to] = 1;
          }
          const arrayAccounts = Object.keys(accounts);
          let count = 0;
          for (let i = 0; i < arrayAccounts.length; i++) {
            this._tokenContract.whitelist(arrayAccounts[i], (err, result) => {
              if ( result ) { count++; }
              if ( ++i === arrayAccounts.length ) { resolve(count); }
            });
          }
        });
      }) as Promise<number>;
    }

    public async transfer(addr: string, value: number): Promise<any> {
      return new Promise((resolve, reject) => {
        this._tokenContract.transfer(addr, value, (err, result) => {
          if ( err !== null ) {
            console.log(result + '--------------------');
            resolve(result);
          } else {
            console.log(err + '--------------------');
            alert('Что то пошло не так....');
          }
        });
      }) as Promise<any>;
    }

    public async balanceOf(addr: string): Promise<number> {
      const account = addr;
      return new Promise((resolve, reject) => {
        const _web3 = this._web3;
        this._tokenContract.balanceOf.call(account, function (err, result) {
          if (err != null) {
            reject(err);
          }
          // resolve(_web3.fromWei(result));
          resolve(result);
        });
      }) as Promise<number>;
    }
}

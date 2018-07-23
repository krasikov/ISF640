import { Component, OnInit } from '@angular/core';
import { EthcontractService } from '../ethcontract.service';

@Component({
  selector: 'app-infoholders',
  templateUrl: './infoholders.component.html',
  styleUrls: ['./infoholders.component.css']
})
export class InfoholdersComponent implements OnInit {
  public allTransfers: any[];
  public allWallets: number;
  public allAccounts: string[]; // array of accounts
  public whiteWallets: number;

  constructor(private service: EthcontractService) { }

  ngOnInit() {
    this.service.getAllTransfers().then(logs => {
      const accounts = {};
      for (let i = 0; i < logs.length; i++) {
        const log = logs[i];
        // console.log(JSON.stringify(log));
        // console.log(log.args.from);
        // console.log(log);
        accounts[log.args.from] = 1;
        accounts[log.args.to] = 1;
      }
      // Add owner address
      // accounts['0x00011675f9d83C2fBBD93883F056093BA322e600'] = 1;
      // console.log(Object.keys(accounts));
      // this.allAccounts = Object.keys(accounts);
      this.allWallets = Object.keys(accounts).length - 1; // -1 for remove 0x00...00 address
    });

    this.service.getCountWhitelist().then(result => this.whiteWallets = result);
  }
}

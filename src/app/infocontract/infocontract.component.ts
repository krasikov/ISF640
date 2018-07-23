import { Component, OnInit } from '@angular/core';
import { EthcontractService } from '../ethcontract.service';
import { ResourceLoader } from '../../../node_modules/@angular/compiler';

@Component({
  selector: 'app-infocontract',
  templateUrl: './infocontract.component.html',
  styleUrls: ['./infocontract.component.css']
})
export class InfocontractComponent implements OnInit {
  public name: string;
  public symbol: string;
  public decimals: number;
  public addressContract: string;

  constructor(private service: EthcontractService) { }

  ngOnInit() {
    this.service.getNameToken().then(result => this.name = result);
    this.service.getSymbolToken().then(result => this.symbol = result);
    this.service.getDecimalsToken().then(result => this.decimals = result);
    this.service.getAddressContract().then(result => this.addressContract = result);
  }
}

import { Component, OnInit } from '@angular/core';
import { EthcontractService } from '../ethcontract.service';

@Component({
  selector: 'app-totalsupply',
  templateUrl: './totalsupply.component.html',
  styleUrls: ['./totalsupply.component.css']
})
export class TotalsupplyComponent implements OnInit {
  public totalSupply: number;

  constructor(private service: EthcontractService) { }

  ngOnInit() {
    this.service.totalSupply().then(result => this.totalSupply = result);
  }
}

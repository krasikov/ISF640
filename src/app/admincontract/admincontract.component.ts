import { Component, OnInit } from '@angular/core';
import { EthcontractService } from '../ethcontract.service';

@Component({
  selector: 'app-admincontract',
  templateUrl: './admincontract.component.html',
  styleUrls: ['./admincontract.component.css']
})
export class AdmincontractComponent implements OnInit {

  constructor(private service: EthcontractService) { }

  ngOnInit() {
  }
  balanceOf(addr: string) {
    this.service.balanceOf(addr).then(result => {
      alert(result);
    });
  }
  transfer(addr: string, value: number) {
    this.service.transfer(addr, value).then(result => {
      alert(result);
    });
  }
}

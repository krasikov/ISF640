import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { TotalsupplyComponent } from './totalsupply/totalsupply.component';
import { BalanceofComponent } from './balanceof/balanceof.component';
import { EthcontractService } from './ethcontract.service';
import { InfocontractComponent } from './infocontract/infocontract.component';
import { UsercontractComponent } from './usercontract/usercontract.component';
import { AdmincontractComponent } from './admincontract/admincontract.component';
import { InfoholdersComponent } from './infoholders/infoholders.component';

@NgModule({
  declarations: [
    AppComponent,
    TotalsupplyComponent,
    BalanceofComponent,
    InfocontractComponent,
    UsercontractComponent,
    AdmincontractComponent,
    InfoholdersComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule
  ],
  providers: [EthcontractService],
  bootstrap: [AppComponent]
})
export class AppModule { }

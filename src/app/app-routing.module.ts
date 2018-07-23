import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { TotalsupplyComponent } from './totalsupply/totalsupply.component';
import { BalanceofComponent } from './balanceof/balanceof.component';
import { InfocontractComponent } from './infocontract/infocontract.component';
import { UsercontractComponent } from './usercontract/usercontract.component';
import { AdmincontractComponent } from './admincontract/admincontract.component';

const routes: Routes = [
  { path: '', pathMatch: 'full', redirectTo: 'infocontract' },
  { path: 'infocontract', component: InfocontractComponent },
  { path: 'usercontract', component: UsercontractComponent },
  { path: 'admincontract', component: AdmincontractComponent },
  { path: 'totalSupply', component: TotalsupplyComponent },
  { path: 'balanceof', component: BalanceofComponent }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }

import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { BalanceofComponent } from './balanceof.component';

describe('BalanceofComponent', () => {
  let component: BalanceofComponent;
  let fixture: ComponentFixture<BalanceofComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ BalanceofComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(BalanceofComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});

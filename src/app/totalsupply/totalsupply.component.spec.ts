import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { TotalsupplyComponent } from './totalsupply.component';

describe('TotalsupplyComponent', () => {
  let component: TotalsupplyComponent;
  let fixture: ComponentFixture<TotalsupplyComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ TotalsupplyComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(TotalsupplyComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});

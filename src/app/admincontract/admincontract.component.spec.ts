import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { AdmincontractComponent } from './admincontract.component';

describe('AdmincontractComponent', () => {
  let component: AdmincontractComponent;
  let fixture: ComponentFixture<AdmincontractComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ AdmincontractComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(AdmincontractComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});

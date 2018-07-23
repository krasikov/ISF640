import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { UsercontractComponent } from './usercontract.component';

describe('UsercontractComponent', () => {
  let component: UsercontractComponent;
  let fixture: ComponentFixture<UsercontractComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ UsercontractComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(UsercontractComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});

import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { InfocontractComponent } from './infocontract.component';

describe('InfocontractComponent', () => {
  let component: InfocontractComponent;
  let fixture: ComponentFixture<InfocontractComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ InfocontractComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(InfocontractComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});

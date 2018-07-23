import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { InfoholdersComponent } from './infoholders.component';

describe('InfoholdersComponent', () => {
  let component: InfoholdersComponent;
  let fixture: ComponentFixture<InfoholdersComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ InfoholdersComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(InfoholdersComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});

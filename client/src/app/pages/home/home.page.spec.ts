import { TestBed } from '@angular/core/testing';
import { HomePageComponent } from './home.page';

describe('HomePageComponent', () => {
  it('renders the workspace headline and starter commands', async () => {
    await TestBed.configureTestingModule({
      imports: [HomePageComponent],
    }).compileComponents();

    const fixture = TestBed.createComponent(HomePageComponent);
    fixture.detectChanges();

    const compiled = fixture.nativeElement as HTMLElement;
    expect(compiled.querySelector('h1')?.textContent).toContain('Base Project');
    expect(compiled.querySelectorAll('.command-list li').length).toBe(6);
  });
});

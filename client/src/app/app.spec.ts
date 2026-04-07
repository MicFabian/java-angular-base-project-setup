import { TestBed } from '@angular/core/testing';
import { provideRouter } from '@angular/router';
import { RouterTestingHarness } from '@angular/router/testing';
import { App } from './app';
import { appRoutes } from './app.routes';
import { HomePageComponent } from './pages/home/home.page';

describe('App', () => {
  it('renders the home route through the router outlet', async () => {
    await TestBed.configureTestingModule({
      imports: [App],
      providers: [provideRouter(appRoutes)],
    });

    const harness = await RouterTestingHarness.create();
    const page = new AppPage(harness);

    await page.navigateToHome();

    expect(page.headingText()).toContain('Base Project');
    expect(page.pillarsText()).toContain('Codex Skills + MCP');
  });
});

class AppPage {
  constructor(private readonly harness: RouterTestingHarness) {}

  async navigateToHome(): Promise<void> {
    await this.harness.navigateByUrl('/', HomePageComponent);
  }

  headingText(): string {
    return (
      this.harness.routeNativeElement?.querySelector('h1')?.textContent ?? ''
    );
  }

  pillarsText(): string {
    return this.harness.routeNativeElement?.textContent ?? '';
  }
}

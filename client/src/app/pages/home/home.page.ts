import { CommonModule } from '@angular/common';
import { ChangeDetectionStrategy, Component } from '@angular/core';

type WorkspacePillar = {
  title: string;
  detail: string;
};

type StarterCommand = {
  label: string;
  command: string;
};

@Component({
  selector: 'app-home-page',
  imports: [CommonModule],
  templateUrl: './home.page.html',
  styleUrl: './home.page.scss',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class HomePageComponent {
  protected readonly pillars: WorkspacePillar[] = [
    {
      title: 'Angular + Nx',
      detail:
        'Frontend delivery stays inside the Nx task graph with build, lint, unit-test, and E2E targets.',
    },
    {
      title: 'Spring Boot + Gradle',
      detail:
        'Backend work uses the Gradle wrapper, clean architecture layer rules, and Spock-based tests.',
    },
    {
      title: 'Codex Skills + MCP',
      detail:
        'Repo-local skills, Nx MCP, Angular CLI MCP, and OpenAI Developer Docs are wired for agentic work.',
    },
  ];

  protected readonly commands: StarterCommand[] = [
    {
      label: 'Personalize starter',
      command:
        'pnpm run personalize -- --project-name orders-platform --display-name "Orders Platform" --java-base-package com.acme.orders',
    },
    { label: 'Bootstrap workspace', command: 'pnpm run setup:db' },
    { label: 'Project verification', command: 'pnpm run verify' },
    { label: 'Frontend dev server', command: 'pnpm nx serve client' },
    { label: 'Backend runtime', command: './gradlew :server:bootRun' },
    {
      label: 'Backend feature scaffold',
      command: 'pnpm run scaffold:backend-feature -- billing',
    },
  ];
}

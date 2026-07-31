                                        ┌───────────────────────────────────────────────┐
                                        │          ANGULAR CI/CD ARCHITECTURE           │
                                        │      GitHub Actions → Azure IIS Server        │
                                        └───────────────────────────────────────────────┘


                                            ┌──────────────────────────┐
                                            │     Developer Machine    │
                                            │--------------------------│
                                            │ • Angular 8 Source Code  │
                                            │ • Node.js 16             │
                                            │ • Git                    │
                                            │ • VS Code                │
                                            └─────────────┬────────────┘
                                                          │
                                                ng serve / Testing
                                                          │
                                               git add / commit
                                                          │
                                                          ▼
                                            git push origin main
                                                          │
                                                          ▼
┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│                                                GITHUB REPOSITORY                                                         │
│--------------------------------------------------------------------------------------------------------------------------│
│                                                                                                                          │
│  main Branch                                                                                                             │
│       │                                                                                                                  │
│       ├── package.json                                                                                                   │
│       ├── angular.json                                                                                                   │
│       ├── src                                                                                                            │
│       ├── deployment                                                                                                     │
│       ├── scripts                                                                                                        │
│       └── .github/workflows/ci-cd.yml   
|
|        .github
|            workflows
|                ci-cd.yml      <-- CI/CD orchestration
|
|        deployment
|            Deploy.ps1         <-- Deploy logic
|            Backup.ps1         <-- Backup logic
|            Rollback.ps1       <-- Rollback logic
|
|        src
|        package.json
|        angular.json                                                                                 
│                                                                                                                          │
└──────────────────────────────────────────────┬───────────────────────────────────────────────────────────────────────────┘
                                               │
                                               │ Push Event
                                               ▼
┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│                                             GITHUB ACTIONS WORKFLOW                                                      │
├──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                                                          │
│ Step 1                                                                                                                   │
│                                                                                                                          │
│ Checkout Source                                                                                                          │
│ actions/checkout@v4                                                                                                      │
│                                                                                                                          │
├──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                                                          │
│ Step 2                                                                                                                   │
│                                                                                                                          │
│ Setup Node.js 16                                                                                                         │
│ actions/setup-node@v4                                                                                                    │
│                                                                                                                          │
├──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                                                          │
│ Step 3                                                                                                                   │
│                                                                                                                          │
│ npm ci                                                                                                                   │
│                                                                                                                          │
│ Downloads dependencies                                                                                                   │
│ Creates node_modules                                                                                                     │
│                                                                                                                          │
├──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                                                          │
│ Step 4                                                                                                                   │
│                                                                                                                          │
│ ng build --prod                                                                                                          │
│                                                                                                                          │
│ Angular Production Build                                                                                                 │
│                                                                                                                          │
│ Output                                                                                                                   │
│                                                                                                                          │
│ dist/ProjectName                                                                                                         │
│                                                                                                                          │
├──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                                                          │
│ Step 5                                                                                                                   │
│                                                                                                                          │
│ Verify Build                                                                                                             │
│                                                                                                                          │
│ Check dist exists                                                                                                        │
│                                                                                                                          │
├──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                                                          │
│ Step 6                                                                                                                   │
│                                                                                                                          │
│ Backup Existing IIS Website                                                                                              │
│                                                                                                                          │
│ C:\Backups                                                                                                               │
│                                                                                                                          │
├──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                                                          │
│ Step 7                                                                                                                   │
│                                                                                                                          │
│ Execute Deploy.ps1                                                                                                       │
│                                                                                                                          │
└──────────────────────────────────────────────┬───────────────────────────────────────────────────────────────────────────┘
                                               │
                                               │
                         Job picked automatically by
                         Self Hosted GitHub Runner
                                               │
                                               ▼
┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│                                        SELF HOSTED RUNNER (Azure VM)                                                     │
├──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                                                          │
│ Runner Service                                                                                                           │
│                                                                                                                          │
│ actions.runner                                                                                                           │
│                                                                                                                          │
│ Poll GitHub every few seconds                                                                                            │
│                                                                                                                          │
│ Receives Workflow                                                                                                        │
│                                                                                                                          │
│ Executes PowerShell Scripts                                                                                              │
│                                                                                                                          │
└──────────────────────────────────────────────┬───────────────────────────────────────────────────────────────────────────┘
                                               │
                                               ▼
┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│                                                 WINDOWS IIS SERVER                                                       │
├──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                                                          │
│ Existing Website                                                                                                         │
│                                                                                                                          │
│ IIS Website                                                                                                              │
│                                                                                                                          │
│ Physical Path                                                                                                            │
│                                                                                                                          │
│ C:\inetpub\wwwroot\AngularApp                                                                                            │
│                                                                                                                          │
├──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                                                          │
│ Deployment Script                                                                                                        │
│                                                                                                                          │
│ 1. Stop Application Pool                                                                                                 │
│                                                                                                                          │
│ 2. Backup Current Files                                                                                                  │
│                                                                                                                          │
│ 3. Delete Existing Files                                                                                                 │
│                                                                                                                          │
│ 4. Copy dist Files                                                                                                       │
│                                                                                                                          │
│ 5. Copy web.config                                                                                                       │
│                                                                                                                          │
│ 6. Start Application Pool                                                                                                │
│                                                                                                                          │
│ 7. Health Check                                                                                                          │
│                                                                                                                          │
└──────────────────────────────────────────────┬───────────────────────────────────────────────────────────────────────────┘
                                               │
                                               ▼
┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│                                            APPLICATION LIVE                                                              │
├──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                                                          │
│ http://yourdomain.com                                                                                                    │
│                                                                                                                          │
│ Latest Angular Version                                                                                                   │
│                                                                                                                          │
│ End Users Access Website                                                                                                 │
│                                                                                                                          │
└──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘



══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

ERROR FLOW

Git Push
      │
      ▼
GitHub Actions

      │
      ├──────── npm install failed
      │
      ├──────── Build failed
      │
      ├──────── dist missing
      │
      ├──────── Deployment failed
      │
      ├──────── Health Check failed
      │
      ▼
GitHub Actions Failed

      │
      ▼

Rollback.ps1

      │

Restore Previous Backup

      │

Restart IIS

      │

Application Restored



══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

REQUIRED COMPONENTS

Developer PC
      │
      ├── Angular 8
      ├── Node 16
      ├── Git
      └── VS Code

↓

GitHub Repository

↓

GitHub Actions

↓

Self Hosted Runner

↓

Windows Server

↓

IIS

↓

Application Pool

↓

Physical Folder

↓

Angular Application

↓

End Users


Static code analysis
✅ Coding standards
✅ Unused variables
✅ Unused imports
✅ Dead code
✅ TypeScript errors
✅ Code complexity
✅ Code duplication
✅ Naming conventions


Developer
    │
    ▼
Git Push
    │
    ▼
GitHub Actions
    │
    ├── Static Code Analysis
    │      ✔ Is the code clean?
    │
    ├── Security Analysis
    │      ✔ Is the code secure?
    │
    ├── Build
    │
    └── Deploy to IIS


    Developer
      │
      ▼
Git Push
      │
      ▼
GitHub Actions
      │
      ▼
Checkout Code
      │
      ▼
npm ci
      │
      ▼
Static Code Analysis
(TSLint + TypeScript)
      │
      ▼
Security Analysis
(CodeQL + npm audit)
      │
      ▼
Build Angular App
      │
      ▼
Generate dist/
      │
      ▼
Deploy
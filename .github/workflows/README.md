# GitHub Actions Workflow for Quarto Course

## Setup Instructions

### 1. Enable GitHub Pages

1. Go to your repository on GitHub
2. Navigate to **Settings** → **Pages**
3. Under **Build and deployment**:
   - **Source**: Select "GitHub Actions"
   - (No need to select a branch when using GitHub Actions)

### 2. Trigger the Workflow

The workflow runs automatically on:
- Every push to the `main` branch
- Manual trigger via the Actions tab

To manually trigger:
1. Go to **Actions** tab
2. Select "Deploy Quarto Course to GitHub Pages"
3. Click "Run workflow"

### 3. Access Your Site

Once deployed, your site will be available at:
```
https://<username>.github.io/<repository-name>/
```

Check the Actions tab for deployment status and logs.

## Workflow Details

The workflow performs the following steps:

1. **Environment Setup**
   - Node.js 20 (for Argdown)
   - Quarto 1.5.57
   - System packages: Inkscape, LaTeX (TeX Live)

2. **Dependencies Installation**
   - Global npm packages: `@argdown/cli`, `@argdown/pandoc-filter`, `@argdown/image-export`, `decktape`
   - Local npm packages from `package.json`
   - Quarto extension: `quarto-ext/fontawesome`

3. **Build**
   - Renders the full Quarto website (`quarto render`)
   - Renders slides separately (`quarto render content/slides/`)
   - Exports slides to PDF using Decktape
   - Output directory: `docs/`

4. **Deploy**
   - Uploads `docs/` directory as GitHub Pages artifact
   - Deploys to GitHub Pages environment

> **Note:** This workflow only handles the **rendering** stage. The **generation** stage (running `quarto-coursegen` to create stubs from `course.yaml`) should be done locally before committing. The workflow assumes all `.qmd` files already exist in your repository.

## Customization

### Change Branch

To deploy from a different branch, edit `.github/workflows/deploy-pages.yml`:

```yaml
on:
  push:
    branches: ["your-branch-name"]
```

### Add PDF Export

To also export slides to PDF (requires more resources), uncomment:

```yaml
- name: Export slides to PDF
  run: make slides-pdf
```

### Reduce Build Time

If you don't need certain outputs, you can modify the render step:

```yaml
- name: Render specific content only
  run: |
    quarto render content/slides/  # slides only
    # quarto render content/handouts/  # add handouts
```

## Troubleshooting

### Build Fails

1. Check the Actions tab for error logs
2. Common issues:
   - Missing `course.yaml` → Ensure it's committed
   - Missing content stubs → Run `make generate` locally first
   - Argdown errors → Check `argdown.config.json` syntax

### Page Not Found (404)

1. Verify GitHub Pages is enabled in Settings → Pages
2. Check the deployment URL matches your repository name
3. Ensure `docs/` directory contains `index.html`

### Outdated Content

1. Clear browser cache
2. Wait a few minutes for CDN propagation
3. Check Actions tab to confirm latest workflow succeeded

# AGENTS.md

This repository is for a personal website that showcases Grecia Mayya's profile and projects across nature, GIS, energy, maps, fieldwork, and related writing or visuals. The site should be simple for a non-web-developer to edit, visually polished, and easy to deploy.

## Project Defaults

- The current v1 is a dependency-free static HTML/CSS site so it can be previewed locally without Node/npm.
- Build the future framework version as a static Astro website unless the user explicitly chooses another stack.
- Target Netlify for deployment.
- Keep the implementation beginner-friendly: clear folders, reusable components, plain content files, and minimal custom JavaScript.
- Favor small, reviewable edits over broad rewrites.
- Explain setup and maintenance steps in plain language.
- Do not invent personal biography details, project facts, map data, or credentials. Ask for exact content or use clearly marked placeholders.

## Website Direction

The site should feel like a nature-forward GIS portfolio, not a generic corporate landing page.

- The first screen should immediately signal nature, mapping, fieldwork, or spatial analysis.
- Use real project imagery, landscape photography, map screenshots, exported web maps, or generated bitmap visuals when appropriate.
- Avoid stock-like filler, dark blurred hero images, generic gradient backgrounds, oversized marketing sections, and decorative-only visuals.
- Keep navigation simple: Home, Nature & Travel, Energy & Grid, Resume.
- Keep page structure obvious and editable.
- Make project pages polished enough to show context, role, tools, outputs, and visual artifacts.
- Use a calm, varied palette inspired by landscapes and cartography. Avoid a one-note palette dominated by only greens, blues, beige, or slate.
- Prioritize accessibility: readable contrast, meaningful alt text, semantic headings, keyboard navigation, and responsive layouts.

## Preferred Project Structure

Use this structure unless the existing project evolves differently:

```text
src/
  pages/
    index.astro
    projects/
    maps.astro
    about.astro
    contact.astro
  components/
  content/
  data/
public/
  images/
  maps/
```

- `src/pages/`: route-level pages.
- `src/components/`: reusable sections, cards, layouts, navigation, map embeds, and project display components.
- `src/content/`: Markdown or MDX content collections when useful.
- `src/data/`: simple JSON, YAML, or TypeScript data files for project lists, navigation, profile facts, and map metadata.
- `public/images/`: images that can be referenced directly by the site.
- `public/maps/`: exported web map folders, static map images, GeoJSON previews, or other browser-ready GIS assets.

## GIS Integration Rules

GIS integration should start simple and reliable.

- Prefer exported web maps and embeds first:
  - ArcGIS Online iframe embeds.
  - QGIS2Web exports.
  - Leaflet export folders.
  - Static map images or screenshots.
  - GeoJSON previews when the data is already cleaned for public use.
- Use custom Leaflet code only when exported embeds are not enough.
- Keep heavy GIS processing outside this website repository.
- Do not scan unrelated personal folders or drives looking for GIS projects.
- If GIS materials are outside this repo, ask for exact paths before inspecting them.
- If the user provides a GIS project folder, first identify safe, browser-ready outputs such as `index.html`, `qgis2web` exports, `data/`, `layers/`, `*.geojson`, `*.png`, or `*.jpg`.
- Do not move, overwrite, simplify, or transform original GIS source files unless the user explicitly asks.
- If copying a map export into `public/maps/`, preserve the export folder structure so relative assets keep working.
- Do not publish private coordinates, sensitive field sites, personal addresses, API keys, tokens, or restricted datasets.

## Known GIS Source Placeholders

The user may later provide paths to local GIS projects. Until then, use placeholders and ask for exact locations.

```text
GIS source folder 1: [ask user for path]
GIS source folder 2: [ask user for path]
Preferred public map export folder: public/maps/
Preferred static map image folder: public/images/maps/
```

When asking for GIS paths, be specific. Good examples:

- "Please provide the folder that contains the exported web map, ideally the folder with `index.html`."
- "Please provide the ArcGIS Online share URL or iframe embed code."
- "Please provide the static map image or screenshot you want shown on this project page."

## Sub-Agent Workflow

Use sub-agents when the user asks for delegation, parallel agent work, research, or multiple edits that can be split cleanly. Keep sub-agent tasks concrete, bounded, and non-overlapping.

### Planner Agent

Purpose: turn a user request into a small implementation brief.

Responsibilities:

- Identify the intended page, section, project, or GIS asset.
- Decide whether design research, GIS inspection, content drafting, implementation, or verification is needed.
- Split work into independent tasks with clear ownership.
- Preserve simplicity and beginner editability.

Prompt template:

```text
Create a concise implementation brief for this website request:
[paste user request]

Assume this is an Astro static personal portfolio with nature/GIS styling and Netlify deployment. Identify the files or areas likely involved, the user-facing outcome, any missing content, and which sub-agent roles should be used. Keep the plan small and beginner-friendly.
```

### Design Research Agent

Purpose: gather visual and component direction.

Responsibilities:

- Research nature portfolio, GIS portfolio, cartography, and fieldwork presentation patterns.
- Recommend accessible palettes, typography direction, imagery treatment, and section layout ideas.
- Suggest components that fit the site, such as project cards, map showcases, field notes, image galleries, and timeline sections.
- Report concise recommendations with links when web research is used.

Prompt template:

```text
Research visual direction for [page/section].

The site is a personal nature/GIS/energy portfolio built with Astro. Recommend a visually stunning but simple direction, including layout, imagery treatment, color palette notes, typography tone, and 3-5 component ideas. Keep recommendations practical for a static website.
```

### GIS Integration Agent

Purpose: inspect provided GIS exports or map assets and recommend the simplest embed path.

Responsibilities:

- Inspect only explicitly provided folders, files, or URLs.
- Identify browser-ready map assets.
- Recommend whether to use iframe, copied export folder, static image, GeoJSON preview, or Leaflet.
- Note privacy or publishing risks.
- Provide exact integration instructions for the Implementation Agent.

Prompt template:

```text
Inspect this GIS material and recommend the simplest website integration:
[path or URL]

Use exported embeds first. Do not alter original GIS files. Identify browser-ready outputs, privacy risks, files that should be copied into public/maps/ or public/images/, and the Astro component/page behavior needed to display it.
```

### Content Agent

Purpose: organize profile and project material into clear website content.

Responsibilities:

- Draft concise project summaries from user-provided notes.
- Structure each project around problem, role, tools, process, result, and visual/map assets.
- Keep claims accurate and avoid inventing credentials, metrics, or outcomes.
- Suggest missing content the user should provide.

Prompt template:

```text
Turn this material into website-ready content:
[paste notes]

Create concise copy for a personal nature/GIS/energy portfolio. Include a title, short summary, role, tools, project type, suggested images/maps, and 3-5 bullets describing the work. Do not invent facts.
```

### Implementation Agent

Purpose: make focused website changes.

Responsibilities:

- Implement the agreed page, section, component, or data update.
- Follow existing Astro patterns once the project exists.
- Keep components simple and reusable.
- Keep styling polished, responsive, and accessible.
- Use `public/images/` and `public/maps/` for static assets.
- Avoid large framework additions unless clearly justified.

Prompt template:

```text
Implement this website change:
[implementation brief]

This is an Astro static personal portfolio with nature/GIS styling. Keep the edit small, accessible, responsive, and beginner-friendly. Use existing conventions. Do not overwrite user content. Report changed files and how the user can edit the content later.
```

### Verification Agent

Purpose: check that the site works and remains easy to maintain.

Responsibilities:

- Run available install/build/check commands.
- Preview responsive layouts when possible.
- Verify images and map embeds load.
- Check obvious accessibility issues.
- Report broken links, missing assets, layout overlap, confusing content, or maintenance risks.

Prompt template:

```text
Verify this website change:
[summary of change]

Check build output, responsive layout, images, map embeds, accessibility basics, and beginner maintainability. Report pass/fail results, exact issues, and suggested fixes. Do not make unrelated changes.
```

## Common User Request Workflow

When the user requests a website change:

1. Restate the goal briefly.
2. Inspect relevant files before editing.
3. If the request involves GIS assets outside this repo, ask for exact paths or URLs.
4. If helpful, delegate independent research, GIS inspection, content drafting, or verification to sub-agents.
5. Implement the smallest complete version.
6. Run relevant checks.
7. Summarize what changed and how to edit it later.

## Beginner-Friendly Astro Setup

If the repository has not been initialized yet, the recommended setup is:

```text
npm create astro@latest .
npm install
npm run dev
```

Recommended Astro choices:

- Template: minimal or empty.
- TypeScript: yes, if prompted.
- Install dependencies: yes.
- Git: optional, depending on whether Git is available.

For Netlify:

- Build command: `npm run build`
- Publish directory: `dist`
- Use static output unless the project later needs server features.

## Verification Checklist

Before reporting work as complete, check the relevant items:

- Astro dev server starts successfully.
- Static build completes with `npm run build`.
- Netlify output is compatible with `dist`.
- Home page works on desktop and mobile.
- Navigation links work.
- Images load from `public/images/`.
- Map exports or embeds load from `public/maps/` or approved external URLs.
- Text does not overlap or overflow on mobile.
- Color contrast is readable.
- Headings follow a sensible order.
- Images and map previews have useful alt text or labels.
- No private GIS data, keys, or sensitive locations were exposed.

## Design Guardrails

- Build the actual portfolio experience first, not a marketing splash page.
- Do not hide the main content behind excessive animation.
- Do not use decorative cards inside other cards.
- Do not rely on gradient blobs or generic abstract backgrounds.
- Do not use huge hero text inside compact panels.
- Do not scale font sizes directly with viewport width.
- Use stable dimensions for map previews, image cards, and project grids so layout does not jump.
- Use real or generated bitmap imagery for major visuals rather than decorative SVG illustrations.
- Keep buttons and controls recognizable, with icons when appropriate.

## Content Model Preference

When adding projects, prefer a simple content shape:

```text
title:
summary:
category: Nature | GIS | Energy | Research | Fieldwork
role:
tools:
year:
location:
featuredImage:
mapEmbed:
mapAssetPath:
body:
```

Only add fields when the page actually needs them.

## Final Response Expectations

When an agent completes work, it should tell the user:

- What changed.
- Which files were touched.
- Which checks were run.
- Anything the user needs to provide next, especially project copy, images, GIS export folders, or map embed URLs.
- How the user can make the next simple edit.

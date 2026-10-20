# Project guidance

## Project structure

- `cv.typ` contains the layout, CV facts, and paired translations, built with Typst
  and `neat-cv`. The `lang=de` input selects German, and `picture=false` selects
  picture-free variants; English and a picture are defaults.
- `img/` contains the profile image and other assets.
- All four CV PDFs are generated output and ignored by Git; do not commit them.
- `.github/workflows/build-cv.yml` builds all four PDFs, deploys previews from `main` and same-repository PRs targeting `main`, and deploys production on published releases.

## Setup and local use

Pinned build dependency versions are maintained in `.github/dependencies.json`.
The scheduled update workflow keeps the versions below and in `README.md` in sync.
It also checks the Typst package index and updates `@preview` package imports in
`cv.typ`, including `datify` and `neat-cv`.

Install Typst (0.15.1 matches CI), Iosevka Nerd Fonts 3.5.1, and
Font Awesome Free 7.3.1 desktop fonts. The required font families are
`Iosevka NF`, `Iosevka NFP Medium Obl`, `Font Awesome 7 Free`, and
`Font Awesome 7 Brands`. Check available fonts with `typst fonts`.
The first build needs network access to download the packages imported by `cv.typ`.

Run commands from the repository root:

```sh
typst compile cv.typ cv.pdf    # Build English CV
typst compile --input lang=de cv.typ cv-de.pdf # Build German CV
typst compile --input picture=false cv.typ cv-no-picture.pdf # English without picture
typst compile --input lang=de --input picture=false cv.typ cv-de-no-picture.pdf # German without picture
typst watch cv.typ cv.pdf      # Rebuild automatically while editing
open cv.pdf                   # Open the built PDF on macOS
```

See `README.md` for dependency links and deployment configuration.

## Content and validation

- The generated PDF must be exactly one A4 page. Never accept or publish a
  multipage CV. Shorten content or adjust spacing while preserving readability
  when changes cause overflow.
- Preserve the two-column layout and verify that text, icons, and the profile
  image render correctly without clipping or overlap.
- After changes to content, layout, fonts, or build configuration, compile all
  four entry points, check the page counts, and visually inspect all four PDFs.
  On macOS, run `sh scripts/check-pdfs.sh`; with Poppler, `pdfinfo` must report
  `Pages: 1` for each PDF. Otherwise check the counts in a PDF viewer.
- Keep CV claims and dates accurate; do not invent qualifications or experience.

## Commits

Use semantic commits following Conventional Commits:
`<type>(<optional scope>): <short imperative description>`.
Choose an appropriate type such as `feat`, `fix`, `docs`, `style`, `refactor`,
`build`, `ci`, or `chore`. Keep each commit focused on one logical change.

Examples:

```text
docs: add project guidance for agents
fix(cv): keep experience section on one page
ci: update the Typst build workflow
```

## Releases

Published GitHub releases deploy their tagged commit to the production site at
`https://cv.jak0b.com`. Use version tags such as `v1.0.0`; check existing releases
with `gh release list` before choosing the next version.

Before publishing, ensure the intended commit is pushed to `main`, the working
tree is clean, and its **Build CV** workflow run has passed. Then create a
published release from that exact commit:

```sh
gh release create vX.Y.Z --target "$(git rev-parse HEAD)" \
  --title "CV vX.Y.Z" --generate-notes --fail-on-no-commits
```

Replace `vX.Y.Z` with the chosen version. `gh release create` creates the tag
and publishes the release; the `release: published` workflow then builds and
checks all four PDFs and deploys them to Cloudflare Pages. Watch the release run
with `gh run list --workflow build-cv.yml --event release --limit 1`, followed by
`gh run watch <run-id> --exit-status`. After it passes, check the four production
PDF links and confirm `/repo` redirects to the released commit. See
`cloudflare/README.md` for deployment details.

# Project guidance

## Project structure

- `cv.typ` is the single entry point. The `lang=de` Typst input selects German,
  and `picture=false` selects picture-free variants; English and a picture are defaults.
- `cv-template.typ` shares the layout, CV facts, and paired translations, built
  with Typst and `neat-cv`.
- `img/` contains the profile image and other assets.
- All four CV PDFs are generated output and ignored by Git; do not commit them.
- `.github/workflows/build-cv.yml` builds all four PDFs and deploys them to Cloudflare Pages on `main`.

## Setup and local use

Pinned build dependency versions are maintained in `.github/dependencies.json`.
The scheduled update workflow keeps the versions below and in `README.md` in sync.
It also checks the Typst package index and updates `@preview` package imports in
the root `.typ` files, including `datify` and `neat-cv` in `cv-template.typ`.

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

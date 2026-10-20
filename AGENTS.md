# Project guidance

## Project structure

- `cv.typ` is the source for the CV, built with Typst and `neat-cv`.
- `img/` contains the profile image and other assets.
- `cv.pdf` is generated output and is ignored by Git; do not commit it.
- `.github/workflows/build-cv.yml` builds the PDF and deploys it to Cloudflare Pages on `main`.

## Setup and local use

Install Typst (0.14.2 matches CI), Iosevka Nerd Fonts 3.4.0, and
Font Awesome Free 7.0.1 desktop fonts. The required font families are
`Iosevka NF`, `Iosevka NFP Medium Obl`, `Font Awesome 7 Free`, and
`Font Awesome 7 Brands`. Check available fonts with `typst fonts`.
The first build needs network access to download the packages imported by `cv.typ`.

Run commands from the repository root:

```sh
typst compile cv.typ cv.pdf    # Build cv.pdf
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
- After changes to content, layout, fonts, or build configuration, run
  `typst compile cv.typ cv.pdf`,
  check the page count, and visually inspect `cv.pdf`. If Poppler is installed,
  `pdfinfo cv.pdf` must report `Pages: 1`; otherwise check the count in a PDF viewer.
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

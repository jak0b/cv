jak0b's CV
=========================
A **one-page**, **two asymmetric column** CV written in Typst using
[neat-cv](https://typst.app/universe/package/neat-cv).

- [English CV (PDF)](https://cv.jak0b.com/cv.pdf)
- [German CV (PDF)](https://cv.jak0b.com/cv-de.pdf)
- [English CV without a picture (PDF)](https://cv.jak0b.com/no-picture)
- [German CV without a picture (PDF)](https://cv.jak0b.com/ohne-bild)

## Dependencies

Install [Typst 0.15.1](https://github.com/typst/typst/releases) to
build the CV. The first build downloads the packages imported by `cv.typ`.

Install [Iosevka Nerd Fonts](https://github.com/ryanoasis/nerd-fonts/releases/tag/v3.5.1)
(`Iosevka.tar.xz`), which provides the `Iosevka NF` and
`Iosevka NFP Medium Obl` families used by the CV.
The template's contact and social icons also require the desktop fonts from
[Font Awesome Free 7](https://github.com/FortAwesome/Font-Awesome/releases/tag/7.3.1).

### macOS

Install [Homebrew](https://brew.sh/) if needed, then install
[Typst](https://formulae.brew.sh/formula/typst), the download helpers, and Poppler
(which provides `pdfinfo` for checking the generated PDFs):

```sh
brew install typst jq curl unzip poppler
```

From the repository root, choose a font directory for your user, then follow
**Install the fonts** below:

```sh
cv_font_dir="$HOME/Library/Fonts/cv"
```

### Arch Linux

Install [Typst](https://archlinux.org/packages/extra/x86_64/typst/), the download
helpers, Fontconfig, and Poppler:

```sh
sudo pacman -Syu --needed typst jq curl unzip fontconfig poppler
```

From the repository root, choose a font directory for your user, then follow
**Install the fonts** below:

```sh
cv_font_dir="${XDG_DATA_HOME:-$HOME/.local/share}/fonts/cv"
```

### Install the fonts

Run this in the same terminal after choosing the directory above. It installs
the font versions pinned in `.github/dependencies.json` for your user:

```sh
cv_nerd_version=$(jq -r '."nerd-fonts"' .github/dependencies.json)
cv_awesome_version=$(jq -r '."font-awesome"' .github/dependencies.json)
cv_download_dir=$(mktemp -d)
mkdir -p "$cv_font_dir"

curl --fail --location --retry 3 \
  --output "$cv_download_dir/Iosevka.tar.xz" \
  "https://github.com/ryanoasis/nerd-fonts/releases/download/v${cv_nerd_version}/Iosevka.tar.xz"
tar -xJf "$cv_download_dir/Iosevka.tar.xz" -C "$cv_font_dir"

curl --fail --location --retry 3 \
  --output "$cv_download_dir/fontawesome.zip" \
  "https://github.com/FortAwesome/Font-Awesome/releases/download/${cv_awesome_version}/fontawesome-free-${cv_awesome_version}-desktop.zip"
unzip -qo "$cv_download_dir/fontawesome.zip" '*.otf' -d "$cv_font_dir"
```

On Arch Linux, refresh the font cache with `fc-cache -f "$cv_font_dir"`.
On either platform, run `typst fonts` and confirm it lists all four families:

- `Iosevka NF`
- `Iosevka NFP Medium Obl`
- `Font Awesome 7 Free`
- `Font Awesome 7 Brands`

Homebrew and Arch may install a newer Typst release. The pinned version is in
`.github/dependencies.json` if you need to match the project build exactly.

## Build

Both languages use `cv-template.typ`, which contains the shared layout, contact
details, dates, skill groups, and paired English/German translations. Edit this
file to update the CV. The entry points select the document language, and the
optional `picture` input controls whether the profile photo appears:

- `cv.typ`: English → `cv.pdf` or `cv-no-picture.pdf`
- `cv-de.typ`: German → `cv-de.pdf` or `cv-de-no-picture.pdf`

Build all four versions:

```sh
typst compile cv.typ cv.pdf
typst compile cv-de.typ cv-de.pdf
typst compile --input picture=false cv.typ cv-no-picture.pdf
typst compile --input picture=false cv-de.typ cv-de-no-picture.pdf
```

On macOS, check that all outputs have one A4 page with PDFKit. The script keeps
Swift's module cache in `/tmp/cv-swift-cache`:

```sh
sh scripts/check-pdfs.sh
```

On other systems, check with Poppler:

```sh
pdfinfo cv.pdf
pdfinfo cv-de.pdf
pdfinfo cv-no-picture.pdf
pdfinfo cv-de-no-picture.pdf
```

Use `typst watch cv.typ cv.pdf` or `typst watch cv-de.typ cv-de.pdf` to
rebuild automatically while editing. All four PDFs must remain exactly one A4 page;
check the page count and visually inspect each after changing shared content.
The shared template rejects builds that overflow onto a second page. Generated
PDFs are ignored by Git.

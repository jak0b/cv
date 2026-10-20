jak0b's CV
=========================
A **one-page**, **two asymmetric column** CV written in Typst using
[neat-cv](https://typst.app/universe/package/neat-cv).

## Dependencies

Install [Typst](https://typst.app/) to build the CV. The first build downloads
the packages imported by `cv.typ`.

Install [Iosevka Nerd Fonts](https://github.com/ryanoasis/nerd-fonts/releases/tag/v3.4.0)
(`Iosevka.tar.xz`), which provides the `Iosevka NF` and
`Iosevka NFP Medium Obl` families used by the CV.
The template's contact and social icons also require the desktop fonts from
[Font Awesome Free 7](https://github.com/FortAwesome/Font-Awesome/releases/tag/7.0.1).

## Build

Edit `cv.typ`, then generate `cv.pdf`:

```sh
make
```

Or run `typst compile cv.typ cv.pdf` directly.

## GitHub Actions

The [Build CV workflow](.github/workflows/build-cv.yml) runs on pushes, pull
requests, and manual dispatches. It installs Typst 0.14.2, Iosevka Nerd Fonts
3.4.0, and Font Awesome Free 7.0.1, runs `make`, and uploads `cv.pdf` as the `cv` artifact. Download it from
the workflow run's **Artifacts** section.


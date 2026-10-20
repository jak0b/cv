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

Both languages use `cv-template.typ`, which contains the shared layout, contact
details, dates, skill ratings, and paired English/German translations. Edit this
file to update the CV. The entry points select the document language:

- `cv.typ`: English → `cv.pdf`
- `cv-de.typ`: German → `cv-de.pdf`

Build both versions:

```sh
typst compile cv.typ cv.pdf
typst compile cv-de.typ cv-de.pdf
```

Use `typst watch cv.typ cv.pdf` or `typst watch cv-de.typ cv-de.pdf` to
rebuild automatically while editing. Both PDFs must remain exactly one A4 page;
check the page count and visually inspect both after changing shared content.
The shared template rejects builds that overflow onto a second page. Generated
PDFs are ignored by Git.

## GitHub Actions

The [Build CV workflow](.github/workflows/build-cv.yml) runs on pushes, pull
requests, and manual dispatches. It installs Typst 0.14.2, Iosevka Nerd Fonts
3.4.0, and Font Awesome Free 7.0.1, builds both language versions, and uploads
`cv.pdf` and `cv-de.pdf` together as the `cv` artifact. Download it from the workflow run's **Artifacts** section.

## Cloudflare Pages deployment

The workflow can deploy the same PDF artifacts to the existing Cloudflare Pages
project serving `cv.jak0b.com`. Successful pushes to `main` and manual runs on
`main` deploy automatically once the settings below are configured. Pull requests
only build the PDF.

In the [cloudflare-deploy environment](https://github.com/jak0b/cv/settings/environments),
add these environment secrets:

- `CLOUDFLARE_API_TOKEN`: a Cloudflare API token with **Account > Cloudflare Pages
  > Edit**, scoped to the account hosting the project.
- `CLOUDFLARE_ACCOUNT_ID`: the account ID from the Cloudflare dashboard.

Add these environment variables in the same `cloudflare-deploy` environment:

- `CLOUDFLARE_PAGES_PROJECT`: the existing Pages project name, rather than the
  custom domain.
- `CLOUDFLARE_PAGES_BRANCH` (optional): the project's production branch in
  Cloudflare, if it is not `main`. This must match to update the production site.

Deployments upload `cv.pdf`, `cv-de.pdf`, and a redirect from `/` to `/cv.pdf`,
replacing the project's current site files. The existing custom-domain binding stays on the
Cloudflare project. If the project has Git integration, disable its automatic
production builds when enabling this workflow to avoid competing deployments.

See [Cloudflare's CI deployment guide](https://developers.cloudflare.com/pages/how-to/use-direct-upload-with-continuous-integration/)
for API token setup. After configuring the settings, run **Build CV** manually on
`main` to publish the current CV.


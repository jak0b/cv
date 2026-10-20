# Cloudflare Pages deployment

The [Build CV workflow](../.github/workflows/build-cv.yml) deploys the English
and German PDFs to the existing Cloudflare Pages project serving `cv.jak0b.com`.
Pushes to `main` and manual runs on `main` deploy after the build succeeds. Pull
requests only build the PDFs.

In the [cloudflare-deploy environment](https://github.com/jak0b/cv/settings/environments),
add these secrets:

- `CLOUDFLARE_API_TOKEN`: a Cloudflare API token with **Account > Cloudflare Pages
  > Edit**, scoped to the account hosting the project.
- `CLOUDFLARE_ACCOUNT_ID`: the account ID from the Cloudflare dashboard.

Add these variables in the same environment:

- `CLOUDFLARE_PAGES_PROJECT`: the existing Pages project name, rather than the
  custom domain.
- `CLOUDFLARE_PAGES_BRANCH` (optional): the project's production branch in
  Cloudflare, if it is not `main`. This must match to update the production site.

Deployments upload `cv.pdf`, `cv-de.pdf`, and [redirects](./_redirects) from
`/` and `/en` to `/cv.pdf`, and from `/de` to `/cv-de.pdf`, replacing the
project's current site files. The existing custom-domain binding stays on the
Cloudflare project. If the project has Git integration, disable its automatic
production builds to avoid competing deployments.

See [Cloudflare's CI deployment guide](https://developers.cloudflare.com/pages/how-to/use-direct-upload-with-continuous-integration/)
for API token setup. After configuring the settings, run **Build CV** manually
on `main` to publish the current CV.

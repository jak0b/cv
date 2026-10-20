# Cloudflare Pages deployment

The [Build CV workflow](../.github/workflows/build-cv.yml) deploys the English
and German PDFs, each with and without a picture, to the existing Cloudflare Pages
project serving `cv.jak0b.com`.
Pushes to `main` and manual runs on `main` create preview deployments after the
build succeeds. The preview branch uses Git's short commit SHA, so each commit
gets a `<short-sha>.<project>.pages.dev` alias. Publishing a GitHub release deploys
the tagged commit to production. After each deployment, the workflow prints its
URL and an English CV link in the job log and summary. Pull requests only build
the PDFs.

In the [cloudflare-deploy environment](https://github.com/jak0b/cv/settings/environments),
add these secrets:

- `CLOUDFLARE_API_TOKEN`: a Cloudflare API token with **Account > Cloudflare Pages
  > Edit**, scoped to the account hosting the project.
- `CLOUDFLARE_ACCOUNT_ID`: the account ID from the Cloudflare dashboard.

Add these variables in the same environment:

- `CLOUDFLARE_PAGES_PROJECT`: the existing Pages project name, rather than the
  custom domain.
- `CLOUDFLARE_PAGES_BRANCH` (optional): the project's production branch in
  Cloudflare, if it is not `main`. Release deployments use this branch.

Both deployment types upload all four PDFs and [redirects](./_redirects) from
`/` and `/en` to `/cv.pdf`, `/de` to `/cv-de.pdf`, `/no-picture` to
`/cv-no-picture.pdf`, `/ohne-bild` to `/cv-de-no-picture.pdf`, and `/repo` to the
[source repository](https://github.com/jak0b/cv). Preview deployments leave
the production site untouched; release deployments update it. The existing
custom-domain binding stays on the Cloudflare project. If the project has Git
integration, disable its automatic builds to avoid competing deployments.

See [Cloudflare's CI deployment guide](https://developers.cloudflare.com/pages/how-to/use-direct-upload-with-continuous-integration/)
for API token setup. After configuring the settings, run **Build CV** manually
on `main` to preview the current CV, then publish a GitHub release to update
production.

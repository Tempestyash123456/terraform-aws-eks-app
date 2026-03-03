# Publishing to HCP Terraform Registry

This guide explains how to publish this module to the **HCP Terraform private module registry** (formerly Terraform Cloud).

---

## Step 1 — Name your GitHub repository correctly

The repository **must** follow the naming convention:

```
terraform-<PROVIDER>-<MODULE_NAME>
```

For this module, name the repo:

```
terraform-aws-eks-app
```

> This naming convention is enforced by the registry. It will not accept repos that don't follow it.

---

## Step 2 — Push the code to GitHub

```bash
git init
git add .
git commit -m "feat: initial module release"
git remote add origin git@github.com:YOUR_ORG/terraform-aws-eks-app.git
git push -u origin main
```

---

## Step 3 — Tag a release

The registry uses **semantic version tags** to track module versions. You must tag at least one release before publishing.

```bash
git tag v1.0.0
git push origin v1.0.0
```

Follow [Semantic Versioning](https://semver.org/): `vMAJOR.MINOR.PATCH`

---

## Step 4 — Connect GitHub to HCP Terraform

1. Log in to [app.terraform.io](https://app.terraform.io)
2. Go to **Settings → VCS Providers**
3. Click **Add a VCS Provider** and follow the OAuth flow to connect your GitHub account/org

---

## Step 5 — Publish the module

1. In HCP Terraform, navigate to your organization
2. Go to **Registry → Modules**
3. Click **Publish Module**
4. Select your connected GitHub VCS provider
5. Select the `terraform-aws-eks-app` repository
6. Click **Publish module**

HCP Terraform will automatically detect your version tags and make them available in the registry.

---

## Step 6 — Use the published module

Once published, use the module like this:

```hcl
module "eks_app" {
  source  = "app.terraform.io/YOUR_ORG/eks-app/aws"
  version = "~> 1.0"

  cluster_name       = "my-cluster"
  aws_region         = "us-east-1"
  app_image          = "nginx:latest"
  app_container_port = 80
}
```

---

## Releasing new versions

Every new version requires a new Git tag:

```bash
# Patch fix
git tag v1.0.1 && git push origin v1.0.1

# New feature (backwards-compatible)
git tag v1.1.0 && git push origin v1.1.0

# Breaking change
git tag v2.0.0 && git push origin v2.0.0
```

HCP Terraform picks up new tags automatically — no manual re-publishing needed.

---

## Registry requirements checklist

| Requirement | Status |
|-------------|--------|
| Repo named `terraform-<PROVIDER>-<NAME>` | `terraform-aws-eks-app` ✅ |
| Root `README.md` present | ✅ |
| Root `main.tf`, `variables.tf`, `outputs.tf` present | ✅ |
| Submodules under `modules/` | ✅ |
| Working example under `examples/` | ✅ |
| At least one semantic version tag (`v1.0.0`) | Push tag to enable ✅ |
| GitHub repo connected to HCP Terraform via VCS | Configure in Settings ✅ |

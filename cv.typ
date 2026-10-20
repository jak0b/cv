#import "@preview/datify:1.3.0": custom-date-format
#import "@preview/neat-cv:1.2.0": cv, cv-with-side, entry, item-with-level, contact-info, social-links
#import "@preview/linguify:0.5.0"

#let gdpd_text = "I authorise the processing of personal data contained within my CV, according to GDPR (EU) 2016/679, Article 6.1(a)."
#let today = datetime.today()
#let experience-start = datetime(year: 2017, month: 9, day: 1)
#let expertise-years = (today - experience-start).days() / 365.2425 - 1
#let expertise-hundredths = int(calc.round(expertise-years * 100))
#let expertise-fraction = calc.rem(expertise-hundredths, 100)
#let expertise-display = str(int(calc.floor(expertise-hundredths / 100))) + "." + (
  if expertise-fraction < 10 { "0" } else { "" }
) + str(expertise-fraction)

#show: cv.with(
  profile-picture: image("img/profile.jpg"),
  paper-size: "a4",
  accent-color: rgb("#407287"),
  header-color: rgb("#8D949D"),
  date: custom-date-format(today),
  body-font: "Iosevka NF",
  heading-font: "Iosevka NFP Medium Obl",
  author: (
    firstname: "Jakub",
    lastname: "Stepien",
    email: "work@jak0b.com",
    position: ("DevOps Engineer"),
    linkedin: "jak0b",
    github: "jak0b",
    phone: "+48 573 305 599"
  ),
)

#cv-with-side[
  = About Me
  Experienced DevOps Engineer with #strong(expertise-display) years of expertise in system maintenance, Linux administration,
  and software development. Well‑versed in networking, Docker, Kubernetes, Helm, and multiple cloud platforms (AWS, GCP),
  with a focus on migrating on‑premises resources to the cloud.

  = Skills
  #item-with-level("AWS: EC2, EKS, VPC, IAM, KMS", 4)
  #item-with-level("Terraform & Infrastructure as Code", 3)
  #item-with-level("Kubernetes, Helm & Docker", 4)
  #item-with-level("Linux administration", 5)
  #item-with-level("Argo CD, Jenkins & GitLab CI", 4)
  #item-with-level("CloudWatch, Prometheus & Grafana", 3)
  #item-with-level("Python, Go & Bash", 4)
  #item-with-level("Networking & Cloud Security", 4)
  #item-with-level("Splunk & Loki", 3)

  = Languages
  #item-with-level("Polish", 5,  subtitle: "mother tongue")
  #item-with-level("German", 4, subtitle: [proficiency – C2,#linebreak()Goethe Institute GDS])
  #item-with-level("English", 4, subtitle: "working proficiency, many years of experience")

#set text( size: 3.5pt)
#set align(bottom)
#gdpd_text
][

= Contact
#set rect(
  inset: 8pt,
  fill: rgb("ffffff"),
  width: 100%,
)

#grid(
  columns: (1fr, 1fr),
  rect[#contact-info()],
  rect[#social-links()],
)

= Experience

#entry(
  title: "DevOps Engineer",
  institution: "Grid Dynamics (contractor for a US based company)",
  location: "remote",
  date: "Aug 2023 - Oct 2026",
  [
  - Supported the deployment of a low-latency manufacturing system written in Go
  - Participated in an on-call rotation, troubleshooting incidents and following operational runbooks
  - Provisioned cloud resources in multiple environments using Terraform:
    #list(tight: true,
      [AWS EC2 & EKS with auto-scaling and diverse networking configurations],
      [AWS MSK (Kafka) cluster with Snowflake connector],
      [AWS MemoryDB],
    )
  - Imported existing cloud resources into Terraform to establish a single source of truth
  - Optimized EKS costs with Karpenter and spot instances
  - Migrated AWS CloudFormation stacks to Pulumi and automated deployments through CI pipelines
  - Migrated deployments from internal Jenkins pipelines to a GitOps approach with Argo CD
  - Automated certificate issuance and management using an internal private PKI
  - Configured Prometheus alerting rules for Kubernetes clusters
  - Troubleshot AWS connectivity, reverse proxy, and load balancer issues with development teams
  - Implemented OIDC authentication and authorization across multiple microservices
  - Managed Rails applications with Ansible and automated build, test, and deployment workflows with Jenkins
  ],
)

#entry(
  title: "DevOps & System Engineer",
  institution: "Docmatic.ai (formerly Random Forest)",
  location: "Krakow, Poland",
  date: "Sep 2018 - Jul 2022",
  [
    - Managed networking infrastructure: servers (HP iLO, Intel BMC), switches, routers (MikroTik) for security and reliability
    - Maintained Proxmox hosts for virtualization of Kubernetes clusters
    - Managed user and developer access via LDAP, VPNs (WireGuard, OpenVPN)
    - Configured site-to-site VPNs for multi-cloud encrypted communication
    - Developed and deployed Python microservices (Flask, Django) with containerization
    - Built and maintained CI/CD pipelines using GitLab
    - Monitored resource usage of non-containerized apps and migrated resources to the cloud
    - Maintained multi-user Jupyter kernels (TensorFlow, PyTorch, Anaconda)
    - Mentored new developers and contributed to Django backend development
  ],
)

= Education

#entry(
  title: "Bachelor's degree in Applied Informatics - Software Engineering",
  institution: "Cracow University of Economics",
  date: "Sep 2017 - Sep 2021",
  [Thesis: "Rust a possible successor to C - overview of the language and sample programs"],
)
]

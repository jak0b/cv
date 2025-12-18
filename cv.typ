#import "@preview/datify:1.0.0": custom-date-format
#import "@preview/neat-cv:0.6.0": cv, side, entry, item-with-level, contact-info, social-links
#import "@preview/linguify:0.4.2"

#let gdpd_text = "I authorise the processing of personal data contained within my CV, according to GDPR (EU) 2016/679, Article 6.1(a)."

#show: cv.with(
  profile-picture: image("images/me.jpg"),
  paper-size: "a4",
  side-width: 4cm,
  accent-color: rgb("#407287"),
  header-color: rgb("#8D949D"),
  date: custom-date-format(datetime.today()),
  body-font: "Iosevka NF",
  author: (
    firstname: "Jakub",
    lastname: "Stepien",
    email: "work@jak0b.com",
    position: ("DevOps Engineer"),
    linkedin: "jak0b",
    github: "jak0b",
    phone: "+48 518 337 454"
  ),
)

#side[
  = About Me
  Experienced DevOps Engineer with 6 years of expertise in system maintenance, Linux administration,
  and software development. Well‑versed in networking, Docker, Kubernetes, Helm, and multiple cloud platforms (AWS, GCP),
  with a focus on migrating on‑premises resources to the cloud.

  = Skills
  #item-with-level("Unix scripting", 5)
  #item-with-level("Linux administration", 4)
  #item-with-level("Kubernetes", 4)
  #item-with-level("Golang", 4)
  #item-with-level("Python", 4)
  #item-with-level("AWS", 3)
  #item-with-level("Terraform", 4)
  #item-with-level("Monitoring & Alerting", 4)
  #item-with-level("CI/CD", 4)
  #item-with-level("Networking & Security", 4)

  = Languages
  #item-with-level("Polish", 5,  subtitle: "mother tongue")
  #item-with-level("German", 4,  subtitle: "proficiency – C2, Goethe Institute GDS")
  #item-with-level("English", 4, subtitle: "working proficiency, many years of experience")

#set text( size: 5pt)
#set align(bottom)
#gdpd_text
]

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
  institution: "Grid Dynamics (contractor for one of the FAANG companies)",
  location: "remote",
  date: "Aug 2023 - now",
  [
  - Migrated deployment processes from an internal Jenkins‑based pipeline system to a GitOps approach (ArgoCD)
  - Troubleshot networking issues related to communication between AWS and company internal systems
  - Provisioned cloud resources in multiple environments using Terraform:
    #list(tight: true,
      [AWS EKS with auto-scaling and diverse networking configurations],
      [AWS MSK (Kafka) cluster with Snowflake connector],
      [AWS MemoryDB],
    )
  - Automated certificate issuance and management within an internal private PKI for Kubernetes and AWS Certificate Manager
  - Configured Prometheus alerting rules for Kubernetes clusters
  - Imported existing resources into Terraform to manage them from a single source.
  - Provided assistance to developers regarding networking, reverse proxy, and load balancer issues
  - Implemented OpenID Connect across multiple micro-services
  - Set up new and refined existing deployment pipelines for Terraform
  - Eliminated unnecessary cloud resources, leading to reduced operational costs for the company
  - Optimized EKS costs by implementing Karpenter and leveraging spot instances for resource allocation.
  - Ensured production deployment readiness and rapid resolution of urgent deployment issues
  - Collaborated with developers across the Pacific and Indian time zones
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
    - Developed and deployed Python micro-services (Flask, Django) with containerization, testing, and deployment across on-premises and cloud environments  
    - Built and maintained CI/CD pipelines using GitLab  
    - Monitored resource usage of non-containerized apps and migrated resources to the cloud  
    - Collaborated with developers and IT teams to troubleshoot infrastructure and deployment issues  
    - Maintained multi-user Jupyter kernels (TensorFlow, PyTorch, Anaconda)  
    - Introduced Docker and serverless (OpenFaaS) deployment for NLP services  
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

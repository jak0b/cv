#import "@preview/datify:1.3.0": custom-date-format
#import "@preview/neat-cv:1.2.0": cv, cv-with-side, entry, contact-info, social-links

#let render-cv(lang: "en", picture: "true", commit: none) = {
  assert(lang in ("en", "de"), message: "Supported CV languages: en, de")
  assert(picture in ("true", "false"), message: "picture input must be true or false")

  // Keep translations beside each other; layout and CV facts are shared.
  let t(en, de) = if lang == "de" { de } else { en }
  let date-range(start, end) = {
    let month(parts) = custom-date-format(
      datetime(year: parts.at(0), month: parts.at(1), day: 1),
      pattern: "MMM yyyy",
      lang: lang,
    )
    month(start) + t(" - ", " – ") + month(end)
  }

  [
    #set text(lang: lang)
    #let gdpr-text = t(
      "I authorise the processing of personal data contained within my CV, according to GDPR (EU) 2016/679, Article 6.1(a).",
      "Ich willige in die Verarbeitung der in meinem Lebenslauf enthaltenen personenbezogenen Daten gemäß Art. 6 Abs. 1 lit. a DSGVO (EU) 2016/679 ein.",
    )
    #let today = datetime.today()
    #let cv-date = custom-date-format(today, lang: lang)

    #show: cv.with(
      profile-picture: if picture == "true" { image("img/profile.jpg") } else { none },
      paper-size: "a4",
      accent-color: rgb("#1F6875"),
      header-color: rgb("#243746"),
      date: cv-date,
      footer: [
        #set align(center)
        #set text(size: 5pt, fill: rgb("#777777"))
        #text(size: 7pt)[
          #t("Generated on", "Erstellt am") #cv-date
          #if commit != none [ · #link("https://github.com/jak0b/cv/commit/" + commit)[#commit.slice(0, 7)]]
        ]
        #block(above: 4pt)[#gdpr-text]
      ],
      body-font: "Iosevka NF",
      heading-font: "Iosevka NFP Medium Obl",
      author: (
        firstname: "Jakub",
        lastname: "Stepien",
        email: "work@jak0b.com",
        position: ("Cloud DevOps & System AI Engineer"),
        custom-links: (
          (icon-name: "github", url: "https://github.com/jak0b", label: "https://github.com/jak0b"),
          (icon-name: "linkedin", url: "https://www.linkedin.com/in/jak0b", label: "https://www.linkedin.com/in/jak0b"),
        ),
        phone: "+48 573 305 599"
      ),
    )

    // Enforce the one-page requirement for every language, locally and in CI.
    #context assert(
      counter(page).final().first() == 1,
      message: "The CV must fit on exactly one A4 page.",
    )

    #cv-with-side[
      = #t("Profile", "Profil")
      #t([DevOps Engineer with *7+ years of experience* across AWS infrastructure, Kubernetes,
        Linux, and software development. Focused on infrastructure as code, GitOps migrations,
        deployment automation, and production operations. Combines cloud experience with
        hands-on networking, security, and backend development.], [
        DevOps Engineer mit *über 7 Jahren Erfahrung* in AWS-Infrastruktur, Kubernetes,
        Linux und Softwareentwicklung. Fokus auf Infrastructure as Code, GitOps-Migrationen,
        Deployment-Automatisierung und Produktionsbetrieb; Erfahrung mit Netzwerken,
        Sicherheit und Backend-Entwicklung.
      ])

      = #t("Skills", "Skills")
      *Cloud* #linebreak()
      AWS: EC2, EKS, VPC, IAM, KMS, MSK, MemoryDB; GCP

      *Infrastructure as Code* #linebreak()
      Terraform, Pulumi, CloudFormation, Ansible

      *#t("Containers & Systems", "Container & Systeme")* #linebreak()
      Kubernetes, Helm, Docker, Karpenter, Linux, Proxmox

      *CI/CD & GitOps* #linebreak()
      Argo CD, Jenkins, GitLab CI

      *#t("Observability", "Observability")* #linebreak()
      Prometheus, Grafana, CloudWatch, Splunk, Loki

      *#t("Networking & Security", "Netzwerk & Security")* #linebreak()
      VPN, LDAP, OIDC, PKI

      *#t("Programming & AI", "Programmierung & KI")* #linebreak()
      Python, Go, Bash; #t("DevOps tasks with Claude and Codex", "DevOps-Aufgaben mit Claude und Codex")

      = #t("Languages", "Sprachen")
      #set par(justify: false)
      #table(
        columns: (1fr,),
        row-gutter: 1pt,
        align: left,
        stroke: none,
        inset: 0pt,
        table.cell(inset: (top: 4pt, bottom: 2pt))[*#t("Polish", "Polnisch")*],
        table.cell(inset: (left: 6pt))[#t("Native", "Muttersprache")],
        table.cell(inset: (top: 4pt, bottom: 2pt))[*#t("German", "Deutsch")*],
        table.cell(inset: (left: 6pt))[C2 — Goethe-Institut GDS],
        table.cell(inset: (top: 4pt, bottom: 2pt))[*#t("English", "Englisch")*],
        table.cell(inset: (left: 6pt))[#t("Working proficiency; many years of professional use", "Langjährige Berufserfahrung auf Englisch")],
      )
    ][

    = #t("Contact", "Kontakt")
    #set rect(
      inset: 8pt,
      fill: rgb("ffffff"),
      width: 100%,
    )

    #grid(
      columns: (0.8fr, 1.2fr),
      rect[#contact-info()],
      rect[#social-links()],
    )

    = #t("Experience", "Berufserfahrung")

    #entry(
      title: "DevOps Engineer",
      institution: t("Grid Dynamics (contractor for a US-based company)", "Grid Dynamics (Contractor für ein US-Unternehmen)"),
      location: t("remote", "Remote"),
      date: date-range((2023, 8), (2026, 10)),
      [
      - #t(
          [Provisioned *AWS infrastructure* across multiple environments with *Terraform*: EC2, EKS, MSK (Kafka) with a Snowflake connector, and MemoryDB],
          [*AWS-Infrastruktur* mit *Terraform* in mehreren Umgebungen aufgebaut und bereitgestellt: EC2, EKS, MSK (Kafka) mit Snowflake-Konnektor und MemoryDB],
        )
      - #t(
          [Imported existing cloud resources into Terraform to establish a single source of truth],
          [Bestehende Cloud-Ressourcen in Terraform importiert und so eine *Single Source of Truth* geschaffen],
        )
      - #t(
          [Optimized *EKS costs* with Karpenter and spot instances],
          [*EKS-Kosten* durch Karpenter und Spot Instances optimiert],
        )
      - #t(
          [Migrated AWS CloudFormation stacks to Pulumi and automated infrastructure deployments through CI pipelines],
          [AWS-CloudFormation-Stacks zu Pulumi migriert und Infrastruktur-Deployments über CI-Pipelines automatisiert],
        )
      - #t(
          [Migrated deployments from internal Jenkins pipelines to *GitOps with Argo CD*],
          [Deployments von internen Jenkins-Pipelines auf *GitOps mit Argo CD* umgestellt],
        )
      - #t(
          [Automated certificate management with a private PKI, implemented *OIDC authentication and authorization* across multiple *microservices*, and was responsible for gRPC *microservices*],
          [Zertifikatsverwaltung mit einer privaten PKI automatisiert, *OIDC-Authentifizierung und -Autorisierung* für mehrere *Microservices* implementiert und gRPC-*Microservices* betreut],
        )
      - #t(
          [Supported deployments and *on-call incident response* for a low-latency manufacturing system written in Go; configured Kubernetes alerts in Prometheus and troubleshot AWS networking, reverse proxies, and load balancers],
          [Deployments und *On-Call Incident Response* für ein *Low-Latency*-Fertigungssystem in Go unterstützt; Prometheus-Alerts für Kubernetes konfiguriert und Probleme mit AWS-Netzwerken, Reverse Proxys und Load Balancern untersucht],
        )
      - #t(
          [Maintained legacy Ruby on Rails applications running as systemd services with Ansible; automated builds, tests, and deployments with Jenkins while keeping the systems up to date *without downtime*],
          [Legacy-Ruby-on-Rails-Anwendungen als systemd-Dienste mit Ansible betreut; Builds, Tests und Deployments mit Jenkins automatisiert und die Systeme *ohne Downtime* aktuell gehalten],
        )
      - #t(
          [Mentored DevOps engineers],
          [DevOps Engineers als Mentor unterstützt],
        )
      ],
    )

    #entry(
      title: "DevOps & System Engineer",
      institution: t("Docmatic.ai (formerly Random Forest)", "Docmatic.ai (ehemals Random Forest)"),
      location: t("Krakow, Poland", "Krakau, Polen"),
      date: date-range((2018, 9), (2022, 7)),
      [
        - #t(
            [Managed Linux servers, switches, MikroTik routers, and Proxmox hosts running *virtualized Kubernetes clusters*],
            [Linux-Server, Netzwerk-Switches, MikroTik-Router und Proxmox-Hosts mit *virtualisierten Kubernetes-Clustern* betreut],
          )
        - #t(
            [Managed LDAP access and WireGuard/OpenVPN connectivity; configured site-to-site VPNs for encrypted multi-cloud communication],
            [LDAP-Zugriffe sowie WireGuard- und OpenVPN-Verbindungen verwaltet; Site-to-Site-VPNs für verschlüsselte Multi-Cloud-Kommunikation eingerichtet],
          )
        - #t(
            [Developed and deployed *Python microservices* (Flask, Django) with containerization],
            [*Python-Microservices* mit Flask und Django entwickelt und als Container ausgerollt],
          )
        - #t(
            [Built and maintained CI/CD pipelines using GitLab],
            [CI/CD-Pipelines mit GitLab aufgebaut und betreut],
          )
        - #t(
            [Monitored application resource usage and *migrated on-premises resources to the cloud*],
            [Ressourcennutzung von Anwendungen überwacht und *On-Premises-Ressourcen in die Cloud migriert*],
          )
        - #t(
            [Mentored new developers and contributed to Django backend development],
            [Neue Entwickler als Mentor begleitet und die Django-Backend-Entwicklung unterstützt],
          )
      ],
    )

    = #t("Education", "Studium")

    #entry(
      title: t("Bachelor's degree in Applied Informatics - Software Engineering", "Bachelor in Angewandter Informatik – Software Engineering"),
      institution: t("Cracow University of Economics", "Wirtschaftsuniversität Krakau"),
      date: date-range((2017, 9), (2021, 9)),
      [#t("Thesis", "Abschlussarbeit"): #t("Rust a possible successor to C - overview of the language and sample programs", "Rust als möglicher Nachfolger von C – Überblick über die Sprache und Beispielprogramme")],
    )
    ]
  ]
}

#render-cv(
  lang: sys.inputs.at("lang", default: "en"),
  picture: sys.inputs.at("picture", default: "true"),
  commit: sys.inputs.at("commit", default: none),
)

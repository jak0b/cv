#import "@preview/datify:1.3.0": custom-date-format
#import "@preview/neat-cv:1.2.0": cv, cv-with-side, entry, contact-info, social-links

#let render-cv(lang: "en") = {
  assert(lang in ("en", "de"), message: "Supported CV languages: en, de")
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

    #show: cv.with(
      profile-picture: image("img/profile.jpg"),
      paper-size: "a4",
      accent-color: rgb("#407287"),
      header-color: rgb("#8D949D"),
      date: custom-date-format(today, lang: lang),
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
        Linux und Softwareentwicklung. Schwerpunkte: Infrastructure as Code, GitOps-Migrationen,
        Deployment-Automatisierung und Produktionsbetrieb. Verbindet Cloud-Erfahrung mit
        praktischen Kenntnissen in Netzwerken, Sicherheit und Backend-Entwicklung.
      ])

      = #t("Skills", "Kenntnisse")
      *Cloud* #linebreak()
      AWS: EC2, EKS, VPC, IAM, KMS, MSK, MemoryDB; GCP

      *Infrastructure as Code* #linebreak()
      Terraform, Pulumi, CloudFormation, Ansible

      *#t("Containers & Systems", "Container & Systeme")* #linebreak()
      Kubernetes, Helm, Docker, Karpenter, Linux, Proxmox

      *CI/CD & GitOps* #linebreak()
      Argo CD, Jenkins, GitLab CI

      *#t("Observability", "Monitoring & Logging")* #linebreak()
      Prometheus, Grafana, CloudWatch, Splunk, Loki

      *#t("Networking & Security", "Netzwerke & Sicherheit")* #linebreak()
      VPN, LDAP, OIDC, PKI

      *#t("Programming", "Programmierung")* #linebreak()
      Python, Go, Bash

      = #t("Languages", "Sprachen")
      *#t("Polish", "Polnisch")* #linebreak()
      #t("Native", "Muttersprache")

      *#t("German", "Deutsch")* #linebreak()
      C2 — Goethe-Institut GDS

      *#t("English", "Englisch")* #linebreak()
      #t("Working proficiency; many years of professional use", "Langjährige Berufspraxis")

    #set text( size: 3.5pt)
    #set align(bottom)
    #gdpr-text
    ][

    = #t("Contact", "Kontakt")
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

    = #t("Experience", "Berufserfahrung")

    #entry(
      title: "DevOps Engineer",
      institution: t("Grid Dynamics (contractor for a US-based company)", "Grid Dynamics (Auftragnehmer für ein US-Unternehmen)"),
      location: t("remote", "Remote"),
      date: date-range((2023, 8), (2026, 10)),
      [
      - #t(
          [Provisioned AWS infrastructure across multiple environments with Terraform: EC2, EKS, MSK (Kafka) with a Snowflake connector, and MemoryDB],
          [AWS-Infrastruktur mit Terraform in mehreren Umgebungen bereitgestellt: EC2, EKS, MSK (Kafka) mit Snowflake-Konnektor und MemoryDB],
        )
      - #t(
          [Imported existing cloud resources into Terraform to establish a single source of truth],
          [Bestehende Cloud-Ressourcen zur zentralen Verwaltung in Terraform importiert],
        )
      - #t(
          [Optimized EKS costs with Karpenter and spot instances],
          [EKS-Kosten mit Karpenter und Spot-Instanzen optimiert],
        )
      - #t(
          [Migrated AWS CloudFormation stacks to Pulumi and automated infrastructure deployments through CI pipelines],
          [AWS-CloudFormation-Stacks zu Pulumi migriert und Infrastruktur-Deployments über CI-Pipelines automatisiert],
        )
      - #t(
          [Migrated deployments from internal Jenkins pipelines to a GitOps approach with Argo CD],
          [Deployments von internen Jenkins-Pipelines auf GitOps mit Argo CD umgestellt],
        )
      - #t(
          [Automated certificate management with a private PKI and implemented OIDC authentication and authorization across multiple microservices],
          [Zertifikatsverwaltung mit privater PKI automatisiert und OIDC-Authentifizierung und -Autorisierung für mehrere Microservices implementiert],
        )
      - #t(
          [Supported deployments and on-call incident response for a low-latency manufacturing system written in Go; configured Kubernetes alerts in Prometheus and troubleshot AWS networking, reverse proxies, and load balancers],
          [Deployment und Rufbereitschaft für ein latenzarmes Fertigungssystem in Go unterstützt; Kubernetes-Alarme in Prometheus konfiguriert und Probleme mit AWS-Netzwerken, Reverse-Proxys und Load-Balancern behoben],
        )
      - #t(
          [Managed Rails applications with Ansible and automated build, test, and deployment workflows with Jenkins],
          [Rails-Anwendungen mit Ansible verwaltet; Build, Tests und Deployments mit Jenkins automatisiert],
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
            [Managed Linux servers, switches, MikroTik routers, and Proxmox hosts running virtualized Kubernetes clusters],
            [Linux-Server, Switches, MikroTik-Router und Proxmox-Hosts mit virtualisierten Kubernetes-Clustern verwaltet],
          )
        - #t(
            [Managed LDAP access and WireGuard/OpenVPN connectivity; configured site-to-site VPNs for encrypted multi-cloud communication],
            [LDAP-Zugänge und WireGuard-/OpenVPN-Verbindungen verwaltet; Site-to-Site-VPNs für verschlüsselte Multi-Cloud-Kommunikation konfiguriert],
          )
        - #t(
            [Developed and deployed Python microservices (Flask, Django) with containerization],
            [Containerisierte Python-Microservices (Flask, Django) entwickelt und bereitgestellt],
          )
        - #t(
            [Built and maintained CI/CD pipelines using GitLab],
            [CI/CD-Pipelines mit GitLab aufgebaut und betreut],
          )
        - #t(
            [Monitored application resource usage and migrated on-premises resources to the cloud],
            [Ressourcennutzung von Anwendungen überwacht und lokale Ressourcen in die Cloud migriert],
          )
        - #t(
            [Mentored new developers and contributed to Django backend development],
            [Neue Entwickler eingearbeitet und am Django-Backend mitentwickelt],
          )
      ],
    )

    = #t("Education", "Studium")

    #entry(
      title: t("Bachelor's degree in Applied Informatics - Software Engineering", "Bachelor in Angewandter Informatik – Software Engineering"),
      institution: t("Cracow University of Economics", "Wirtschaftsuniversität Krakau"),
      date: date-range((2017, 9), (2021, 9)),
      [#t("Thesis", "Abschlussarbeit"): "Rust a possible successor to C - overview of the language and sample programs"],
    )
    ]
  ]
}

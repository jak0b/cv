#import "@preview/datify:1.3.0": custom-date-format
#import "@preview/neat-cv:1.2.0": cv, cv-with-side, entry, item-with-level, contact-info, social-links

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
      = #t("About Me", "Über mich")
      #t([Experienced DevOps Engineer with #strong(expertise-display) years of expertise in system maintenance, Linux administration,
      and software development. Well‑versed in networking, Docker, Kubernetes, Helm, and multiple cloud platforms (AWS, GCP),
      with a focus on migrating on‑premises resources to the cloud.], [
        Erfahrener DevOps Engineer mit #strong(expertise-display.replace(".", ",")) Jahren Erfahrung in Systemwartung,
        Linux-Administration und Softwareentwicklung. Versiert in Netzwerken, Docker, Kubernetes,
        Helm und Cloud-Plattformen (AWS, GCP). Schwerpunkt: Migration lokaler Ressourcen in die Cloud.
      ])

      = #t("Skills", "Kenntnisse")
      #item-with-level("AWS: EC2, EKS, VPC, IAM, KMS", 4)
      #item-with-level("Terraform & Infrastructure as Code", 3)
      #item-with-level("Kubernetes, Helm & Docker", 4)
      #item-with-level(t("Linux administration", "Linux-Administration"), 5)
      #item-with-level("Argo CD, Jenkins & GitLab CI", 4)
      #item-with-level("CloudWatch, Prometheus & Grafana", 3)
      #item-with-level("Python, Go & Bash", 4)
      #item-with-level(t("Networking & Cloud Security", "Netzwerke & Cloud-Sicherheit"), 4)
      #item-with-level("Splunk & Loki", 3)

      = #t("Languages", "Sprachen")
      #item-with-level(t("Polish", "Polnisch"), 5,  subtitle: t("mother tongue", "Muttersprache"))
      #item-with-level(t("German", "Deutsch"), 4, subtitle: t([proficiency – C2,#linebreak()Goethe Institute GDS], [C2,#linebreak()Goethe-Institut GDS]))
      #item-with-level(t("English", "Englisch"), 4, subtitle: t("working proficiency, many years of experience", "Langjährige Berufspraxis"))

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
      institution: t("Grid Dynamics (contractor for a US based company)", "Grid Dynamics (Auftragnehmer für ein US-Unternehmen)"),
      location: t("remote", "Remote"),
      date: date-range((2023, 8), (2026, 10)),
      [
      - #t(
          [Supported the deployment of a low-latency manufacturing system written in Go],
          [Deployment eines latenzarmen Fertigungssystems in Go unterstützt],
        )
      - #t(
          [Participated in an on-call rotation, troubleshooting incidents and following operational runbooks],
          [Rufbereitschaft, Störungsanalyse und -behebung anhand von Runbooks],
        )
      - #t(
          [Provisioned cloud resources in multiple environments using Terraform:],
          [Cloud-Ressourcen mit Terraform in mehreren Umgebungen bereitgestellt:],
        )
        #list(tight: true,
          [#t([AWS EC2 & EKS with auto-scaling and diverse networking configurations], [AWS EC2 & EKS mit Auto-Scaling und vielfältigen Netzwerkkonfigurationen])],
          [#t([AWS MSK (Kafka) cluster with Snowflake connector], [AWS-MSK-Cluster (Kafka) mit Snowflake-Konnektor])],
          [AWS MemoryDB],
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
          [Migrated AWS CloudFormation stacks to Pulumi and automated deployments through CI pipelines],
          [AWS-CloudFormation-Stacks zu Pulumi migriert und Deployments über CI-Pipelines automatisiert],
        )
      - #t(
          [Migrated deployments from internal Jenkins pipelines to a GitOps approach with Argo CD],
          [Deployments von internen Jenkins-Pipelines auf GitOps mit Argo CD umgestellt],
        )
      - #t(
          [Automated certificate issuance and management using an internal private PKI],
          [Zertifikatsausstellung und -verwaltung mit interner privater PKI automatisiert],
        )
      - #t(
          [Configured Prometheus alerting rules for Kubernetes clusters],
          [Prometheus-Alarmregeln für Kubernetes-Cluster konfiguriert],
        )
      - #t(
          [Troubleshot AWS connectivity, reverse proxy, and load balancer issues with development teams],
          [AWS-Verbindungs-, Reverse-Proxy- und Load-Balancer-Probleme mit Entwicklungsteams behoben],
        )
      - #t(
          [Implemented OIDC authentication and authorization across multiple microservices],
          [OIDC-Authentifizierung und -Autorisierung für mehrere Microservices implementiert],
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
            [Managed networking infrastructure: servers (HP iLO, Intel BMC), switches, routers (MikroTik) for security and reliability],
            [Netzwerkinfrastruktur für sicheren, zuverlässigen Betrieb verwaltet: Server (HP iLO, Intel BMC), Switches, Router (MikroTik)],
          )
        - #t(
            [Maintained Proxmox hosts for virtualization of Kubernetes clusters],
            [Proxmox-Hosts zur Virtualisierung von Kubernetes-Clustern betreut],
          )
        - #t(
            [Managed user and developer access via LDAP, VPNs (WireGuard, OpenVPN)],
            [Benutzer- und Entwicklerzugänge über LDAP und VPNs (WireGuard, OpenVPN) verwaltet],
          )
        - #t(
            [Configured site-to-site VPNs for multi-cloud encrypted communication],
            [Site-to-Site-VPNs für verschlüsselte Multi-Cloud-Kommunikation konfiguriert],
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
            [Monitored resource usage of non-containerized apps and migrated resources to the cloud],
            [Ressourcennutzung nicht containerisierter Anwendungen überwacht und Ressourcen in die Cloud migriert],
          )
        - #t(
            [Maintained multi-user Jupyter kernels (TensorFlow, PyTorch, Anaconda)],
            [Jupyter-Kernel für mehrere Benutzer betreut (TensorFlow, PyTorch, Anaconda)],
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

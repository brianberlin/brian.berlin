
# Brian Berlin
- (225) 907-0291
- [bri@nberl.in](mailto:bri@nberl.in)
- [Github](https://github.com/brianberlin)

I'm a senior software engineer specializing in Elixir and distributed systems, with extensive experience in building scalable web applications. Currently seeking new opportunities where I can leverage my technical expertise and leadership skills.

# Technical Skills

- Elixir / Erlang / OTP / Phoenix / GraphQL / Liveview / Nerves
- React / Redux / React Native / Ember / Javascript / NodeJS
- Postgres / MySQL / MongoDB / Redis / DynamoDB / Elasticsearch
- Docker / Kubernetes
- New Relic / Prometheus / Grafana / Observability

# Experience

## Fillogic
__Senior Software Engineer (2025 - Present)__

Fillogic is a third-party logistics provider specializing in reverse logistics and warehouse management for e-commerce brands. The company operates warehouse facilities that handle returns processing, inventory management, order fulfillment, and last-mile delivery coordination for customers like Levi's, Phillip Morris, Pact, FIGS, and others. Their platform manages the entire lifecycle of returned merchandise—from initial RMA creation through grading, repackaging, resale listing, and redistribution—while also supporting forward logistics operations like B2C packing and shipping.

Key contributions and projects:

**Streamlined Mobile Label Printing System** - Architected and implemented an end-to-end mobile label printing system that increased return processing throughput by 30% by eliminating inefficient bulk printing workflows. Previously, workers had to walk to hardwired laptops to print labels in bulk for multi-item RMAs, leading to frequent tag misplacement and significant time waste. The solution integrated three components: a dynamic ZPL template engine with customer-specific customization, NFC printer pairing that enables one-tap printer configuration at shift start, and direct Zebra printer integration in the React Native app allowing workers to print labels on-demand with a single button press. This eliminated worker movement between stations and enabled continuous grading and labeling at individual workstations, dramatically reducing errors and improving operational efficiency.

**Truck-based Development Workflow** - Architected trunk-based development workflow with label-triggered staging deployments, enabling safe pre-production testing and reducing deployment risk

**Error Tracking** - Migrated error tracking from Rollbax to Sentry across backend and mobile applications, improving production debugging capabilities and reducing MTTR by 40%

**Mobile Builds** - Implemented automated CI/CD pipelines for React Native mobile builds with GitHub Actions, including automated APK generation, version management, and release distribution

**Time Management** - Built complete time management system with clock in/out, break tracking, payroll reporting, and PostgreSQL advisory locks to prevent race conditions, processing 500+ daily time entries

**Feature Flags** - Developed real-time feature flag system with Phoenix Channels, enabling targeted feature rollouts and A/B testing without deployments

**Barcode Scanning** - Refactored barcode scanner integration for Zebra handheld devices using native DataWedge SDK, improving scan reliability and adding automatic profile configuration with factory reset capability


## Peek
__Senior Backend Engineer (2022 - 2025)__

Peek provides SaaS solutions for the experience industry, serving businesses such as ghost tours, zip line adventures, boat rentals, and other tourism/activity operators. As a senior backend engineer, I worked on the large-scale Elixir codebase powering the flagship Peek Pro platform, which processes a high volume of bookings annually. I also gained experience with Ember.js for frontend development and implemented comprehensive observability solutions using New Relic.

Key contributions and projects:

**Peek CoPilot** - Led the development of Peek CoPilot, an AI-powered business intelligence tool that transformed operational data into actionable insights. Created a pipeline to analyze and summarize customer reviews, extract sentiment patterns and provide partners with concrete improvement recommendations. Implemented advanced pricing intelligence that analyzed competitive market data to optimize pricing strategies, directly increasing partner revenue.

**Outbox Messaging** - Implemented a high-performance messaging outbox system with an optimized Elasticsearch indexing strategy enabling real-time search and retrieval across many services with massive message volumes. Featured a user interface for tracking communication history and scheduled messages that included the ability to search, preview, cancel, and resend messages.

**Digitally Signed Waivers** - Led the redesign and implementation of an enterprise-grade digital waiver system. Developed a flexible architecture that seamlessly integrated waivers with the booking process. Created a secure, legally-compliant signature system supporting both adult participants and minors with guardian approval. Implemented a robust storage and retrieval system ensuring waivers remained accessible for legal compliance.

**Reporting Platform** - Spearheaded the development of a next-generation business intelligence platform. Leveraged AlloyDB's advanced capabilities to design and implement a high-performance data warehouse. Created the backend GraphQL API to power a comprehensive suite of real-time analytics dashboards providing critical business insights with the ability to create customizable reporting templates to perform complex comparative analyses across time periods and business segments.

**Peek.com Search** - Architected a high-performance search and discovery system for Peek.com's consumer marketplace. Designed and implemented sophisticated Elasticsearch indexing strategies to aggregate data from multiple sources. Optimized search relevance algorithms to improve conversion rates and user satisfaction.

**Elasticsearch Framework** - Engineered an enterprise-grade Elasticsearch infrastructure framework that improved reliability and developer productivity. Designed and implemented a macro-based Elixir module system for configuring and managing multiple Elasticsearch indexes. Created an intelligent batching system for efficiently transforming database records into Elasticsearch documents. Implemented error handling with automatic retry mechanisms for failed indexing operations. Built safeguards including hot swap protection to ensure zero-downtime index rebuilds and prevent partial index states.

**Tipping System** - Implemented a tipping system integrated into the booking flow that increased partner revenue and guide satisfaction. Automated tip distribution to guides based on configurable rules. Included financial tracking and reporting for accounting compliance.

**Code Coverage Tool** - Created and open-sourced a GitHub Action that analyzes test coverage and highlights areas needing improvement through PR annotations. The tool features configurable thresholds and has been adopted by multiple teams to maintain code quality standards. ([GitHub Repository](https://github.com/peek-travel/coverage-reporter))


## Revelry
__Software Engineer / Engineering Coach (2018 - 2022)__

At Revelry, I worked across diverse client projects while also serving as an engineering coach, mentoring junior developers and establishing technical best practices. I specialized in building scalable, distributed systems using Elixir and other modern technologies.

- Implemented comprehensive observability solutions using logging, telemetry, Prometheus, and Grafana, enabling proactive system monitoring and rapid issue resolution
- Designed and deployed distributed Elixir applications using libcluster strategies for both local development and production Kubernetes environments
- Architected a fault-tolerant distributed application cache system:
  - Engineered for resilience during network partitions and rolling deployments
  - Utilized ETS tables for high-performance, in-memory data storage
  - Designed a flexible behavior-based API for configurable data creation and update policies
- Optimized database performance through systematic analysis, identifying missing indexes and query optimizations that reduced costs and improved response times
- Implemented sophisticated multi-stage deployment processes for safely managing database schema changes in production environments
- Containerized applications using Docker and orchestrated deployments with Kubernetes, ensuring consistent environments across development and production
- Led troubleshooting efforts for complex Kubernetes deployments using kubectl and k9s
- Developed the company's internal time tracking application using Elixir/Phoenix, improving project management and billing accuracy
- Demonstrated versatility by working across multiple technology stacks including Node.js/Express, React, React Native, and TypeScript

## 3Coasts
__Owner (2011 - 2018)__

Founded and operated a successful web design and development consultancy that delivered custom digital solutions for businesses across multiple industries. Led all aspects of the business including client acquisition, project management, design, development, and deployment. Specialized in creating strategic digital experiences that helped clients achieve their marketing objectives and business goals.

## GradSquare
__Co-Founder (2015 - 2016)__

GradSquare's mission was to bridge the gap between universities and industry. A centralized platform where employers/recruiters could easily find graduates from every university, and universities could get actionable insights on the market traction of their degree programs.

As the sole technologist for GradSquare, I was the graphic designer and software engineer. Below are some screenshots of the application that was created.

 - [Find a Job](https://brian.berlin/images/gradsquare/find-a-job.png)
 - [In App Messaging](https://brian.berlin/images/gradsquare/in-app-messaging.png)

## Bclip Productions
__Software Engineer (2002 - 2011)__

My introduction to software engineering was made possible through my job at Bclip. Bclip is a video production company that creates videos for businesses. My job was to deliver videos in various formats which included: interactive presentations on CDROM and DVD, touch screen kiosks meant for retail installation and tradeshow floors, streaming video embeddable on websites. This was my first job out of college and where I became interested in programming with my first language which was a language called Lingo from Macromedia Director.

 - [Sonny's Car Wash Dual Screen Kiosk](https://brian.berlin/images/bclip/sonnys-kiosk.jpeg)
 - [Sonny's Car Wash Touch Screen Kiosk](https://brian.berlin/images/bclip/sonnys-kiosk-2.jpeg)

# Open Source

- [Coverage Reporter](https://github.com/peek-travel/coverage-reporter) - GitHub Action that analyzes test coverage and adds PR annotations highlighting areas needing additional tests.
- [NervesHubWeb - Ability to delete accounts](https://github.com/nerves-hub/nerves_hub_web/pull/676) - Added account deletion functionality to the NervesHub platform.
- [NervesHubWeb - Other contributions](https://github.com/nerves-hub/nerves_hub_web/pulls?q=is%3Apr+author%3Abrianberlin+is%3Aclosed) - Various improvements to the NervesHub web interface.

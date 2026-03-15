🚀 Capstone Project: 3-Tier Web Application CI/CD Deployment
🏗️ Architecture & Deployment Strategy Update
Note on Infrastructure Provisioning:
The initial project scope involved manually provisioning a raw Linux Virtual Machine via an IaaS (Infrastructure as a Service) provider to host a single docker-compose environment. However, to implement a more robust, scalable, and modern DevOps workflow, the architecture was upgraded to a fully managed PaaS (Platform as a Service) deployment using Render.

This strategic pivot provided several enterprise-grade advantages over a traditional local or standalone VM setup:

Automated CI/CD Pipeline: Instead of manually SSHing into a server to pull images, the frontend and backend are now directly integrated with GitHub. Every code push triggers an automated build and zero-downtime deployment.

Microservice Isolation: Rather than bundling the frontend, API, and database into a single host environment, the tiers have been decoupled. The PostgreSQL database, Node.js backend, and static frontend run on isolated, independently scalable cloud instances.

Enhanced Security: The PostgreSQL database is completely isolated from the public internet, communicating with the Node.js API exclusively via a secure internal network URL.

🔗 Live Access
Frontend UI: https://capstone-frontend-eopf.onrender.com

Backend API: https://capstone-backend-7vp2.onrender.com/api/projects

🛠️ Tech Stack
Frontend: HTML, CSS, JavaScript (Deployed as a globally distributed Static Site)

Backend: Node.js, Express (Containerized and deployed as a Web Service)

Database: Managed PostgreSQL

CI/CD: Native GitHub integration via Render
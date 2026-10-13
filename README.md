\# GitHook Shield



GitHook Shield is a lightweight DevSecOps project that demonstrates how to integrate security checks into the software development and deployment lifecycle.



The project uses Git pre-commit hooks to detect potential hardcoded secrets, GitHub Actions for continuous integration, Docker for containerization, and Terraform to manage Kubernetes resources and monitoring infrastructure.



\## Features



\- \*\*Pre-commit security checks:\*\* Detects common hardcoded secret patterns in staged changes and blocks suspicious commits.

\- \*\*Automated CI:\*\* GitHub Actions runs Python syntax checks, basic secret detection, and a Docker image build.

\- \*\*Containerization:\*\* Packages the Flask application into a Docker image.

\- \*\*Infrastructure as Code:\*\* Uses Terraform to define Kubernetes deployment and service resources.

\- \*\*Monitoring:\*\* Uses Prometheus, Grafana, and Alertmanager through the kube-prometheus-stack Helm chart.



\## Project Structure



```text

githook-shield/

├── app/

│   ├── app.py

│   ├── requirements.txt

│   └── Dockerfile

├── hooks/

│   └── pre-commit

├── scripts/

│   └── install-hooks.sh

├── .github/

│   └── workflows/

│       └── ci.yml

├── terraform/

│   ├── main.tf

│   ├── variables.tf

│   └── monitoring-values.yaml

└── README.md

```



\## Prerequisites



\- Git and Git Bash

\- Python 3.12 or later

\- Docker Desktop with the WSL 2 backend

\- Terraform

\- Minikube

\- kubectl

\- Helm



\## Run the Application Locally



Navigate to the application directory:



```bash

cd app

python -m venv venv

```



Activate the environment in Git Bash:



```bash

source venv/Scripts/activate

```



Install dependencies and run the application:



```bash

pip install -r requirements.txt

python app.py

```



Open `http://localhost:5000` to access the application.



The health endpoint is available at `http://localhost:5000/health`.



\## Build and Run with Docker



From the repository root:



```bash

docker build -t githook-shield:1.0 ./app

docker run --rm -p 5000:5000 githook-shield:1.0

```



\## Install the Git Hook



Run from the repository root in Git Bash:



```bash

bash scripts/install-hooks.sh

```



The hook checks staged changes for common secret patterns before allowing a commit. It is a basic demonstration, not a replacement for a dedicated secret-scanning tool.



\## CI Pipeline



The GitHub Actions workflow runs on pushes and pull requests targeting `main`. It checks Python syntax, performs basic secret detection, and builds the Docker image.



\## Infrastructure and Monitoring



The Terraform configuration defines a Kubernetes namespace, application deployment, ClusterIP service, and a Prometheus/Grafana monitoring stack.



Before applying Terraform, ensure that Minikube is running, the Docker image is available inside the cluster, and the required tools are installed.



Initialize Terraform:



```bash

cd terraform

terraform init

terraform validate

terraform plan

```



Review the plan before applying it. The local Kubernetes setup avoids paid cloud infrastructure, but it still consumes local CPU, RAM, and disk space.



\## Limitations



\- Secret detection uses simple text patterns and can produce false positives or miss secrets.

\- The monitoring stack requires sufficient local resources.

\- The application is intended as a learning project and is not production-hardened.



\## License


This project is intended for educational use.





## Setup (new machine)

Prerequisites: Git, Docker Desktop (give it 6 GB+ RAM), Minikube, kubectl, Terraform, Gitleaks.

```bash
git clone https://github.com/YOUR_USERNAME/githook-shield.git
cd githook-shield
bash scripts/install-hooks.sh

minikube start --cpus=4 --memory=5120
cd terraform
terraform init
terraform apply
cd ..
kubectl apply -f k8s/monitoring-app.yaml
```

Access:
- App: `minikube service githook-shield -n githook-shield`
- Grafana: `kubectl port-forward -n monitoring deploy/kps-grafana 3000:3000` (admin / admin123, demo only)
- Prometheus: `kubectl port-forward -n monitoring svc/kps-kube-prometheus-stack-prometheus 9090`
- Alertmanager: `kubectl port-forward -n monitoring svc/kps-kube-prometheus-stack-alertmanager 9093`

Note: Terraform state is local and not committed. Only one person should run `terraform apply` per cluster.

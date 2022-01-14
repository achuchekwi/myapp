=====Terraform=====
Use the Terraform script to create infrastructure, follow steps below:

1 Install Kubernetes master on one machine and slave on another (Ref. https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)
2 Create 2 AMI's one for Master and one for slave based on the above instances
3 Delete thr master and slave instances
4 Run the Terraform script to create 2 master and 3 slave instances
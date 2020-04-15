#Output for expose EKS AMI ID
output "ami_eks_worker_id" {
  value = data.aws_ami.eks-worker.id
}
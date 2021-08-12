# EKS Cluster and Custom Nodegroup with Launch Template

**Architecture**

![architecture](https://github.com/GSNextLevel/neoTerraform/blob/main/image/custom_eks.png?raw=true)

<br>

**Sample `*.tfvars`**

```sh
vpc_cidr_block  = "10.0.0.0/20"
region          = "ap-northeast-2"
instance_type   = "t3.large"
image_id        = "Your AMI Name"
key_name        = "Your Key Name"
node_group_name = "Your Nodegroup Name"
```

<br>

## Trouble Shooting Knowhow

### EKS 워커노드와 노드그룹이 잘 생성되지 않을 때

1. [How can I get my worker nodes to join my Amazon EKS cluster?](https://aws.amazon.com/premiumsupport/knowledge-center/eks-worker-nodes-cluster/)
2. Launch Template에 들어가는 `userdata` 스트립트 (`/`, `''`, `공백`) 등을 수정



### Terraform으로 정의한 코드와 인프라의 형상이 일치하지 않을 때

`state list`, `import`, `-target` 등을 적절히 활용하여 인프라 형상을 동일하게 유지

- `terraform state list` : local의 형상 파악
- `terraform import aws_eks_cluster.eks_cluster {Cluster Name}` : 추가
- `terraform destroy -target aws_iam_role.eks-node` : 삭제


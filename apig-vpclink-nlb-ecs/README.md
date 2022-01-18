# Connect the ECS Fargate connected to NLB in the private subnet using API Gateway and vpc-link

**Architecture**

![architecture](https://github.com/GSNextLevel/neoTerraform/blob/main/image/apig-private.png?raw=true)

<br>

**Sample `*.tfvars`**

usage : `terraform plan -var-file=".tfvars"`

```sh
my_domain     = "google.com"
custom_domain = "api.google.link"
```

<br>

## Run Command

```shell
docker image pull nginx
```

<br>

## 한계

- workspace를 사용한 리소스 분리
- ACM 코드로 제어

<br>

## Trouble Shooting Knowhow

### Terraform으로 정의한 코드와 인프라의 형상이 일치하지 않을 때

`state list`, `import`, `-target` 등을 적절히 활용하여 인프라 형상을 동일하게 유지

- `terraform state list` : local의 형상 파악
- `terraform import aws_eks_cluster.eks_cluster {Cluster Name}` : 추가
- `terraform destroy -target aws_iam_role.eks-node` : 삭제

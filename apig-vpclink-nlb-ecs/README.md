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
- api resource가 여러개일 경우, (resource, method, integration)과 관련된 코드가 길어짐

  Swagger, Open API Json으로 관리해도, 통합 과정에서 1리소스 1통합으로 인한 코드 길이 증가

  ```terraform
  data "aws_api_gateway_rest_api" "my_rest_api" {
  name = "Swagger"
  }

  data "aws_api_gateway_resource" "my_resource" {
  rest_api_id = data.aws_api_gateway_rest_api.my_rest_api.id
  path        = "/"
  }

  resource "aws_api_gateway_integration" "test" {
  rest_api_id = data.aws_api_gateway_rest_api.my_rest_api.id
  resource_id = data.aws_api_gateway_resource.my_resource.id
  http_method = "POST"

  # Use Proxy Integration
  type                    = "HTTP_PROXY"
  uri                     = "https://www.google.de"
  integration_http_method = "POST"
  passthrough_behavior    = "WHEN_NO_MATCH"
  content_handling        = "CONVERT_TO_TEXT"

  connection_type = "VPC_LINK"
  connection_id   = aws_api_gateway_vpc_link.nginx-vpclink.id
  }
  ```

- API Gateway Deploy의 Mutable 하게 업데이트 하는 부분을 테라폼으로 관리할 방법은?
- 그 외 다수

<br>

## Trouble Shooting Knowhow

### Terraform으로 정의한 코드와 인프라의 형상이 일치하지 않을 때

`state list`, `import`, `-target` 등을 적절히 활용하여 인프라 형상을 동일하게 유지

- `terraform state list` : local의 형상 파악
- `terraform import aws_eks_cluster.eks_cluster {Cluster Name}` : 추가
- `terraform destroy -target aws_iam_role.eks-node` : 삭제

### CannotPullContainerError

```
STOPPED (CannotPullContainerError: inspect image has been retried 5 time(s): failed to resolve ref "docker.io/library/nginx:latest": failed to do request: Head https://registry-1.docker.io/v2/library/nginx/manifests/latest: dial tcp 52.72.252.48:443: i/o timeout)
```

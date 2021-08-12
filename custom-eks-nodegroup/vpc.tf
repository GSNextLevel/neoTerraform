resource "aws_vpc" "eks_vpc" {
  cidr_block = var.vpc_cidr_block

  tags = tomap({
    "Name"                                      = "terraform-eks-node"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared" # For 1.18 and earlier clusters
  })
}

resource "aws_subnet" "eks_subnet" {
  count = 3

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = "10.0.${count.index}.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.eks_vpc.id

  tags = tomap({
    "Name"                                      = "terraform-eks-node",
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"  # For 1.18 and earlier clusters
  })
}

resource "aws_internet_gateway" "eks_igw" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    Name = "terraform-eks"
  }
}

resource "aws_route_table" "eks_route_table" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks_igw.id
  }
}

resource "aws_route_table_association" "eks_association" {
  count = 3

  subnet_id      = aws_subnet.eks_subnet.*.id[count.index]
  route_table_id = aws_route_table.eks_route_table.id
}

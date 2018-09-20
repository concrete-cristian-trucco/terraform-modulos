Terraform web-site-examle Module.

Este módulo cria uma **infraestrutura básica WEB de exemplo** (elb, sg e ec2) e aceita os seguintes parâmetros:

**name** (Nome do recurso, por exemplo marketing-app)

**environment** (Ambiente do recurso, por exemplo qa, dev, production)

**subnets** (Uma lista de subnets onde estes recursos serão criados)

**vpc_id** (ID da VPC a ser usada na criação dos recursos)

## 노트북 PC 환경설정 
- Azure CLI 설치(linux) : 
```bash
1.Microsoft 리포지토리 키를 가져옵니다.
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

2.로컬 azure-cli 리포지토리 정보를 만듭니다.
echo -e "[azure-cli]
name=Azure CLI
baseurl=https://packages.microsoft.com/yumrepos/azure-cli
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/azure-cli.repo

3.설치 
sudo yum install azure-cli
```
  - 참고: https://docs.microsoft.com/ko-kr/cli/azure/install-azure-cli-linux?pivots=dnf 

## Azure 접속관련 환경 설정 
- Azure credentials 생성 : 
  - https://docs.microsoft.com/en-us/azure/virtual-machines/linux/build-image-with-packer#create-azure-credentials 

- Azure credentials 확인 및 az 로그인 : 
  - https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret

- Azure 환경변수 설정 (az cli를 통한 로그인으로 가능)  
  - export ARM_CLIENT_ID=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
  - export ARM_CLIENT_SECRET=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
  - export ARM_SUBSCRIPTION_ID=fxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
  - export ARM_TENANT_ID=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

## 테라폼 작업 시작 
```bash 
terraform init 
terraform plan
terraform apply  
```  
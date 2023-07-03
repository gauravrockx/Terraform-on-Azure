# Terraform-on-Azure
This repo has terraform code to learn basics for Azure infra creation

Before starting to learn Azure on Terraform, below are the pre-requisites :-
1. Azure Account
2. Microsoft Visual Code (Not mandatory but helpful to code in this IDE)

We will be using service principal to communicate to Azure Account, Add below details in providers.tf file

subscription_id = "###########################"

tenant_id = "#############################"

client_id = "#############################" 

client_secret = "###########################"

For subscription_id, navigate to Subscritpion on Azure portal.

For tenant_id, go to Azure Active directory.

For client_id, go to AAD -> App registrations -> New registration -> enter any name like terraform and register

For client_secret, go to newly create secret(terraform in our case) -> Certificates & secrets -> New client secret -> enter any name and add -> Copy the value of secret
  

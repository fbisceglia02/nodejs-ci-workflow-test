terraform {
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = "~>2.0"
        }
    }
}

provider "azurerm" {
  features {}
  subscription_id = "c550fb2d-3f43-40b7-9e36-f1d47f436e42"
  client_id       = "92c7d9c8-725f-4e4f-9bab-30c39a86d393"
  client_secret   = "pVJ8Q~x3i2EZalCu1TMG1hJPtdggQuXvjyQ2~bnQ"
  tenant_id       = "3370381d-b121-4cdb-a22a-12f8a6f8dc3f"
}

# Create a resource group right here
resource "azurerm_resource_group" "rg_test" {

    name = "terraform_test_rg"
    location = "East US"
  
}

# Define the App service plan (underlying infrastructure for the web app)
resource "azurerm_app_service_plan" "app_sp_test" {

    name = "my-app-service-plan"
    location = azurerm_resource_group.rg_test.name
    resource_group_name = azurerm_resource_group.rg_test.name
    sku {
        tier = "Basic"
        size = "Bi"
    }
}

# Define the Node.js web app
resource "azurerm_app_service" "app_svc_test" {

    name = "my-nodejs-webapp" 
    location =  azurerm_resource_group.rg_test.location
    resource_group_name = azurerm_resource_group.rg_test.name
    app_service_plan_id = azurerm_app_service_plan.app_sp_test.id

    site_config {

        # Node.js version to use
        node_version = "16.0.0"

        # Specify the startup command for your Node.js app (replace with your app's entry point)
        app_command = "node index.js"
    }

    app_settings {
        # Add any environment variables your Node.js app needs
        WEBSITE_NODE_DEFAULT_VERSION = "16.0.0"
    }
}

output "app_url" {
  value = azurerm_app_service.example.default_site_hostname
}
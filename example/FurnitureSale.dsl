workspace "Furniture Incorporated" "Context view to visualize the sales system for a furniture company" {

    model {
        customer = person "Furniture Customer" "A customer of the company who buys a piece of furniture" "Customer"
        
        
        system = softwareSystem "Sales System" "Internat sales system to create orders" "Sales" {
            webapp = container "Description" {
                customer -> this "Creates a purchase order" "Sales System"
            }
            
            backend = container "Back end" "Internal view of the server application" {
                databaseConnector = component "Database Connector" "Administer the connection to the database and executios queries"
                routeHandler = component "Routes Handler" "Creates all the REST routes to have a CRUD operations"
                purchaseController = component "Sales Controller" "handles all the necessary business logic to be able to create a sale"
                
                
                routeHandler -> purchaseController "Invokes the operations"
                purchaseController -> databaseConnector "Uses the database connection to create orders"
            }
        }
        
        client = softwareSystem "Web App" "Web browser application where products are listed" "Web Browser"
        server = softwareSystem "Backend" "Server application that create purchase orders" "Server"
        database = softwareSystem "Database" "Database system to keep a record of purchase orders" "Database"
        
        client -> server "HTTP request to create a purchase order"
        server -> database "Reads from and writes to"
                
        
    }

    views {
        
        
        systemContext system SalesContext "General view of how the sale system interacts with external actors" {
            include *
        }
        
        container system container {
            include *
        }
        
        component backend "Backend" {
            include *
        }

        styles {
            element "Person" {
                color #ffffff
                fontSize 22
                shape Person
            }
            element "Customer" {
                background #08427b
            }
            element "Software System" {
                background #1168bd
                color #ffffff
            }
            element "Existing System" {
                background #999999
                color #ffffff
            }
            element "Container" {
                background #438dd5
                color #ffffff
            }
            element "Web Browser" {
                shape WebBrowser
            }
            element "Mobile App" {
                shape MobileDeviceLandscape
            }
            element "Database" {
                shape Cylinder
            }
            element "Component" {
                background #85bbf0
                color #000000
            }
            element "Failover" {
                opacity 25
            }
        }
    }
}
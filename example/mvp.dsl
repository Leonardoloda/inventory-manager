workspace "Inventory MVP"{

    model {

        // Stake holders
        analyst = person "Analyst"
        provider = person  "Provider"
        client = person "Client"
        transport = person "Transport"
        admin = person "Admin"

        // External Systems
        buyer = softwareSystem "Sales Orders System" "Internal system used by the sales and purchase team to adquire new materials" "external"
        order = softwareSystem "Provider's System" "System provided by the providers to create purchase orders" "external"
        map = softwareSystem "Geolocation System" "External system to handle GeoLocation data" "external"
        notification = softwareSystem "Notification System" "System enabled to send notifications" "external"

        inventorySystem = softwareSystem "Inventory System" {
            description "Our system that handles all the inventory related information"
            tags "main"

            webApp = container "Web Application" "Web Application to manage inventory" "JavaScript" "web"
            mobileApp = container "Mobile App" "Mobile Application to check routes and availability" "Hybrid Apps" "mobile"
            
            sensors = container "IoT" "Real world sensors the fetch info about the inventory" "Amazon Kinesis" "sensor"

            DatabaseSystem = container "Database System" "Set of databases to store the data" {
                tags "database"

                stockDatabase = component "Stock Database" "Database to store products and amounts" "Elasticsearch" "database"
                orderDatabase = component "Order Database" "Database to store purchase orders" "SQL" "database"
            }

            Backend = container "API application" "MicroService based application" "Kubernetes" {
                tags = "Microservice"
                gateway = component "API" "A simple application to allow accessing the info" "Kubernetes" "API"

                ordersService = component "Orders Service" "MicroService to handle orders" "API"
                stockService = component "Stock service" "Microservice to handle stock qty" "API"
            }

            ReportStorage = container "Report application" "Consolidates system wide events into a report tool" "ELK" {
                collector = component "Data Aggregator" "A single point of entry to collect and parse data" "Python"

                collection = component "Data Storage" "Stores non structured events" "ElasticSearch"

                terminal = component "Data Visualization" "Simple UI to visualize reports" "Kibana"
            }
        }


        // Admnistration
        webApp -> gateway "Uses"
        mobileApp -> gateway "Uses"

        // Order management
        buyer -> gateway "Creates sales orders"
        provider -> gateway "Supplies stock to be registered"

        gateway -> ordersService "Stores the new order"
        ordersService -> orderDatabase "Updates the stored orders"
        ordersService -> order "Creates orders to restock products"

        // IoT integration
        sensors -> gateway "Sends stock info events"
        gateway -> stockService "Updates the quantities"
        stockService -> stockDatabase "Persists the data"

        // Reporting
        gateway -> collector "Process all events"
        collector -> collection "Stores all historical data"
        analyst -> terminal "Generates reports"
        collection -> terminal "Uses historical data from"

        // Routes planning
        client -> gateway "Creates purchase order"
        gateway -> ordersService "creates a new delivery order"
        ordersService -> orderDatabase "Stores the new delivery order"
        transport -> mobileApp "Gets the pending delivery orders"
        mobileApp -> map "Creates a route to deliver"

        // Administrator
        admin -> inventorySystem "Enables system wide configurations"

    }

    views {
        systemContext inventorySystem SalesContext "General view of how the sale system interacts with external actors" {
            include *
            autoLayout lr
        }

        component Backend {
            include *
            autoLayout lr
        }

        component ReportStorage {
            include *
            autoLayout lr
        }

        styles {
            element "main" {
                background #EEB0B0
                border solid
            }

            element "external" {
                background #9DD6FA
            }

            element "Person" {
                background #EF8C00
                shape Person
            }

            element "web" {
                background #a1b596
                shape WebBrowser
            }

            element "mobile" {
                background #a1b596
                shape MobileDeviceLandscape
            }

            element "database" {
                background #DCBBD8
                shape Cylinder
            }

            element "sensor" {
                background #FFFFF1
                shape Robot
            }
            
            element "Backend" {
                background #8E8D9F
            }

            element "Microservice" {
                background #BADDFF
            }

            element container {
                shape Component
            }
        }
    }

    configuration {
        scope softwaresystem
    }

}
workspace {

    model {
        user = person "Felhasználó" "A felhasználók, akik a webalkalmazást használják"
        PerimeterD = softwareSystem "Határvédelem (CloudFlare)" "Határvédelmi megoldás az alkalmazás biztonságos elérésének biztosítására"
        AuthService = softwareSystem "Hitelesítő szolgáltatás (Google)" "OpenID alapú hitelesítő szolgáltatás" "Google"
        EventManager = softwareSystem "Event Manager" "Egy megoldás, amely segítséget nyújt az események szervezéséhez" {
            webApp = container "Webalkalmazás" "A statikus web tartalmakat biztosítja a felhasználó számára" "Java and Spring MVC"
            spApp = container "Single-Page alkalmazás" "A felhasználó böngészőjében megvalósított felületi funkcionalitást biztosítja" "JavaScript and Angular"
            apiApplication = container "API alkalmazás" "A funkcionalitás biztosítása JSON/HTTPS API-n keresztül" "Java and Spring MVC" {
//                authenticationController = component "Bejelentkezés-vezérlő" "A felhasználók bejelentkezésének biztosítása" "Spring MVC Rest Controller"
                personController = component "Személy-vezérlő" "A Személy objektumok kezelése" "Spring MVC Rest Controller"
                eventController = component "Esemény-vezérlő" "Az Esemény objektumok kezelése" "Spring MVC Rest Controller"
                organizationController = component "Szervezet-vezérlő" "A Szervezet objektumok kezelése" "Spring MVC Rest Controller"
            }
            database = container "Adatbázis" "Adatok tárolása és elérés biztosítása" "MariaDB" "Database"
        }
        user -> PerimeterD "Oldal elérési kérések" "HTTPS" "sync"
        PerimeterD -> user "Oldal elérési kérések kiszolgálása" "HTTPS" "sync"
        PerimeterD -> EventManager "Oldal elérési kérések továbbítása" "HTTPS" "sync"
        EventManager -> PerimeterD "Oldal elérési kérések továbbításának kiszolgálása" "HTTPS" "sync"
//        user -> AuthService "OpenID hitelesítés igény" "HTTPS" "sync"
//        AuthService -> user "OpenID hitelesítési adatok" "HTTPS" "sync"


//        user -> webApp "Az oldal meglátogatása" "HTTPS" "sync"
//        user -> spApp "Felhasználói felületi funkciók használata" "HTTPS" "sync"
        PerimeterD -> webApp "Az oldal meglátogatása" "HTTPS" "sync"
        PerimeterD -> spApp "Felhasználói felületi funkciók használata" "HTTPS" "sync"
        spApp -> AuthService "OpenID hitelesítés igény" "HTTPS" "sync"
        AuthService -> spApp "OpenID hitelesítési adatok" "HTTPS" "sync"

        webApp -> spApp "A felhasználó web böngészőjének kiszolgálása" "HTTPS" "sync"

//        apiApplication -> database "Olvasás és írás" "SQL/TCP" "sync"

//        spApp -> authenticationController "API hívások" "JSON/HTTPS" "sync"
        spApp -> personController "API hívások" "JSON/HTTPS" "sync"
        spApp -> eventController "API hívások" "JSON/HTTPS" "sync"
        spApp -> organizationController "API hívások" "JSON/HTTPS" "sync"



//        authenticationController -> database "Olvasás és írás" "SQL/TCP" "sync"
        personController -> database "Olvasás és írás" "SQL/TCP" "sync"
        eventController -> database "Olvasás és írás" "SQL/TCP" "sync"
        organizationController -> database "Olvasás és írás" "SQL/TCP" "sync"




/*        user -> webapp "Kérések elküldése" "http" "sync"
        user -> webapp "Hitelesítés" "http" "sync"
        webapp -> user "Kérések kiszolgálása" "http" "sync"
        webapp -> database "Adatok olvasása és írása"
*/
    }

    views {
        systemLandscape {
            include user
            include EventManager
            include PerimeterD
            include AuthService
            autoLayout
        }

/*        systemContext EventManager {
            include user
            include EventManager
            autolayout lr
        }
*/
        container EventManager {
            include user
            include * 
            autolayout lr
        }

        component apiApplication "Components" {
            include *
            autoLayout
            description "The component diagram for the API Application."
        }


        theme default

        styles {
            element "Person" {
                color #ffffff
                fontSize 22
                shape Person
            }
            element "Software System" {
                background #1168bd
                color #ffffff
            }
            element "Container" {
                background #438dd5
                color #ffffff
            }
            element "Web Browser" {
                shape WebBrowser
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
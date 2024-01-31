workspace {
    model {
        user = person "Neovim Enjoyer"
        softwareSystem = softwareSystem "Neovim" {
            editor = container "Neovim Base" {
                user -> this "Uses"
            }
            plugin = container "Todoist.nvim" {
                filetype = component "Custom Todoist Filetype" 
                
                editor -> this "Utilizes Commands"
            }
        }
    }

    views {
        systemContext softwareSystem {
            include *
            autolayout lr
        }

        container softwareSystem {
            include *
            autolayout lr
        }

        theme default
    }

}

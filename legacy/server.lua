local conf, f = require( "conf" ), require( "lib" )

--------------------------------------------------------------------------------

local function application()
    local menu = {}
    menu.title = conf.srv.title
    menu.message = "Use arrow keys to navigate, 'enter' to select"
    menu.selected = 1
    menu.options = {}

    menu.options[1] = {
        text = "Back to main menu",
        action = function()
            dofile( "main.lua" )
        end
    }

    menu.options[2] = {
        text = "Update images",
        action = function()
            os.execute(conf.srv.update)
        end
    }

    menu.options[3] = {
        text = "Back up config and volumes",
        action = function()
            local stamp = os.date("%Y-%m-%d")
            os.execute( 
                "sudo tar -zcvf " 
                .. conf.srv.bu_path 
                .. "/" 
                .. stamp 
                .. "_burij_Sicherung_config.tar.gz " 
                .. conf.srv.path
            )
            os.execute( 
                "sudo zip -r " 
                .. conf.srv.bu_path 
                .. "/" 
                .. stamp 
                .. "_burij_Sicherung_volumes " 
                .. conf.srv.vol_path 
            )
        end
    }

    menu.options[4] = {
        text = "Start up server",
        action = function()
            os.execute( "cd " .. conf.srv.path .. " && sudo docker compose up -d" )
        end
    }

    menu.options[5] = {
        text = "Shut down server",
        action = function()
            os.execute( "sudo docker stop $(sudo docker ps -a -q)" )
        end
    }

    menu.options[6] = {
        text = "Delete docker garbage",
        action = function()
            os.execute( 
                "sudo docker stop $(sudo docker ps -a -q); "
                .. "sudo docker rm $(sudo docker ps -a -q); "
                .. "sudo docker rmi $(sudo docker images -qf 'dangling=true')"
            )
        end
    }

    menu.options[7] = {
        text = "Rescan Nextcloud files",
        action = function()
            os.execute( 
                conf.srv.docker 
                .. conf.srv.nc 
                .. "chown -R 33:0 /srv/ncdata/ -v; "
                .. conf.srv.docker 
                .. conf.srv.nc 
                .. "chmod -R 750 /srv/ncdata/ -v; "
                .. conf.srv.docker 
                .. "--user www-data -it" 
                .. conf.srv.nc 
                .. "php occ files:scan --all -v"
            )
        end
    }

    menu.options[8] = {
        text = "Write blog entry",
        action = function()
            os.execute( conf.srv.blog )
        end
    }

    menu.options[9] = {
        text = "Edit homepage",
        action = function()
            os.execute( conf.srv.home )
        end
    }

    menu.options[10] = {
        text = "Settings",
        action = function()
            os.execute("nano " .. conf.srv.config)
        end
    }

    menu.options[11] = {
        text = "Exit",
        action = function() 
            os.exit() 
        end
    }

    f.do_draw_menu(menu)
end

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
application()
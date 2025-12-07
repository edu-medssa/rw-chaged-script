#!/bin/bash

    wget https://github.com/edu-medssa/web_template/raw/refs/heads/main/main.zip -O main.zip
    sudo mkdir -p /opt/main
    sudo mkdir -p /opt/temp
    sudo unzip -o /root/main.zip -d /opt/temp
    
    cd /opt/temp/sni-templates-main/filecloud
    # rm -rf assets "README.md" #"index.html"
    RandomHTML="/opt/temp/sni-templates-main/filecloud"
    
    #Manage Template for steal
    ManageTemplate() {
    
    local random_meta_id=$(openssl rand -hex 16)
    local random_comment=$(openssl rand -hex 8)
    local random_class_suffix=$(openssl rand -hex 4)
    local random_title_prefix="RusBar_"
    local random_title_suffix=$(openssl rand -hex 4)
    local random_footer_text="Designed by Rus Bar for User_${random_title_suffix}"
    local random_id_suffix=$(openssl rand -hex 4)

    local meta_names=("viewport-id" "session-id" "track-id" "render-id" "page-id" "config-id")
    local meta_usernames=("Rusbar63961" "Rusbar64561" "Rusbar63963" "Rusbar73961" "Rusbar63951" "Rusbar11961" "Rusbar63111" "Rusbar19961" "Rusbar21961" "Rusbar61461")
    local random_meta_name=${meta_names[$RANDOM % ${#meta_names[@]}]}
    local random_username=${meta_usernames[$RANDOM % ${#meta_usernames[@]}]}

    local class_prefixes=("style" "data" "ui" "layout" "theme" "view")
    local random_class_prefix=${class_prefixes[$RANDOM % ${#class_prefixes[@]}]}
    local random_class="$random_class_prefix-$random_class_suffix"
    local random_title="${random_title_prefix}${random_title_suffix}"

    find "$RandomHTML" -type f -name "*.html" -exec sed -i \
        -e "s|<!-- Website template by freewebsitetemplates.com -->||" \
        -e "s|<!-- Theme by: WebThemez.com -->||" \
        -e "s|<a href=\"http://freewebsitetemplates.com\">Free Website Templates</a>|<span>${random_footer_text}</span>|" \
        -e "s|<a href=\"http://webthemez.com\" alt=\"webthemez\">WebThemez.com</a>|<span>${random_footer_text}</span>|" \
        -e "s|id=\"Content\"|id=\"rnd_${random_id_suffix}\"|" \
        -e "s|id=\"subscribe\"|id=\"sub_${random_id_suffix}\"|" \
        -e "s|<title>.*</title>|<title>${random_title}</title>|" \
        -e "s|</head>|<meta name=\"$random_meta_name\" content=\"$random_meta_id\">\n<!-- $random_comment -->\n</head>|" \
        -e "s|</[Hh][Ee][Aa][Dd]\s*>|<meta name=\"$random_meta_name\" content=\"$random_meta_id\">\n<!-- $random_comment -->\n</head>|" \
        -e "s|<body|<body class=\"$random_class\"|" \
        -e "s|CHANGEMEPLS|$random_username|g" \
    {} \;

    find "$RandomHTML" -type f -name "*.css" -exec sed -i \
        -e "1i\/* $random_comment */" \
        -e "1i.$random_class { display: block; }" \
        {} \;

    kill "$spinner_pid" 2>/dev/null
    wait "$spinner_pid" 2>/dev/null
    printf "\r\033[K" > /dev/tty

    if [[ -d "${RandomHTML}" ]]; then
        if [[ ! -d "/opt/main/" ]]; then
            mkdir -p "/opt/main/" || { echo "Failed to create /opt/main/"; exit 1; }
        fi
        rm -rf /opt/main/*
        cp -a "${RandomHTML}"/. "/opt/main/"
    elif [[ -f "${RandomHTML}" ]]; then
        cp "${RandomHTML}" "/opt/main/"
        echo "Copied"
    else
        echo "Error" && exit 1
    fi

    if ! find "/opt/main/" -type f -name "*.html" -exec grep -q "$random_meta_name" {} \; 2>/dev/null; then
        echo -e "FAILED_TO_MODIFY_HTML_FILES"
        return 1
    fi
}
ManageTemplate
rm -f /root/main.zip
# sudo rm -rf /opt/temp

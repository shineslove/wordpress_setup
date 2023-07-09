# Note-to-self: Docker setup bash shell default
checkPHPAvailable() {
    if [[ -z $(command -v php) ]]; then
        sudo apt-get update
        sudo apt-get install php -y
        sudo apt-get install php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip php-fpm -y
        echo false
        return
    fi
    echo true
}

installCLI() {
    if [[ -z $(command -v wp) ]]; then
        cd /tmp
        curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
        chmod +x wp-cli.phar
        sudo mv wp-cli.phar /usr/local/bin/wp
    fi
}

ensureInstalled() {
    for pkg in "$@"
    do
        if [[ -z $(command -v $pkg) ]]; then
            echo "$pkg is not found, installing..."
            case "$pkg" in
                mysql) sudo apt install mysql-server mysql-client -y
                    ;;
                *) sudo apt install $pkg -y
                    ;;
            esac

        fi
    done
}

installCompletion() {
    if [[ -z $(cat $HOME/.bashrc | grep -i wp-completion) ]]; then
        cd /tmp
        curl -O https://raw.githubusercontent.com/wp-cli/wp-cli/v2.8.1/utils/wp-completion.bash
        sudo mv wp-completion.bash /usr/share/bash-completion/
        echo "source /usr/share/bash-completion/wp-completion.bash" >> $HOME/.bashrc
    fi
}

setupWPCLI() {

    # makes me want to write bousch
    output=$(checkPHPAvailable)

    if [[ $output == "false" ]]; then
        echo "PHP is not installed."
        return
    fi

    installCLI

    installCompletion

    pkgs_to_check=( nginx php mysql)

    ensureInstalled "${pkgs_to_check[@]}"

}

setupWPCLI

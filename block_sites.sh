#!/bin/bash

# Este script bloqueia ou desbloqueia o acesso a sites específicos no Linux, 
# utilizando o arquivo /etc/hosts para redirecionar domínios bloqueados para 127.0.0.1.
# Ele foi adaptado para lidar com listas de sites no formato usado por StevenBlack/hosts.
# Fonte: https://github.com/StevenBlack/hosts

# Caminho para o arquivo /etc/hosts
HOSTS_FILE="/etc/hosts"
# IP para redirecionar (localhost)
REDIRECT_IP="127.0.0.1"
# Diretório base das categorias de sites a serem bloqueados
CATEGORIES_DIR="categories"

# Função para adicionar sites ao arquivo /etc/hosts
block_sites() {
    category="$1"
    category_file="$CATEGORIES_DIR/$category/list.txt"
    
    # Verifica se o arquivo da categoria existe
    if [[ -f "$category_file" ]]; then
        # Lê o arquivo linha por linha
        while IFS= read -r line; do
            # Ignora linhas de comentários ou linhas em branco
            if [[ $line == \#* ]] || [[ -z "$line" ]]; then
                continue
            fi
            
            # Extrai o domínio da linha que começa com "0.0.0.0"
            domain=$(echo "$line" | awk '{print $2}')
            
            # Verifica se o domínio já está no arquivo hosts
            if ! grep -q "$domain" "$HOSTS_FILE"; then
                echo "Bloqueando $domain da categoria $category..."
                # Adiciona o domínio ao arquivo hosts
                echo "$REDIRECT_IP $domain" | sudo tee -a "$HOSTS_FILE" > /dev/null
            else
                echo "$domain da categoria $category já está bloqueado."
            fi
        done < "$category_file"
    else
        echo "A categoria $category não existe."
    fi
}

# Função para remover sites bloqueados do arquivo /etc/hosts
unblock_sites() {
    category="$1"
    category_file="$CATEGORIES_DIR/$category/sites_list.txt"

    # Verifica se o arquivo da categoria existe
    if [[ -f "$category_file" ]]; then
        while IFS= read -r line; do
            # Ignora linhas de comentários ou linhas em branco
            if [[ $line == \#* ]] || [[ -z "$line" ]]; then
                continue
            fi
            
            # Extrai o domínio da linha que começa com "0.0.0.0"
            domain=$(echo "$line" | awk '{print $2}')
            
            # Verifica se o domínio está no arquivo hosts
            if grep -q "$domain" "$HOSTS_FILE"; then
                echo "Desbloqueando $domain da categoria $category..."
                # Remove o domínio do arquivo hosts
                sudo sed -i".bak" "/$domain/d" "$HOSTS_FILE"
            else
                echo "$domain da categoria $category não está bloqueado."
            fi
        done < "$category_file"
    else
        echo "A categoria $category não existe."
    fi
}

# Função para bloquear ou desbloquear todas as categorias
process_all_categories() {
    action="$1"
    
    for category_dir in "$CATEGORIES_DIR"/*/; do
        category=$(basename "$category_dir")
        "$action"_sites "$category"
    done
}

# Menu de opções
case "$1" in
    block)
        if [[ -n "$2" ]]; then
            block_sites "$2"
        else
            process_all_categories "block"
        fi
        ;;
    unblock)
        if [[ -n "$2" ]]; then
            unblock_sites "$2"
        else
            process_all_categories "unblock"
        fi
        ;;
    *)
        echo "Uso: $0 {block|unblock} [categoria]"
        echo "Exemplo: $0 block social"
        exit 1
        ;;
esac

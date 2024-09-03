# Website Moderator

Este projeto em Shell Script permite bloquear e desbloquear o acesso a websites específicos no Linux, organizados em categorias. Ele utiliza o arquivo `/etc/hosts` para redirecionar os domínios bloqueados para `127.0.0.1`.

### Estrutura

- `categories/`: Contém subpastas para cada categoria de sites (ex: `social`, `entertainment`, `news`...).
- Cada subpasta contém um arquivo `list.txt` com a lista de sites a serem bloqueados naquela categoria.

### Como usar

1. Adicione os sites que você deseja bloquear nos arquivos `list.txt` correspondentes em cada categoria.
2. Execute o script `block_sites.sh` com as seguintes opções:

- **Bloquear todas as categorias**
    ```bash
    sudo ./block_sites.sh block
    ```
- **Bloquear uma categoria específica**
    ```bash
    sudo ./block_sites.sh block social
    ```

- **Desbloquear todas as categorias**
    ```bash
    sudo ./block_sites.sh unblock
    ```

- **Desbloquear uma categoria específica**
    ```bash
    sudo ./block_sites.sh unblock social
    ```

> [!IMPORTANT]
> Este script requer permissões de superusuário para modificar o arquivo `/etc/hosts`. Por isso, pode ser necessário usar sudo ao executá-lo.


### Como Permitir a Execução

Siga os mesmos passos de antes para tornar o script executável:

```bash
chmod +x block_sites.sh
```

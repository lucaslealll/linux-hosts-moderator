# Website Moderator

**LAST LIST UPDATE: 2024-09-03**

This project provides scripts for blocking and unblocking access to specific websites on both Linux and Windows. Sites are organized into categories and redirected to `127.0.0.1` by modifying the `hosts` file. 

> [!NOTE]
> The lists of sites are extracted from the repository [StevenBlack/hosts](https://github.com/StevenBlack/hosts?tab=readme-ov-file).

## Structure

- **`categories/`**: Contains subdirectories for each site category (e.g., `social`, `entertainment`, `news`, etc.).
- Each subdirectory contains a `sites_list.txt` file with the list of sites to be blocked for that category.

## Linux

The Linux script is written in Shell Script and uses the `/etc/hosts` file to redirect blocked domains.

### How to Use

1. Add the sites you want to block to the `sites_list.txt` files in the appropriate category subdirectories.
2. Run the `block_sites.sh` script with the following options:

- **Block all categories**
    ```bash
    sudo ./block_sites.sh block
    ```

- **Block a specific category**
    ```bash
    sudo ./block_sites.sh block social
    ```

- **Unblock all categories**
    ```bash
    sudo ./block_sites.sh unblock
    ```

- **Unblock a specific category**
    ```bash
    sudo ./block_sites.sh unblock social
    ```

> [!IMPORTANT]
> This script requires superuser permissions to modify the `/etc/hosts` file. Therefore, you may need to use `sudo` to run it.

### How to Make the Script Executable

Run the following command to make the script executable:

```bash
chmod +x block_sites.sh
```

## Windows

The Windows script is written in PowerShell and manipulates the `hosts` file located at `C:\Windows\System32\drivers\etc\hosts`.

### How to Use

1. Add the sites you want to block to the `sites_list.txt` files in the appropriate category subdirectories.
2. Open PowerShell as Administrator and run the `block_sites.ps1` script with the following options:

- **Block all categories**
    ```powershell
    .\block_sites.ps1 block
    ```

- **Block a specific category**
    ```powershell
    .\block_sites.ps1 block social
    ```

- **Unblock all categories**
    ```powershell
    .\block_sites.ps1 unblock
    ```

- **Unblock a specific category**
    ```powershell
    .\block_sites.ps1 unblock social
    ```

> [!IMPORTANT]
> This script needs to be run as Administrator to modify the `hosts` file. Make sure to open PowerShell with elevated permissions.

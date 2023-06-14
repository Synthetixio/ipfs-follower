# MacOS installation instructions

### 1. Download the latest IPFS release for macOS
   - Visit the IPFS distribution page at https://dist.ipfs.io/#go-ipfs
   - Download the macOS version that matches your system's architecture (either ARM64 or AMD64)

### 2. Extract the IPFS archive
   - Locate the downloaded .tar.gz file in the Downloads folder
   - Double-click the file to extract its contents

### 3. Move the extracted `ipfs` executable to /usr/local/bin
   1. Open `/usr/local/bin` folder in Finder
   2. From the menu bar, click on the "Go" menu.
   3. Choose "Go to Folder..." or press Shift + Cmd + G.
   4. In the "Go to the folder" dialog box, enter /usr/local/bin and click on "Go" or press Enter.
   5. Open Finder and go to the extracted go-ipfs folder
   6. Locate the `ipfs` executable
   7. Move the `ipfs` executable to the /usr/local/bin folder using drag-and-drop

### 4. Configure IPFS
   1. Open Finder.
   2. From the menu bar, click on the "Go" menu.
   3. Choose "Go to Folder..." or press `Shift + Cmd + G`.
   4. In the "Go to the folder" dialog box, enter `~/.ipfs` and click on "Go" or press Enter.
   5. Locate the `config` file, right-click on it, and select "Open With" > "TextEdit" or another text editor.
   6. Find the "API" section and add the following lines under "HTTPHeaders":

      ```json
      "Access-Control-Allow-Origin": [
        "*"
      ],
      "Access-Control-Allow-Methods": [
        "PUT",
        "POST",
        "GET"
      ],
      ```

      Make sure the added lines are formatted correctly and match the surrounding JSON structure.

   7. Find the "Swarm" section. In the "Swarm" section, locate the "ConnMgr" section and update the values as follows:

      ```json
      "ConnMgr": {
        "GracePeriod": "1m0s",
        "HighWater": 40,
        "LowWater": 20,
        "Type": "basic"
      },
      ```

      Make sure the added lines are formatted correctly and match the surrounding JSON structure.

   8. Save the changes and close the text editor.

### 5. Set up IPFS to autostart on login:

   1. Open `Automator` (you can find it by searching in Spotlight).
   2. Click on `New Document`, then choose `Application` and click `Choose`.
   3. In the `Actions` library on the left, search for `Run Shell Script` and drag it to the workflow area on the right.
   4. In the `Run Shell Script` box, replace the text with the following command:

      ```sh
      /usr/local/bin/ipfs daemon --init
      ```

   5. Click on `File` > `Save` in the top menu, and save the Automator application with a name like `IPFS Autostart` in the `/Applications` folder.
   6. Open `System Preferences`, and search for `Login Items`.
   7. In `Open at Login` section click the `+` button and navigate to the `/Applications` folder.
   8. Select the `IPFS Autostart` application you just created, and click `Add`.

### 6. Download the latest IPFS Cluster Follow release for macOS
   - Visit the IPFS Cluster distribution page at https://dist.ipfs.io/#ipfs-cluster-follow
   - Download the macOS version that matches your system's architecture (either ARM64 or AMD64)

### 7. Extract the IPFS Cluster Follow archive
   - Locate the downloaded .tar.gz file in the Downloads folder
   - Double-click the file to extract its contents

### 8. Move the extracted `ipfs-cluster-follow` executable to /usr/local/bin
   1. Open `/usr/local/bin` folder in Finder
   2. From the menu bar, click on the "Go" menu.
   3. Choose "Go to Folder..." or press Shift + Cmd + G.
   4. In the "Go to the folder" dialog box, enter `/usr/local/bin` and click on "Go" or press Enter.
   5. Open Finder and go to the extracted ipfs-cluster-follow folder
   6. Locate the `ipfs-cluster-follow` executable
   7. Move the `ipfs-cluster-follow` executable to the /usr/local/bin folder using drag-and-drop

### 9. Configure IPFS Cluster Follow

   1. Open `Terminal` (you can find it by searching in Spotlight).
   2. Paste the following command into the terminal and press Enter:
      ```sh
      /usr/local/bin/ipfs-cluster-follow synthetix init "http://127.0.0.1:8080/ipns/k51qzi5uqu5dj0vqsuc4wyyj93tpaurdfjtulpx0w45q8eqd7uay49zodimyh7"
      ```

### 10. Set up IPFS Cluster Follow to autostart on login

   1. Open `Automator` (you can find it by searching in Spotlight).
   2. Click on `New Document`, then choose `Application` and click `Choose`.
   3. In the `Actions` library on the left, search for `Run Shell Script` and drag it to the workflow area on the right.
   4. In the `Run Shell Script` box, replace the text with the following command:

      ```sh
      /usr/local/bin/ipfs-cluster-follow synthetix run
      ```

   5. Click on `File` > `Save` in the top menu, and save the Automator application with a name like `IPFS Cluster Follow Autostart` in the `/Applications` folder.
   6. Open `System Preferences`, and search for `Login Items`.
   7. In `Open at Login` section click the `+` button and navigate to the `/Applications` folder.
   8. Select the `IPFS Cluster Follow Autostart` application you just created, and click `Add`.

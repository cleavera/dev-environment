 #!/bin/sh

if passwd -S root | grep -q "NP"; then
    echo "Root password not set. Setting it now..."
    sudo passwd

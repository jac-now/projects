# Description: Install common software using winget package manager
winget install -e -h --accept-source-agreements --accept-package-agreements --id Adobe.Acrobat.Reader.64-bit --scope machine;
winget install -e -h --accept-source-agreements --accept-package-agreements --id Mozilla.Firefox --scope machine;
winget install -e -h --accept-source-agreements --accept-package-agreements --id Google.Chrome --scope machine;
winget install -e -h --accept-source-agreements --accept-package-agreements --id Microsoft.Office --scope machine;
winget install -e -h --accept-source-agreements --accept-package-agreements --id Microsoft.Teams --scope machine;
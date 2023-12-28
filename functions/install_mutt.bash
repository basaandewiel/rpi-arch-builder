sudo pacman -Suy neomutt
# - if you are using gmail as SMTP-server:
sudo pacman -Suy cyrus-sasl 
read -p "edit config file (zie backup /etc/muttrc) hier moet je het app specifieke wachtwoord invullen" key
#
neomutt -F /etc/muttrc
#testmail: 
echo "dit is een test" | neomutt -F /etc/muttrc -s "testmail" -a <attachmentfile> -- bas.aan.de.wiel@gmail.com
#
#

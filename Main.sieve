require [ "mailbox" , "relational" , "fileinto" , "variables" , "imap4flags" , "regex" , "copy" , "subaddress" ];

## Flag: syscategory|UniqueId:0|Rulename: $social
if allof( 
	not hasflag :is "$social",
	anyof(
		address :detail "To" "social",
		header :contains "from" 
			[
				"facebook.com",
				"twitter.com", 
				"youtube.com", 
				"plus.google.com", 
				"vimeo.com", 
				"tumblr.com", 
				"pinterest.com",
				"instagram.com", 
				"flickr.com",
				"xing.com",
				"linkedin.com"
			]
		)
	)
{
    addflag "$social" ;
}

## Flag: syscategory|UniqueId:1|Rulename: $purchases
if allof(
	not hasflag :is "$purchases",
	header :contains "from" 
		[
		"amazon.de" , "paypal.de" , "ebay.de" , "ebay-kleinanzeigen.de" , "zalando.de" , "immobilienscout24.de" , "autoscout24.de" , "notebooksbilliger.de" , "otto.de" , "tchibo.de" , "lidl.de" , "aldi.de" , "aliexpress.com" , "bonprix.de" , "conrad.de" , "reichelt.de" , "orders.apple.com" , "euro.apple.com" , "cyberport.de" , "alternate.de" , "audible.de" , "steampowered.com" , "mytoys.de" , "ikea.com" , "hm.com" , "mediamarkt.de" , "saturn.de"
		]
	) 
{
    addflag "$purchases" ;
}

## Flag: |UniqueId:2|Rulename: Filter into folders
if allof( 
    address :user :regex "To" "(.+)",
	# I would like some of my mail to go the the inbox directly
    not address :user :matches "To" ["aleks*","alex*"])
{
	# Store the user part
	set "user" "${1}";
	# check if the detail is not empty
	if address :detail :regex "To" "(.+)" 	{
		# Store into a subfolder of the user folder
		# I also want to create that subfilder if it doesn't exist
		# I would like to store the mail in the Inbox if the user folder doesn't exist but this looks sufficient for now
		fileinto :create "INBOX/${user}/${1}";
	}else{
		# If the user folder exists put the mail there
		# Otherwis go to the inbox
		fileinto "INBOX/${user}";
	}
}

## Flag: |UniqueId:3|Rulename: asdfsdf
##if header :contains "To" "asdf" 
##{
##    fileinto "INBOX" ;
##}

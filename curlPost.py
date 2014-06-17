import os

import sys

argn = len(sys.argv)
argv = sys.argv
print argn
if argn != 5:
	print """
	Usage: python curlPost.py HOSTNAME PORT USERNAME PASSWORD
	After setup, you'll be able to POST to the host.
	"""
	quit()

print """Usage Example: 
[POST | PUT] api/url/path path/to.xml
"""

while True:
	userinput = raw_input().split(" ");
	if len(userinput)!=3:
		print "Misformatted command, expect 2 args got none"
		continue

	curlString = "curl -X "+userinput[0]+" --data-binary @" +userinput[2]+" --user "+argv[3]+":"+argv[4]+" https://"+argv[1]+":"+argv[2]+"/"+userinput[1] + " --insecure"

	print curlString
	os.system(curlString);
	print "------"

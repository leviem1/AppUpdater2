#!/bin/bash
killall Safari > /dev/null
# Set your variable values here
bud='/usr/libexec/Plistbuddy'
plist='/Users/NWEA/Library/Preferences/com.apple.Safari.plist'
 
urls=('http://co.testnav.com/'
'http://epat-parcc.testnav.com'
'http://systemcheck.co.testnav.com')
 
#Remove plist to start fresh
echo "Removing Safari .plist..."
rm -f "$plist"
 
killall cfprefsd > /dev/null
 
${bud} -c "Add :ManagedPlugInPolicies:com.oracle.java.JavaAppletPlugin:PlugInHostnamePolicies array" ${plist}
 
for i in "${!urls[@]}"
do
	domain=$(echo ${urls[$i]} | cut -d'/' -f3)
	#echo "Setting to run in unsafe mode: ${urls[$i]}..."
	echo "Setting to run in unsafe mode: $domain..."
	${bud} -c "Add :ManagedPlugInPolicies:com.oracle.java.JavaAppletPlugin:PlugInHostnamePolicies:$i dict" ${plist}
	${bud} -c "Add :ManagedPlugInPolicies:com.oracle.java.JavaAppletPlugin:PlugInHostnamePolicies:$i:PlugInPageURL string ${urls[$i]}" ${plist}
	${bud} -c "Add :ManagedPlugInPolicies:com.oracle.java.JavaAppletPlugin:PlugInHostnamePolicies:$i:PlugInHostname string $domain" ${plist}
	${bud} -c "Add :ManagedPlugInPolicies:com.oracle.java.JavaAppletPlugin:PlugInHostnamePolicies:$i:PlugInRunUnsandboxed bool YES" ${plist}
	${bud} -c "Add :ManagedPlugInPolicies:com.oracle.java.JavaAppletPlugin:PlugInHostnamePolicies:$i:PlugInPolicy string PlugInPolicyAllowWithSecurityRestrictions" ${plist}
done
 
killall cfprefsd
defaults read com.apple.Safari > /dev/null
 
# Enable pop-ups 
echo "Enabling pop-ups..."
defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically 1
defaults write com.apple.Safari  com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool true

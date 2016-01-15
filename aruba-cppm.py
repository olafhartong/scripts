import argparse
import commands

parser = argparse.ArgumentParser (description='Calculate clearpass arubasupport password')
parser.add_argument('supportkey', help="CPPM Support key")
args = parser.parse_args()

OBFUSCATION_STRING="12%JHA7$%344dggashas&*&$*(QN&*ASDHSFS&>SDL#31&"
OBFUSCATION_STRING34="A%DSG%TQ!@!323SD67rfde5$#$^&eWszfse112sdfsrtwea"
if args.supportkey[:2] == "02":
        cmd = "echo \""  + args.supportkey[2:] + "\" | openssl aes-128-cbc -k \'" + OBFUSCATION_STRING + "\' -d -a"
if args.supportkey[:2] == "03":
        cmd = "echo \""  + args.supportkey[2:] + "\" | openssl aes-128-cbc -k \'" + OBFUSCATION_STRING34 + "\' -d -a"
if args.supportkey[:2] == "04":
        cmd = "echo \""  + args.supportkey[2:] + "\" | openssl aes-128-cbc -k \'" + OBFUSCATION_STRING34 + "\' -d -a -md sha1"
status, output = commands.getstatusoutput(cmd)
if status != 0:
        msg = "ERROR: Decrypting support key failed. Cause = %s" %(output)
        raise Exception, msg
print output

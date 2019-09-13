# from subprocess import Popen, PIPE


# proc = Popen("terraform apply",stdout=PIPE, stdin=PIPE, stderr=PIPE,universal_newlines=True)
# proc.stdin.write("{}\n".format("yes"))
# out,err = proc.communicate(input="{}\n".format("yes"))

import os

os.system("terraform apply | yes")
# os.system("yes")
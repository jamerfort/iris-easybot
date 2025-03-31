import glob
import os
import iris
from iris import ipm

# switch namespace to the %SYS namespace
iris.system.Process.SetNamespace("%SYS")

# set credentials to not expire
iris.cls('Security.Users').UnExpireUserPasswords("*")

# switch namespace to IRISAPP built by merge.cpf
iris.system.Process.SetNamespace("IRISAPP")

# Load src/cls
errorlog = iris.ref("")
iris.cls('%SYSTEM.OBJ').LoadDir("/home/irisowner/dev/src/cls", "cuk", errorlog, 1)

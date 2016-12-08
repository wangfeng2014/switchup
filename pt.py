#!/usr/bin/python
from Tkinter import *
from tkMessageBox import *
import commands

def applyswitch():
    newmode = v.get()
    if newmode == 'wifi' or newmode == '4g':
        commands.getoutput('./t.sh ' + newmode)
        tips['text'] = reboottext
        if askokcancel(title='Reboot', message="Do you want reboot to apply the new configuration?"):
            commands.getoutput('sudo reboot')
        else:
            print 'you cancel the reboot'
    else:
        tips['text'] = errortext


def updatetips():
    tips['text'] = infotext


currentmode = commands.getoutput("./t.sh mode")
print currentmode
top = Tk()
top.title("mode setting")
Label(top, bg='green',text="Current mode is :"+currentmode).pack(fill=X)
Label(top, text="switch mode to :").pack(anchor=W)
# Tkinter.sp

infotext = "select the new mode and click apply to switch mode."
reboottext = "Mode switch finished. \nYou need reboot system to apply the new mode."
errorext = "Invalid selected mode"

v = StringVar()
v.set(currentmode)
Radiobutton(top, variable=v, text='wifi mode', value="wifi",command=updatetips).pack(fill=X)
Radiobutton(top, variable=v, text='4g mode', value="4g",command=updatetips).pack(fill=X)

Button(top, text="Apply new mode", command =applyswitch).pack(fill=X)

tips = Label(top, text=infotext)
tips.pack()




mainloop()

/*
 DDHotKey -- DDHotKeyAppDelegate.m
 
 Copyright (c) 2010, Dave DeLong <http://www.davedelong.com>
 
 Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted, provided that the above copyright notice and this permission notice appear in all copies.
 
 The software is  provided "as is", without warranty of any kind, including all implied warranties of merchantability and fitness. In no event shall the author(s) or copyright holder(s) be liable for any claim, damages, or other liability, whether in an action of contract, tort, or otherwise, arising from, out of, or in connection with the software or the use or other dealings in the software.
 */

#import "DDHotKeyAppDelegate.h"
#import "DDHotKeyCenter.h"
#include "Python/Python.h"
#include <stdlib.h>

DDHotKeyAppDelegate* theAppDelegate;

PyObject* ini_Parse(PyObject* self, PyObject* pArgs)
{
	int* key = NULL;
	int *mod = NULL;
	char* cmd = NULL;
	
	if (!PyArg_ParseTuple(pArgs, "iis", &key, &mod, &cmd)) return NULL;

	[theAppDelegate registerWithKey:key
			      mod:mod
			      cmd:[NSString stringWithUTF8String: cmd]];

	Py_INCREF(Py_None);
	return Py_None;
}

static PyMethodDef iniMethods[] = {
	{"Parse", ini_Parse, METH_VARARGS, "Logs stdout"},
	{NULL, NULL, 0, NULL}
};


@implementation DDHotKeyAppDelegate

@synthesize window;

- (void)registerWithKey:(int)key mod:(int)mod cmd:(NSString *)cmd  {
    NSLog(@"%d: %d: %@", key, mod, cmd);
    DDHotKeyCenter * c = [[DDHotKeyCenter alloc] init];

    // todo: get the mask from the mod argument
    if (![c registerHotKeyWithKeyCode:key modifierFlags:mod target:self action:@selector(hotkeyWithEvent:object:) object:cmd]) {
	NSLog(@"Unable to register hotkey for example 1");
    } else {
	NSLog(@"Registered hotkey for example 1");
	NSLog(@"Registered: %@", [c registeredHotKeys]);
    }
    [c release];
}

- (void) hotkeyWithEvent:(NSEvent *)hkEvent object:(id)anObject {
    const char * command = [anObject UTF8String];
    system(command);
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    theAppDelegate = self;
    Py_SetProgramName("Python Console");

    // Initialize the Python interpreter.
    Py_Initialize();

    Py_InitModule("ini", iniMethods);
	
    PyRun_SimpleString(
		       /* start code-generator 
			  expand <<EOF | here-doc-to-cstr | append-line-number //
			  import ini
			  import os
			  ini_path = os.path.join(os.path.expanduser("~"), ".mac-hotkey.rc")
			  ini_file = open(ini_path)
                          keycodes = {
$(perl -ne 'if (m/kVK_ANSI_A\s+=/..m/kVK_ANSI_Keypad9\s+=/) {
                m/(\S+)\s*=\s*(\S+)/;
                printf 
"                              \"%s\" : $2\n", lc $1;
            }' \
/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.7.sdk/System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/HIToolbox.framework/Versions/A/Headers/Events.h)
                          }

			  keymasks = {
                              "shift"   : 1 << 17,
                              "control" : 1 << 18,
			      "alt"     : 1 << 19,
                              "command" : 1 << 20,
                          }
			  import re
			  for line in ini_file:
			      m = re.match(r"(\S+)\s+(\S+)\s+(.*)", line)
			      mod = keymasks["shift"]
			      for mask in m.group(2).split("|"):
			          mod |= keymasks[mask]
                              ini.Parse(keycodes["kvk_ansi_" + m.group(1)], mod, m.group(3))
EOF
			  end code-generator */
		       // start generated code
		       "import ini\n" // 1
		       "import os\n" // 2
		       "ini_path = os.path.join(os.path.expanduser(\"~\"), \".mac-hotkey.rc\")\n" // 3
		       "ini_file = open(ini_path)\n" // 4
		       "keycodes = {\n" // 5
		       "    \"kvk_ansi_a\" : 0x00,\n" // 6
		       "    \"kvk_ansi_s\" : 0x01,\n" // 7
		       "    \"kvk_ansi_d\" : 0x02,\n" // 8
		       "    \"kvk_ansi_f\" : 0x03,\n" // 9
		       "    \"kvk_ansi_h\" : 0x04,\n" // 10
		       "    \"kvk_ansi_g\" : 0x05,\n" // 11
		       "    \"kvk_ansi_z\" : 0x06,\n" // 12
		       "    \"kvk_ansi_x\" : 0x07,\n" // 13
		       "    \"kvk_ansi_c\" : 0x08,\n" // 14
		       "    \"kvk_ansi_v\" : 0x09,\n" // 15
		       "    \"kvk_ansi_b\" : 0x0B,\n" // 16
		       "    \"kvk_ansi_q\" : 0x0C,\n" // 17
		       "    \"kvk_ansi_w\" : 0x0D,\n" // 18
		       "    \"kvk_ansi_e\" : 0x0E,\n" // 19
		       "    \"kvk_ansi_r\" : 0x0F,\n" // 20
		       "    \"kvk_ansi_y\" : 0x10,\n" // 21
		       "    \"kvk_ansi_t\" : 0x11,\n" // 22
		       "    \"kvk_ansi_1\" : 0x12,\n" // 23
		       "    \"kvk_ansi_2\" : 0x13,\n" // 24
		       "    \"kvk_ansi_3\" : 0x14,\n" // 25
		       "    \"kvk_ansi_4\" : 0x15,\n" // 26
		       "    \"kvk_ansi_6\" : 0x16,\n" // 27
		       "    \"kvk_ansi_5\" : 0x17,\n" // 28
		       "    \"kvk_ansi_equal\" : 0x18,\n" // 29
		       "    \"kvk_ansi_9\" : 0x19,\n" // 30
		       "    \"kvk_ansi_7\" : 0x1A,\n" // 31
		       "    \"kvk_ansi_minus\" : 0x1B,\n" // 32
		       "    \"kvk_ansi_8\" : 0x1C,\n" // 33
		       "    \"kvk_ansi_0\" : 0x1D,\n" // 34
		       "    \"kvk_ansi_rightbracket\" : 0x1E,\n" // 35
		       "    \"kvk_ansi_o\" : 0x1F,\n" // 36
		       "    \"kvk_ansi_u\" : 0x20,\n" // 37
		       "    \"kvk_ansi_leftbracket\" : 0x21,\n" // 38
		       "    \"kvk_ansi_i\" : 0x22,\n" // 39
		       "    \"kvk_ansi_p\" : 0x23,\n" // 40
		       "    \"kvk_ansi_l\" : 0x25,\n" // 41
		       "    \"kvk_ansi_j\" : 0x26,\n" // 42
		       "    \"kvk_ansi_quote\" : 0x27,\n" // 43
		       "    \"kvk_ansi_k\" : 0x28,\n" // 44
		       "    \"kvk_ansi_semicolon\" : 0x29,\n" // 45
		       "    \"kvk_ansi_backslash\" : 0x2A,\n" // 46
		       "    \"kvk_ansi_comma\" : 0x2B,\n" // 47
		       "    \"kvk_ansi_slash\" : 0x2C,\n" // 48
		       "    \"kvk_ansi_n\" : 0x2D,\n" // 49
		       "    \"kvk_ansi_m\" : 0x2E,\n" // 50
		       "    \"kvk_ansi_period\" : 0x2F,\n" // 51
		       "    \"kvk_ansi_grave\" : 0x32,\n" // 52
		       "    \"kvk_ansi_keypaddecimal\" : 0x41,\n" // 53
		       "    \"kvk_ansi_keypadmultiply\" : 0x43,\n" // 54
		       "    \"kvk_ansi_keypadplus\" : 0x45,\n" // 55
		       "    \"kvk_ansi_keypadclear\" : 0x47,\n" // 56
		       "    \"kvk_ansi_keypaddivide\" : 0x4B,\n" // 57
		       "    \"kvk_ansi_keypadenter\" : 0x4C,\n" // 58
		       "    \"kvk_ansi_keypadminus\" : 0x4E,\n" // 59
		       "    \"kvk_ansi_keypadequals\" : 0x51,\n" // 60
		       "    \"kvk_ansi_keypad0\" : 0x52,\n" // 61
		       "    \"kvk_ansi_keypad1\" : 0x53,\n" // 62
		       "    \"kvk_ansi_keypad2\" : 0x54,\n" // 63
		       "    \"kvk_ansi_keypad3\" : 0x55,\n" // 64
		       "    \"kvk_ansi_keypad4\" : 0x56,\n" // 65
		       "    \"kvk_ansi_keypad5\" : 0x57,\n" // 66
		       "    \"kvk_ansi_keypad6\" : 0x58,\n" // 67
		       "    \"kvk_ansi_keypad7\" : 0x59,\n" // 68
		       "    \"kvk_ansi_keypad8\" : 0x5B,\n" // 69
		       "    \"kvk_ansi_keypad9\" : 0x5C\n" // 70
		       "}\n" // 71
		       "\n" // 72
		       "keymasks = {\n" // 73
		       "    \"shift\"   : 1 << 17,\n" // 74
		       "    \"control\" : 1 << 18,\n" // 75
		       "    \"alt\"     : 1 << 19,\n" // 76
		       "    \"command\" : 1 << 20,\n" // 77
		       "}\n" // 78
		       "import re\n" // 79
		       "for line in ini_file:\n" // 80
		       "    m = re.match(r\"(\\S+)\\s+(\\S+)\\s+(.*)\", line)\n" // 81
		       "    mod = keymasks[\"shift\"]\n" // 82
		       "    for mask in m.group(2).split(\"|\"):\n" // 83
		       "        mod |= keymasks[mask]\n" // 84
		       "    ini.Parse(keycodes[\"kvk_ansi_\" + m.group(1)], mod, m.group(3))\n" // 85

		       // end generated code
		       );
}



@end

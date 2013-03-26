/*
 DDHotKey -- DDHotKeyAppDelegate.m
 
 Copyright (c) 2010, Dave DeLong <http://www.davedelong.com>
 
 Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted, provided that the above copyright notice and this permission notice appear in all copies.
 
 The software is  provided "as is", without warranty of any kind, including all implied warranties of merchantability and fitness. In no event shall the author(s) or copyright holder(s) be liable for any claim, damages, or other liability, whether in an action of contract, tort, or otherwise, arising from, out of, or in connection with the software or the use or other dealings in the software.
 */

#import "DDHotKeyAppDelegate.h"
#import "DDHotKeyCenter.h"
#include "Python/Python.h"

DDHotKeyAppDelegate* theAppDelegate;

PyObject* ini_Parse(PyObject* self, PyObject* pArgs)
{
	char* key = NULL;
	char* mod = NULL;
	char* cmd = NULL;
	
	if (!PyArg_ParseTuple(pArgs, "sss", &key, &mod, &cmd)) return NULL;

	[theAppDelegate pythonOutWithKey:[NSString stringWithCString: key]
			      mod:[NSString stringWithCString: mod]
			      cmd:[NSString stringWithCString: cmd]];

	Py_INCREF(Py_None);
	return Py_None;
}

static PyMethodDef iniMethods[] = {
	{"Parse", ini_Parse, METH_VARARGS, "Logs stdout"},
	{NULL, NULL, 0, NULL}
};


@implementation DDHotKeyAppDelegate

@synthesize window, output;

- (void)pythonOutWithKey:(NSString *)key mod:(NSString *)mod cmd:(NSString *)cmd  {
    NSLog(@"%@: %@: %@", key, mod, cmd);
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    theAppDelegate = self;
    Py_SetProgramName("Python Console");

    // Initialize the Python interpreter.
    Py_Initialize();

    Py_InitModule("ini", iniMethods);
	
    PyRun_SimpleString(
		       /* start code-generator 
			  expand <<EOF | here-doc-to-cstr
			  import ini
			  import os
			  ini_path = os.path.join(os.path.expanduser("~"), ".mac-hotkey.rc")
			  ini_file = open(ini_path)
			  import re
			  for line in ini_file:
			      m = re.match(r"(\S+)\s+(\S+)\s+(.*)", line)
                              ini.Parse(m.group(1), m.group(2), m.group(3))
EOF
			  end code-generator */
		       // start generated code
		       "import ini\n"
		       "import os\n"
		       "ini_path = os.path.join(os.path.expanduser(\"~\"), \".mac-hotkey.rc\")\n"
		       "ini_file = open(ini_path)\n"
		       "import re\n"
		       "for line in ini_file:\n"
		       "    m = re.match(r\"(\\S+)\\s+(\\S+)\\s+(.*)\", line)\n"
		       "    ini.Parse(m.group(1), m.group(2), m.group(3))\n"

		       // end generated code
		       );
}

- (void) addOutput:(NSString *)newOutput {
	NSString * current = [output string];
	[output setString:[current stringByAppendingFormat:@"%@\n", newOutput]];
	[output scrollRangeToVisible:NSMakeRange([[output string] length], 0)];
}

- (void) hotkeyWithEvent:(NSEvent *)hkEvent {
	[self addOutput:[NSString stringWithFormat:@"Firing -[%@ %@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd)]];
	[self addOutput:[NSString stringWithFormat:@"Hotkey event: %@", hkEvent]];
}

- (void) hotkeyWithEvent:(NSEvent *)hkEvent object:(id)anObject {
	[self addOutput:[NSString stringWithFormat:@"Firing -[%@ %@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd)]];
	[self addOutput:[NSString stringWithFormat:@"Hotkey event: %@", hkEvent]];
	[self addOutput:[NSString stringWithFormat:@"Object: %@", anObject]];
}

- (IBAction) registerExample1:(id)sender {
	[self addOutput:@"Attempting to register hotkey for example 1"];
	DDHotKeyCenter * c = [[DDHotKeyCenter alloc] init];
	if (![c registerHotKeyWithKeyCode:9 modifierFlags:NSControlKeyMask target:self action:@selector(hotkeyWithEvent:) object:nil]) {
		[self addOutput:@"Unable to register hotkey for example 1"];
	} else {
		[self addOutput:@"Registered hotkey for example 1"];
		[self addOutput:[NSString stringWithFormat:@"Registered: %@", [c registeredHotKeys]]];
	}
	[c release];
}

- (IBAction) registerExample2:(id)sender {
	[self addOutput:@"Attempting to register hotkey for example 2"];
	DDHotKeyCenter * c = [[DDHotKeyCenter alloc] init];
	if (![c registerHotKeyWithKeyCode:9 modifierFlags:(NSControlKeyMask | NSAlternateKeyMask) target:self action:@selector(hotkeyWithEvent:object:) object:@"hello, world!"]) {
		[self addOutput:@"Unable to register hotkey for example 2"];
	} else {
		[self addOutput:@"Registered hotkey for example 2"];
		[self addOutput:[NSString stringWithFormat:@"Registered: %@", [c registeredHotKeys]]];
	}
	[c release];
}

- (IBAction) registerExample3:(id)sender {
#if NS_BLOCKS_AVAILABLE
	[self addOutput:@"Attempting to register hotkey for example 3"];
	DDHotKeyCenter * c = [[DDHotKeyCenter alloc] init];
	int theAnswer = 42;
	DDHotKeyTask task = ^(NSEvent *hkEvent) {
		[self addOutput:@"Firing block hotkey"];
		[self addOutput:[NSString stringWithFormat:@"Hotkey event: %@", hkEvent]];
		[self addOutput:[NSString stringWithFormat:@"the answer is: %d", theAnswer]];	
	};
	if (![c registerHotKeyWithKeyCode:9 modifierFlags:(NSControlKeyMask | NSAlternateKeyMask | NSCommandKeyMask) task:task]) {
		[self addOutput:@"Unable to register hotkey for example 3"];
	} else {
		[self addOutput:@"Registered hotkey for example 3"];
		[self addOutput:[NSString stringWithFormat:@"Registered: %@", [c registeredHotKeys]]];
	}
	[c release];
#else
	NSRunAlertPanel(@"Blocks not available", @"This example requires the 10.6 SDK", @"OK", nil, nil);
#endif
}

- (IBAction) unregisterExample1:(id)sender {
	DDHotKeyCenter * c = [[DDHotKeyCenter alloc] init];
	[c unregisterHotKeyWithKeyCode:9 modifierFlags:NSControlKeyMask];
	[self addOutput:@"Unregistered hotkey for example 1"];
	[c release];
}

- (IBAction) unregisterExample2:(id)sender {
	DDHotKeyCenter * c = [[DDHotKeyCenter alloc] init];
	[c unregisterHotKeyWithKeyCode:9 modifierFlags:(NSControlKeyMask | NSAlternateKeyMask)];
	[self addOutput:@"Unregistered hotkey for example 2"];
	[c release];
}

- (IBAction) unregisterExample3:(id)sender {
	DDHotKeyCenter * c = [[DDHotKeyCenter alloc] init];
	[c unregisterHotKeyWithKeyCode:9 modifierFlags:(NSControlKeyMask | NSAlternateKeyMask | NSCommandKeyMask)];
	[self addOutput:@"Unregistered hotkey for example 3"];
	[c release];
}

@end

/*
 * Copyright (c) 2026 Mayur Pawashe
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in the
 * documentation and/or other materials provided with the distribution.
 *
 * Neither the name of the project's author nor the names of its
 * contributors may be used to endorse or promote products derived from
 * this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "ZGGeneralPreferencesViewController.h"

#define ZGGeneralPreferencesLocalizationTable @"[Code] Preferences"

#define ZGPreferredLanguageKey @"ZGPreferredLanguage"
#define ZGAppleLanguagesKey @"AppleLanguages"

#define ZGUseSystemLanguageValue @"system"

// A label that keeps its wrapping width in sync with whatever width it ends up with
@interface ZGWrappingLabel : NSTextField
@end

@implementation ZGWrappingLabel

- (void)layoutSubtreeIfNeeded
{
	self.preferredMaxLayoutWidth = NSWidth(self.frame);
	[super layoutSubtreeIfNeeded];
}

@end

@implementation ZGGeneralPreferencesViewController
{
	NSArray<NSString *> *_languageCodes;
	NSPopUpButton *_languagePopUpButton;
}

#pragma mark Birth

- (id)init
{
	self = [super initWithNibName:nil bundle:nil];
	return self;
}

- (void)loadView
{
	_languageCodes = [ZGGeneralPreferencesViewController availableLanguageCodes];
	
	NSView *containerView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 360, 118)];
	
	NSTextField *languageLabel = [NSTextField labelWithString:NSLocalizedStringFromTable(@"languagePreferenceLabel", ZGGeneralPreferencesLocalizationTable, nil)];
	languageLabel.translatesAutoresizingMaskIntoConstraints = NO;
	languageLabel.font = [NSFont systemFontOfSize:[NSFont smallSystemFontSize]];
	languageLabel.alignment = NSTextAlignmentRight;
	[containerView addSubview:languageLabel];
	
	_languagePopUpButton = [[NSPopUpButton alloc] initWithFrame:NSZeroRect pullsDown:NO];
	_languagePopUpButton.translatesAutoresizingMaskIntoConstraints = NO;
	_languagePopUpButton.cell.controlSize = NSControlSizeSmall;
	_languagePopUpButton.font = [NSFont systemFontOfSize:[NSFont smallSystemFontSize]];
	[_languagePopUpButton setTarget:self];
	[_languagePopUpButton setAction:@selector(changeLanguage:)];
	[containerView addSubview:_languagePopUpButton];
	
	[self updateLanguagePopUpButton];
	
	ZGWrappingLabel *restartLabel = [ZGWrappingLabel wrappingLabelWithString:NSLocalizedStringFromTable(@"languageRestartDescription", ZGGeneralPreferencesLocalizationTable, nil)];
	restartLabel.translatesAutoresizingMaskIntoConstraints = NO;
	restartLabel.font = [NSFont systemFontOfSize:[NSFont smallSystemFontSize]];
	restartLabel.textColor = [NSColor secondaryLabelColor];
	[containerView addSubview:restartLabel];
	
	NSButton *relaunchButton = [[NSButton alloc] initWithFrame:NSZeroRect];
	relaunchButton.translatesAutoresizingMaskIntoConstraints = NO;
	relaunchButton.title = NSLocalizedStringFromTable(@"relaunchButtonTitle", ZGGeneralPreferencesLocalizationTable, nil);
	relaunchButton.font = [NSFont systemFontOfSize:[NSFont smallSystemFontSize]];
	relaunchButton.bezelStyle = NSBezelStyleRoundRect;
	relaunchButton.cell.controlSize = NSControlSizeSmall;
	[relaunchButton sizeToFit];
	[relaunchButton setTarget:self];
	[relaunchButton setAction:@selector(relaunchButton:)];
	[containerView addSubview:relaunchButton];
	
	CGFloat margin = 20.0;
	
	[NSLayoutConstraint activateConstraints:@[
	 [languageLabel.topAnchor constraintEqualToAnchor:containerView.topAnchor constant:margin],
	 [languageLabel.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor constant:margin],
	 
	 [_languagePopUpButton.centerYAnchor constraintEqualToAnchor:languageLabel.centerYAnchor],
	 [_languagePopUpButton.leadingAnchor constraintEqualToAnchor:languageLabel.trailingAnchor constant:8.0],
	 [_languagePopUpButton.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor constant:-margin],
	 [_languagePopUpButton.widthAnchor constraintGreaterThanOrEqualToConstant:150.0],
	 
	 [restartLabel.topAnchor constraintEqualToAnchor:languageLabel.bottomAnchor constant:12.0],
	 [restartLabel.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor constant:margin],
	 [restartLabel.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor constant:-margin],
	 
	 [relaunchButton.topAnchor constraintEqualToAnchor:restartLabel.bottomAnchor constant:12.0],
	 [relaunchButton.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor constant:-margin],
	 [relaunchButton.bottomAnchor constraintLessThanOrEqualToAnchor:containerView.bottomAnchor constant:-margin],
	]];
	
	self.view = containerView;
}

#pragma mark Language Preferences

+ (NSArray<NSString *> *)availableLanguageCodes
{
	NSMutableArray<NSString *> *languageCodes = [NSMutableArray array];
	for (NSString *localization in [[NSBundle mainBundle] localizations])
	{
		if ([localization isEqualToString:@"Base"])
		{
			continue;
		}
		
		[languageCodes addObject:localization];
	}
	
	[languageCodes sortUsingSelector:@selector(compare:)];
	
	return languageCodes;
}

+ (NSString *)displayNameForLanguageCode:(NSString *)languageCode
{
	NSString *displayName = [[[NSLocale alloc] initWithLocaleIdentifier:languageCode] displayNameForKey:NSLocaleIdentifier value:languageCode];
	if (displayName.length == 0)
	{
		displayName = languageCode;
	}
	
	return displayName.capitalizedString;
}

+ (nullable NSString *)preferredLanguageCode
{
	NSString *languageCode = [[NSUserDefaults standardUserDefaults] stringForKey:ZGPreferredLanguageKey];
	if (languageCode == nil || [languageCode isEqualToString:ZGUseSystemLanguageValue] || ![[self availableLanguageCodes] containsObject:languageCode])
	{
		return nil;
	}
	
	return languageCode;
}

+ (void)setPreferredLanguageCode:(nullable NSString *)languageCode
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	if (languageCode == nil)
	{
		[defaults removeObjectForKey:ZGPreferredLanguageKey];
		[defaults removeObjectForKey:ZGAppleLanguagesKey];
	}
	else
	{
		[defaults setObject:languageCode forKey:ZGPreferredLanguageKey];
		
		// The bundle localized resources are picked up from AppleLanguages at launch time
		NSString * _Nonnull resolvedLanguageCode = (NSString * _Nonnull)languageCode;
		NSMutableArray<NSString *> *appleLanguages = [NSMutableArray arrayWithObject:resolvedLanguageCode];
		if (![resolvedLanguageCode isEqualToString:@"en"])
		{
			[appleLanguages addObject:@"en"];
		}
		
		[defaults setObject:appleLanguages forKey:ZGAppleLanguagesKey];
	}
}

- (void)updateLanguagePopUpButton
{
	[_languagePopUpButton removeAllItems];
	
	NSMenuItem *systemMenuItem = [[NSMenuItem alloc] initWithTitle:NSLocalizedStringFromTable(@"useSystemLanguageMenuItem", ZGGeneralPreferencesLocalizationTable, nil) action:NULL keyEquivalent:@""];
	systemMenuItem.representedObject = nil;
	[_languagePopUpButton.menu addItem:systemMenuItem];
	
	[_languagePopUpButton.menu addItem:[NSMenuItem separatorItem]];
	
	for (NSString *languageCode in _languageCodes)
	{
		NSMenuItem *menuItem = [[NSMenuItem alloc] initWithTitle:[ZGGeneralPreferencesViewController displayNameForLanguageCode:languageCode] action:NULL keyEquivalent:@""];
		menuItem.representedObject = languageCode;
		[_languagePopUpButton.menu addItem:menuItem];
	}
	
	NSString *preferredLanguageCode = [ZGGeneralPreferencesViewController preferredLanguageCode];
	if (preferredLanguageCode == nil)
	{
		[_languagePopUpButton selectItemAtIndex:0];
		return;
	}
	
	NSInteger index = 0;
	for (NSMenuItem *menuItem in _languagePopUpButton.menu.itemArray)
	{
		NSString *languageCode = (NSString *)menuItem.representedObject;
		if ([languageCode isEqualToString:preferredLanguageCode])
		{
			[_languagePopUpButton selectItemAtIndex:index];
			break;
		}
		index++;
	}
}

- (IBAction)changeLanguage:(id)__unused sender
{
	NSMenuItem *selectedMenuItem = _languagePopUpButton.selectedItem;
	[ZGGeneralPreferencesViewController setPreferredLanguageCode:selectedMenuItem.representedObject];
	
	[self showRelaunchAlert];
}

- (IBAction)relaunchButton:(id)__unused sender
{
	[self showRelaunchAlert];
}

#pragma mark Relaunching

- (void)showRelaunchAlert
{
	NSAlert *alert = [[NSAlert alloc] init];
	alert.alertStyle = NSAlertStyleInformational;
	alert.messageText = NSLocalizedStringFromTable(@"relaunchAlertTitle", ZGGeneralPreferencesLocalizationTable, nil);
	alert.informativeText = NSLocalizedStringFromTable(@"relaunchAlertMessage", ZGGeneralPreferencesLocalizationTable, nil);
	
	[alert addButtonWithTitle:NSLocalizedStringFromTable(@"relaunchAlertConfirmButton", ZGGeneralPreferencesLocalizationTable, nil)];
	[alert addButtonWithTitle:NSLocalizedStringFromTable(@"relaunchAlertLaterButton", ZGGeneralPreferencesLocalizationTable, nil)];
	
	NSWindow *window = self.view.window;
	if (window != nil)
	{
		[alert beginSheetModalForWindow:window completionHandler:^(NSModalResponse returnCode) {
			if (returnCode == NSAlertFirstButtonReturn)
			{
				[ZGGeneralPreferencesViewController relaunchApplication];
			}
		}];
	}
	else
	{
		if ([alert runModal] == NSAlertFirstButtonReturn)
		{
			[ZGGeneralPreferencesViewController relaunchApplication];
		}
	}
}

+ (void)relaunchApplication
{
	NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
	if (bundlePath == nil)
	{
		[[NSApplication sharedApplication] terminate:nil];
		return;
	}
	
	NSTask *task = [[NSTask alloc] init];
	task.launchPath = @"/usr/bin/open";
	task.arguments = @[@"-n", bundlePath];
	
	NSError *error = nil;
	if (![task launchAndReturnError:&error])
	{
		NSLog(@"Failure: couldn't relaunch %@: %@", bundlePath, error);
		
		NSURL *bundleURL = [NSURL fileURLWithPath:bundlePath];
		[[NSWorkspace sharedWorkspace] openApplicationAtURL:bundleURL configuration:[NSWorkspaceOpenConfiguration configuration] completionHandler:^(NSRunningApplication * _Nullable __unused runningApplication, NSError * _Nullable openError) {
			if (openError != nil)
			{
				NSLog(@"Failure: couldn't open %@: %@", bundlePath, openError);
			}
		}];
	}
	
	[[NSApplication sharedApplication] terminate:nil];
}

@end

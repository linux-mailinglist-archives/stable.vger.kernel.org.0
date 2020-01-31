Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3E9014ED93
	for <lists+stable@lfdr.de>; Fri, 31 Jan 2020 14:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728659AbgAaNlT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jan 2020 08:41:19 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:53170 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728752AbgAaNlT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Jan 2020 08:41:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580478077;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zObha477OThnMhlBvN5sgMKGw4x6R4iZ2lukLTkZBB8=;
        b=H7JC5WRZe1YYl72KvA2LrXRPXVBs9MT262ondd2MtkBUD2Cm/sOaNScvujJhcMzDJsT/Yu
        NODSvdtdgLVGWE4eyhwWl1jyQRpfIfLmz4mtIsqgpIjb8smqv59fco6FL7jI87CJHF1PEJ
        TWutM2jHt5kLhL7L46eTGqILNY5CJ2U=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-72-dt8CLmL2OSi25x66nkakmg-1; Fri, 31 Jan 2020 08:41:12 -0500
X-MC-Unique: dt8CLmL2OSi25x66nkakmg-1
Received: by mail-wr1-f69.google.com with SMTP id s13so3349038wru.7
        for <stable@vger.kernel.org>; Fri, 31 Jan 2020 05:41:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=zObha477OThnMhlBvN5sgMKGw4x6R4iZ2lukLTkZBB8=;
        b=udLnLA8CLOFMid5NSg7ZJGl5G8pE4ratBWW1Si2+pA/RJpFumDuljRBgDvf/1E6BHQ
         ZmpuNQ7cFC3gh5XqEJ2Ky83u9q2kFf7yb9+5/zHeCH0SBrM49QbNWWSkbB1IdsOpX0y2
         NMOX1Us9jLz56/6MiGTOkshrLVzlPw49R795ElLsQtwVPjPkbR7lpUHVXkDC4XqdGGcS
         Dly4Pdr9XQv4DX8u/YX/NqRe/Rn0TqYz8zaLPkpsa5da4hkubp2oOtezyrMr0wsJWxJq
         F52wpakLgm9SVmIPWuI3MmXl0Ck3yscAn8FzAptvLSTl2/j0nprQnQQA53slnBrp5hXz
         mJSA==
X-Gm-Message-State: APjAAAWdJvhMjNbk6vAHPcjm2mn6s0jzy1f5MBchjL/H4LhrA7Rbp3hs
        tiVVe0EDYkc/j9gvDaa8/okITWZ7puTOKJvULz2Hd3VyoIvSLsVQczDIbYXje+0vd3bj6DD3mrB
        jTLosE+mS9W+Blusw
X-Received: by 2002:adf:f3cd:: with SMTP id g13mr12570934wrp.54.1580478071113;
        Fri, 31 Jan 2020 05:41:11 -0800 (PST)
X-Google-Smtp-Source: APXvYqx91AS6ya0VGdH1ZsMbyn7JxP6qoZUCmW7KLx2P6bTF0eGN9YXzsn07lLewEodBnX3thHvCnA==
X-Received: by 2002:adf:f3cd:: with SMTP id g13mr12570900wrp.54.1580478070755;
        Fri, 31 Jan 2020 05:41:10 -0800 (PST)
Received: from localhost.localdomain ([62.72.193.75])
        by smtp.gmail.com with ESMTPSA id q10sm10509322wme.16.2020.01.31.05.41.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jan 2020 05:41:10 -0800 (PST)
Subject: Re: [PATCH] HID: ite: Only bind to keyboard USB interface on Acer
 SW5-012 keyboard dock
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        "3.8+" <stable@vger.kernel.org>,
        =?UTF-8?Q?Zden=c4=9bk_Rampas?= <zdenda.rampas@gmail.com>
References: <20200131124553.27796-1-hdegoede@redhat.com>
 <CAO-hwJK-wwZ8UJRaBgjVc0ZXakU9C3eDbh+i6Q5vm8xh1P76LQ@mail.gmail.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <ea896405-6784-7cfd-b27c-28e8ebc3cd7e@redhat.com>
Date:   Fri, 31 Jan 2020 14:41:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <CAO-hwJK-wwZ8UJRaBgjVc0ZXakU9C3eDbh+i6Q5vm8xh1P76LQ@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------EB9378C377BF609CE80CE404"
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------EB9378C377BF609CE80CE404
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

On 1/31/20 2:10 PM, Benjamin Tissoires wrote:
> Hi Hans,
> 
> On Fri, Jan 31, 2020 at 1:46 PM Hans de Goede <hdegoede@redhat.com> wrote:
>>
>> Commit 8f18eca9ebc5 ("HID: ite: Add USB id match for Acer SW5-012 keyboard
>> dock") added the USB id for the Acer SW5-012's keyboard dock to the
>> hid-ite driver to fix the rfkill driver not working.
>>
>> Most keyboard docks with an ITE 8595 keyboard/touchpad controller have the
>> "Wireless Radio Control" bits which need the special hid-ite driver on the
>> second USB interface (the mouse interface) and their touchpad only supports
>> mouse emulation, so using generic hid-input handling for anything but
>> the "Wireless Radio Control" bits is fine. On these devices we simply bind
>> to all USB interfaces.
>>
>> But unlike other ITE8595 using keyboard docks, the Acer Aspire Switch 10
>> (SW5-012)'s touchpad not only does mouse emulation it also supports
>> HID-multitouch and all the keys including the "Wireless Radio Control"
>> bits have been moved to the first USB interface (the keyboard intf).
>>
>> So we need hid-ite to handle the first (keyboard) USB interface and have
>> it NOT bind to the second (mouse) USB interface so that that can be
>> handled by hid-multitouch.c and we get proper multi-touch support.
>>
>> This commit adds a match callback to hid-ite which makes it only
>> match the first USB interface when running on the Acer SW5-012,
>> fixing the regression to mouse-emulation mode introduced by adding the
>> keyboard dock USB id.
>>
>> Note the match function only does the special only bind to the first
>> USB interface on the Acer SW5-012, on other devices the hid-ite driver
>> actually must bind to the second interface as that is where the
>> "Wireless Radio Control" bits are.
> 
> This is not a full review, but a couple of things that popped out
> while scrolling through the patch.
> 
>>
>> Cc: stable@vger.kernel.org
>> Fixes: 8f18eca9ebc5 ("HID: ite: Add USB id match for Acer SW5-012 keyboard dock")
>> Reported-by: Zdeněk Rampas <zdenda.rampas@gmail.com>
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>> ---
>>   drivers/hid/hid-ite.c | 34 ++++++++++++++++++++++++++++++++++
>>   1 file changed, 34 insertions(+)
>>
>> diff --git a/drivers/hid/hid-ite.c b/drivers/hid/hid-ite.c
>> index c436e12feb23..69a4ddfd033d 100644
>> --- a/drivers/hid/hid-ite.c
>> +++ b/drivers/hid/hid-ite.c
>> @@ -8,9 +8,12 @@
>>   #include <linux/input.h>
>>   #include <linux/hid.h>
>>   #include <linux/module.h>
>> +#include <linux/usb.h>
>>
>>   #include "hid-ids.h"
>>
>> +#define ITE8595_KBD_USB_INTF           0
>> +
>>   static int ite_event(struct hid_device *hdev, struct hid_field *field,
>>                       struct hid_usage *usage, __s32 value)
>>   {
>> @@ -37,6 +40,36 @@ static int ite_event(struct hid_device *hdev, struct hid_field *field,
>>          return 0;
>>   }
>>
>> +static bool ite_match(struct hid_device *hdev, bool ignore_special_driver)
>> +{
>> +       struct usb_interface *intf;
>> +
>> +       if (ignore_special_driver)
>> +               return false;
>> +
>> +       /*
>> +        * Most keyboard docks with an ITE 8595 keyboard/touchpad controller
>> +        * have the "Wireless Radio Control" bits which need this special
>> +        * driver on the second USB interface (the mouse interface). On
>> +        * these devices we simply bind to all USB interfaces.
>> +        *
>> +        * The Acer Aspire Switch 10 (SW5-012) is special, its touchpad
>> +        * not only does mouse emulation it also supports HID-multitouch
>> +        * and all the keys including the "Wireless Radio Control" bits
>> +        * have been moved to the first USB interface (the keyboard intf).
>> +        *
>> +        * We want the hid-multitouch driver to bind to the touchpad, so on
>> +        * the Acer SW5-012 we should only bind to the keyboard USB intf.
>> +        */
>> +       if (hdev->bus != BUS_USB || hdev->vendor != USB_VENDOR_ID_SYNAPTICS ||
>> +                    hdev->product != USB_DEVICE_ID_SYNAPTICS_ACER_SWITCH5_012)
> 
> Isn't there an existing matching function we can use here, instead of
> checking each individual field?

There is hid_match_one_id() but that is not exported (can be fixed) and it
requires a struct hid_device_id, which either requires declaring an extra
standalone struct hid_device_id for the SW5-012 kbd-dock, or hardcoding an
index into the existing hid_device_id array for the driver (with the hardcoding
being error prone, so not a good idea).

Given the problems with using hid_match_one_id() I decided to just go with
the above.

But see below.

> 
>> +               return true;
>> +
>> +       intf = to_usb_interface(hdev->dev.parent);
> 
> And this is oops-prone. You need:
> - ensure hid_is_using_ll_driver(hdev, &usb_hid_driver) returns true.
> - add a dependency on USBHID in the KConfig now that you are checking
> on the USB transport layer.
> 
> That being said, I would love instead:
> - to have a non USB version of this match, where you decide which
> component needs to be handled based on the report descriptor

Actually your idea to use the desciptors is not bad, but since what
we really want is to not bind to the interface which is marked for the
hid-multitouch driver I just realized we can just check that.

So how about:

static bool ite_match(struct hid_device *hdev, bool ignore_special_driver)
{
         if (ignore_special_driver)
                 return false;

         /*
          * Some keyboard docks with an ITE 8595 keyboard/touchpad controller
          * support the HID multitouch protocol for the touchpad, in that
          * case the "Wireless Radio Control" bits which we care about are
          * on the other interface; and we should not bind to the multitouch
          * capable interface as that breaks multitouch support.
          */
         return hdev->group != HID_GROUP_MULTITOUCH_WIN_8;
}

? (note untested)

Zdeněk  I have attached a new version of the patch which uses this
improved version of the match function, if you have a chance to test it
this weekend that would be great, otherwise I will test it on my own
sw5-012 on Monday.

> - have a regression test in
> https://gitlab.freedesktop.org/libevdev/hid-tools for this particular
> device, because I never intended the .match callback to be used by
> anybody else than hid-generic, and opening this can of worms is prone
> to introduce regressions in the future.

Ugh, I can understand your desire for a test for this, but writing
tests is not really my thing. Anyways do you have an example test I
could use as a start ?

Regards,

Hans

--------------EB9378C377BF609CE80CE404
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-HID-ite-Only-bind-to-keyboard-USB-interface-on-Acer-.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename*0="0001-HID-ite-Only-bind-to-keyboard-USB-interface-on-Acer-.pa";
 filename*1="tch"

From f26ab52abab63d819c49db0460d2392cce1da733 Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Fri, 31 Jan 2020 12:06:13 +0100
Subject: [PATCH v2] HID: ite: Only bind to keyboard USB interface on Acer
 SW5-012 keyboard dock
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Commit 8f18eca9ebc5 ("HID: ite: Add USB id match for Acer SW5-012 keyboard
dock") added the USB id for the Acer SW5-012's keyboard dock to the
hid-ite driver to fix the rfkill driver not working.

Most keyboard docks with an ITE 8595 keyboard/touchpad controller have the
"Wireless Radio Control" bits which need the special hid-ite driver on the
second USB interface (the mouse interface) and their touchpad only supports
mouse emulation, so using generic hid-input handling for anything but
the "Wireless Radio Control" bits is fine. On these devices we simply bind
to all USB interfaces.

But unlike other ITE8595 using keyboard docks, the Acer Aspire Switch 10
(SW5-012)'s touchpad not only does mouse emulation it also supports
HID-multitouch and all the keys including the "Wireless Radio Control"
bits have been moved to the first USB interface (the keyboard intf).

So we need hid-ite to handle the first (keyboard) USB interface and have
it NOT bind to the second (mouse) USB interface so that that can be
handled by hid-multitouch.c and we get proper multi-touch support.

This commit adds a match callback to hid-ite which makes it not bind
to hid-devices which are marked as being win8 multi-touch devices, this
fixing the regression to mouse-emulation mode introduced by adding the
keyboard dock USB id.

Note the match function only does the special only bind to the first
USB interface on the Acer SW5-012, on other devices the hid-ite driver
actually must bind to the second interface as that is where the
"Wireless Radio Control" bits are.

Cc: stable@vger.kernel.org
Fixes: 8f18eca9ebc5 ("HID: ite: Add USB id match for Acer SW5-012 keyboard dock")
Reported-by: Zdeněk Rampas <zdenda.rampas@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
Changes in v2:
- Check hdev->group instead of peeking at the USB descriptors (intf number)
---
 drivers/hid/hid-ite.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/hid/hid-ite.c b/drivers/hid/hid-ite.c
index c436e12feb23..db0f35be5a8b 100644
--- a/drivers/hid/hid-ite.c
+++ b/drivers/hid/hid-ite.c
@@ -37,6 +37,21 @@ static int ite_event(struct hid_device *hdev, struct hid_field *field,
 	return 0;
 }
 
+static bool ite_match(struct hid_device *hdev, bool ignore_special_driver)
+{
+	if (ignore_special_driver)
+		return false;
+
+	/*
+	 * Some keyboard docks with an ITE 8595 keyboard/touchpad controller
+	 * support the HID multitouch protocol for the touchpad, in that
+	 * case the "Wireless Radio Control" bits which we care about are
+	 * on the other interface; and we should not bind to the multitouch
+	 * capable interface as that breaks multitouch support.
+	 */
+	return hdev->group != HID_GROUP_MULTITOUCH_WIN_8;
+}
+
 static const struct hid_device_id ite_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ITE, USB_DEVICE_ID_ITE8595) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_258A, USB_DEVICE_ID_258A_6A88) },
@@ -50,6 +65,7 @@ MODULE_DEVICE_TABLE(hid, ite_devices);
 static struct hid_driver ite_driver = {
 	.name = "itetech",
 	.id_table = ite_devices,
+	.match = ite_match,
 	.event = ite_event,
 };
 module_hid_driver(ite_driver);
-- 
2.23.0


--------------EB9378C377BF609CE80CE404--


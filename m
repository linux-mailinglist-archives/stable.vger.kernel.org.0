Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E59114EE29
	for <lists+stable@lfdr.de>; Fri, 31 Jan 2020 15:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728730AbgAaOEi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jan 2020 09:04:38 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:32583 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728500AbgAaOEi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Jan 2020 09:04:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580479476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VdOW7PNJeuMmmDY9kZwQNkZeEVlpGmsTxVCL30ndvIg=;
        b=WKcWkYVbJgGw/kdzDLFg0nfEwCoKOHVsSQNc3AMx3labVo2h1eQMt9jZxNpwdaQg7Z3SCZ
        MY4c5PeVszEyQCvazd9RLmiXJKkAg0UCym5yexny4EXtrlqOEqcD2TXO3IeCt3+x7WJjI6
        IuHXWIR1gydN6DjB4pA4/tudO+g7/m4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-YtPIU6jfMmq3hZgGBbrYHg-1; Fri, 31 Jan 2020 09:04:28 -0500
X-MC-Unique: YtPIU6jfMmq3hZgGBbrYHg-1
Received: by mail-wm1-f69.google.com with SMTP id o193so2844215wme.8
        for <stable@vger.kernel.org>; Fri, 31 Jan 2020 06:04:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VdOW7PNJeuMmmDY9kZwQNkZeEVlpGmsTxVCL30ndvIg=;
        b=ndAXNNVuwnKM8fFkWmU1GYPo1276i8VpMnJi7Xj+ccsfZi2JfGSbz7Ws6FMlPcA0a7
         x0WMugzUxd9VUxSKB2nBHURfT8C+FLXATYWFgco8WtmmvLjKwoFoJmY8h0ut+EL0g2Lw
         6smq/xrEgnWlBZagayIEFwjUEsI06Ilx1R5mgsz7LE+tAsUcBn3a3pnYwfAf0qkF8Udg
         JCZ9Oc5qGh5hMWYuUdQzGxYkVPp0/YHk9o6PRBbG0YxL4eVKakUe7T9ppqyNERliAWAj
         aOzvMb3mIVwLVWSKLmfNZ2MFRpU8AX1M450k569oxev0pjpPlWyNSvB+wpdA2KRy7dUO
         cfrA==
X-Gm-Message-State: APjAAAXQGQlOmJtrsiJ95J9uNdedyegrCsKSFpQqe+4U1CpPg6yqcLEs
        NjxKZe0hthH2NIsS86aOXuQrhUcgvRshb2TjlYDigT/LujlCEahk4lYdR5K9/kbr059hrqK4AvF
        HEG8jahnYOaZU5c6L
X-Received: by 2002:adf:cd04:: with SMTP id w4mr13108322wrm.219.1580479467278;
        Fri, 31 Jan 2020 06:04:27 -0800 (PST)
X-Google-Smtp-Source: APXvYqwGp9bgSUTCDiHCJ4QeoJtRo7//i35bQ2dIxy7owX0NHN+MtvuteERwIDccDqwixzEi1IoVPg==
X-Received: by 2002:adf:cd04:: with SMTP id w4mr13108286wrm.219.1580479466826;
        Fri, 31 Jan 2020 06:04:26 -0800 (PST)
Received: from localhost.localdomain ([62.72.193.75])
        by smtp.gmail.com with ESMTPSA id w8sm11030625wmm.0.2020.01.31.06.04.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jan 2020 06:04:26 -0800 (PST)
Subject: Re: [PATCH] HID: ite: Only bind to keyboard USB interface on Acer
 SW5-012 keyboard dock
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        "3.8+" <stable@vger.kernel.org>,
        =?UTF-8?Q?Zden=c4=9bk_Rampas?= <zdenda.rampas@gmail.com>
References: <20200131124553.27796-1-hdegoede@redhat.com>
 <CAO-hwJK-wwZ8UJRaBgjVc0ZXakU9C3eDbh+i6Q5vm8xh1P76LQ@mail.gmail.com>
 <ea896405-6784-7cfd-b27c-28e8ebc3cd7e@redhat.com>
 <CAO-hwJJ1v30NT5quobYawV9yv87buyrQXOG9u-nY3zXXSrCGvg@mail.gmail.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <6d94cf74-c28f-08b0-a136-044c231b8bc5@redhat.com>
Date:   Fri, 31 Jan 2020 15:04:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <CAO-hwJJ1v30NT5quobYawV9yv87buyrQXOG9u-nY3zXXSrCGvg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 1/31/20 2:54 PM, Benjamin Tissoires wrote:
> On Fri, Jan 31, 2020 at 2:41 PM Hans de Goede <hdegoede@redhat.com> wrote:
>>
>> Hi,
>>
>> On 1/31/20 2:10 PM, Benjamin Tissoires wrote:
>>> Hi Hans,
>>>
>>> On Fri, Jan 31, 2020 at 1:46 PM Hans de Goede <hdegoede@redhat.com> wrote:
>>>>
>>>> Commit 8f18eca9ebc5 ("HID: ite: Add USB id match for Acer SW5-012 keyboard
>>>> dock") added the USB id for the Acer SW5-012's keyboard dock to the
>>>> hid-ite driver to fix the rfkill driver not working.
>>>>
>>>> Most keyboard docks with an ITE 8595 keyboard/touchpad controller have the
>>>> "Wireless Radio Control" bits which need the special hid-ite driver on the
>>>> second USB interface (the mouse interface) and their touchpad only supports
>>>> mouse emulation, so using generic hid-input handling for anything but
>>>> the "Wireless Radio Control" bits is fine. On these devices we simply bind
>>>> to all USB interfaces.
>>>>
>>>> But unlike other ITE8595 using keyboard docks, the Acer Aspire Switch 10
>>>> (SW5-012)'s touchpad not only does mouse emulation it also supports
>>>> HID-multitouch and all the keys including the "Wireless Radio Control"
>>>> bits have been moved to the first USB interface (the keyboard intf).
>>>>
>>>> So we need hid-ite to handle the first (keyboard) USB interface and have
>>>> it NOT bind to the second (mouse) USB interface so that that can be
>>>> handled by hid-multitouch.c and we get proper multi-touch support.
>>>>
>>>> This commit adds a match callback to hid-ite which makes it only
>>>> match the first USB interface when running on the Acer SW5-012,
>>>> fixing the regression to mouse-emulation mode introduced by adding the
>>>> keyboard dock USB id.
>>>>
>>>> Note the match function only does the special only bind to the first
>>>> USB interface on the Acer SW5-012, on other devices the hid-ite driver
>>>> actually must bind to the second interface as that is where the
>>>> "Wireless Radio Control" bits are.
>>>
>>> This is not a full review, but a couple of things that popped out
>>> while scrolling through the patch.
>>>
>>>>
>>>> Cc: stable@vger.kernel.org
>>>> Fixes: 8f18eca9ebc5 ("HID: ite: Add USB id match for Acer SW5-012 keyboard dock")
>>>> Reported-by: Zdeněk Rampas <zdenda.rampas@gmail.com>
>>>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>>>> ---
>>>>    drivers/hid/hid-ite.c | 34 ++++++++++++++++++++++++++++++++++
>>>>    1 file changed, 34 insertions(+)
>>>>
>>>> diff --git a/drivers/hid/hid-ite.c b/drivers/hid/hid-ite.c
>>>> index c436e12feb23..69a4ddfd033d 100644
>>>> --- a/drivers/hid/hid-ite.c
>>>> +++ b/drivers/hid/hid-ite.c
>>>> @@ -8,9 +8,12 @@
>>>>    #include <linux/input.h>
>>>>    #include <linux/hid.h>
>>>>    #include <linux/module.h>
>>>> +#include <linux/usb.h>
>>>>
>>>>    #include "hid-ids.h"
>>>>
>>>> +#define ITE8595_KBD_USB_INTF           0
>>>> +
>>>>    static int ite_event(struct hid_device *hdev, struct hid_field *field,
>>>>                        struct hid_usage *usage, __s32 value)
>>>>    {
>>>> @@ -37,6 +40,36 @@ static int ite_event(struct hid_device *hdev, struct hid_field *field,
>>>>           return 0;
>>>>    }
>>>>
>>>> +static bool ite_match(struct hid_device *hdev, bool ignore_special_driver)
>>>> +{
>>>> +       struct usb_interface *intf;
>>>> +
>>>> +       if (ignore_special_driver)
>>>> +               return false;
>>>> +
>>>> +       /*
>>>> +        * Most keyboard docks with an ITE 8595 keyboard/touchpad controller
>>>> +        * have the "Wireless Radio Control" bits which need this special
>>>> +        * driver on the second USB interface (the mouse interface). On
>>>> +        * these devices we simply bind to all USB interfaces.
>>>> +        *
>>>> +        * The Acer Aspire Switch 10 (SW5-012) is special, its touchpad
>>>> +        * not only does mouse emulation it also supports HID-multitouch
>>>> +        * and all the keys including the "Wireless Radio Control" bits
>>>> +        * have been moved to the first USB interface (the keyboard intf).
>>>> +        *
>>>> +        * We want the hid-multitouch driver to bind to the touchpad, so on
>>>> +        * the Acer SW5-012 we should only bind to the keyboard USB intf.
>>>> +        */
>>>> +       if (hdev->bus != BUS_USB || hdev->vendor != USB_VENDOR_ID_SYNAPTICS ||
>>>> +                    hdev->product != USB_DEVICE_ID_SYNAPTICS_ACER_SWITCH5_012)
>>>
>>> Isn't there an existing matching function we can use here, instead of
>>> checking each individual field?
>>
>> There is hid_match_one_id() but that is not exported (can be fixed) and it
>> requires a struct hid_device_id, which either requires declaring an extra
>> standalone struct hid_device_id for the SW5-012 kbd-dock, or hardcoding an
>> index into the existing hid_device_id array for the driver (with the hardcoding
>> being error prone, so not a good idea).
>>
>> Given the problems with using hid_match_one_id() I decided to just go with
>> the above.
> 
> right. An other solution would be to have a local macro/function that
> does that. Because as soon as you start adding a quirk, an other comes
> right after.
> 
>>
>> But see below.
>>
>>>
>>>> +               return true;
>>>> +
>>>> +       intf = to_usb_interface(hdev->dev.parent);
>>>
>>> And this is oops-prone. You need:
>>> - ensure hid_is_using_ll_driver(hdev, &usb_hid_driver) returns true.
>>> - add a dependency on USBHID in the KConfig now that you are checking
>>> on the USB transport layer.
>>>
>>> That being said, I would love instead:
>>> - to have a non USB version of this match, where you decide which
>>> component needs to be handled based on the report descriptor
>>
>> Actually your idea to use the desciptors is not bad, but since what
>> we really want is to not bind to the interface which is marked for the
>> hid-multitouch driver I just realized we can just check that.
>>
>> So how about:
>>
>> static bool ite_match(struct hid_device *hdev, bool ignore_special_driver)
>> {
>>           if (ignore_special_driver)
>>                   return false;
>>
>>           /*
>>            * Some keyboard docks with an ITE 8595 keyboard/touchpad controller
>>            * support the HID multitouch protocol for the touchpad, in that
>>            * case the "Wireless Radio Control" bits which we care about are
>>            * on the other interface; and we should not bind to the multitouch
>>            * capable interface as that breaks multitouch support.
>>            */
>>           return hdev->group != HID_GROUP_MULTITOUCH_WIN_8;
>> }
> 
> Yep, I like that very much :)

Actually if we want to check the group and there are only 2 interfaces we do
not need to use the match callback at all, w e can simply match on the
group of the interface which we do want:

diff --git a/drivers/hid/hid-ite.c b/drivers/hid/hid-ite.c
index db0f35be5a8b..21bd48f16033 100644
--- a/drivers/hid/hid-ite.c
+++ b/drivers/hid/hid-ite.c
@@ -56,8 +56,9 @@ static const struct hid_device_id ite_devices[] = {
  	{ HID_USB_DEVICE(USB_VENDOR_ID_ITE, USB_DEVICE_ID_ITE8595) },
  	{ HID_USB_DEVICE(USB_VENDOR_ID_258A, USB_DEVICE_ID_258A_6A88) },
  	/* ITE8595 USB kbd ctlr, with Synaptics touchpad connected to it. */
-	{ HID_USB_DEVICE(USB_VENDOR_ID_SYNAPTICS,
-			 USB_DEVICE_ID_SYNAPTICS_ACER_SWITCH5_012) },
+	{ HID_DEVICE(BUS_USB, HID_GROUP_GENERIC,
+		     USB_VENDOR_ID_SYNAPTICS,
+		     USB_DEVICE_ID_SYNAPTICS_ACER_SWITCH5_012) },
  	{ }
  };
  MODULE_DEVICE_TABLE(hid, ite_devices);

Much cleaner (and now I don't need to write a test, which is always
a good motivation to come up with a cleaner solution :)

Let me turn this into a proper patch and then I will send that to
Zdeněk (off-list) for him to test (note don't worry if you do
not have time to test this weekend, then I'll do it on Monday).

Regards,

Hans

p.s.

1. My train is approaching Brussels (Fosdem) so my email response
time will soon become irregular.

2. Benjamin will you be at Fosdem too ?


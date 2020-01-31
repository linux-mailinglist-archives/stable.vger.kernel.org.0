Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21C9D14EFFE
	for <lists+stable@lfdr.de>; Fri, 31 Jan 2020 16:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729032AbgAaPqC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jan 2020 10:46:02 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:30936 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728846AbgAaPqC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Jan 2020 10:46:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580485560;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ojdqvwAj2g8/T0aLiCiKPcuvDlaGomkubMbQbtIHtOo=;
        b=Es5+PEOlUhxVWCNgiWY/q3tvOGqq+X7hsVYO/GtU6sB0xpv4dRXw7a9ItFI2sRcQRKnPgZ
        M3/kzqR2B0IVxszxi4GpBg+sCH1jTUMAhz8Wz6zNQzplP94ktS1Hz/KuCGH9yQf1Ud3eFj
        gp41n5zu9YynZqSYBeHhTP03FZTMbio=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-128-eUwydhUpNSi_UD1VkqadZQ-1; Fri, 31 Jan 2020 10:45:42 -0500
X-MC-Unique: eUwydhUpNSi_UD1VkqadZQ-1
Received: by mail-wm1-f72.google.com with SMTP id 7so2967077wmf.9
        for <stable@vger.kernel.org>; Fri, 31 Jan 2020 07:45:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ojdqvwAj2g8/T0aLiCiKPcuvDlaGomkubMbQbtIHtOo=;
        b=FHtKtPeFP5w4GuVfbX8IcZExvMarM1ikgAhTRAbWwSVHjUBPN56StF2wzuIf6Jq3eD
         DApIL4Cgp48ndvBzJQ6pF5UxX6oIdfi6djERcTFLpB2ss3+AoOWHKdc79a1VzbdqnA31
         z5Wep9rhWspQsLSjoMBGUfWqvvI0jniev83OPufo6Y7OWUv09jBorK93FmLa9xmzXTkw
         IFZh4Utiy9IE/7mnAqYU3Lnfd6whDM87frwR6ukZeA5La5Lw8IXrayjeJGaRf8Ld4gPI
         GWd/vFV7EuMBqEAoYuM4wdUCwdFclLJaBYcERsUqByXFGrF4sY8eDmz4IuT/CDSe4CwE
         pwfA==
X-Gm-Message-State: APjAAAV5j8ICfxIz1LcJ4RhvocGQL1ckPWvcruJxF8IUOjv5edRMdvYN
        //2xu/iMCyag2esHhKfIDKPlKvq9vp5FvB+Ia+ykCMLQiZmIlsYx/9oblMgUNiNPy6n393xFAx+
        FliN0I/rMXM3yOZ3p
X-Received: by 2002:a7b:cf01:: with SMTP id l1mr12624967wmg.86.1580485540963;
        Fri, 31 Jan 2020 07:45:40 -0800 (PST)
X-Google-Smtp-Source: APXvYqxab9HnbNSQW2BwxHCZktavfkKg3vJVJ7HVzz8qxyt3ch26FGDLZ/+PanYkyqbf4AUz3Z7zwQ==
X-Received: by 2002:a7b:cf01:: with SMTP id l1mr12624930wmg.86.1580485540531;
        Fri, 31 Jan 2020 07:45:40 -0800 (PST)
Received: from localhost.localdomain ([62.72.193.75])
        by smtp.gmail.com with ESMTPSA id b137sm12146107wme.26.2020.01.31.07.45.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jan 2020 07:45:40 -0800 (PST)
Subject: Re: [PATCH] HID: ite: Only bind to keyboard USB interface on Acer
 SW5-012 keyboard dock
To:     Z R <zdenda.rampas@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        "3.8+" <stable@vger.kernel.org>
References: <20200131124553.27796-1-hdegoede@redhat.com>
 <CAO-hwJK-wwZ8UJRaBgjVc0ZXakU9C3eDbh+i6Q5vm8xh1P76LQ@mail.gmail.com>
 <ea896405-6784-7cfd-b27c-28e8ebc3cd7e@redhat.com>
 <CAO-hwJJ1v30NT5quobYawV9yv87buyrQXOG9u-nY3zXXSrCGvg@mail.gmail.com>
 <6d94cf74-c28f-08b0-a136-044c231b8bc5@redhat.com>
 <CAO-hwJ+o5CvU3Pv+dQV2gSTeF+n0AGkjwYJvWfX_ZYtM=OtH6g@mail.gmail.com>
 <CABHH5-LmC3JOWyDoxC5hizZe6RZ6RuO=-gk8WDXvU9Z2usihXg@mail.gmail.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <fa288cc2-0560-1fa5-a629-20a7a33afeb2@redhat.com>
Date:   Fri, 31 Jan 2020 16:45:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <CABHH5-LmC3JOWyDoxC5hizZe6RZ6RuO=-gk8WDXvU9Z2usihXg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 1/31/20 4:38 PM, Z R wrote:
> Hi Benjamin,
> hid-record for keyboard and touchpad. With Commit 8f18eca9ebc5 reverted and from unmodified kernel.
> 
> I hope it is what you asked for :-)
> 
> Currently waiting for reworked patch from Hans.

I just send you the reworked patch.

Does the recordning include pressing of the wlan on/off key (Fn + F3 I believe) ?
That is the whole reason why the special hid-ite driver is necessary.

Benjamin about the wlan on/off key. AFAICR on a press + release of the key a
single hid input report for the generic-desktop  Wireless Radio Controls group
is send. This input-report only has the one button with usage code HID_GD_RFKILL_BTN
in there and it is always 0. It is as if the input-report is only send on release
and not on press. So the hid-ite code emulates a press + release whenever the
input-report is send.

IOW the receiving of the input report is (ab)used as indication of the button
having been pressed.

Regards,

Hans


> 
> Bye for now
> Zdeněk
> 
> pá 31. 1. 2020 v 15:12 odesílatel Benjamin Tissoires <benjamin.tissoires@redhat.com <mailto:benjamin.tissoires@redhat.com>> napsal:
> 
>     On Fri, Jan 31, 2020 at 3:04 PM Hans de Goede <hdegoede@redhat.com <mailto:hdegoede@redhat.com>> wrote:
>      >
>      > Hi,
>      >
>      > On 1/31/20 2:54 PM, Benjamin Tissoires wrote:
>      > > On Fri, Jan 31, 2020 at 2:41 PM Hans de Goede <hdegoede@redhat.com <mailto:hdegoede@redhat.com>> wrote:
>      > >>
>      > >> Hi,
>      > >>
>      > >> On 1/31/20 2:10 PM, Benjamin Tissoires wrote:
>      > >>> Hi Hans,
>      > >>>
>      > >>> On Fri, Jan 31, 2020 at 1:46 PM Hans de Goede <hdegoede@redhat.com <mailto:hdegoede@redhat.com>> wrote:
>      > >>>>
>      > >>>> Commit 8f18eca9ebc5 ("HID: ite: Add USB id match for Acer SW5-012 keyboard
>      > >>>> dock") added the USB id for the Acer SW5-012's keyboard dock to the
>      > >>>> hid-ite driver to fix the rfkill driver not working.
>      > >>>>
>      > >>>> Most keyboard docks with an ITE 8595 keyboard/touchpad controller have the
>      > >>>> "Wireless Radio Control" bits which need the special hid-ite driver on the
>      > >>>> second USB interface (the mouse interface) and their touchpad only supports
>      > >>>> mouse emulation, so using generic hid-input handling for anything but
>      > >>>> the "Wireless Radio Control" bits is fine. On these devices we simply bind
>      > >>>> to all USB interfaces.
>      > >>>>
>      > >>>> But unlike other ITE8595 using keyboard docks, the Acer Aspire Switch 10
>      > >>>> (SW5-012)'s touchpad not only does mouse emulation it also supports
>      > >>>> HID-multitouch and all the keys including the "Wireless Radio Control"
>      > >>>> bits have been moved to the first USB interface (the keyboard intf).
>      > >>>>
>      > >>>> So we need hid-ite to handle the first (keyboard) USB interface and have
>      > >>>> it NOT bind to the second (mouse) USB interface so that that can be
>      > >>>> handled by hid-multitouch.c and we get proper multi-touch support.
>      > >>>>
>      > >>>> This commit adds a match callback to hid-ite which makes it only
>      > >>>> match the first USB interface when running on the Acer SW5-012,
>      > >>>> fixing the regression to mouse-emulation mode introduced by adding the
>      > >>>> keyboard dock USB id.
>      > >>>>
>      > >>>> Note the match function only does the special only bind to the first
>      > >>>> USB interface on the Acer SW5-012, on other devices the hid-ite driver
>      > >>>> actually must bind to the second interface as that is where the
>      > >>>> "Wireless Radio Control" bits are.
>      > >>>
>      > >>> This is not a full review, but a couple of things that popped out
>      > >>> while scrolling through the patch.
>      > >>>
>      > >>>>
>      > >>>> Cc: stable@vger.kernel.org <mailto:stable@vger.kernel.org>
>      > >>>> Fixes: 8f18eca9ebc5 ("HID: ite: Add USB id match for Acer SW5-012 keyboard dock")
>      > >>>> Reported-by: Zdeněk Rampas <zdenda.rampas@gmail.com <mailto:zdenda.rampas@gmail.com>>
>      > >>>> Signed-off-by: Hans de Goede <hdegoede@redhat.com <mailto:hdegoede@redhat.com>>
>      > >>>> ---
>      > >>>>    drivers/hid/hid-ite.c | 34 ++++++++++++++++++++++++++++++++++
>      > >>>>    1 file changed, 34 insertions(+)
>      > >>>>
>      > >>>> diff --git a/drivers/hid/hid-ite.c b/drivers/hid/hid-ite.c
>      > >>>> index c436e12feb23..69a4ddfd033d 100644
>      > >>>> --- a/drivers/hid/hid-ite.c
>      > >>>> +++ b/drivers/hid/hid-ite.c
>      > >>>> @@ -8,9 +8,12 @@
>      > >>>>    #include <linux/input.h>
>      > >>>>    #include <linux/hid.h>
>      > >>>>    #include <linux/module.h>
>      > >>>> +#include <linux/usb.h>
>      > >>>>
>      > >>>>    #include "hid-ids.h"
>      > >>>>
>      > >>>> +#define ITE8595_KBD_USB_INTF           0
>      > >>>> +
>      > >>>>    static int ite_event(struct hid_device *hdev, struct hid_field *field,
>      > >>>>                        struct hid_usage *usage, __s32 value)
>      > >>>>    {
>      > >>>> @@ -37,6 +40,36 @@ static int ite_event(struct hid_device *hdev, struct hid_field *field,
>      > >>>>           return 0;
>      > >>>>    }
>      > >>>>
>      > >>>> +static bool ite_match(struct hid_device *hdev, bool ignore_special_driver)
>      > >>>> +{
>      > >>>> +       struct usb_interface *intf;
>      > >>>> +
>      > >>>> +       if (ignore_special_driver)
>      > >>>> +               return false;
>      > >>>> +
>      > >>>> +       /*
>      > >>>> +        * Most keyboard docks with an ITE 8595 keyboard/touchpad controller
>      > >>>> +        * have the "Wireless Radio Control" bits which need this special
>      > >>>> +        * driver on the second USB interface (the mouse interface). On
>      > >>>> +        * these devices we simply bind to all USB interfaces.
>      > >>>> +        *
>      > >>>> +        * The Acer Aspire Switch 10 (SW5-012) is special, its touchpad
>      > >>>> +        * not only does mouse emulation it also supports HID-multitouch
>      > >>>> +        * and all the keys including the "Wireless Radio Control" bits
>      > >>>> +        * have been moved to the first USB interface (the keyboard intf).
>      > >>>> +        *
>      > >>>> +        * We want the hid-multitouch driver to bind to the touchpad, so on
>      > >>>> +        * the Acer SW5-012 we should only bind to the keyboard USB intf.
>      > >>>> +        */
>      > >>>> +       if (hdev->bus != BUS_USB || hdev->vendor != USB_VENDOR_ID_SYNAPTICS ||
>      > >>>> +                    hdev->product != USB_DEVICE_ID_SYNAPTICS_ACER_SWITCH5_012)
>      > >>>
>      > >>> Isn't there an existing matching function we can use here, instead of
>      > >>> checking each individual field?
>      > >>
>      > >> There is hid_match_one_id() but that is not exported (can be fixed) and it
>      > >> requires a struct hid_device_id, which either requires declaring an extra
>      > >> standalone struct hid_device_id for the SW5-012 kbd-dock, or hardcoding an
>      > >> index into the existing hid_device_id array for the driver (with the hardcoding
>      > >> being error prone, so not a good idea).
>      > >>
>      > >> Given the problems with using hid_match_one_id() I decided to just go with
>      > >> the above.
>      > >
>      > > right. An other solution would be to have a local macro/function that
>      > > does that. Because as soon as you start adding a quirk, an other comes
>      > > right after.
>      > >
>      > >>
>      > >> But see below.
>      > >>
>      > >>>
>      > >>>> +               return true;
>      > >>>> +
>      > >>>> +       intf = to_usb_interface(hdev->dev.parent);
>      > >>>
>      > >>> And this is oops-prone. You need:
>      > >>> - ensure hid_is_using_ll_driver(hdev, &usb_hid_driver) returns true.
>      > >>> - add a dependency on USBHID in the KConfig now that you are checking
>      > >>> on the USB transport layer.
>      > >>>
>      > >>> That being said, I would love instead:
>      > >>> - to have a non USB version of this match, where you decide which
>      > >>> component needs to be handled based on the report descriptor
>      > >>
>      > >> Actually your idea to use the desciptors is not bad, but since what
>      > >> we really want is to not bind to the interface which is marked for the
>      > >> hid-multitouch driver I just realized we can just check that.
>      > >>
>      > >> So how about:
>      > >>
>      > >> static bool ite_match(struct hid_device *hdev, bool ignore_special_driver)
>      > >> {
>      > >>           if (ignore_special_driver)
>      > >>                   return false;
>      > >>
>      > >>           /*
>      > >>            * Some keyboard docks with an ITE 8595 keyboard/touchpad controller
>      > >>            * support the HID multitouch protocol for the touchpad, in that
>      > >>            * case the "Wireless Radio Control" bits which we care about are
>      > >>            * on the other interface; and we should not bind to the multitouch
>      > >>            * capable interface as that breaks multitouch support.
>      > >>            */
>      > >>           return hdev->group != HID_GROUP_MULTITOUCH_WIN_8;
>      > >> }
>      > >
>      > > Yep, I like that very much :)
>      >
>      > Actually if we want to check the group and there are only 2 interfaces we do
>      > not need to use the match callback at all, w e can simply match on the
>      > group of the interface which we do want:
>      >
>      > diff --git a/drivers/hid/hid-ite.c b/drivers/hid/hid-ite.c
>      > index db0f35be5a8b..21bd48f16033 100644
>      > --- a/drivers/hid/hid-ite.c
>      > +++ b/drivers/hid/hid-ite.c
>      > @@ -56,8 +56,9 @@ static const struct hid_device_id ite_devices[] = {
>      >         { HID_USB_DEVICE(USB_VENDOR_ID_ITE, USB_DEVICE_ID_ITE8595) },
>      >         { HID_USB_DEVICE(USB_VENDOR_ID_258A, USB_DEVICE_ID_258A_6A88) },
>      >         /* ITE8595 USB kbd ctlr, with Synaptics touchpad connected to it. */
>      > -       { HID_USB_DEVICE(USB_VENDOR_ID_SYNAPTICS,
>      > -                        USB_DEVICE_ID_SYNAPTICS_ACER_SWITCH5_012) },
>      > +       { HID_DEVICE(BUS_USB, HID_GROUP_GENERIC,
>      > +                    USB_VENDOR_ID_SYNAPTICS,
>      > +                    USB_DEVICE_ID_SYNAPTICS_ACER_SWITCH5_012) },
>      >         { }
>      >   };
>      >   MODULE_DEVICE_TABLE(hid, ite_devices);
>      >
>      > Much cleaner
> 
>     yep
> 
>      > (and now I don't need to write a test, which is always
>      > a good motivation to come up with a cleaner solution :)
> 
>     Hehe, too bad, you already picked up my curiosity on this one, and I
>     really would like to see the report descriptors and some events of the
>     keys that are fixed by hid-ite.c.
>     <with a low voice>This will be a hard requirement to accept this patch </joke>.
> 
>     More seriously, Zdeněk, can you run hid-recorder from
>     https://gitlab.freedesktop.org/libevdev/hid-tools/ and provide me the
>     report descriptor for all of your ITE HID devices? I'll add the
>     matching tests in hid-tools and be sure we do not regress in the
>     future.
> 
>      >
>      > Let me turn this into a proper patch and then I will send that to
>      > Zdeněk (off-list) for him to test (note don't worry if you do
>      > not have time to test this weekend, then I'll do it on Monday).
>      >
>      > Regards,
>      >
>      > Hans
>      >
>      > p.s.
>      >
>      > 1. My train is approaching Brussels (Fosdem) so my email response
>      > time will soon become irregular.
> 
>     How dare you? :)
> 
>      >
>      > 2. Benjamin will you be at Fosdem too ?
>      >
> 
>     Unfortunately no. Already got my quota of meeting people for this year
>     between Kernel Recipes in September, XDC in October and LCA last week.
>     So I need to keep in a quiet environment for a little bit :)
> 
>     Cheers,
>     Benjamin
> 


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1B8F14F783
	for <lists+stable@lfdr.de>; Sat,  1 Feb 2020 11:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgBAKXH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Feb 2020 05:23:07 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57335 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726297AbgBAKXH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 Feb 2020 05:23:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580552585;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ygk86g7XE5FJ86PQtQyq0klsIpzsmrdoJbkOKAtXeks=;
        b=NedCLvCOF+aUZlu5xW+HJ7D10+US7/rDFYY8gzcqSW3rWXf0tMaMZgIyfcrXNd5f7f03Op
        Q2Q8zNl/zVzmdTajyjNBsU4RLjhbaAlbtPnA+/OqxJK2uZyYbwIceNtre2Zq8yi2GhxOoM
        nb2N7vHYYA4c3Enj+kkI1rX4PQ50ynM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-179-HXSGH-KBN3KxXLhrxCy0Jw-1; Sat, 01 Feb 2020 05:23:00 -0500
X-MC-Unique: HXSGH-KBN3KxXLhrxCy0Jw-1
Received: by mail-wr1-f71.google.com with SMTP id h30so4801745wrh.5
        for <stable@vger.kernel.org>; Sat, 01 Feb 2020 02:23:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ygk86g7XE5FJ86PQtQyq0klsIpzsmrdoJbkOKAtXeks=;
        b=EkQpPi8YmZv7miPex3PtKVcnwrEADGs8w/WmFqaov5roUYFUCbIbIuUpgff8bWKN+y
         AO1S+9YWtvyVVg24w1TqgBuXx1LGwJodq8Gal7rxoEezehICxZoKXtcM7A3zG8wC4yFc
         Io2Q5NuoFbnD/Y/Gh6FbmnSdt/n3BQWic+jfl5zEPNgO6xsBQYA1EVrwxHvKFA0bvf3Y
         7/10P7t1MBZB4B2XjG0DhnwvtBJCTRcN9GrN21DDua1vZeCQLDE2keZ73RZbFWpYSgJz
         UBnbWtzlTB95C/3YVJUVvOCkl1XGhyCEVQjQsmMIDDjq5w9OnfxhFOkPjWYedggoZThs
         0AvA==
X-Gm-Message-State: APjAAAWxJLP8ixtOU0FY3347IB5casfGn7ThcEFL3gyQPWbdHRXMk2xw
        wv1/54ZC25z13VEhlh2iKGMy1hrSaoMoPnFT8TP4toSYono45cy5GDwQ22/bld8/XZnrnwWI/Id
        KD71RpQiomXdpFv/i
X-Received: by 2002:a5d:448c:: with SMTP id j12mr3925181wrq.125.1580552579349;
        Sat, 01 Feb 2020 02:22:59 -0800 (PST)
X-Google-Smtp-Source: APXvYqzZ/2tWm7o3QKYHJw6/ahvbsxG3Lk3p49HsaeYAdNRiSbSIQGMUviKWmZobt6xdXD51vZCZPg==
X-Received: by 2002:a5d:448c:: with SMTP id j12mr3925154wrq.125.1580552578994;
        Sat, 01 Feb 2020 02:22:58 -0800 (PST)
Received: from localhost.localdomain ([2001:67c:1810:f055:3fec:c198:3e12:89c7])
        by smtp.gmail.com with ESMTPSA id b17sm16284811wrp.49.2020.02.01.02.22.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Feb 2020 02:22:58 -0800 (PST)
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
 <fa288cc2-0560-1fa5-a629-20a7a33afeb2@redhat.com>
 <CABHH5-KNv7TU6=fiMk3JDxEX2mx7y9qr0Qx9sjOL9-=Rd5jsMw@mail.gmail.com>
 <CAO-hwJ+QnjLu1-Q_KneyOnpc-QaedYUdJUJHH-0E=Txv3kqy5Q@mail.gmail.com>
 <CABHH5-+MQZgj+Wz-BdHLJbK7X2dyyAES6KJspR=gK0TO0Dk73A@mail.gmail.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <ae52762f-b743-de74-f978-7607a4f02eaf@redhat.com>
Date:   Sat, 1 Feb 2020 11:22:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <CABHH5-+MQZgj+Wz-BdHLJbK7X2dyyAES6KJspR=gK0TO0Dk73A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 1/31/20 6:17 PM, Z R wrote:
> Hi Benjamin,
> in last log touchpad.log (omg, should be keyboard.log), I pressed fn-f3 multiple times. I got one two liner:
> 
> # ReportID: 3 / Wireless Radio Button: 0 | #
> E: 000007.606583 2 03 00
> 
> every time i release f3. Does not matter what is happening with fn-key. (could be released already or still pushed down). This log was collected with last patch from Hans applied.
> 
> Sorry for the mess I caused :-) I still don't get how you guys manage to have your emails so well polished and readable.

I don't think you've, caused a mess. Thank you both for the bug report and for your
help in testing this.

One last test request, can you run evemu-record on a kernel with my latest simplified patch,
select the keyboard device and then press (and release) the "rfkill" key and see it generates
a RF_KILL key press + release evdev event?

What would also be helpful is the output of:

ls -l /sys/bus/hid/devices/0003*/driver

Regards,

Hans





> pá 31. 1. 2020 v 18:00 odesílatel Benjamin Tissoires <benjamin.tissoires@redhat.com <mailto:benjamin.tissoires@redhat.com>> napsal:
> 
>     On Fri, Jan 31, 2020 at 5:09 PM Z R <zdenda.rampas@gmail.com <mailto:zdenda.rampas@gmail.com>> wrote:
>      >
>      > I believe I pressed wifi button on both replays for keyboard.
> 
>     Yep, I can see that. Just to double check, on the last log, you
>     pressed the wifi button twice?
> 
>     Anyway, thanks for all the logs, I should have enough to implement the
>     regression tests.
> 
>     Cheers,
>     Benjamin
> 
>      >
>      > With latest patch from Hans on top of v5.5.0 touchpads "two finger scrolling" is working again. Attaching current hid-record for keyboard with Wifi button pressed. Events in log appeared after f3 button was "released".
>      >
>      > Thanks
>      >
>      > Zdeněk
>      >
>      > pá 31. 1. 2020 v 16:45 odesílatel Hans de Goede <hdegoede@redhat.com <mailto:hdegoede@redhat.com>> napsal:
>      >>
>      >> Hi,
>      >>
>      >> On 1/31/20 4:38 PM, Z R wrote:
>      >> > Hi Benjamin,
>      >> > hid-record for keyboard and touchpad. With Commit 8f18eca9ebc5 reverted and from unmodified kernel.
>      >> >
>      >> > I hope it is what you asked for :-)
>      >> >
>      >> > Currently waiting for reworked patch from Hans.
>      >>
>      >> I just send you the reworked patch.
>      >>
>      >> Does the recordning include pressing of the wlan on/off key (Fn + F3 I believe) ?
>      >> That is the whole reason why the special hid-ite driver is necessary.
>      >>
>      >> Benjamin about the wlan on/off key. AFAICR on a press + release of the key a
>      >> single hid input report for the generic-desktop  Wireless Radio Controls group
>      >> is send. This input-report only has the one button with usage code HID_GD_RFKILL_BTN
>      >> in there and it is always 0. It is as if the input-report is only send on release
>      >> and not on press. So the hid-ite code emulates a press + release whenever the
>      >> input-report is send.
>      >>
>      >> IOW the receiving of the input report is (ab)used as indication of the button
>      >> having been pressed.
>      >>
>      >> Regards,
>      >>
>      >> Hans
>      >>
>      >>
>      >> >
>      >> > Bye for now
>      >> > Zdeněk
>      >> >
>      >> > pá 31. 1. 2020 v 15:12 odesílatel Benjamin Tissoires <benjamin.tissoires@redhat.com <mailto:benjamin.tissoires@redhat.com> <mailto:benjamin.tissoires@redhat.com <mailto:benjamin.tissoires@redhat.com>>> napsal:
>      >> >
>      >> >     On Fri, Jan 31, 2020 at 3:04 PM Hans de Goede <hdegoede@redhat.com <mailto:hdegoede@redhat.com> <mailto:hdegoede@redhat.com <mailto:hdegoede@redhat.com>>> wrote:
>      >> >      >
>      >> >      > Hi,
>      >> >      >
>      >> >      > On 1/31/20 2:54 PM, Benjamin Tissoires wrote:
>      >> >      > > On Fri, Jan 31, 2020 at 2:41 PM Hans de Goede <hdegoede@redhat.com <mailto:hdegoede@redhat.com> <mailto:hdegoede@redhat.com <mailto:hdegoede@redhat.com>>> wrote:
>      >> >      > >>
>      >> >      > >> Hi,
>      >> >      > >>
>      >> >      > >> On 1/31/20 2:10 PM, Benjamin Tissoires wrote:
>      >> >      > >>> Hi Hans,
>      >> >      > >>>
>      >> >      > >>> On Fri, Jan 31, 2020 at 1:46 PM Hans de Goede <hdegoede@redhat.com <mailto:hdegoede@redhat.com> <mailto:hdegoede@redhat.com <mailto:hdegoede@redhat.com>>> wrote:
>      >> >      > >>>>
>      >> >      > >>>> Commit 8f18eca9ebc5 ("HID: ite: Add USB id match for Acer SW5-012 keyboard
>      >> >      > >>>> dock") added the USB id for the Acer SW5-012's keyboard dock to the
>      >> >      > >>>> hid-ite driver to fix the rfkill driver not working.
>      >> >      > >>>>
>      >> >      > >>>> Most keyboard docks with an ITE 8595 keyboard/touchpad controller have the
>      >> >      > >>>> "Wireless Radio Control" bits which need the special hid-ite driver on the
>      >> >      > >>>> second USB interface (the mouse interface) and their touchpad only supports
>      >> >      > >>>> mouse emulation, so using generic hid-input handling for anything but
>      >> >      > >>>> the "Wireless Radio Control" bits is fine. On these devices we simply bind
>      >> >      > >>>> to all USB interfaces.
>      >> >      > >>>>
>      >> >      > >>>> But unlike other ITE8595 using keyboard docks, the Acer Aspire Switch 10
>      >> >      > >>>> (SW5-012)'s touchpad not only does mouse emulation it also supports
>      >> >      > >>>> HID-multitouch and all the keys including the "Wireless Radio Control"
>      >> >      > >>>> bits have been moved to the first USB interface (the keyboard intf).
>      >> >      > >>>>
>      >> >      > >>>> So we need hid-ite to handle the first (keyboard) USB interface and have
>      >> >      > >>>> it NOT bind to the second (mouse) USB interface so that that can be
>      >> >      > >>>> handled by hid-multitouch.c and we get proper multi-touch support.
>      >> >      > >>>>
>      >> >      > >>>> This commit adds a match callback to hid-ite which makes it only
>      >> >      > >>>> match the first USB interface when running on the Acer SW5-012,
>      >> >      > >>>> fixing the regression to mouse-emulation mode introduced by adding the
>      >> >      > >>>> keyboard dock USB id.
>      >> >      > >>>>
>      >> >      > >>>> Note the match function only does the special only bind to the first
>      >> >      > >>>> USB interface on the Acer SW5-012, on other devices the hid-ite driver
>      >> >      > >>>> actually must bind to the second interface as that is where the
>      >> >      > >>>> "Wireless Radio Control" bits are.
>      >> >      > >>>
>      >> >      > >>> This is not a full review, but a couple of things that popped out
>      >> >      > >>> while scrolling through the patch.
>      >> >      > >>>
>      >> >      > >>>>
>      >> >      > >>>> Cc: stable@vger.kernel.org <mailto:stable@vger.kernel.org> <mailto:stable@vger.kernel.org <mailto:stable@vger.kernel.org>>
>      >> >      > >>>> Fixes: 8f18eca9ebc5 ("HID: ite: Add USB id match for Acer SW5-012 keyboard dock")
>      >> >      > >>>> Reported-by: Zdeněk Rampas <zdenda.rampas@gmail.com <mailto:zdenda.rampas@gmail.com> <mailto:zdenda.rampas@gmail.com <mailto:zdenda.rampas@gmail.com>>>
>      >> >      > >>>> Signed-off-by: Hans de Goede <hdegoede@redhat.com <mailto:hdegoede@redhat.com> <mailto:hdegoede@redhat.com <mailto:hdegoede@redhat.com>>>
>      >> >      > >>>> ---
>      >> >      > >>>>    drivers/hid/hid-ite.c | 34 ++++++++++++++++++++++++++++++++++
>      >> >      > >>>>    1 file changed, 34 insertions(+)
>      >> >      > >>>>
>      >> >      > >>>> diff --git a/drivers/hid/hid-ite.c b/drivers/hid/hid-ite.c
>      >> >      > >>>> index c436e12feb23..69a4ddfd033d 100644
>      >> >      > >>>> --- a/drivers/hid/hid-ite.c
>      >> >      > >>>> +++ b/drivers/hid/hid-ite.c
>      >> >      > >>>> @@ -8,9 +8,12 @@
>      >> >      > >>>>    #include <linux/input.h>
>      >> >      > >>>>    #include <linux/hid.h>
>      >> >      > >>>>    #include <linux/module.h>
>      >> >      > >>>> +#include <linux/usb.h>
>      >> >      > >>>>
>      >> >      > >>>>    #include "hid-ids.h"
>      >> >      > >>>>
>      >> >      > >>>> +#define ITE8595_KBD_USB_INTF           0
>      >> >      > >>>> +
>      >> >      > >>>>    static int ite_event(struct hid_device *hdev, struct hid_field *field,
>      >> >      > >>>>                        struct hid_usage *usage, __s32 value)
>      >> >      > >>>>    {
>      >> >      > >>>> @@ -37,6 +40,36 @@ static int ite_event(struct hid_device *hdev, struct hid_field *field,
>      >> >      > >>>>           return 0;
>      >> >      > >>>>    }
>      >> >      > >>>>
>      >> >      > >>>> +static bool ite_match(struct hid_device *hdev, bool ignore_special_driver)
>      >> >      > >>>> +{
>      >> >      > >>>> +       struct usb_interface *intf;
>      >> >      > >>>> +
>      >> >      > >>>> +       if (ignore_special_driver)
>      >> >      > >>>> +               return false;
>      >> >      > >>>> +
>      >> >      > >>>> +       /*
>      >> >      > >>>> +        * Most keyboard docks with an ITE 8595 keyboard/touchpad controller
>      >> >      > >>>> +        * have the "Wireless Radio Control" bits which need this special
>      >> >      > >>>> +        * driver on the second USB interface (the mouse interface). On
>      >> >      > >>>> +        * these devices we simply bind to all USB interfaces.
>      >> >      > >>>> +        *
>      >> >      > >>>> +        * The Acer Aspire Switch 10 (SW5-012) is special, its touchpad
>      >> >      > >>>> +        * not only does mouse emulation it also supports HID-multitouch
>      >> >      > >>>> +        * and all the keys including the "Wireless Radio Control" bits
>      >> >      > >>>> +        * have been moved to the first USB interface (the keyboard intf).
>      >> >      > >>>> +        *
>      >> >      > >>>> +        * We want the hid-multitouch driver to bind to the touchpad, so on
>      >> >      > >>>> +        * the Acer SW5-012 we should only bind to the keyboard USB intf.
>      >> >      > >>>> +        */
>      >> >      > >>>> +       if (hdev->bus != BUS_USB || hdev->vendor != USB_VENDOR_ID_SYNAPTICS ||
>      >> >      > >>>> +                    hdev->product != USB_DEVICE_ID_SYNAPTICS_ACER_SWITCH5_012)
>      >> >      > >>>
>      >> >      > >>> Isn't there an existing matching function we can use here, instead of
>      >> >      > >>> checking each individual field?
>      >> >      > >>
>      >> >      > >> There is hid_match_one_id() but that is not exported (can be fixed) and it
>      >> >      > >> requires a struct hid_device_id, which either requires declaring an extra
>      >> >      > >> standalone struct hid_device_id for the SW5-012 kbd-dock, or hardcoding an
>      >> >      > >> index into the existing hid_device_id array for the driver (with the hardcoding
>      >> >      > >> being error prone, so not a good idea).
>      >> >      > >>
>      >> >      > >> Given the problems with using hid_match_one_id() I decided to just go with
>      >> >      > >> the above.
>      >> >      > >
>      >> >      > > right. An other solution would be to have a local macro/function that
>      >> >      > > does that. Because as soon as you start adding a quirk, an other comes
>      >> >      > > right after.
>      >> >      > >
>      >> >      > >>
>      >> >      > >> But see below.
>      >> >      > >>
>      >> >      > >>>
>      >> >      > >>>> +               return true;
>      >> >      > >>>> +
>      >> >      > >>>> +       intf = to_usb_interface(hdev->dev.parent);
>      >> >      > >>>
>      >> >      > >>> And this is oops-prone. You need:
>      >> >      > >>> - ensure hid_is_using_ll_driver(hdev, &usb_hid_driver) returns true.
>      >> >      > >>> - add a dependency on USBHID in the KConfig now that you are checking
>      >> >      > >>> on the USB transport layer.
>      >> >      > >>>
>      >> >      > >>> That being said, I would love instead:
>      >> >      > >>> - to have a non USB version of this match, where you decide which
>      >> >      > >>> component needs to be handled based on the report descriptor
>      >> >      > >>
>      >> >      > >> Actually your idea to use the desciptors is not bad, but since what
>      >> >      > >> we really want is to not bind to the interface which is marked for the
>      >> >      > >> hid-multitouch driver I just realized we can just check that.
>      >> >      > >>
>      >> >      > >> So how about:
>      >> >      > >>
>      >> >      > >> static bool ite_match(struct hid_device *hdev, bool ignore_special_driver)
>      >> >      > >> {
>      >> >      > >>           if (ignore_special_driver)
>      >> >      > >>                   return false;
>      >> >      > >>
>      >> >      > >>           /*
>      >> >      > >>            * Some keyboard docks with an ITE 8595 keyboard/touchpad controller
>      >> >      > >>            * support the HID multitouch protocol for the touchpad, in that
>      >> >      > >>            * case the "Wireless Radio Control" bits which we care about are
>      >> >      > >>            * on the other interface; and we should not bind to the multitouch
>      >> >      > >>            * capable interface as that breaks multitouch support.
>      >> >      > >>            */
>      >> >      > >>           return hdev->group != HID_GROUP_MULTITOUCH_WIN_8;
>      >> >      > >> }
>      >> >      > >
>      >> >      > > Yep, I like that very much :)
>      >> >      >
>      >> >      > Actually if we want to check the group and there are only 2 interfaces we do
>      >> >      > not need to use the match callback at all, w e can simply match on the
>      >> >      > group of the interface which we do want:
>      >> >      >
>      >> >      > diff --git a/drivers/hid/hid-ite.c b/drivers/hid/hid-ite.c
>      >> >      > index db0f35be5a8b..21bd48f16033 100644
>      >> >      > --- a/drivers/hid/hid-ite.c
>      >> >      > +++ b/drivers/hid/hid-ite.c
>      >> >      > @@ -56,8 +56,9 @@ static const struct hid_device_id ite_devices[] = {
>      >> >      >         { HID_USB_DEVICE(USB_VENDOR_ID_ITE, USB_DEVICE_ID_ITE8595) },
>      >> >      >         { HID_USB_DEVICE(USB_VENDOR_ID_258A, USB_DEVICE_ID_258A_6A88) },
>      >> >      >         /* ITE8595 USB kbd ctlr, with Synaptics touchpad connected to it. */
>      >> >      > -       { HID_USB_DEVICE(USB_VENDOR_ID_SYNAPTICS,
>      >> >      > -                        USB_DEVICE_ID_SYNAPTICS_ACER_SWITCH5_012) },
>      >> >      > +       { HID_DEVICE(BUS_USB, HID_GROUP_GENERIC,
>      >> >      > +                    USB_VENDOR_ID_SYNAPTICS,
>      >> >      > +                    USB_DEVICE_ID_SYNAPTICS_ACER_SWITCH5_012) },
>      >> >      >         { }
>      >> >      >   };
>      >> >      >   MODULE_DEVICE_TABLE(hid, ite_devices);
>      >> >      >
>      >> >      > Much cleaner
>      >> >
>      >> >     yep
>      >> >
>      >> >      > (and now I don't need to write a test, which is always
>      >> >      > a good motivation to come up with a cleaner solution :)
>      >> >
>      >> >     Hehe, too bad, you already picked up my curiosity on this one, and I
>      >> >     really would like to see the report descriptors and some events of the
>      >> >     keys that are fixed by hid-ite.c.
>      >> >     <with a low voice>This will be a hard requirement to accept this patch </joke>.
>      >> >
>      >> >     More seriously, Zdeněk, can you run hid-recorder from
>      >> > https://gitlab.freedesktop.org/libevdev/hid-tools/ and provide me the
>      >> >     report descriptor for all of your ITE HID devices? I'll add the
>      >> >     matching tests in hid-tools and be sure we do not regress in the
>      >> >     future.
>      >> >
>      >> >      >
>      >> >      > Let me turn this into a proper patch and then I will send that to
>      >> >      > Zdeněk (off-list) for him to test (note don't worry if you do
>      >> >      > not have time to test this weekend, then I'll do it on Monday).
>      >> >      >
>      >> >      > Regards,
>      >> >      >
>      >> >      > Hans
>      >> >      >
>      >> >      > p.s.
>      >> >      >
>      >> >      > 1. My train is approaching Brussels (Fosdem) so my email response
>      >> >      > time will soon become irregular.
>      >> >
>      >> >     How dare you? :)
>      >> >
>      >> >      >
>      >> >      > 2. Benjamin will you be at Fosdem too ?
>      >> >      >
>      >> >
>      >> >     Unfortunately no. Already got my quota of meeting people for this year
>      >> >     between Kernel Recipes in September, XDC in October and LCA last week.
>      >> >     So I need to keep in a quiet environment for a little bit :)
>      >> >
>      >> >     Cheers,
>      >> >     Benjamin
>      >> >
>      >>
> 


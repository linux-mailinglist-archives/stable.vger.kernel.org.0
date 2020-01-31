Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA6214EE32
	for <lists+stable@lfdr.de>; Fri, 31 Jan 2020 15:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728804AbgAaOML (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jan 2020 09:12:11 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51593 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728771AbgAaOML (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Jan 2020 09:12:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580479930;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W26MWgCKM2hNfmbr4HIoJZCEwxPHOrRCzwAg6nJsQ6s=;
        b=GjX3RDoxXGC7HYjmB5ixY5RKVVKVv6GvxAxrmVr9DhXtkY6E2oGlVLXjiTFPaYOOVSKfTH
        /s5MZb+NcrLXynofOG2u4bfck2ACDlLLcpH1BWp9fA0RtvXBvBpQiD+mRuoyyvinS1H/6b
        cm083xVN4Acu7ujeUOCoD3S1a+KEOL0=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-293-3t6tmYYwMCGUI6clb5ji8Q-1; Fri, 31 Jan 2020 09:11:53 -0500
X-MC-Unique: 3t6tmYYwMCGUI6clb5ji8Q-1
Received: by mail-qv1-f72.google.com with SMTP id l5so4455456qvq.7
        for <stable@vger.kernel.org>; Fri, 31 Jan 2020 06:11:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=W26MWgCKM2hNfmbr4HIoJZCEwxPHOrRCzwAg6nJsQ6s=;
        b=Dp/7YF1uVD9UC0PNNcJDu4gvS9OS/UnYJ4J49fd0LNl9ZxL14Mvnx1aMeyMPnT81SX
         9YcFAPXzOWP90Fn1kRyjD0qOYtG36hlQn3aDFI18+E0mmBhXVTeW3dSqDZ8WydbDdEBp
         OoPReu0iHEc10EV6E2rKaRmRlSFS9NJMkUlHI6r+U/89w0XTADP/2z8c/qO7E+ulLfDf
         f3s2GjYzAiFudL1LyftOvn5YIzzKgTHB8IuRHH4ehunK3yvUS48mFkoNiZ5tZWyWh5a/
         w/hPrqaL7hJQZWxOy5zeMJ+Jy9LlgTE7vhyonv0Lt1UQgVdrV6YrrCwPqxyLn+Qv4C87
         DalQ==
X-Gm-Message-State: APjAAAVx/cjaT7H7vzeTMahqjQfkKOl2g9Et4KvWcyMbAf82LEguD4LP
        L6i32GCUarSlT7hqXGaN9Hjv9gjpvbDtysrfqVafnA4XxtXwGh6Hxofl+F/A6AhSPASPLV/Jy1e
        rRIoMVZZC9A2upfMwrJtQEfybAEUOGWWb
X-Received: by 2002:ad4:514e:: with SMTP id g14mr10384284qvq.196.1580479912517;
        Fri, 31 Jan 2020 06:11:52 -0800 (PST)
X-Google-Smtp-Source: APXvYqwoPaFxzXxGvX9q9qtwzkyDr0d5CRrsKhyblj2K3wp6pWOcFjYzMbDsUavXxwVWQExhsfAWedOgwICQpk5Cl1U=
X-Received: by 2002:ad4:514e:: with SMTP id g14mr10384233qvq.196.1580479912098;
 Fri, 31 Jan 2020 06:11:52 -0800 (PST)
MIME-Version: 1.0
References: <20200131124553.27796-1-hdegoede@redhat.com> <CAO-hwJK-wwZ8UJRaBgjVc0ZXakU9C3eDbh+i6Q5vm8xh1P76LQ@mail.gmail.com>
 <ea896405-6784-7cfd-b27c-28e8ebc3cd7e@redhat.com> <CAO-hwJJ1v30NT5quobYawV9yv87buyrQXOG9u-nY3zXXSrCGvg@mail.gmail.com>
 <6d94cf74-c28f-08b0-a136-044c231b8bc5@redhat.com>
In-Reply-To: <6d94cf74-c28f-08b0-a136-044c231b8bc5@redhat.com>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Fri, 31 Jan 2020 15:11:41 +0100
Message-ID: <CAO-hwJ+o5CvU3Pv+dQV2gSTeF+n0AGkjwYJvWfX_ZYtM=OtH6g@mail.gmail.com>
Subject: Re: [PATCH] HID: ite: Only bind to keyboard USB interface on Acer
 SW5-012 keyboard dock
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        "3.8+" <stable@vger.kernel.org>,
        =?UTF-8?Q?Zden=C4=9Bk_Rampas?= <zdenda.rampas@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 31, 2020 at 3:04 PM Hans de Goede <hdegoede@redhat.com> wrote:
>
> Hi,
>
> On 1/31/20 2:54 PM, Benjamin Tissoires wrote:
> > On Fri, Jan 31, 2020 at 2:41 PM Hans de Goede <hdegoede@redhat.com> wro=
te:
> >>
> >> Hi,
> >>
> >> On 1/31/20 2:10 PM, Benjamin Tissoires wrote:
> >>> Hi Hans,
> >>>
> >>> On Fri, Jan 31, 2020 at 1:46 PM Hans de Goede <hdegoede@redhat.com> w=
rote:
> >>>>
> >>>> Commit 8f18eca9ebc5 ("HID: ite: Add USB id match for Acer SW5-012 ke=
yboard
> >>>> dock") added the USB id for the Acer SW5-012's keyboard dock to the
> >>>> hid-ite driver to fix the rfkill driver not working.
> >>>>
> >>>> Most keyboard docks with an ITE 8595 keyboard/touchpad controller ha=
ve the
> >>>> "Wireless Radio Control" bits which need the special hid-ite driver =
on the
> >>>> second USB interface (the mouse interface) and their touchpad only s=
upports
> >>>> mouse emulation, so using generic hid-input handling for anything bu=
t
> >>>> the "Wireless Radio Control" bits is fine. On these devices we simpl=
y bind
> >>>> to all USB interfaces.
> >>>>
> >>>> But unlike other ITE8595 using keyboard docks, the Acer Aspire Switc=
h 10
> >>>> (SW5-012)'s touchpad not only does mouse emulation it also supports
> >>>> HID-multitouch and all the keys including the "Wireless Radio Contro=
l"
> >>>> bits have been moved to the first USB interface (the keyboard intf).
> >>>>
> >>>> So we need hid-ite to handle the first (keyboard) USB interface and =
have
> >>>> it NOT bind to the second (mouse) USB interface so that that can be
> >>>> handled by hid-multitouch.c and we get proper multi-touch support.
> >>>>
> >>>> This commit adds a match callback to hid-ite which makes it only
> >>>> match the first USB interface when running on the Acer SW5-012,
> >>>> fixing the regression to mouse-emulation mode introduced by adding t=
he
> >>>> keyboard dock USB id.
> >>>>
> >>>> Note the match function only does the special only bind to the first
> >>>> USB interface on the Acer SW5-012, on other devices the hid-ite driv=
er
> >>>> actually must bind to the second interface as that is where the
> >>>> "Wireless Radio Control" bits are.
> >>>
> >>> This is not a full review, but a couple of things that popped out
> >>> while scrolling through the patch.
> >>>
> >>>>
> >>>> Cc: stable@vger.kernel.org
> >>>> Fixes: 8f18eca9ebc5 ("HID: ite: Add USB id match for Acer SW5-012 ke=
yboard dock")
> >>>> Reported-by: Zden=C4=9Bk Rampas <zdenda.rampas@gmail.com>
> >>>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> >>>> ---
> >>>>    drivers/hid/hid-ite.c | 34 ++++++++++++++++++++++++++++++++++
> >>>>    1 file changed, 34 insertions(+)
> >>>>
> >>>> diff --git a/drivers/hid/hid-ite.c b/drivers/hid/hid-ite.c
> >>>> index c436e12feb23..69a4ddfd033d 100644
> >>>> --- a/drivers/hid/hid-ite.c
> >>>> +++ b/drivers/hid/hid-ite.c
> >>>> @@ -8,9 +8,12 @@
> >>>>    #include <linux/input.h>
> >>>>    #include <linux/hid.h>
> >>>>    #include <linux/module.h>
> >>>> +#include <linux/usb.h>
> >>>>
> >>>>    #include "hid-ids.h"
> >>>>
> >>>> +#define ITE8595_KBD_USB_INTF           0
> >>>> +
> >>>>    static int ite_event(struct hid_device *hdev, struct hid_field *f=
ield,
> >>>>                        struct hid_usage *usage, __s32 value)
> >>>>    {
> >>>> @@ -37,6 +40,36 @@ static int ite_event(struct hid_device *hdev, str=
uct hid_field *field,
> >>>>           return 0;
> >>>>    }
> >>>>
> >>>> +static bool ite_match(struct hid_device *hdev, bool ignore_special_=
driver)
> >>>> +{
> >>>> +       struct usb_interface *intf;
> >>>> +
> >>>> +       if (ignore_special_driver)
> >>>> +               return false;
> >>>> +
> >>>> +       /*
> >>>> +        * Most keyboard docks with an ITE 8595 keyboard/touchpad co=
ntroller
> >>>> +        * have the "Wireless Radio Control" bits which need this sp=
ecial
> >>>> +        * driver on the second USB interface (the mouse interface).=
 On
> >>>> +        * these devices we simply bind to all USB interfaces.
> >>>> +        *
> >>>> +        * The Acer Aspire Switch 10 (SW5-012) is special, its touch=
pad
> >>>> +        * not only does mouse emulation it also supports HID-multit=
ouch
> >>>> +        * and all the keys including the "Wireless Radio Control" b=
its
> >>>> +        * have been moved to the first USB interface (the keyboard =
intf).
> >>>> +        *
> >>>> +        * We want the hid-multitouch driver to bind to the touchpad=
, so on
> >>>> +        * the Acer SW5-012 we should only bind to the keyboard USB =
intf.
> >>>> +        */
> >>>> +       if (hdev->bus !=3D BUS_USB || hdev->vendor !=3D USB_VENDOR_I=
D_SYNAPTICS ||
> >>>> +                    hdev->product !=3D USB_DEVICE_ID_SYNAPTICS_ACER=
_SWITCH5_012)
> >>>
> >>> Isn't there an existing matching function we can use here, instead of
> >>> checking each individual field?
> >>
> >> There is hid_match_one_id() but that is not exported (can be fixed) an=
d it
> >> requires a struct hid_device_id, which either requires declaring an ex=
tra
> >> standalone struct hid_device_id for the SW5-012 kbd-dock, or hardcodin=
g an
> >> index into the existing hid_device_id array for the driver (with the h=
ardcoding
> >> being error prone, so not a good idea).
> >>
> >> Given the problems with using hid_match_one_id() I decided to just go =
with
> >> the above.
> >
> > right. An other solution would be to have a local macro/function that
> > does that. Because as soon as you start adding a quirk, an other comes
> > right after.
> >
> >>
> >> But see below.
> >>
> >>>
> >>>> +               return true;
> >>>> +
> >>>> +       intf =3D to_usb_interface(hdev->dev.parent);
> >>>
> >>> And this is oops-prone. You need:
> >>> - ensure hid_is_using_ll_driver(hdev, &usb_hid_driver) returns true.
> >>> - add a dependency on USBHID in the KConfig now that you are checking
> >>> on the USB transport layer.
> >>>
> >>> That being said, I would love instead:
> >>> - to have a non USB version of this match, where you decide which
> >>> component needs to be handled based on the report descriptor
> >>
> >> Actually your idea to use the desciptors is not bad, but since what
> >> we really want is to not bind to the interface which is marked for the
> >> hid-multitouch driver I just realized we can just check that.
> >>
> >> So how about:
> >>
> >> static bool ite_match(struct hid_device *hdev, bool ignore_special_dri=
ver)
> >> {
> >>           if (ignore_special_driver)
> >>                   return false;
> >>
> >>           /*
> >>            * Some keyboard docks with an ITE 8595 keyboard/touchpad co=
ntroller
> >>            * support the HID multitouch protocol for the touchpad, in =
that
> >>            * case the "Wireless Radio Control" bits which we care abou=
t are
> >>            * on the other interface; and we should not bind to the mul=
titouch
> >>            * capable interface as that breaks multitouch support.
> >>            */
> >>           return hdev->group !=3D HID_GROUP_MULTITOUCH_WIN_8;
> >> }
> >
> > Yep, I like that very much :)
>
> Actually if we want to check the group and there are only 2 interfaces we=
 do
> not need to use the match callback at all, w e can simply match on the
> group of the interface which we do want:
>
> diff --git a/drivers/hid/hid-ite.c b/drivers/hid/hid-ite.c
> index db0f35be5a8b..21bd48f16033 100644
> --- a/drivers/hid/hid-ite.c
> +++ b/drivers/hid/hid-ite.c
> @@ -56,8 +56,9 @@ static const struct hid_device_id ite_devices[] =3D {
>         { HID_USB_DEVICE(USB_VENDOR_ID_ITE, USB_DEVICE_ID_ITE8595) },
>         { HID_USB_DEVICE(USB_VENDOR_ID_258A, USB_DEVICE_ID_258A_6A88) },
>         /* ITE8595 USB kbd ctlr, with Synaptics touchpad connected to it.=
 */
> -       { HID_USB_DEVICE(USB_VENDOR_ID_SYNAPTICS,
> -                        USB_DEVICE_ID_SYNAPTICS_ACER_SWITCH5_012) },
> +       { HID_DEVICE(BUS_USB, HID_GROUP_GENERIC,
> +                    USB_VENDOR_ID_SYNAPTICS,
> +                    USB_DEVICE_ID_SYNAPTICS_ACER_SWITCH5_012) },
>         { }
>   };
>   MODULE_DEVICE_TABLE(hid, ite_devices);
>
> Much cleaner

yep

> (and now I don't need to write a test, which is always
> a good motivation to come up with a cleaner solution :)

Hehe, too bad, you already picked up my curiosity on this one, and I
really would like to see the report descriptors and some events of the
keys that are fixed by hid-ite.c.
<with a low voice>This will be a hard requirement to accept this patch </jo=
ke>.

More seriously, Zden=C4=9Bk, can you run hid-recorder from
https://gitlab.freedesktop.org/libevdev/hid-tools/ and provide me the
report descriptor for all of your ITE HID devices? I'll add the
matching tests in hid-tools and be sure we do not regress in the
future.

>
> Let me turn this into a proper patch and then I will send that to
> Zden=C4=9Bk (off-list) for him to test (note don't worry if you do
> not have time to test this weekend, then I'll do it on Monday).
>
> Regards,
>
> Hans
>
> p.s.
>
> 1. My train is approaching Brussels (Fosdem) so my email response
> time will soon become irregular.

How dare you? :)

>
> 2. Benjamin will you be at Fosdem too ?
>

Unfortunately no. Already got my quota of meeting people for this year
between Kernel Recipes in September, XDC in October and LCA last week.
So I need to keep in a quiet environment for a little bit :)

Cheers,
Benjamin


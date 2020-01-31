Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C81514F0FC
	for <lists+stable@lfdr.de>; Fri, 31 Jan 2020 18:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbgAaRAC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jan 2020 12:00:02 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59040 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726712AbgAaRAC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Jan 2020 12:00:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580490000;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h3fbEhuXDHYWHqGssrqV3FdyYWjTwQyNm04imGz7cZY=;
        b=K5ehJLaTt5JfV5oI6sv75n1Z+gMW1sSJ18KsZPLVyLSDUBDWZIck0t79v2v1KnFy/gkq73
        zotyB/MRMNiDXKjC4MZzSi+fBUOI7B/MOxqNbMrzpOtflowejs+z7ThJ2CZlxSjQ0N0EH9
        R93MDluozClZFw47L8kku1PVkTvIVA8=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-362-oEtch5xONiugaGWCGrvIGw-1; Fri, 31 Jan 2020 11:59:54 -0500
X-MC-Unique: oEtch5xONiugaGWCGrvIGw-1
Received: by mail-qk1-f200.google.com with SMTP id a132so4476688qkg.5
        for <stable@vger.kernel.org>; Fri, 31 Jan 2020 08:59:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=h3fbEhuXDHYWHqGssrqV3FdyYWjTwQyNm04imGz7cZY=;
        b=VcjIK9LgYvl5GpS7NBGgoofxvi1Vt713eJEmJEevGxN7LILjDPxpKpCqpuhrYEd/1d
         Sb8O3KiZIddtXwq+AdiHbf7xKUbO8VusRKItlSEjybLPS6DA6POVCxHk26gRkiq5o/7z
         cu05Hr7uN4ONNzTc+J3LmKCobDxB9A69qSwq7b2MGFRb1iVfA7xSKRpck1DiJR7ISdxx
         U1SEbarIZ4UNo4yhBzL8Qh67kpNuyai/hIK7udf0kfSRWNPbvsXND9cwQ6J3NahWD/+X
         RsScu1mPuqz+ycXfQKyDbvPxaFPVidVJLIjZz+ebcliijQFFV/arRxOLsJNxLbM8w5r/
         zYGw==
X-Gm-Message-State: APjAAAU4jufXBfpuAepUCMmIG14swDkGXHKYjuJgXtgnbx/X0cH7C8ZA
        7lSCdz5rQYSDFTAz3Lc7p9bXNKXDCZ0zjnq3VNetdM1YGvWNiL07N3gLBuBVZG+8wD/UheXFWW1
        mLdoWPx+hD+gsNIym6lNuGbxw8MxLzDlj
X-Received: by 2002:a05:620a:782:: with SMTP id 2mr11774326qka.169.1580489994018;
        Fri, 31 Jan 2020 08:59:54 -0800 (PST)
X-Google-Smtp-Source: APXvYqztQBC+Uq5sxTBjm0u2yeI96phxPqbOn/w1oiFrSQqDvWyp2ClwHTZNqHH5ta9Eic4FuxMJ8nHdyBd577Ewq2c=
X-Received: by 2002:a05:620a:782:: with SMTP id 2mr11774291qka.169.1580489993625;
 Fri, 31 Jan 2020 08:59:53 -0800 (PST)
MIME-Version: 1.0
References: <20200131124553.27796-1-hdegoede@redhat.com> <CAO-hwJK-wwZ8UJRaBgjVc0ZXakU9C3eDbh+i6Q5vm8xh1P76LQ@mail.gmail.com>
 <ea896405-6784-7cfd-b27c-28e8ebc3cd7e@redhat.com> <CAO-hwJJ1v30NT5quobYawV9yv87buyrQXOG9u-nY3zXXSrCGvg@mail.gmail.com>
 <6d94cf74-c28f-08b0-a136-044c231b8bc5@redhat.com> <CAO-hwJ+o5CvU3Pv+dQV2gSTeF+n0AGkjwYJvWfX_ZYtM=OtH6g@mail.gmail.com>
 <CABHH5-LmC3JOWyDoxC5hizZe6RZ6RuO=-gk8WDXvU9Z2usihXg@mail.gmail.com>
 <fa288cc2-0560-1fa5-a629-20a7a33afeb2@redhat.com> <CABHH5-KNv7TU6=fiMk3JDxEX2mx7y9qr0Qx9sjOL9-=Rd5jsMw@mail.gmail.com>
In-Reply-To: <CABHH5-KNv7TU6=fiMk3JDxEX2mx7y9qr0Qx9sjOL9-=Rd5jsMw@mail.gmail.com>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Fri, 31 Jan 2020 17:59:42 +0100
Message-ID: <CAO-hwJ+QnjLu1-Q_KneyOnpc-QaedYUdJUJHH-0E=Txv3kqy5Q@mail.gmail.com>
Subject: Re: [PATCH] HID: ite: Only bind to keyboard USB interface on Acer
 SW5-012 keyboard dock
To:     Z R <zdenda.rampas@gmail.com>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        "3.8+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 31, 2020 at 5:09 PM Z R <zdenda.rampas@gmail.com> wrote:
>
> I believe I pressed wifi button on both replays for keyboard.

Yep, I can see that. Just to double check, on the last log, you
pressed the wifi button twice?

Anyway, thanks for all the logs, I should have enough to implement the
regression tests.

Cheers,
Benjamin

>
> With latest patch from Hans on top of v5.5.0 touchpads "two finger scroll=
ing" is working again. Attaching current hid-record for keyboard with Wifi =
button pressed. Events in log appeared after f3 button was "released".
>
> Thanks
>
> Zden=C4=9Bk
>
> p=C3=A1 31. 1. 2020 v 16:45 odes=C3=ADlatel Hans de Goede <hdegoede@redha=
t.com> napsal:
>>
>> Hi,
>>
>> On 1/31/20 4:38 PM, Z R wrote:
>> > Hi Benjamin,
>> > hid-record for keyboard and touchpad. With Commit 8f18eca9ebc5 reverte=
d and from unmodified kernel.
>> >
>> > I hope it is what you asked for :-)
>> >
>> > Currently waiting for reworked patch from Hans.
>>
>> I just send you the reworked patch.
>>
>> Does the recordning include pressing of the wlan on/off key (Fn + F3 I b=
elieve) ?
>> That is the whole reason why the special hid-ite driver is necessary.
>>
>> Benjamin about the wlan on/off key. AFAICR on a press + release of the k=
ey a
>> single hid input report for the generic-desktop  Wireless Radio Controls=
 group
>> is send. This input-report only has the one button with usage code HID_G=
D_RFKILL_BTN
>> in there and it is always 0. It is as if the input-report is only send o=
n release
>> and not on press. So the hid-ite code emulates a press + release wheneve=
r the
>> input-report is send.
>>
>> IOW the receiving of the input report is (ab)used as indication of the b=
utton
>> having been pressed.
>>
>> Regards,
>>
>> Hans
>>
>>
>> >
>> > Bye for now
>> > Zden=C4=9Bk
>> >
>> > p=C3=A1 31. 1. 2020 v 15:12 odes=C3=ADlatel Benjamin Tissoires <benjam=
in.tissoires@redhat.com <mailto:benjamin.tissoires@redhat.com>> napsal:
>> >
>> >     On Fri, Jan 31, 2020 at 3:04 PM Hans de Goede <hdegoede@redhat.com=
 <mailto:hdegoede@redhat.com>> wrote:
>> >      >
>> >      > Hi,
>> >      >
>> >      > On 1/31/20 2:54 PM, Benjamin Tissoires wrote:
>> >      > > On Fri, Jan 31, 2020 at 2:41 PM Hans de Goede <hdegoede@redha=
t.com <mailto:hdegoede@redhat.com>> wrote:
>> >      > >>
>> >      > >> Hi,
>> >      > >>
>> >      > >> On 1/31/20 2:10 PM, Benjamin Tissoires wrote:
>> >      > >>> Hi Hans,
>> >      > >>>
>> >      > >>> On Fri, Jan 31, 2020 at 1:46 PM Hans de Goede <hdegoede@red=
hat.com <mailto:hdegoede@redhat.com>> wrote:
>> >      > >>>>
>> >      > >>>> Commit 8f18eca9ebc5 ("HID: ite: Add USB id match for Acer =
SW5-012 keyboard
>> >      > >>>> dock") added the USB id for the Acer SW5-012's keyboard do=
ck to the
>> >      > >>>> hid-ite driver to fix the rfkill driver not working.
>> >      > >>>>
>> >      > >>>> Most keyboard docks with an ITE 8595 keyboard/touchpad con=
troller have the
>> >      > >>>> "Wireless Radio Control" bits which need the special hid-i=
te driver on the
>> >      > >>>> second USB interface (the mouse interface) and their touch=
pad only supports
>> >      > >>>> mouse emulation, so using generic hid-input handling for a=
nything but
>> >      > >>>> the "Wireless Radio Control" bits is fine. On these device=
s we simply bind
>> >      > >>>> to all USB interfaces.
>> >      > >>>>
>> >      > >>>> But unlike other ITE8595 using keyboard docks, the Acer As=
pire Switch 10
>> >      > >>>> (SW5-012)'s touchpad not only does mouse emulation it also=
 supports
>> >      > >>>> HID-multitouch and all the keys including the "Wireless Ra=
dio Control"
>> >      > >>>> bits have been moved to the first USB interface (the keybo=
ard intf).
>> >      > >>>>
>> >      > >>>> So we need hid-ite to handle the first (keyboard) USB inte=
rface and have
>> >      > >>>> it NOT bind to the second (mouse) USB interface so that th=
at can be
>> >      > >>>> handled by hid-multitouch.c and we get proper multi-touch =
support.
>> >      > >>>>
>> >      > >>>> This commit adds a match callback to hid-ite which makes i=
t only
>> >      > >>>> match the first USB interface when running on the Acer SW5=
-012,
>> >      > >>>> fixing the regression to mouse-emulation mode introduced b=
y adding the
>> >      > >>>> keyboard dock USB id.
>> >      > >>>>
>> >      > >>>> Note the match function only does the special only bind to=
 the first
>> >      > >>>> USB interface on the Acer SW5-012, on other devices the hi=
d-ite driver
>> >      > >>>> actually must bind to the second interface as that is wher=
e the
>> >      > >>>> "Wireless Radio Control" bits are.
>> >      > >>>
>> >      > >>> This is not a full review, but a couple of things that popp=
ed out
>> >      > >>> while scrolling through the patch.
>> >      > >>>
>> >      > >>>>
>> >      > >>>> Cc: stable@vger.kernel.org <mailto:stable@vger.kernel.org>
>> >      > >>>> Fixes: 8f18eca9ebc5 ("HID: ite: Add USB id match for Acer =
SW5-012 keyboard dock")
>> >      > >>>> Reported-by: Zden=C4=9Bk Rampas <zdenda.rampas@gmail.com <=
mailto:zdenda.rampas@gmail.com>>
>> >      > >>>> Signed-off-by: Hans de Goede <hdegoede@redhat.com <mailto:=
hdegoede@redhat.com>>
>> >      > >>>> ---
>> >      > >>>>    drivers/hid/hid-ite.c | 34 ++++++++++++++++++++++++++++=
++++++
>> >      > >>>>    1 file changed, 34 insertions(+)
>> >      > >>>>
>> >      > >>>> diff --git a/drivers/hid/hid-ite.c b/drivers/hid/hid-ite.c
>> >      > >>>> index c436e12feb23..69a4ddfd033d 100644
>> >      > >>>> --- a/drivers/hid/hid-ite.c
>> >      > >>>> +++ b/drivers/hid/hid-ite.c
>> >      > >>>> @@ -8,9 +8,12 @@
>> >      > >>>>    #include <linux/input.h>
>> >      > >>>>    #include <linux/hid.h>
>> >      > >>>>    #include <linux/module.h>
>> >      > >>>> +#include <linux/usb.h>
>> >      > >>>>
>> >      > >>>>    #include "hid-ids.h"
>> >      > >>>>
>> >      > >>>> +#define ITE8595_KBD_USB_INTF           0
>> >      > >>>> +
>> >      > >>>>    static int ite_event(struct hid_device *hdev, struct hi=
d_field *field,
>> >      > >>>>                        struct hid_usage *usage, __s32 valu=
e)
>> >      > >>>>    {
>> >      > >>>> @@ -37,6 +40,36 @@ static int ite_event(struct hid_device =
*hdev, struct hid_field *field,
>> >      > >>>>           return 0;
>> >      > >>>>    }
>> >      > >>>>
>> >      > >>>> +static bool ite_match(struct hid_device *hdev, bool ignor=
e_special_driver)
>> >      > >>>> +{
>> >      > >>>> +       struct usb_interface *intf;
>> >      > >>>> +
>> >      > >>>> +       if (ignore_special_driver)
>> >      > >>>> +               return false;
>> >      > >>>> +
>> >      > >>>> +       /*
>> >      > >>>> +        * Most keyboard docks with an ITE 8595 keyboard/t=
ouchpad controller
>> >      > >>>> +        * have the "Wireless Radio Control" bits which ne=
ed this special
>> >      > >>>> +        * driver on the second USB interface (the mouse i=
nterface). On
>> >      > >>>> +        * these devices we simply bind to all USB interfa=
ces.
>> >      > >>>> +        *
>> >      > >>>> +        * The Acer Aspire Switch 10 (SW5-012) is special,=
 its touchpad
>> >      > >>>> +        * not only does mouse emulation it also supports =
HID-multitouch
>> >      > >>>> +        * and all the keys including the "Wireless Radio =
Control" bits
>> >      > >>>> +        * have been moved to the first USB interface (the=
 keyboard intf).
>> >      > >>>> +        *
>> >      > >>>> +        * We want the hid-multitouch driver to bind to th=
e touchpad, so on
>> >      > >>>> +        * the Acer SW5-012 we should only bind to the key=
board USB intf.
>> >      > >>>> +        */
>> >      > >>>> +       if (hdev->bus !=3D BUS_USB || hdev->vendor !=3D US=
B_VENDOR_ID_SYNAPTICS ||
>> >      > >>>> +                    hdev->product !=3D USB_DEVICE_ID_SYNA=
PTICS_ACER_SWITCH5_012)
>> >      > >>>
>> >      > >>> Isn't there an existing matching function we can use here, =
instead of
>> >      > >>> checking each individual field?
>> >      > >>
>> >      > >> There is hid_match_one_id() but that is not exported (can be=
 fixed) and it
>> >      > >> requires a struct hid_device_id, which either requires decla=
ring an extra
>> >      > >> standalone struct hid_device_id for the SW5-012 kbd-dock, or=
 hardcoding an
>> >      > >> index into the existing hid_device_id array for the driver (=
with the hardcoding
>> >      > >> being error prone, so not a good idea).
>> >      > >>
>> >      > >> Given the problems with using hid_match_one_id() I decided t=
o just go with
>> >      > >> the above.
>> >      > >
>> >      > > right. An other solution would be to have a local macro/funct=
ion that
>> >      > > does that. Because as soon as you start adding a quirk, an ot=
her comes
>> >      > > right after.
>> >      > >
>> >      > >>
>> >      > >> But see below.
>> >      > >>
>> >      > >>>
>> >      > >>>> +               return true;
>> >      > >>>> +
>> >      > >>>> +       intf =3D to_usb_interface(hdev->dev.parent);
>> >      > >>>
>> >      > >>> And this is oops-prone. You need:
>> >      > >>> - ensure hid_is_using_ll_driver(hdev, &usb_hid_driver) retu=
rns true.
>> >      > >>> - add a dependency on USBHID in the KConfig now that you ar=
e checking
>> >      > >>> on the USB transport layer.
>> >      > >>>
>> >      > >>> That being said, I would love instead:
>> >      > >>> - to have a non USB version of this match, where you decide=
 which
>> >      > >>> component needs to be handled based on the report descripto=
r
>> >      > >>
>> >      > >> Actually your idea to use the desciptors is not bad, but sin=
ce what
>> >      > >> we really want is to not bind to the interface which is mark=
ed for the
>> >      > >> hid-multitouch driver I just realized we can just check that=
.
>> >      > >>
>> >      > >> So how about:
>> >      > >>
>> >      > >> static bool ite_match(struct hid_device *hdev, bool ignore_s=
pecial_driver)
>> >      > >> {
>> >      > >>           if (ignore_special_driver)
>> >      > >>                   return false;
>> >      > >>
>> >      > >>           /*
>> >      > >>            * Some keyboard docks with an ITE 8595 keyboard/t=
ouchpad controller
>> >      > >>            * support the HID multitouch protocol for the tou=
chpad, in that
>> >      > >>            * case the "Wireless Radio Control" bits which we=
 care about are
>> >      > >>            * on the other interface; and we should not bind =
to the multitouch
>> >      > >>            * capable interface as that breaks multitouch sup=
port.
>> >      > >>            */
>> >      > >>           return hdev->group !=3D HID_GROUP_MULTITOUCH_WIN_8=
;
>> >      > >> }
>> >      > >
>> >      > > Yep, I like that very much :)
>> >      >
>> >      > Actually if we want to check the group and there are only 2 int=
erfaces we do
>> >      > not need to use the match callback at all, w e can simply match=
 on the
>> >      > group of the interface which we do want:
>> >      >
>> >      > diff --git a/drivers/hid/hid-ite.c b/drivers/hid/hid-ite.c
>> >      > index db0f35be5a8b..21bd48f16033 100644
>> >      > --- a/drivers/hid/hid-ite.c
>> >      > +++ b/drivers/hid/hid-ite.c
>> >      > @@ -56,8 +56,9 @@ static const struct hid_device_id ite_devices=
[] =3D {
>> >      >         { HID_USB_DEVICE(USB_VENDOR_ID_ITE, USB_DEVICE_ID_ITE85=
95) },
>> >      >         { HID_USB_DEVICE(USB_VENDOR_ID_258A, USB_DEVICE_ID_258A=
_6A88) },
>> >      >         /* ITE8595 USB kbd ctlr, with Synaptics touchpad connec=
ted to it. */
>> >      > -       { HID_USB_DEVICE(USB_VENDOR_ID_SYNAPTICS,
>> >      > -                        USB_DEVICE_ID_SYNAPTICS_ACER_SWITCH5_0=
12) },
>> >      > +       { HID_DEVICE(BUS_USB, HID_GROUP_GENERIC,
>> >      > +                    USB_VENDOR_ID_SYNAPTICS,
>> >      > +                    USB_DEVICE_ID_SYNAPTICS_ACER_SWITCH5_012) =
},
>> >      >         { }
>> >      >   };
>> >      >   MODULE_DEVICE_TABLE(hid, ite_devices);
>> >      >
>> >      > Much cleaner
>> >
>> >     yep
>> >
>> >      > (and now I don't need to write a test, which is always
>> >      > a good motivation to come up with a cleaner solution :)
>> >
>> >     Hehe, too bad, you already picked up my curiosity on this one, and=
 I
>> >     really would like to see the report descriptors and some events of=
 the
>> >     keys that are fixed by hid-ite.c.
>> >     <with a low voice>This will be a hard requirement to accept this p=
atch </joke>.
>> >
>> >     More seriously, Zden=C4=9Bk, can you run hid-recorder from
>> >     https://gitlab.freedesktop.org/libevdev/hid-tools/ and provide me =
the
>> >     report descriptor for all of your ITE HID devices? I'll add the
>> >     matching tests in hid-tools and be sure we do not regress in the
>> >     future.
>> >
>> >      >
>> >      > Let me turn this into a proper patch and then I will send that =
to
>> >      > Zden=C4=9Bk (off-list) for him to test (note don't worry if you=
 do
>> >      > not have time to test this weekend, then I'll do it on Monday).
>> >      >
>> >      > Regards,
>> >      >
>> >      > Hans
>> >      >
>> >      > p.s.
>> >      >
>> >      > 1. My train is approaching Brussels (Fosdem) so my email respon=
se
>> >      > time will soon become irregular.
>> >
>> >     How dare you? :)
>> >
>> >      >
>> >      > 2. Benjamin will you be at Fosdem too ?
>> >      >
>> >
>> >     Unfortunately no. Already got my quota of meeting people for this =
year
>> >     between Kernel Recipes in September, XDC in October and LCA last w=
eek.
>> >     So I need to keep in a quiet environment for a little bit :)
>> >
>> >     Cheers,
>> >     Benjamin
>> >
>>


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D009A14F14F
	for <lists+stable@lfdr.de>; Fri, 31 Jan 2020 18:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbgAaRcC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jan 2020 12:32:02 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56484 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726139AbgAaRcB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Jan 2020 12:32:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580491919;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5yGsXlQpTBU81dfENwjzuaNiGpxI4b2dAlHcXn/wt24=;
        b=MCzavFeCUFvBB1d4c5lTSLEtPQ6dHgCUo7FFY67ZP+bu0EMwLpgbaorRcAAmPjsISOpCcZ
        ey6TwN+i0rb04lUMAayolX+vJhLFDycRvDRQtMGg2MeGW9MP6+lL0J5eGEuAJXyb9Pooww
        +rs1t9d26frXu4gv/bluTnpP4hAn178=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-124-TZGFlbvoPF2xRAJP0vSbXg-1; Fri, 31 Jan 2020 12:31:55 -0500
X-MC-Unique: TZGFlbvoPF2xRAJP0vSbXg-1
Received: by mail-qv1-f70.google.com with SMTP id dr18so4834563qvb.14
        for <stable@vger.kernel.org>; Fri, 31 Jan 2020 09:31:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5yGsXlQpTBU81dfENwjzuaNiGpxI4b2dAlHcXn/wt24=;
        b=i1TpBuyFPfBe3ajrpHlm/agyd9O9QLO7oq6mruo75V+/L4W5dlhFb6ljisbUNmtKpU
         FIhXzzCYDcw+sQGPbMOqAcxrgFyNrMN0sxbn0RBimJ2cAezkYFqIoTrSgdMOFfD50Pmu
         LHkM4GwrpN8XacU711EbB7jA6cAipHfvtNPZh2hQ4anG6BlCVUW14Jlokw+gUCGuKmtQ
         YIy/izQ7C6Hs3Aw8VUCaHrADk5QTnCOQDPQzXT5ebkuPjPF+0S6NrnOqgYKVlJ72F1on
         aLM7WF3J+DnGTYSDKejGIty1HgzK3dJJfAsDoj982PMnr257AZYv0/uqmosoLppClipt
         Y97A==
X-Gm-Message-State: APjAAAWjiWTn1WYo7Lw5g/QtiDcad+orw2NkSYZYvWzMaQNdr3rw9dCo
        7YZAtNS9zNDmt1tTw6JAD2Gnnnjb6JCcT7nyytFewVXxGnAZ266LHUXotJk9N8IOFeniPeEHLp9
        ePzuYjC7h84KBeKvyM7VBaqDtY7yLrtSN
X-Received: by 2002:a0c:b61c:: with SMTP id f28mr11721760qve.101.1580491914793;
        Fri, 31 Jan 2020 09:31:54 -0800 (PST)
X-Google-Smtp-Source: APXvYqxnU6Ee8Gj8mYj+tf4JqO5Sf88Oga+uzVfJU/OPXhguYiSaXwZIrk08pi8M5QXpxBpymZXPkFa0WLLz0SaFG6s=
X-Received: by 2002:a0c:b61c:: with SMTP id f28mr11721715qve.101.1580491914326;
 Fri, 31 Jan 2020 09:31:54 -0800 (PST)
MIME-Version: 1.0
References: <20200131124553.27796-1-hdegoede@redhat.com> <CAO-hwJK-wwZ8UJRaBgjVc0ZXakU9C3eDbh+i6Q5vm8xh1P76LQ@mail.gmail.com>
 <ea896405-6784-7cfd-b27c-28e8ebc3cd7e@redhat.com> <CAO-hwJJ1v30NT5quobYawV9yv87buyrQXOG9u-nY3zXXSrCGvg@mail.gmail.com>
 <6d94cf74-c28f-08b0-a136-044c231b8bc5@redhat.com> <CAO-hwJ+o5CvU3Pv+dQV2gSTeF+n0AGkjwYJvWfX_ZYtM=OtH6g@mail.gmail.com>
 <CABHH5-LmC3JOWyDoxC5hizZe6RZ6RuO=-gk8WDXvU9Z2usihXg@mail.gmail.com>
 <fa288cc2-0560-1fa5-a629-20a7a33afeb2@redhat.com> <CABHH5-KNv7TU6=fiMk3JDxEX2mx7y9qr0Qx9sjOL9-=Rd5jsMw@mail.gmail.com>
 <CAO-hwJ+QnjLu1-Q_KneyOnpc-QaedYUdJUJHH-0E=Txv3kqy5Q@mail.gmail.com> <CABHH5-+MQZgj+Wz-BdHLJbK7X2dyyAES6KJspR=gK0TO0Dk73A@mail.gmail.com>
In-Reply-To: <CABHH5-+MQZgj+Wz-BdHLJbK7X2dyyAES6KJspR=gK0TO0Dk73A@mail.gmail.com>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Fri, 31 Jan 2020 18:31:43 +0100
Message-ID: <CAO-hwJ+f=pyzS5U39LaYexy6gf2bRzr1_hgp5wxkW0b6uJwz7w@mail.gmail.com>
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

On Fri, Jan 31, 2020 at 6:17 PM Z R <zdenda.rampas@gmail.com> wrote:
>
> Hi Benjamin,
> in last log touchpad.log (omg, should be keyboard.log), I pressed fn-f3 m=
ultiple times. I got one two liner:
>
> # ReportID: 3 / Wireless Radio Button: 0 | #
> E: 000007.606583 2 03 00

great, thanks.

>
> every time i release f3. Does not matter what is happening with fn-key. (=
could be released already or still pushed down). This log was collected wit=
h last patch from Hans applied.

Actually, it doesn't really matter if the patch from Hans was applied
or not. I am looking at the raw event from the device before kernel
processing :)

May I ask you one more thing: can you run `libinput record` (as root)
on the touchpad? I need to know how many fingers the touchpad is
capable to detect, as right now, my tests are failing because of that.

>
> Sorry for the mess I caused :-) I still don't get how you guys manage to =
have your emails so well polished and readable.

No worries. Having a responsive user is much more valuable than
someone who takes ages to reply even in a clear and well polished
message :)

Cheers,
Benjamin

>
> Bye
> Zden=C4=9Bk
>
> p=C3=A1 31. 1. 2020 v 18:00 odes=C3=ADlatel Benjamin Tissoires <benjamin.=
tissoires@redhat.com> napsal:
>>
>> On Fri, Jan 31, 2020 at 5:09 PM Z R <zdenda.rampas@gmail.com> wrote:
>> >
>> > I believe I pressed wifi button on both replays for keyboard.
>>
>> Yep, I can see that. Just to double check, on the last log, you
>> pressed the wifi button twice?
>>
>> Anyway, thanks for all the logs, I should have enough to implement the
>> regression tests.
>>
>> Cheers,
>> Benjamin
>>
>> >
>> > With latest patch from Hans on top of v5.5.0 touchpads "two finger scr=
olling" is working again. Attaching current hid-record for keyboard with Wi=
fi button pressed. Events in log appeared after f3 button was "released".
>> >
>> > Thanks
>> >
>> > Zden=C4=9Bk
>> >
>> > p=C3=A1 31. 1. 2020 v 16:45 odes=C3=ADlatel Hans de Goede <hdegoede@re=
dhat.com> napsal:
>> >>
>> >> Hi,
>> >>
>> >> On 1/31/20 4:38 PM, Z R wrote:
>> >> > Hi Benjamin,
>> >> > hid-record for keyboard and touchpad. With Commit 8f18eca9ebc5 reve=
rted and from unmodified kernel.
>> >> >
>> >> > I hope it is what you asked for :-)
>> >> >
>> >> > Currently waiting for reworked patch from Hans.
>> >>
>> >> I just send you the reworked patch.
>> >>
>> >> Does the recordning include pressing of the wlan on/off key (Fn + F3 =
I believe) ?
>> >> That is the whole reason why the special hid-ite driver is necessary.
>> >>
>> >> Benjamin about the wlan on/off key. AFAICR on a press + release of th=
e key a
>> >> single hid input report for the generic-desktop  Wireless Radio Contr=
ols group
>> >> is send. This input-report only has the one button with usage code HI=
D_GD_RFKILL_BTN
>> >> in there and it is always 0. It is as if the input-report is only sen=
d on release
>> >> and not on press. So the hid-ite code emulates a press + release when=
ever the
>> >> input-report is send.
>> >>
>> >> IOW the receiving of the input report is (ab)used as indication of th=
e button
>> >> having been pressed.
>> >>
>> >> Regards,
>> >>
>> >> Hans
>> >>
>> >>
>> >> >
>> >> > Bye for now
>> >> > Zden=C4=9Bk
>> >> >
>> >> > p=C3=A1 31. 1. 2020 v 15:12 odes=C3=ADlatel Benjamin Tissoires <ben=
jamin.tissoires@redhat.com <mailto:benjamin.tissoires@redhat.com>> napsal:
>> >> >
>> >> >     On Fri, Jan 31, 2020 at 3:04 PM Hans de Goede <hdegoede@redhat.=
com <mailto:hdegoede@redhat.com>> wrote:
>> >> >      >
>> >> >      > Hi,
>> >> >      >
>> >> >      > On 1/31/20 2:54 PM, Benjamin Tissoires wrote:
>> >> >      > > On Fri, Jan 31, 2020 at 2:41 PM Hans de Goede <hdegoede@re=
dhat.com <mailto:hdegoede@redhat.com>> wrote:
>> >> >      > >>
>> >> >      > >> Hi,
>> >> >      > >>
>> >> >      > >> On 1/31/20 2:10 PM, Benjamin Tissoires wrote:
>> >> >      > >>> Hi Hans,
>> >> >      > >>>
>> >> >      > >>> On Fri, Jan 31, 2020 at 1:46 PM Hans de Goede <hdegoede@=
redhat.com <mailto:hdegoede@redhat.com>> wrote:
>> >> >      > >>>>
>> >> >      > >>>> Commit 8f18eca9ebc5 ("HID: ite: Add USB id match for Ac=
er SW5-012 keyboard
>> >> >      > >>>> dock") added the USB id for the Acer SW5-012's keyboard=
 dock to the
>> >> >      > >>>> hid-ite driver to fix the rfkill driver not working.
>> >> >      > >>>>
>> >> >      > >>>> Most keyboard docks with an ITE 8595 keyboard/touchpad =
controller have the
>> >> >      > >>>> "Wireless Radio Control" bits which need the special hi=
d-ite driver on the
>> >> >      > >>>> second USB interface (the mouse interface) and their to=
uchpad only supports
>> >> >      > >>>> mouse emulation, so using generic hid-input handling fo=
r anything but
>> >> >      > >>>> the "Wireless Radio Control" bits is fine. On these dev=
ices we simply bind
>> >> >      > >>>> to all USB interfaces.
>> >> >      > >>>>
>> >> >      > >>>> But unlike other ITE8595 using keyboard docks, the Acer=
 Aspire Switch 10
>> >> >      > >>>> (SW5-012)'s touchpad not only does mouse emulation it a=
lso supports
>> >> >      > >>>> HID-multitouch and all the keys including the "Wireless=
 Radio Control"
>> >> >      > >>>> bits have been moved to the first USB interface (the ke=
yboard intf).
>> >> >      > >>>>
>> >> >      > >>>> So we need hid-ite to handle the first (keyboard) USB i=
nterface and have
>> >> >      > >>>> it NOT bind to the second (mouse) USB interface so that=
 that can be
>> >> >      > >>>> handled by hid-multitouch.c and we get proper multi-tou=
ch support.
>> >> >      > >>>>
>> >> >      > >>>> This commit adds a match callback to hid-ite which make=
s it only
>> >> >      > >>>> match the first USB interface when running on the Acer =
SW5-012,
>> >> >      > >>>> fixing the regression to mouse-emulation mode introduce=
d by adding the
>> >> >      > >>>> keyboard dock USB id.
>> >> >      > >>>>
>> >> >      > >>>> Note the match function only does the special only bind=
 to the first
>> >> >      > >>>> USB interface on the Acer SW5-012, on other devices the=
 hid-ite driver
>> >> >      > >>>> actually must bind to the second interface as that is w=
here the
>> >> >      > >>>> "Wireless Radio Control" bits are.
>> >> >      > >>>
>> >> >      > >>> This is not a full review, but a couple of things that p=
opped out
>> >> >      > >>> while scrolling through the patch.
>> >> >      > >>>
>> >> >      > >>>>
>> >> >      > >>>> Cc: stable@vger.kernel.org <mailto:stable@vger.kernel.o=
rg>
>> >> >      > >>>> Fixes: 8f18eca9ebc5 ("HID: ite: Add USB id match for Ac=
er SW5-012 keyboard dock")
>> >> >      > >>>> Reported-by: Zden=C4=9Bk Rampas <zdenda.rampas@gmail.co=
m <mailto:zdenda.rampas@gmail.com>>
>> >> >      > >>>> Signed-off-by: Hans de Goede <hdegoede@redhat.com <mail=
to:hdegoede@redhat.com>>
>> >> >      > >>>> ---
>> >> >      > >>>>    drivers/hid/hid-ite.c | 34 +++++++++++++++++++++++++=
+++++++++
>> >> >      > >>>>    1 file changed, 34 insertions(+)
>> >> >      > >>>>
>> >> >      > >>>> diff --git a/drivers/hid/hid-ite.c b/drivers/hid/hid-it=
e.c
>> >> >      > >>>> index c436e12feb23..69a4ddfd033d 100644
>> >> >      > >>>> --- a/drivers/hid/hid-ite.c
>> >> >      > >>>> +++ b/drivers/hid/hid-ite.c
>> >> >      > >>>> @@ -8,9 +8,12 @@
>> >> >      > >>>>    #include <linux/input.h>
>> >> >      > >>>>    #include <linux/hid.h>
>> >> >      > >>>>    #include <linux/module.h>
>> >> >      > >>>> +#include <linux/usb.h>
>> >> >      > >>>>
>> >> >      > >>>>    #include "hid-ids.h"
>> >> >      > >>>>
>> >> >      > >>>> +#define ITE8595_KBD_USB_INTF           0
>> >> >      > >>>> +
>> >> >      > >>>>    static int ite_event(struct hid_device *hdev, struct=
 hid_field *field,
>> >> >      > >>>>                        struct hid_usage *usage, __s32 v=
alue)
>> >> >      > >>>>    {
>> >> >      > >>>> @@ -37,6 +40,36 @@ static int ite_event(struct hid_devi=
ce *hdev, struct hid_field *field,
>> >> >      > >>>>           return 0;
>> >> >      > >>>>    }
>> >> >      > >>>>
>> >> >      > >>>> +static bool ite_match(struct hid_device *hdev, bool ig=
nore_special_driver)
>> >> >      > >>>> +{
>> >> >      > >>>> +       struct usb_interface *intf;
>> >> >      > >>>> +
>> >> >      > >>>> +       if (ignore_special_driver)
>> >> >      > >>>> +               return false;
>> >> >      > >>>> +
>> >> >      > >>>> +       /*
>> >> >      > >>>> +        * Most keyboard docks with an ITE 8595 keyboar=
d/touchpad controller
>> >> >      > >>>> +        * have the "Wireless Radio Control" bits which=
 need this special
>> >> >      > >>>> +        * driver on the second USB interface (the mous=
e interface). On
>> >> >      > >>>> +        * these devices we simply bind to all USB inte=
rfaces.
>> >> >      > >>>> +        *
>> >> >      > >>>> +        * The Acer Aspire Switch 10 (SW5-012) is speci=
al, its touchpad
>> >> >      > >>>> +        * not only does mouse emulation it also suppor=
ts HID-multitouch
>> >> >      > >>>> +        * and all the keys including the "Wireless Rad=
io Control" bits
>> >> >      > >>>> +        * have been moved to the first USB interface (=
the keyboard intf).
>> >> >      > >>>> +        *
>> >> >      > >>>> +        * We want the hid-multitouch driver to bind to=
 the touchpad, so on
>> >> >      > >>>> +        * the Acer SW5-012 we should only bind to the =
keyboard USB intf.
>> >> >      > >>>> +        */
>> >> >      > >>>> +       if (hdev->bus !=3D BUS_USB || hdev->vendor !=3D=
 USB_VENDOR_ID_SYNAPTICS ||
>> >> >      > >>>> +                    hdev->product !=3D USB_DEVICE_ID_S=
YNAPTICS_ACER_SWITCH5_012)
>> >> >      > >>>
>> >> >      > >>> Isn't there an existing matching function we can use her=
e, instead of
>> >> >      > >>> checking each individual field?
>> >> >      > >>
>> >> >      > >> There is hid_match_one_id() but that is not exported (can=
 be fixed) and it
>> >> >      > >> requires a struct hid_device_id, which either requires de=
claring an extra
>> >> >      > >> standalone struct hid_device_id for the SW5-012 kbd-dock,=
 or hardcoding an
>> >> >      > >> index into the existing hid_device_id array for the drive=
r (with the hardcoding
>> >> >      > >> being error prone, so not a good idea).
>> >> >      > >>
>> >> >      > >> Given the problems with using hid_match_one_id() I decide=
d to just go with
>> >> >      > >> the above.
>> >> >      > >
>> >> >      > > right. An other solution would be to have a local macro/fu=
nction that
>> >> >      > > does that. Because as soon as you start adding a quirk, an=
 other comes
>> >> >      > > right after.
>> >> >      > >
>> >> >      > >>
>> >> >      > >> But see below.
>> >> >      > >>
>> >> >      > >>>
>> >> >      > >>>> +               return true;
>> >> >      > >>>> +
>> >> >      > >>>> +       intf =3D to_usb_interface(hdev->dev.parent);
>> >> >      > >>>
>> >> >      > >>> And this is oops-prone. You need:
>> >> >      > >>> - ensure hid_is_using_ll_driver(hdev, &usb_hid_driver) r=
eturns true.
>> >> >      > >>> - add a dependency on USBHID in the KConfig now that you=
 are checking
>> >> >      > >>> on the USB transport layer.
>> >> >      > >>>
>> >> >      > >>> That being said, I would love instead:
>> >> >      > >>> - to have a non USB version of this match, where you dec=
ide which
>> >> >      > >>> component needs to be handled based on the report descri=
ptor
>> >> >      > >>
>> >> >      > >> Actually your idea to use the desciptors is not bad, but =
since what
>> >> >      > >> we really want is to not bind to the interface which is m=
arked for the
>> >> >      > >> hid-multitouch driver I just realized we can just check t=
hat.
>> >> >      > >>
>> >> >      > >> So how about:
>> >> >      > >>
>> >> >      > >> static bool ite_match(struct hid_device *hdev, bool ignor=
e_special_driver)
>> >> >      > >> {
>> >> >      > >>           if (ignore_special_driver)
>> >> >      > >>                   return false;
>> >> >      > >>
>> >> >      > >>           /*
>> >> >      > >>            * Some keyboard docks with an ITE 8595 keyboar=
d/touchpad controller
>> >> >      > >>            * support the HID multitouch protocol for the =
touchpad, in that
>> >> >      > >>            * case the "Wireless Radio Control" bits which=
 we care about are
>> >> >      > >>            * on the other interface; and we should not bi=
nd to the multitouch
>> >> >      > >>            * capable interface as that breaks multitouch =
support.
>> >> >      > >>            */
>> >> >      > >>           return hdev->group !=3D HID_GROUP_MULTITOUCH_WI=
N_8;
>> >> >      > >> }
>> >> >      > >
>> >> >      > > Yep, I like that very much :)
>> >> >      >
>> >> >      > Actually if we want to check the group and there are only 2 =
interfaces we do
>> >> >      > not need to use the match callback at all, w e can simply ma=
tch on the
>> >> >      > group of the interface which we do want:
>> >> >      >
>> >> >      > diff --git a/drivers/hid/hid-ite.c b/drivers/hid/hid-ite.c
>> >> >      > index db0f35be5a8b..21bd48f16033 100644
>> >> >      > --- a/drivers/hid/hid-ite.c
>> >> >      > +++ b/drivers/hid/hid-ite.c
>> >> >      > @@ -56,8 +56,9 @@ static const struct hid_device_id ite_devi=
ces[] =3D {
>> >> >      >         { HID_USB_DEVICE(USB_VENDOR_ID_ITE, USB_DEVICE_ID_IT=
E8595) },
>> >> >      >         { HID_USB_DEVICE(USB_VENDOR_ID_258A, USB_DEVICE_ID_2=
58A_6A88) },
>> >> >      >         /* ITE8595 USB kbd ctlr, with Synaptics touchpad con=
nected to it. */
>> >> >      > -       { HID_USB_DEVICE(USB_VENDOR_ID_SYNAPTICS,
>> >> >      > -                        USB_DEVICE_ID_SYNAPTICS_ACER_SWITCH=
5_012) },
>> >> >      > +       { HID_DEVICE(BUS_USB, HID_GROUP_GENERIC,
>> >> >      > +                    USB_VENDOR_ID_SYNAPTICS,
>> >> >      > +                    USB_DEVICE_ID_SYNAPTICS_ACER_SWITCH5_01=
2) },
>> >> >      >         { }
>> >> >      >   };
>> >> >      >   MODULE_DEVICE_TABLE(hid, ite_devices);
>> >> >      >
>> >> >      > Much cleaner
>> >> >
>> >> >     yep
>> >> >
>> >> >      > (and now I don't need to write a test, which is always
>> >> >      > a good motivation to come up with a cleaner solution :)
>> >> >
>> >> >     Hehe, too bad, you already picked up my curiosity on this one, =
and I
>> >> >     really would like to see the report descriptors and some events=
 of the
>> >> >     keys that are fixed by hid-ite.c.
>> >> >     <with a low voice>This will be a hard requirement to accept thi=
s patch </joke>.
>> >> >
>> >> >     More seriously, Zden=C4=9Bk, can you run hid-recorder from
>> >> >     https://gitlab.freedesktop.org/libevdev/hid-tools/ and provide =
me the
>> >> >     report descriptor for all of your ITE HID devices? I'll add the
>> >> >     matching tests in hid-tools and be sure we do not regress in th=
e
>> >> >     future.
>> >> >
>> >> >      >
>> >> >      > Let me turn this into a proper patch and then I will send th=
at to
>> >> >      > Zden=C4=9Bk (off-list) for him to test (note don't worry if =
you do
>> >> >      > not have time to test this weekend, then I'll do it on Monda=
y).
>> >> >      >
>> >> >      > Regards,
>> >> >      >
>> >> >      > Hans
>> >> >      >
>> >> >      > p.s.
>> >> >      >
>> >> >      > 1. My train is approaching Brussels (Fosdem) so my email res=
ponse
>> >> >      > time will soon become irregular.
>> >> >
>> >> >     How dare you? :)
>> >> >
>> >> >      >
>> >> >      > 2. Benjamin will you be at Fosdem too ?
>> >> >      >
>> >> >
>> >> >     Unfortunately no. Already got my quota of meeting people for th=
is year
>> >> >     between Kernel Recipes in September, XDC in October and LCA las=
t week.
>> >> >     So I need to keep in a quiet environment for a little bit :)
>> >> >
>> >> >     Cheers,
>> >> >     Benjamin
>> >> >
>> >>
>>


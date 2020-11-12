Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 666942B08DF
	for <lists+stable@lfdr.de>; Thu, 12 Nov 2020 16:49:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728359AbgKLPty (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Nov 2020 10:49:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58215 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728032AbgKLPty (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Nov 2020 10:49:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605196190;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kXEzqhwrOMahwRe3h7l8MFwr1cgeZXS6baY+BOm47yM=;
        b=a/7HbvPg36mW0bWXxAPuN4vkhhqgnHKbRw1vQA017fiyag+cwklybcrngpM3NXrszmUUen
        cRLyAVP2ADTNNM9wFqdJoRN8zW5figO0d3dd/spahqLTlEIGXoyqbdAXsGQOq8ncC8JMse
        5q/75DKKbtu9iSQGprR5og/xzyw3DIQ=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-439-2jqV4U0fNKuFeV0elDOshQ-1; Thu, 12 Nov 2020 10:49:49 -0500
X-MC-Unique: 2jqV4U0fNKuFeV0elDOshQ-1
Received: by mail-pl1-f197.google.com with SMTP id k6so3741450pls.22
        for <stable@vger.kernel.org>; Thu, 12 Nov 2020 07:49:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kXEzqhwrOMahwRe3h7l8MFwr1cgeZXS6baY+BOm47yM=;
        b=FDzTDEHZcRUU4To7y3uTDAqM3VlrZby49/dq1Da3jWvdxzCJRJorumtZMhR+5zQlpg
         Rqw8CUIh8LrC7pkqqG7iOPL6ZNAm64e/jbuL3/70BFsFRvRKfEstBK3FcB+MTZE/4ffW
         LpVjuM2ewmrMNYLqXfCqT8qlN7969JG1q9YIcpazmsxbcEp3+qYBHAFSk8CP06772WN5
         L2YXrivbzwtrzML9I+GOOcs6fVyMmPsGWLJN+3JMiimrj4ykgpCMoQpFkli9fnH+Mab/
         sq7VcJgTIm7iCvYrN0yPRCTetLEjUS4UqEsuwqJ8GzFFzyOpxlAUYzxgO60uiSZhJElS
         tIkg==
X-Gm-Message-State: AOAM530r6uAZkO4/mIxAehkPzNg3qWbxVQbEWXCzHxoPYNQQCBE2fpn7
        3tfMemYhDPMx/xihUFAnh+RApeA2sWIfFA2ZAT1h1VACuWs3heY9YnoCiBvmUQlX3hTNSBnOOMG
        fU0VkyINH/IRUFglK3fcr72mMazfHLiKU
X-Received: by 2002:a17:90b:941:: with SMTP id dw1mr5672233pjb.129.1605196187726;
        Thu, 12 Nov 2020 07:49:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwdV/HBai9YSmzcO0TZlTJHzNIPX6rA/wGd+EO39Nm5ehnzSg2nXfyLrtDiCpFAOGv04aLOE+M11uOYYDy/ErI=
X-Received: by 2002:a17:90b:941:: with SMTP id dw1mr5672213pjb.129.1605196187350;
 Thu, 12 Nov 2020 07:49:47 -0800 (PST)
MIME-Version: 1.0
References: <20201102133658.4410-1-hdegoede@redhat.com> <e3817ab8-906e-cb98-91db-ffb4cc821788@redhat.com>
 <ab1788a1-1f23-45bd-72e8-fadcea82514f@redhat.com> <07280208-7a52-954e-4795-9022fe498294@redhat.com>
In-Reply-To: <07280208-7a52-954e-4795-9022fe498294@redhat.com>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Thu, 12 Nov 2020 16:49:36 +0100
Message-ID: <CAO-hwJ+u5=rFN8vkV7FJUrYv4geNmfTD3g=vdkBf3P9BMCdmxw@mail.gmail.com>
Subject: Re: [PATCH 1/3] HID: logitech-dj: Handle quad/bluetooth keyboards
 with a builtin trackpad
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        "3.8+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 11, 2020 at 12:07 PM Hans de Goede <hdegoede@redhat.com> wrote:
>
> Hi,
>
> On 11/10/20 7:29 PM, Benjamin Tissoires wrote:
> > Hi Hans,
> >
> > On Tue, Nov 10, 2020 at 2:17 PM Hans de Goede <hdegoede@redhat.com> wrote:
> >>
> >> Hi All,
> >>
> >> On 11/2/20 2:36 PM, Hans de Goede wrote:
> >> > Some quad/bluetooth keyboards, such as the Dinovo Edge (Y-RAY81) have a
> >> > builtin touchpad. In this case when asking the receiver for paired devices,
> >> > we get only 1 paired device with a device_type of REPORT_TYPE_KEYBOARD.
> >> >
> >> > This means that we do not instantiate a second dj_hiddev for the mouse
> >> > (as we normally would) and thus there is no place for us to forward the
> >> > mouse input reports to, causing the touchpad part of the keyboard to not
> >> > work.
> >> >
> >> > There is no way for us to detect these keyboards, so this commit adds
> >> > an array with device-ids for such keyboards and when a keyboard is on
> >> > this list it adds STD_MOUSE to the reports_supported bitmap for the
> >> > dj_hiddev created for the keyboard fixing the touchpad not working.
> >> >
> >> > Using a list of device-ids for this is not ideal, but there are only
> >> > very few such keyboards so this should be fine. Besides the Dinovo Edge,
> >> > other known wireless Logitech keyboards with a builtin touchpad are:
> >> >
> >> > * Dinovo Mini (TODO add its device-id to the list)
> >> > * K400 (uses a unifying receiver so is not affected)
> >> > * K600 (uses a unifying receiver so is not affected)
> >> >
> >> > Cc: stable@vger.kernel.org
> >> > BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1811424
> >> > Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> >>
> >> ping? This is a bug fix for a regression caused by:
> >
> > Series looks good. I tried to enable the Dinovo Mini this afternoon (see
> > patch below), but it's not that clean and easy...
> >
> >>
> >> Commit f2113c3020ef ("HID: logitech-dj: add support for Logitech Bluetooth Mini-Receiver")
> >>
> >> Specifically that commit caused the builtin touchpad to stop working on Logitech Dinovo
> >> Edge keyboards and this fixes this.
> >>
> >> I realize now that I forgot to add a:
> >>
> >> Fixes: f2113c3020ef ("HID: logitech-dj: add support for Logitech Bluetooth Mini-Receiver")
> >>
> >> Tag, let me know if you want a v2 for that.
> >
> > I guess you want the tag on all 3 patches, not just the first.
>
> Patch 2 and 3 do not fix a regression:
>
> Patch 2 enables extra functionality (non working A-D and phone keys)
> Patch 3 fixes there being 2 batteries under /sys/class/power when the kbd
> is in bluetooth mode, this problem is introduced by patch 2.
>
> I think that taking patch 2/3 for 5.10-rc# is fine, but they don't really
> fix anything related to commit f2113c3020ef. If anything patch 3 should have
> a fixes tag for the final commit hash of patch 2 (or maybe just squash them?)
>
> Note not taking patch 2/3 for 5.10-rc# is fine too.
>
> > If so, I can try to push it later today or tomorrow.
>
> Sounds good, thank you.

I have now applied the 3 patches to the for-5.10/upstream-fixes branch.
I also added the Fixes tag to the first commit only.

>
> >> Regardless since this is a bug fix, it would be good if we can get this
> >> merged into one of the upcoming 5.10-rc#s. Even without the Dinovo Mini
> >> id added this is still worthwhile to get the reported regression fixed
> >> and we can add the Dinovo Mini id later.
> >
> > Yeah, the Dinovo Mini will come later.
> >
> > My current WIP is the following:
>
> Oh interesting, and good timing, let me explain:
>
> I bought a 2nd hand Dinovo Edge to debug the reported regression (*), but
> that came without a receiver. So I paired it with the MX5000 receiver which
> I already had (and which has the same USB-ids as the reporters receiver)
> and that works fine with this patch.
>
> But I did want to have a complete set, so I found some US store on amazon
> selling spare Dinovo Edge dongles and shipping them to Europe in a letter
> (so no crazy shipping costs). That dongle arrived yesterday and I did a
> quick test run. It has usb-ids of c713 for the keyboard usb-device and
> c714 for the mouse usb-device (the dongle has a builtin hub and presents
> 2 separate usb devices, like the MX5000 / MX5500 dongles).
>
> So I added these ids to hid-logitech-dj.c (and dropped one of them from hid-lg.c)
> after that the mousepad on the Dinovo Edge however stopped working again
> when paired with this dongle. So I already guessed that the mouse descriptor
> would be different, but I did not get around to actually checking this.
>
> Note this has an important implication for your patch, you assume the mouse-report
> changes based on the paired device. But that is not the case it is simple that
> some (newer? at least a somewhat higher usb-dev-id) quad/bt2.0 combo dongles
> have a different mouse report.
>
> At least with the Dinovo Edge the mouse report changes when it is paired with
> a different dongle, so it is the dongle which determines the mouse report, not
> the paired device.

Glad this is the case. My patch was just trying to get things around
while not breaking too many things. So there will be refinements to do
later.

>
> So we need a "recvr_type_bluetooth_v2" and then this new report can just be added
> to the big:
>
>                 if (djdev->dj_receiver_dev->type == recvr_type_gaming_hidpp ||
>                     djdev->dj_receiver_dev->type == recvr_type_mouse_only)
>                         rdcat(rdesc, &rsize, mse_high_res_descriptor,
>                               sizeof(mse_high_res_descriptor));
>                 else if (djdev->dj_receiver_dev->type == recvr_type_27mhz)
>                         rdcat(rdesc, &rsize, mse_27mhz_descriptor,
>                               sizeof(mse_27mhz_descriptor));
>                 else if (djdev->dj_receiver_dev->type == recvr_type_bluetooth)
>                         rdcat(rdesc, &rsize, mse_bluetooth_descriptor,
>                               sizeof(mse_bluetooth_descriptor));
>                 else
>                         rdcat(rdesc, &rsize, mse_descriptor,
>                               sizeof(mse_descriptor));
>
> block.

That would seem like a good solution, yes.

>
> Hmm, I also see that the new descriptor has a report-id of 5, so it looks like
> we do need the BT_MOUSE thing, but then set it based on the receiver usb-id instead?

Right.

>
> Do the original HID descriptors of the receiver perhaps have both a report 2 and
> a report 5 and we should add both ?

No, I think it only has report ID 5.

>
> Note I also see that you add a separate id-array for the dinovo-mini because
> of this given my experience that the behavior changes based on the used
> receiver, I don't think that is necessary. Instead we need to add or not
> add the BT_MOUSE bit to the keyboards reports_supported based on the
> receiver-type (I think).

Ack

>
> Anyways this definitely needs some more work, so as you said lets move
> forward with the fix for the MX5000 receiver usb-ids as is.
>
> Although adding the dinovo-mini device-id to the kbd_builtin_touchpad_ids[]
> in case it gets paired with sat the MX5000 receiver probably cannot hurt.

Sure. Feel free to send any followup patches.

Cheers,
Benjamin

>
> Regards,
>
> Hans
>
>
>
>
> *) and I'm glad I did I don't think I would have enjoyed debugging this remotely
>
>
>
>
> > ---
> >
> > diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
> > index 1cafb65428b0..1c7857bf3290 100644
> > --- a/drivers/hid/hid-logitech-dj.c
> > +++ b/drivers/hid/hid-logitech-dj.c
> > @@ -84,6 +84,7 @@
> >  #define STD_MOUSE                BIT(2)
> >  #define MULTIMEDIA                BIT(3)
> >  #define POWER_KEYS                BIT(4)
> > +#define BT_MOUSE                BIT(5)
> >  #define MEDIA_CENTER                BIT(8)
> >  #define KBD_LEDS                BIT(14)
> >  /* Fake (bitnr > NUMBER_OF_HID_REPORTS) bit to track HID++ capability */
> > @@ -333,6 +334,47 @@ static const char mse_bluetooth_descriptor[] = {
> >      0xC0,            /*  END_COLLECTION                      */
> >  };
> >
> > +/* Mouse descriptor (5) for Bluetooth receiver, low-res hwheel, 8 buttons */
> > +static const char mse5_bluetooth_descriptor[] = {
> > +    0x05, 0x01,        /*  USAGE_PAGE (Generic Desktop)        */
> > +    0x09, 0x02,        /*  Usage (Mouse)                       */
> > +    0xa1, 0x01,        /*  Collection (Application)            */
> > +    0x85, 0x05,        /*   Report ID (5)                      */
> > +    0x09, 0x01,        /*   Usage (Pointer)                    */
> > +    0xa1, 0x00,        /*   Collection (Physical)              */
> > +    0x05, 0x09,        /*    Usage Page (Button)               */
> > +    0x19, 0x01,        /*    Usage Minimum (1)                 */
> > +    0x29, 0x08,        /*    Usage Maximum (8)                 */
> > +    0x15, 0x00,        /*    Logical Minimum (0)               */
> > +    0x25, 0x01,        /*    Logical Maximum (1)               */
> > +    0x95, 0x08,        /*    Report Count (8)                  */
> > +    0x75, 0x01,        /*    Report Size (1)                   */
> > +    0x81, 0x02,        /*    Input (Data,Var,Abs)              */
> > +    0x05, 0x01,        /*    Usage Page (Generic Desktop)      */
> > +    0x16, 0x01, 0xf8,    /*    Logical Minimum (-2047)           */
> > +    0x26, 0xff, 0x07,    /*    Logical Maximum (2047)            */
> > +    0x75, 0x0c,        /*    Report Size (12)                  */
> > +    0x95, 0x02,        /*    Report Count (2)                  */
> > +    0x09, 0x30,        /*    Usage (X)                         */
> > +    0x09, 0x31,        /*    Usage (Y)                         */
> > +    0x81, 0x06,        /*    Input (Data,Var,Rel)              */
> > +    0x15, 0x81,        /*    Logical Minimum (-127)            */
> > +    0x25, 0x7f,        /*    Logical Maximum (127)             */
> > +    0x75, 0x08,        /*    Report Size (8)                   */
> > +    0x95, 0x01,        /*    Report Count (1)                  */
> > +    0x09, 0x38,        /*    Usage (Wheel)                     */
> > +    0x81, 0x06,        /*    Input (Data,Var,Rel)              */
> > +    0x05, 0x0c,        /*    Usage Page (Consumer Devices)     */
> > +    0x0a, 0x38, 0x02,    /*    Usage (AC Pan)                    */
> > +    0x15, 0x81,        /*    Logical Minimum (-127)            */
> > +    0x25, 0x7f,        /*    Logical Maximum (127)             */
> > +    0x75, 0x08,        /*    Report Size (8)                   */
> > +    0x95, 0x01,        /*    Report Count (1)                  */
> > +    0x81, 0x06,        /*    Input (Data,Var,Rel)              */
> > +    0xc0,            /*   End Collection                     */
> > +    0xc0,            /*  End Collection                      */
> > +};
> > +
> >  /* Gaming Mouse descriptor (2) */
> >  static const char mse_high_res_descriptor[] = {
> >      0x05, 0x01,        /*  USAGE_PAGE (Generic Desktop)        */
> > @@ -877,6 +919,10 @@ static const u16 kbd_builtin_touchpad_ids[] = {
> >      0xb309, /* Dinovo Edge */
> >  };
> >
> > +static const u16 kbd_builtin_touchpad5_ids[] = {
> > +    0xb30c, /* Dinovo Mini */
> > +};
> > +
> >  static void logi_hidpp_dev_conn_notif_equad(struct hid_device *hdev,
> >                          struct hidpp_event *hidpp_report,
> >                          struct dj_workitem *workitem)
> > @@ -901,6 +947,12 @@ static void logi_hidpp_dev_conn_notif_equad(struct hid_device *hdev,
> >                  break;
> >              }
> >          }
> > +        for (i = 0; i < ARRAY_SIZE(kbd_builtin_touchpad5_ids); i++) {
> > +            if (id == kbd_builtin_touchpad5_ids[i]) {
> > +                workitem->reports_supported |= BT_MOUSE;
> > +                break;
> > +            }
> > +        }
> >          break;
> >      case REPORT_TYPE_MOUSE:
> >          workitem->reports_supported |= STD_MOUSE | HIDPP;
> > @@ -1368,6 +1420,13 @@ static int logi_dj_ll_parse(struct hid_device *hid)
> >                    sizeof(mse_descriptor));
> >      }
> >
> > +    if (djdev->reports_supported & BT_MOUSE) {
> > +        dbg_hid("%s: sending a mouse descriptor, reports_supported: %llx\n",
> > +            __func__, djdev->reports_supported);
> > +        rdcat(rdesc, &rsize, mse5_bluetooth_descriptor,
> > +              sizeof(mse5_bluetooth_descriptor));
> > +    }
> > +
> >      if (djdev->reports_supported & MULTIMEDIA) {
> >          dbg_hid("%s: sending a multimedia report descriptor: %llx\n",
> >              __func__, djdev->reports_supported);
> > @@ -1907,6 +1966,14 @@ static const struct hid_device_id logi_dj_receivers[] = {
> >        HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH,
> >          0xc71c),
> >       .driver_data = recvr_type_bluetooth},
> > +    { /* Logitech DiNovo Mini HID++ / bluetooth receiver mouse intf. */
> > +      HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH,
> > +        0xc71e),
> > +     .driver_data = recvr_type_bluetooth},
> > +    { /* Logitech DiNovo Mini HID++ / bluetooth receiver keyboard intf. */
> > +      HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH,
> > +        0xc71f),
> > +     .driver_data = recvr_type_bluetooth},
> >      {}
> >  };
> >
> > ---
> >
> > And the keyboard is not sending the proper KEY_MEDIA like with the
> > hid-logitech.ko driver. So this WIP can not go into a stable tree.
> >
> > Cheers,
> > Benjamin
> >
>


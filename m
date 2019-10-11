Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3633AD4AFD
	for <lists+stable@lfdr.de>; Sat, 12 Oct 2019 01:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbfJKXdN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 19:33:13 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:45564 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbfJKXdN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Oct 2019 19:33:13 -0400
Received: by mail-lj1-f193.google.com with SMTP id q64so11319935ljb.12;
        Fri, 11 Oct 2019 16:33:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dqUKeMBldu3J8Qo+YczW715+ytHuDyYUPQ729VlTblA=;
        b=ViDJbvPdEkhfNnL7YgdxFbHlRF2QVLlpO/JJiNEbRZ7w0ZTCXVETifJ+gV4mHGkfe8
         YpzVYRBxCQgmLI5gvxn6oMrTg7KC4hxnFHU7J4I14cHPknJJtOBqXOJynIwA2/tYFYy9
         bRVy2B7zgoBTaU7L2y7OZGQ7kzZBiFfSs6FHemOO8CYv/wyWKemKnG2g944xbT/v6hbm
         1u2ADwbrFGaxnfeUzbFtqaGcHFSkusrESPZHqfmhp/W3Ipzhd5As5Eq1PJVH9UVtfNNg
         J53SsRbtCKps7omwz/WC+fIqxm7QKzA2foWgdsJGQcr4HO79HmBRSnTYF3ptbT1HkpnE
         9RuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dqUKeMBldu3J8Qo+YczW715+ytHuDyYUPQ729VlTblA=;
        b=EHN6bCqta81z3+Ntc30OW2CpZe28+RtL8aZF66OLIBln9xMOzXodSujCuhrVxzfRiu
         Ho+rnvDOK6ASkJIc99ikbyVeuua3olPMkyeAtC57q+lVhvbuvJSPuCQoMw0Umq+qKQ1D
         Wv0WwGi+TtMY4291a7U8l/BlA7I+AlpsgT/sKSBT8WJiOsM7VqLeyuiz8PTUjtorOTOA
         o7wBLHMV57vxghKBRCA3VFICvRjJaOltr1pKVnS4SSRrONfpVJH28A4BMUC7FwxR/GXi
         Yq9EuvJQewvBXfRTmMbaYmQmGHY9j6Cyn1B2xbTs2U48wI450+FgoBfn7wpRv75BLRO4
         AeDA==
X-Gm-Message-State: APjAAAURno++QEiPEL60q4+RCmpj8AqmJcgsB2G1kVmGCs3QNNiw7L7c
        qVRBHHdTGEc/vxdaUtl3i2BS4SJjcnQzz0vHbY0=
X-Google-Smtp-Source: APXvYqzbQ/bf7zsX3QEfkEEGFHRLIyF+hWVAaoYkoLmlXPMmrpD7t3Q/03q1SqYW+mwE67DGgWaUmj5YR3kUjUBnIJ4=
X-Received: by 2002:a2e:9a4e:: with SMTP id k14mr10684321ljj.104.1570836790163;
 Fri, 11 Oct 2019 16:33:10 -0700 (PDT)
MIME-Version: 1.0
References: <20191007051240.4410-1-andrew.smirnov@gmail.com>
 <20191007051240.4410-4-andrew.smirnov@gmail.com> <CAO-hwJJ8tp4Rqte-umv9e=S5evR5oJTErsNR0Wk-z8wcbtR0wg@mail.gmail.com>
 <CAHQ1cqHCYiaEXck3LMGBwYiHVDQcF=XuF=kHJ4f_v1ea6hDR2g@mail.gmail.com> <CAO-hwJ+HZEhn_riNwrODKSySt4aP4RzZq+omYDAF-7q5dLQR1Q@mail.gmail.com>
In-Reply-To: <CAO-hwJ+HZEhn_riNwrODKSySt4aP4RzZq+omYDAF-7q5dLQR1Q@mail.gmail.com>
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
Date:   Fri, 11 Oct 2019 16:32:58 -0700
Message-ID: <CAHQ1cqHNca22fAWMnLFBuD-txb7MvdFrY9bY2A9uViq4P5Cikg@mail.gmail.com>
Subject: Re: [PATCH 3/3] HID: logitech-hidpp: add G920 device validation quirk
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Sam Bazely <sambazley@fastmail.com>,
        Jiri Kosina <jikos@kernel.org>,
        Henrik Rydberg <rydberg@bitmath.org>,
        "Pierre-Loup A . Griffais" <pgriffais@valvesoftware.com>,
        Austin Palmer <austinp@valvesoftware.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "3.8+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 11, 2019 at 3:33 PM Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> On Fri, Oct 11, 2019 at 9:39 PM Andrey Smirnov <andrew.smirnov@gmail.com> wrote:
> >
> > On Fri, Oct 11, 2019 at 7:56 AM Benjamin Tissoires
> > <benjamin.tissoires@redhat.com> wrote:
> > >
> > > On Mon, Oct 7, 2019 at 7:13 AM Andrey Smirnov <andrew.smirnov@gmail.com> wrote:
> > > >
> > > > G920 device only advertises REPORT_ID_HIDPP_LONG and
> > > > REPORT_ID_HIDPP_VERY_LONG in its HID report descriptor, so querying
> > > > for REPORT_ID_HIDPP_SHORT with optional=false will always fail and
> > > > prevent G920 to be recognized as a valid HID++ device.
> > > >
> > > > Modify hidpp_validate_device() to check only REPORT_ID_HIDPP_LONG with
> > > > optional=false on G920 to fix this.
> > > >
> > > > Fixes: fe3ee1ec007b ("HID: logitech-hidpp: allow non HID++ devices to be handled by this module")
> > > > Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=204191
> > > > Reported-by: Sam Bazely <sambazley@fastmail.com>
> > > > Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
> > > > Cc: Jiri Kosina <jikos@kernel.org>
> > > > Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> > > > Cc: Henrik Rydberg <rydberg@bitmath.org>
> > > > Cc: Sam Bazely <sambazley@fastmail.com>
> > > > Cc: Pierre-Loup A. Griffais <pgriffais@valvesoftware.com>
> > > > Cc: Austin Palmer <austinp@valvesoftware.com>
> > > > Cc: linux-input@vger.kernel.org
> > > > Cc: linux-kernel@vger.kernel.org
> > > > Cc: stable@vger.kernel.org
> > > > ---
> > > >  drivers/hid/hid-logitech-hidpp.c | 6 ++++++
> > > >  1 file changed, 6 insertions(+)
> > > >
> > > > diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
> > > > index cadf36d6c6f3..f415bf398e17 100644
> > > > --- a/drivers/hid/hid-logitech-hidpp.c
> > > > +++ b/drivers/hid/hid-logitech-hidpp.c
> > > > @@ -3511,6 +3511,12 @@ static bool hidpp_validate_report(struct hid_device *hdev, int id,
> > > >
> > > >  static bool hidpp_validate_device(struct hid_device *hdev)
> > > >  {
> > > > +       struct hidpp_device *hidpp = hid_get_drvdata(hdev);
> > > > +
> > > > +       if (hidpp->quirks & HIDPP_QUIRK_CLASS_G920)
> > > > +               return hidpp_validate_report(hdev, REPORT_ID_HIDPP_LONG,
> > > > +                                            HIDPP_REPORT_SHORT_LENGTH, false);
> > > > +
> > >
> > > with https://patchwork.kernel.org/patch/11184749/ we also have a need
> > > for such a trick for BLE mice.
> > >
> > > I wonder if we should not have a more common way of validating the devices
> > >
> >
> > What about just checking for:
> >
> > hidpp_validate_report(REPORT_ID_HIDPP_SHORT,
> >                                     HIDPP_REPORT_SHORT_LENGTH, true) ||
> > hidpp_validate_report(hdev, REPORT_ID_HIDPP_LONG,
> >                                     HIDPP_REPORT_LONG_LENGTH, true);
> >
> > and probably dropping the "optional" argument for
> > hidpp_validate_report()? Original code allows there to be devices
> > supporting shorts reports only, but it seems that devices that support
> > only long reports are legitimate too, so maybe the only "invalid"
> > combination is if both are invalid length or missing?
>
> Well, the problem is we also want to detect 2 things:
> - devices that do not have any of the HID++ collections, and handle
> them as generic ones (the second mouse/keyboard collection in the
> gaming mice should still be exported by the driver, or this will kill
> the macros / rebinding capabilities
> - malicious devices that pretends to have a HID++ collection but want
> to trigger a buffer overflow by having a shorter than expected report
> length
>
> Point 2 above should still be fine, but point 1 is why we have the
> enforcement of the HID++ short report in the first place.
>

It sounds like the result of hidpp_validate_report() can't really be
contained in a bool. If we modify it to return -EINVAL for bogus
report length, -ENOTSUPP if report ID is not supported and 0 if
everything is valid we should be able to capture all valid permutation
by checking for with

int id_short = hidpp_validate_report(ID_SHORT);
int id_long  = hidpp_validate_report(ID_LONG);

return (!id_short && !id_long) || (id_short == -ENOTSUPP && !id_long)
|| (id_long == -ENOTSUPP && !id_short)

no?

Thanks,
Andrey Smirnov

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29CBDD5F44
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 11:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731098AbfJNJrq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 05:47:46 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:30407 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730915AbfJNJrq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Oct 2019 05:47:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571046464;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nT2RrZtaq6JmJmsrID6t8B00LKO1nf8nFaNNyvXimHw=;
        b=dc9rN14SPe99cV2IUSqkLulFfpUgNWHRtmaxrvCduC/AD4TLchQx+PANo+PEvtez7LIZEl
        DKoYL444bdUHB08u6P0Kw+Z3ZbVcG7jQcBovDCV5qXc+9tUvI822CMM56GTNXiR5lovyP+
        +y06yyt7U/pxaBfTV5/noK11Bx1/5pQ=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-268-J1xwyoPDOVib7evzdP9YTg-1; Mon, 14 Oct 2019 05:47:40 -0400
Received: by mail-qt1-f197.google.com with SMTP id m6so17320188qtk.23
        for <stable@vger.kernel.org>; Mon, 14 Oct 2019 02:47:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tikxGi43a/ogHMQeUvt4yKFgetbCPvcttFBIabbyj28=;
        b=gOVNsuWleejOW1ubsxSwViJG4n08JJz+pFHA7f3vS/h82xg3V29skqrfLMDKOzatHy
         QHRsUfjqy5oGZ77aXh+i3sChWMv1vSFBkEj1AEuzhmkktU9IfDlq7S4HckkUfexWu+pc
         /JJIa6ptZqO4XAn5o3JsP0kkFPFBqtmtSOPqhb1SjerkNoWmYg15LVzgM8x2cW1JZOd5
         LSu4HrG+psbBlaaEW2MLZHMgvfNN9UBZav9n6Y0cqTYfqy5/kXZJaWIAkF3aOe5Xbpx9
         UZOwMon9CMrkrlbU2IU4sIUirYvAuI32+cBzo0XdPCexb9mOc1aBin2bkqSIsowMQjBM
         4t0w==
X-Gm-Message-State: APjAAAUeV3ANXVmq8IGYiTKze0Ve99lY5UMMz+ZqtB7IXhEeamFNb9Y8
        FKvi0N4ee5RTsqervE7ji5g7VO/KuDAgaeKH5PcYvkt5XVO4JohJNbM7o9cd7wfvENa3Txje1jP
        RDCoQ3fI451q7YtOKBE9Z4tvecREfKjVM
X-Received: by 2002:a05:620a:1116:: with SMTP id o22mr28156585qkk.170.1571046459958;
        Mon, 14 Oct 2019 02:47:39 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyvbOFBLvfatVqxwW5o/shLYzkTaBsdCKuYpQDE01FDeDZTKqGCvPGRPGzVzTMn3Bd8hBCS7VgMz21JW+/5Pmo=
X-Received: by 2002:a05:620a:1116:: with SMTP id o22mr28156570qkk.170.1571046459697;
 Mon, 14 Oct 2019 02:47:39 -0700 (PDT)
MIME-Version: 1.0
References: <20191007051240.4410-1-andrew.smirnov@gmail.com>
 <20191007051240.4410-4-andrew.smirnov@gmail.com> <CAO-hwJJ8tp4Rqte-umv9e=S5evR5oJTErsNR0Wk-z8wcbtR0wg@mail.gmail.com>
 <CAHQ1cqHCYiaEXck3LMGBwYiHVDQcF=XuF=kHJ4f_v1ea6hDR2g@mail.gmail.com>
 <CAO-hwJ+HZEhn_riNwrODKSySt4aP4RzZq+omYDAF-7q5dLQR1Q@mail.gmail.com> <CAHQ1cqHNca22fAWMnLFBuD-txb7MvdFrY9bY2A9uViq4P5Cikg@mail.gmail.com>
In-Reply-To: <CAHQ1cqHNca22fAWMnLFBuD-txb7MvdFrY9bY2A9uViq4P5Cikg@mail.gmail.com>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Mon, 14 Oct 2019 11:47:28 +0200
Message-ID: <CAO-hwJK65mHghXDkb4=b5e04eoG6gMiU2AuV=pLUWU8xN_yJ2w@mail.gmail.com>
Subject: Re: [PATCH 3/3] HID: logitech-hidpp: add G920 device validation quirk
To:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Mazin Rezk <mnrzk@protonmail.com>
Cc:     "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Sam Bazely <sambazley@fastmail.com>,
        Jiri Kosina <jikos@kernel.org>,
        Henrik Rydberg <rydberg@bitmath.org>,
        "Pierre-Loup A . Griffais" <pgriffais@valvesoftware.com>,
        Austin Palmer <austinp@valvesoftware.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "3.8+" <stable@vger.kernel.org>
X-MC-Unique: J1xwyoPDOVib7evzdP9YTg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Oct 12, 2019 at 1:33 AM Andrey Smirnov <andrew.smirnov@gmail.com> w=
rote:
>
> On Fri, Oct 11, 2019 at 3:33 PM Benjamin Tissoires
> <benjamin.tissoires@redhat.com> wrote:
> >
> > On Fri, Oct 11, 2019 at 9:39 PM Andrey Smirnov <andrew.smirnov@gmail.co=
m> wrote:
> > >
> > > On Fri, Oct 11, 2019 at 7:56 AM Benjamin Tissoires
> > > <benjamin.tissoires@redhat.com> wrote:
> > > >
> > > > On Mon, Oct 7, 2019 at 7:13 AM Andrey Smirnov <andrew.smirnov@gmail=
.com> wrote:
> > > > >
> > > > > G920 device only advertises REPORT_ID_HIDPP_LONG and
> > > > > REPORT_ID_HIDPP_VERY_LONG in its HID report descriptor, so queryi=
ng
> > > > > for REPORT_ID_HIDPP_SHORT with optional=3Dfalse will always fail =
and
> > > > > prevent G920 to be recognized as a valid HID++ device.
> > > > >
> > > > > Modify hidpp_validate_device() to check only REPORT_ID_HIDPP_LONG=
 with
> > > > > optional=3Dfalse on G920 to fix this.
> > > > >
> > > > > Fixes: fe3ee1ec007b ("HID: logitech-hidpp: allow non HID++ device=
s to be handled by this module")
> > > > > Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=3D204191
> > > > > Reported-by: Sam Bazely <sambazley@fastmail.com>
> > > > > Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
> > > > > Cc: Jiri Kosina <jikos@kernel.org>
> > > > > Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> > > > > Cc: Henrik Rydberg <rydberg@bitmath.org>
> > > > > Cc: Sam Bazely <sambazley@fastmail.com>
> > > > > Cc: Pierre-Loup A. Griffais <pgriffais@valvesoftware.com>
> > > > > Cc: Austin Palmer <austinp@valvesoftware.com>
> > > > > Cc: linux-input@vger.kernel.org
> > > > > Cc: linux-kernel@vger.kernel.org
> > > > > Cc: stable@vger.kernel.org
> > > > > ---
> > > > >  drivers/hid/hid-logitech-hidpp.c | 6 ++++++
> > > > >  1 file changed, 6 insertions(+)
> > > > >
> > > > > diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-l=
ogitech-hidpp.c
> > > > > index cadf36d6c6f3..f415bf398e17 100644
> > > > > --- a/drivers/hid/hid-logitech-hidpp.c
> > > > > +++ b/drivers/hid/hid-logitech-hidpp.c
> > > > > @@ -3511,6 +3511,12 @@ static bool hidpp_validate_report(struct h=
id_device *hdev, int id,
> > > > >
> > > > >  static bool hidpp_validate_device(struct hid_device *hdev)
> > > > >  {
> > > > > +       struct hidpp_device *hidpp =3D hid_get_drvdata(hdev);
> > > > > +
> > > > > +       if (hidpp->quirks & HIDPP_QUIRK_CLASS_G920)
> > > > > +               return hidpp_validate_report(hdev, REPORT_ID_HIDP=
P_LONG,
> > > > > +                                            HIDPP_REPORT_SHORT_L=
ENGTH, false);
> > > > > +
> > > >
> > > > with https://patchwork.kernel.org/patch/11184749/ we also have a ne=
ed
> > > > for such a trick for BLE mice.
> > > >
> > > > I wonder if we should not have a more common way of validating the =
devices
> > > >
> > >
> > > What about just checking for:
> > >
> > > hidpp_validate_report(REPORT_ID_HIDPP_SHORT,
> > >                                     HIDPP_REPORT_SHORT_LENGTH, true) =
||
> > > hidpp_validate_report(hdev, REPORT_ID_HIDPP_LONG,
> > >                                     HIDPP_REPORT_LONG_LENGTH, true);
> > >
> > > and probably dropping the "optional" argument for
> > > hidpp_validate_report()? Original code allows there to be devices
> > > supporting shorts reports only, but it seems that devices that suppor=
t
> > > only long reports are legitimate too, so maybe the only "invalid"
> > > combination is if both are invalid length or missing?
> >
> > Well, the problem is we also want to detect 2 things:
> > - devices that do not have any of the HID++ collections, and handle
> > them as generic ones (the second mouse/keyboard collection in the
> > gaming mice should still be exported by the driver, or this will kill
> > the macros / rebinding capabilities
> > - malicious devices that pretends to have a HID++ collection but want
> > to trigger a buffer overflow by having a shorter than expected report
> > length
> >
> > Point 2 above should still be fine, but point 1 is why we have the
> > enforcement of the HID++ short report in the first place.
> >
>
> It sounds like the result of hidpp_validate_report() can't really be
> contained in a bool. If we modify it to return -EINVAL for bogus
> report length, -ENOTSUPP if report ID is not supported and 0 if
> everything is valid we should be able to capture all valid permutation
> by checking for with
>
> int id_short =3D hidpp_validate_report(ID_SHORT);
> int id_long  =3D hidpp_validate_report(ID_LONG);
>
> return (!id_short && !id_long) || (id_short =3D=3D -ENOTSUPP && !id_long)
> || (id_long =3D=3D -ENOTSUPP && !id_short)
>
> no?

Sounds like a good idea.

There is a few changes I'd like to do on this proposal:
- ideally, we should also check on very long HID++ reports, but as
d71b18f7c79993 ("HID: logitech-hidpp: do not hardcode very long report
length") mentioned, we should probably ensure that those very long
reports are at least bigger than HIDPP_REPORT_LONG_LENGTH and shorter
than HIDPP_REPORT_VERY_LONG_MAX_LENGTH.

- the boolean operation has a risk of being quite hard to follow if we
now have 3 IDs to check. So we would need a few comments for each
operation to explain which is which.

- maybe we should exit earlier if any of the id_short, id_long or
id_very_long is -EINVAL, as this should be detected has a hard failure

- the choice of the return codes should be changed:
  * ENOTSUPP is defined for the NFSv3 protocol, and I think ENOENT (no
such file or directory) or ENXIO (No such device or address) might be
better
  * EINVAL is for an invalid argument of a function, and here the
argument is correct, but the device is not. Maybe EBADR (Invalid
request descriptor)?

If we can get this patch in stable soon, this would also help of the
BLE series Mazin is currently working on.

Cheers,
Benjamin


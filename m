Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE4D2D4A5C
	for <lists+stable@lfdr.de>; Sat, 12 Oct 2019 00:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727218AbfJKWdP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 18:33:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22197 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726174AbfJKWdO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Oct 2019 18:33:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570833194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ih6shK72SsYbUilowKrJkHCxbMKYtWGrrGp+ltqWoGg=;
        b=Y7g+6fcyOR5QpZqUZzLRLlZqU5xjocCQ9A7VKmejjQb6BQrsUPDnpJc6UOp+woaN6RcHwu
        pV/kC/Yg6YITdLCpT+w+wj41wBNL4XETvKgwGrn/RgVimuM//jh8I3/EB2sY2wEWHzaCPh
        gFGe6jdUkZDo5kLUxxlmlbPkFQR6rs8=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-93-8xKsn1OhO16eVHfgGNT91g-1; Fri, 11 Oct 2019 18:33:09 -0400
Received: by mail-qk1-f200.google.com with SMTP id q80so10391289qke.22
        for <stable@vger.kernel.org>; Fri, 11 Oct 2019 15:33:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xUGJx7tOM8vQwvIOh3cm4givSxEOOhsnPOf5V8GuBe4=;
        b=mDYPZ1QO4rQ51UusxiGkmQY5s0dgaGfOf3vbVA6wGK1U0Or3fT7cmTX349XgBBPsEX
         qt+Yex+d9zEiG79qgRfU60POVPiy9LQG4yLNygX92osSJkyIhS8MUOZnEHALQkjSQevZ
         09P3/1NpoS4PAhRFf6sB4jmMI6rtg+XxXM21uuJK6BSQLuOPn9HzIAqR5yRu7ifrw5lY
         syfRdBzDwugyxd6FzJ9kEgc9M8tQ5C8lUvDew7wtFmpWMcJsScb22Jpl5Ep/oyk2kZqs
         703hIdWuYWn1zkFnMnV1hpgUI/9x9FvrumRAGCUqTFXHyfyGnrkXQmzLd6w+NGTmAJaL
         0p3A==
X-Gm-Message-State: APjAAAV50nwOIX9T/NvOOuxpo8b30ngxp7CJSNzjsLBIyPcYkNyiYrhQ
        90rZjNlcDkB3ZpI7LTss4iIGDPFwTO4kOpxCJ0ZEh82DN0X5jyxlHuWrYS0x4w4lD1dg/+nBiFk
        tmp44zIRniOea7AltwhneDuhgDfq5NogT
X-Received: by 2002:a05:620a:13d9:: with SMTP id g25mr18351873qkl.230.1570833189360;
        Fri, 11 Oct 2019 15:33:09 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyNVINYPQ1pIAUtuY+uu541pUmoVdM12qwuHJDRtZtIJHK0tuakBrRGmXG2hwE3aKPfYHWMUN5DKm+iE9s8m5c=
X-Received: by 2002:a05:620a:13d9:: with SMTP id g25mr18351832qkl.230.1570833189064;
 Fri, 11 Oct 2019 15:33:09 -0700 (PDT)
MIME-Version: 1.0
References: <20191007051240.4410-1-andrew.smirnov@gmail.com>
 <20191007051240.4410-4-andrew.smirnov@gmail.com> <CAO-hwJJ8tp4Rqte-umv9e=S5evR5oJTErsNR0Wk-z8wcbtR0wg@mail.gmail.com>
 <CAHQ1cqHCYiaEXck3LMGBwYiHVDQcF=XuF=kHJ4f_v1ea6hDR2g@mail.gmail.com>
In-Reply-To: <CAHQ1cqHCYiaEXck3LMGBwYiHVDQcF=XuF=kHJ4f_v1ea6hDR2g@mail.gmail.com>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Sat, 12 Oct 2019 00:32:57 +0200
Message-ID: <CAO-hwJ+HZEhn_riNwrODKSySt4aP4RzZq+omYDAF-7q5dLQR1Q@mail.gmail.com>
Subject: Re: [PATCH 3/3] HID: logitech-hidpp: add G920 device validation quirk
To:     Andrey Smirnov <andrew.smirnov@gmail.com>
Cc:     "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Sam Bazely <sambazley@fastmail.com>,
        Jiri Kosina <jikos@kernel.org>,
        Henrik Rydberg <rydberg@bitmath.org>,
        "Pierre-Loup A . Griffais" <pgriffais@valvesoftware.com>,
        Austin Palmer <austinp@valvesoftware.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "3.8+" <stable@vger.kernel.org>
X-MC-Unique: 8xKsn1OhO16eVHfgGNT91g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 11, 2019 at 9:39 PM Andrey Smirnov <andrew.smirnov@gmail.com> w=
rote:
>
> On Fri, Oct 11, 2019 at 7:56 AM Benjamin Tissoires
> <benjamin.tissoires@redhat.com> wrote:
> >
> > On Mon, Oct 7, 2019 at 7:13 AM Andrey Smirnov <andrew.smirnov@gmail.com=
> wrote:
> > >
> > > G920 device only advertises REPORT_ID_HIDPP_LONG and
> > > REPORT_ID_HIDPP_VERY_LONG in its HID report descriptor, so querying
> > > for REPORT_ID_HIDPP_SHORT with optional=3Dfalse will always fail and
> > > prevent G920 to be recognized as a valid HID++ device.
> > >
> > > Modify hidpp_validate_device() to check only REPORT_ID_HIDPP_LONG wit=
h
> > > optional=3Dfalse on G920 to fix this.
> > >
> > > Fixes: fe3ee1ec007b ("HID: logitech-hidpp: allow non HID++ devices to=
 be handled by this module")
> > > Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=3D204191
> > > Reported-by: Sam Bazely <sambazley@fastmail.com>
> > > Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
> > > Cc: Jiri Kosina <jikos@kernel.org>
> > > Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> > > Cc: Henrik Rydberg <rydberg@bitmath.org>
> > > Cc: Sam Bazely <sambazley@fastmail.com>
> > > Cc: Pierre-Loup A. Griffais <pgriffais@valvesoftware.com>
> > > Cc: Austin Palmer <austinp@valvesoftware.com>
> > > Cc: linux-input@vger.kernel.org
> > > Cc: linux-kernel@vger.kernel.org
> > > Cc: stable@vger.kernel.org
> > > ---
> > >  drivers/hid/hid-logitech-hidpp.c | 6 ++++++
> > >  1 file changed, 6 insertions(+)
> > >
> > > diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logit=
ech-hidpp.c
> > > index cadf36d6c6f3..f415bf398e17 100644
> > > --- a/drivers/hid/hid-logitech-hidpp.c
> > > +++ b/drivers/hid/hid-logitech-hidpp.c
> > > @@ -3511,6 +3511,12 @@ static bool hidpp_validate_report(struct hid_d=
evice *hdev, int id,
> > >
> > >  static bool hidpp_validate_device(struct hid_device *hdev)
> > >  {
> > > +       struct hidpp_device *hidpp =3D hid_get_drvdata(hdev);
> > > +
> > > +       if (hidpp->quirks & HIDPP_QUIRK_CLASS_G920)
> > > +               return hidpp_validate_report(hdev, REPORT_ID_HIDPP_LO=
NG,
> > > +                                            HIDPP_REPORT_SHORT_LENGT=
H, false);
> > > +
> >
> > with https://patchwork.kernel.org/patch/11184749/ we also have a need
> > for such a trick for BLE mice.
> >
> > I wonder if we should not have a more common way of validating the devi=
ces
> >
>
> What about just checking for:
>
> hidpp_validate_report(REPORT_ID_HIDPP_SHORT,
>                                     HIDPP_REPORT_SHORT_LENGTH, true) ||
> hidpp_validate_report(hdev, REPORT_ID_HIDPP_LONG,
>                                     HIDPP_REPORT_LONG_LENGTH, true);
>
> and probably dropping the "optional" argument for
> hidpp_validate_report()? Original code allows there to be devices
> supporting shorts reports only, but it seems that devices that support
> only long reports are legitimate too, so maybe the only "invalid"
> combination is if both are invalid length or missing?

Well, the problem is we also want to detect 2 things:
- devices that do not have any of the HID++ collections, and handle
them as generic ones (the second mouse/keyboard collection in the
gaming mice should still be exported by the driver, or this will kill
the macros / rebinding capabilities
- malicious devices that pretends to have a HID++ collection but want
to trigger a buffer overflow by having a shorter than expected report
length

Point 2 above should still be fine, but point 1 is why we have the
enforcement of the HID++ short report in the first place.

Cheers,
Benjamin

>
> Thanks,
> Andrey Smirnov


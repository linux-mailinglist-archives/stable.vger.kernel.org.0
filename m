Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C22C6D488C
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 21:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729024AbfJKTi7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 15:38:59 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:37551 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728974AbfJKTi7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Oct 2019 15:38:59 -0400
Received: by mail-lj1-f195.google.com with SMTP id l21so10946559lje.4;
        Fri, 11 Oct 2019 12:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bvbkgPji/VuFLHgjt9B1Ec11lPx0dB/Mf4ZgfY2WJ0A=;
        b=ck3sqG+HCuBS2PvbPgzkGeex+ksEJxtGvTPTGlxGOaGI1cnWQYSMN9Qg4Gsqwm10VQ
         5tXVXoM+GaRPf+9EkOcXabZocewWMNtzOdAB6Fe52D6yMM2CyLqZDSVURiONLwxhuyBF
         bi/oHXoJpFSMCljG4rVs/XDL11NVgk54RWeVgwSPAM7n+uJiKS3Ozlwmw84govq9xul8
         WGU/EP8F0/jkbBWEkaUsHfX/S3A61cPFcP4ph2oa+9ldb6WyNSr5KxyreW0eEx7XB1u6
         ninfVvXwsmEveVNmGBwH2wFHDmaxCqV5ELHWKFjGMa/9MinsjI1h8ipsiiaxhEw72pVZ
         ZYwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bvbkgPji/VuFLHgjt9B1Ec11lPx0dB/Mf4ZgfY2WJ0A=;
        b=Y9VfbMHtqt/O1CisulGsMnHQPLSHr1qQX0LnXf50q+bJHVaM9jSWYIitvM3rvtle+A
         SSp9+tWb/zdMa2NvKAbBTmko8yvJNRlj023ZjIbiB1tRme4dGTffFcb/DK4Pn2kyQtxB
         O1It6hNGBYGuaYXQJ5C+6NM0mYXGNMQl/3vQSvFhLOK2FjNB9/R2242RhQyVLlvbwGHL
         mT1OKnUzZq6AE9yWKYNHtzx4Iv8Qru5f4dH+rCHEbi+tfwsfLLkBVeJvIz3ZJHSPAaiU
         Ic3KXEO8iraFrzWlrWz8sX+tEbCFj/gVaHY8YmIQv/8lIOCa3rERIfecyx3NNKESR1zh
         y7WQ==
X-Gm-Message-State: APjAAAXOGIh6MTh11o9gICSAoaZXHT4xT3A4EUi7lKcX8jh5T2k/lzOF
        44HW2Tvyx1zV+V6gHOXBk0K9PIQl4pytkP4R3nK2+vTAyPU=
X-Google-Smtp-Source: APXvYqyLYRKd5FFwzw51/dkToQP/WtKREB+bxrHW6EtZpBon38cz6MKrSZce2CyBZAxOghYhkiemxpVu0oOi/aDuBjU=
X-Received: by 2002:a2e:97ca:: with SMTP id m10mr8645293ljj.168.1570822736617;
 Fri, 11 Oct 2019 12:38:56 -0700 (PDT)
MIME-Version: 1.0
References: <20191007051240.4410-1-andrew.smirnov@gmail.com>
 <20191007051240.4410-4-andrew.smirnov@gmail.com> <CAO-hwJJ8tp4Rqte-umv9e=S5evR5oJTErsNR0Wk-z8wcbtR0wg@mail.gmail.com>
In-Reply-To: <CAO-hwJJ8tp4Rqte-umv9e=S5evR5oJTErsNR0Wk-z8wcbtR0wg@mail.gmail.com>
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
Date:   Fri, 11 Oct 2019 12:38:45 -0700
Message-ID: <CAHQ1cqHCYiaEXck3LMGBwYiHVDQcF=XuF=kHJ4f_v1ea6hDR2g@mail.gmail.com>
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

On Fri, Oct 11, 2019 at 7:56 AM Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> On Mon, Oct 7, 2019 at 7:13 AM Andrey Smirnov <andrew.smirnov@gmail.com> wrote:
> >
> > G920 device only advertises REPORT_ID_HIDPP_LONG and
> > REPORT_ID_HIDPP_VERY_LONG in its HID report descriptor, so querying
> > for REPORT_ID_HIDPP_SHORT with optional=false will always fail and
> > prevent G920 to be recognized as a valid HID++ device.
> >
> > Modify hidpp_validate_device() to check only REPORT_ID_HIDPP_LONG with
> > optional=false on G920 to fix this.
> >
> > Fixes: fe3ee1ec007b ("HID: logitech-hidpp: allow non HID++ devices to be handled by this module")
> > Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=204191
> > Reported-by: Sam Bazely <sambazley@fastmail.com>
> > Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
> > Cc: Jiri Kosina <jikos@kernel.org>
> > Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> > Cc: Henrik Rydberg <rydberg@bitmath.org>
> > Cc: Sam Bazely <sambazley@fastmail.com>
> > Cc: Pierre-Loup A. Griffais <pgriffais@valvesoftware.com>
> > Cc: Austin Palmer <austinp@valvesoftware.com>
> > Cc: linux-input@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Cc: stable@vger.kernel.org
> > ---
> >  drivers/hid/hid-logitech-hidpp.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
> > index cadf36d6c6f3..f415bf398e17 100644
> > --- a/drivers/hid/hid-logitech-hidpp.c
> > +++ b/drivers/hid/hid-logitech-hidpp.c
> > @@ -3511,6 +3511,12 @@ static bool hidpp_validate_report(struct hid_device *hdev, int id,
> >
> >  static bool hidpp_validate_device(struct hid_device *hdev)
> >  {
> > +       struct hidpp_device *hidpp = hid_get_drvdata(hdev);
> > +
> > +       if (hidpp->quirks & HIDPP_QUIRK_CLASS_G920)
> > +               return hidpp_validate_report(hdev, REPORT_ID_HIDPP_LONG,
> > +                                            HIDPP_REPORT_SHORT_LENGTH, false);
> > +
>
> with https://patchwork.kernel.org/patch/11184749/ we also have a need
> for such a trick for BLE mice.
>
> I wonder if we should not have a more common way of validating the devices
>

What about just checking for:

hidpp_validate_report(REPORT_ID_HIDPP_SHORT,
                                    HIDPP_REPORT_SHORT_LENGTH, true) ||
hidpp_validate_report(hdev, REPORT_ID_HIDPP_LONG,
                                    HIDPP_REPORT_LONG_LENGTH, true);

and probably dropping the "optional" argument for
hidpp_validate_report()? Original code allows there to be devices
supporting shorts reports only, but it seems that devices that support
only long reports are legitimate too, so maybe the only "invalid"
combination is if both are invalid length or missing?

Thanks,
Andrey Smirnov

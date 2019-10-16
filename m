Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44F04D9A55
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 21:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394379AbfJPTi3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 15:38:29 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:43328 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389475AbfJPTi3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Oct 2019 15:38:29 -0400
Received: by mail-io1-f68.google.com with SMTP id v2so55323656iob.10;
        Wed, 16 Oct 2019 12:38:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7XgTR34jmJY6bbE8yVq7UbaQLHMtXrKCgBYN+0ani3I=;
        b=nWbJgs1Vz1MF2aDQEDJas4bAiv0IDC0qUwwUB6KI0vcpDmEYSSnBa9hWfSEl6o0d/k
         3gt6JSWDs4XvxnPRCBRNI369ib1K5xBJLPYKmlH3a3/keDWs+ElKG8p/64wEHXFf/Y6Q
         LAeajzscGMsQRzYAabU3P/rk53I10JIf1N9XLJj231Nu2heAVsk+vGdYPSdniSoG4/4T
         3FOt6/rG7m4bKJbn7+MSQNzUqYNiyIFXvNQmut1BKLLfD1cQittuMIN4hTm4GXwz2QU5
         2pRVVuzSeqAIpQ+aEx4cRednpifdYJsS83ct+Qf++XhjlqHfNZUog860Koqd3b1O3vsS
         ZHpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7XgTR34jmJY6bbE8yVq7UbaQLHMtXrKCgBYN+0ani3I=;
        b=SEq09PpRoPXTn6WgsCjPHl/KkUsgzenacvqnjgNBI6Vklz2gshnDV7ih4vh73/8Oe0
         osWdLvWzSNn2gC+pfdtULDzVyml0aEhTj+s5qgOn35gSXP9q8La3Awz2a++rebsLhEPF
         lWatG9iMwSJDfSN3Q2qJjJJv79S3dJwcIngePigG9CS7WnwE9pnBfRw9JWGVU16+saGJ
         jgA5FiL9awolSB5zoVZ0qOCf471/97nf511zS42ou+uIQtUadjNKa4TNep3/10zj43I7
         f7joncL7EpDaT6i8lOHemUW5SkpI571ZCVXI12Ei7EiXzaBKs1r/kZkz4pDkFaZZw/tU
         GefQ==
X-Gm-Message-State: APjAAAUtziNomgPRO4NeF2QmvvplbX4IrhTP8Tkr8b0r8yNosnrlJdbo
        99AK9W+KYVvCPtGNzgLR2gRNvkrjSi4qyW6mXMn2Aia8
X-Google-Smtp-Source: APXvYqwgobmLNITMjifakN1liPScdJvi5J4WITDlpQm22ByVsjfAFNjAhdW4B8QIfeEKN9U/FlOarelfHC1Wm5Qqm2k=
X-Received: by 2002:a5e:db46:: with SMTP id r6mr269537iop.287.1571254707727;
 Wed, 16 Oct 2019 12:38:27 -0700 (PDT)
MIME-Version: 1.0
References: <20191016182935.5616-1-andrew.smirnov@gmail.com>
 <20191016182935.5616-3-andrew.smirnov@gmail.com> <CAO-hwJ++YWtX29YefGzaEfCLDA=npZwUxDCkDzxALAmLLqv7FQ@mail.gmail.com>
In-Reply-To: <CAO-hwJ++YWtX29YefGzaEfCLDA=npZwUxDCkDzxALAmLLqv7FQ@mail.gmail.com>
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
Date:   Wed, 16 Oct 2019 12:38:15 -0700
Message-ID: <CAHQ1cqHcm2z4dTJ-3kx-_e3_1mpz9x_AQ+GP_j-nqL=3Gm-AtQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] HID: logitech-hidpp: rework device validation
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

On Wed, Oct 16, 2019 at 12:24 PM Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> Hi Andrey,
>
> On Wed, Oct 16, 2019 at 8:30 PM Andrey Smirnov <andrew.smirnov@gmail.com> wrote:
> >
> > G920 device only advertises REPORT_ID_HIDPP_LONG and
> > REPORT_ID_HIDPP_VERY_LONG in its HID report descriptor, so querying
> > for REPORT_ID_HIDPP_SHORT with optional=false will always fail and
> > prevent G920 to be recognized as a valid HID++ device.
> >
> > To fix this and improve some other aspects, modify
> > hidpp_validate_device() as follows:
> >
> >   - Inline the code of hidpp_validate_report() to simplify
> >     distingushing between non-present and invalid report descriptors
> >
> >   - Drop the check for id >= HID_MAX_IDS || id < 0 since all of our
> >     IDs are static and known to satisfy that at compile time
> >
> >   - Change the algorithms to check all possible report
> >     types (including very long report) and deem the device as a valid
> >     HID++ device if it supports at least one
> >
> >   - Treat invalid report length as a hard stop for the validation
> >     algorithm, meaning that if any of the supported reports has
> >     invalid length we assume the worst and treat the device as a
> >     generic HID device.
> >
> >   - Fold initialization of hidpp->very_long_report_length into
> >     hidpp_validate_device() since it already fetches very long report
> >     length and validates its value
> >
> > Fixes: fe3ee1ec007b ("HID: logitech-hidpp: allow non HID++ devices to be handled by this module")
> > Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=204191
> > Reported-by: Sam Bazely <sambazley@fastmail.com>
> > Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
> > Cc: Jiri Kosina <jikos@kernel.org>
> > Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> > Cc: Henrik Rydberg <rydberg@bitmath.org>
> > Cc: Pierre-Loup A. Griffais <pgriffais@valvesoftware.com>
> > Cc: Austin Palmer <austinp@valvesoftware.com>
> > Cc: linux-input@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Cc: stable@vger.kernel.org # 5.2+
> > ---
> >  drivers/hid/hid-logitech-hidpp.c | 54 ++++++++++++++++++--------------
> >  1 file changed, 30 insertions(+), 24 deletions(-)
> >
> > diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
> > index 85911586b3b6..8c4be991f387 100644
> > --- a/drivers/hid/hid-logitech-hidpp.c
> > +++ b/drivers/hid/hid-logitech-hidpp.c
> > @@ -3498,34 +3498,45 @@ static int hidpp_get_report_length(struct hid_device *hdev, int id)
> >         return report->field[0]->report_count + 1;
> >  }
> >
> > -static bool hidpp_validate_report(struct hid_device *hdev, int id,
> > -                                 int expected_length, bool optional)
> > +static bool hidpp_validate_device(struct hid_device *hdev)
> >  {
> > -       int report_length;
> > +       struct hidpp_device *hidpp = hid_get_drvdata(hdev);
> > +       int id, report_length, supported_reports = 0;
> > +
> > +       id = REPORT_ID_HIDPP_SHORT;
> > +       report_length = hidpp_get_report_length(hdev, id);
> > +       if (report_length) {
> > +               if (report_length < HIDPP_REPORT_SHORT_LENGTH)
> > +                       goto bad_device;
> >
> > -       if (id >= HID_MAX_IDS || id < 0) {
> > -               hid_err(hdev, "invalid HID report id %u\n", id);
> > -               return false;
> > +               supported_reports++;
> >         }
> >
> > +       id = REPORT_ID_HIDPP_LONG;
> >         report_length = hidpp_get_report_length(hdev, id);
> > -       if (!report_length)
> > -               return optional;
> > +       if (report_length) {
> > +               if (report_length < HIDPP_REPORT_LONG_LENGTH)
> > +                       goto bad_device;
> >
> > -       if (report_length < expected_length) {
> > -               hid_warn(hdev, "not enough values in hidpp report %d\n", id);
> > -               return false;
> > +               supported_reports++;
> >         }
> >
> > -       return true;
> > -}
> > +       id = REPORT_ID_HIDPP_VERY_LONG;
> > +       report_length = hidpp_get_report_length(hdev, id);
> > +       if (report_length) {
> > +               if (report_length > HIDPP_REPORT_LONG_LENGTH &&
> > +                   report_length < HIDPP_REPORT_VERY_LONG_MAX_LENGTH)
>
> Can you double check the conditions here?
> It's late, but I think you inverted the tests as we expect the report
> length to be between HIDPP_REPORT_LONG_LENGTH and
> HIDPP_REPORT_VERY_LONG_MAX_LENGTH inclusive, while here this creates a
> bad_device.

Hmm, I think you are right. Not sure why I didn't catch it on G920
since it support very long reports AFAIR. Will re-spin and double
check in v3. Sorry about that.

Thanks,
Andrey Smirnov

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3020B3D633
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 21:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392453AbfFKTDF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 15:03:05 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:38308 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392436AbfFKTDD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jun 2019 15:03:03 -0400
Received: by mail-lf1-f66.google.com with SMTP id b11so10132139lfa.5;
        Tue, 11 Jun 2019 12:03:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wOd5RFLew6CdqEZNQp7QEBi1szCLUjSrRQzD8SvAiVg=;
        b=GQzI4RGbSQLsqwNk4BHMkRdGjxlEd5ZaTF8wUzz0VGC93CTKHOoIkIJR+CMdxSD/UM
         JJn1W3bA1/Tkp032qyCP5gncO5AH1f6ykvTS54kRNu72PrWw8P0T9Lk/uw7OFv+yFm+1
         BDiZ5hpOsDJLN3heuAjbDwDna008r/rZha54zYiXpb1wpyZrgLpLH8N8eUM7usWlG/ol
         j0+rvsHJf24/xr9YUNuG6ozjxEh7cdqLXvyzaNZk5/79Gd9FjRO+fVKJVoE2pP8GiFQl
         fGlfMZEvBqhVC/Y31xmQ7OWlWAgTeVbuwEKSKK/8jFBCMekA6FXACehSEIfjf4S/nomU
         EAtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wOd5RFLew6CdqEZNQp7QEBi1szCLUjSrRQzD8SvAiVg=;
        b=A6INRL5LX81iONJ8fz5Osy4nyBbnO0IM7T6haFHagO8XYXqHhzNaYM6NZ4KY3S/jTJ
         dvPLFprQNUyjAieug/INXG1NWGnrKFhIEgFTMz9xav9NYOMs1IPY1iBmTX8T0XemF+4c
         u8g9TWlYZW70N6T2HnBbhvu6tcVnuOTGOzCBPuYnVcAGwpq142+OhRtLULWphINsICN5
         1afqeO71LeCpynF/8idMytrTbEe7jdZGug/rErSG2UxBHxGKrKxzGi/+gMj8tJFx7tzs
         d/VV3vDMbo7sJ2mUh7NLvaG5RoVLBOnWMeXRu0J7o1OxAMvYjw99G/PUGjSb1JN0GOTH
         PSAg==
X-Gm-Message-State: APjAAAWcTHXoyVgVIVTVR2AVvJcS8bE0b0Rk+Knj9Rt+1lAg4jiYkZyi
        IdPTz7PQvhGKIdnahrcWxeE1n2ylVJ5BIXLdzTr7o6hM
X-Google-Smtp-Source: APXvYqx1T0x8RVg/ceaESNqHiE0NQjsQle9cejbffh1qor1nnOlAiI7FgeeO8IKRXR5sAhw9qMNUdrbJnX38zuoSggk=
X-Received: by 2002:a19:488e:: with SMTP id v136mr37325178lfa.192.1560279780090;
 Tue, 11 Jun 2019 12:03:00 -0700 (PDT)
MIME-Version: 1.0
References: <CANRwn3Ru+7FGtsY=GaDa7pAJkuagdb6nFtvrFq1qhTWJR0rF9A@mail.gmail.com>
 <20190426163531.9782-1-jason.gerecke@wacom.com>
In-Reply-To: <20190426163531.9782-1-jason.gerecke@wacom.com>
From:   Jason Gerecke <killertofu@gmail.com>
Date:   Tue, 11 Jun 2019 12:02:47 -0700
Message-ID: <CANRwn3RBK41mRJKUPDDptoq_So6_7UxR0toaauZvjT5U=OaHWw@mail.gmail.com>
Subject: Re: [PATCH 2/2] HID: wacom: Don't report anything prior to the tool
 entering range
To:     "# v3.17+" <stable@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Linux Input <linux-input@vger.kernel.org>,
        Ping Cheng <pinglinux@gmail.com>,
        Aaron Armstrong Skomra <skomra@gmail.com>,
        Jason Gerecke <jason.gerecke@wacom.com>,
        Aaron Armstrong Skomra <aaron.skomra@wacom.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I haven't been keeping a close eye on this and just noticed that this
patch set doesn't seem to have been merged into stable. There's also a
second patch series (beginning with "[PATCH 1/3] HID: wacom: Send
BTN_TOUCH in response to INTUOSP2_BT eraser contact") that hasn't seen
any stable activity either.

Any idea what's up?

Jason
---
Now instead of four in the eights place /
you=E2=80=99ve got three, =E2=80=98Cause you added one  /
(That is to say, eight) to the two,     /
But you can=E2=80=99t take seven from three,    /
So you look at the sixty-fours....
On Fri, Apr 26, 2019 at 9:35 AM Gerecke, Jason <killertofu@gmail.com> wrote=
:
>
> From: Jason Gerecke <jason.gerecke@wacom.com>
>
> If the tool spends some time in prox before entering range, a series of
> events (e.g. ABS_DISTANCE, MSC_SERIAL) can be sent before we or userspace
> have any clue about the pen whose data is being reported. We need to hold
> off on reporting anything until the pen has entered range. Since we still
> want to report events that occur "in prox" after the pen has *left* range
> we use 'wacom-tool[0]' as the indicator that the pen did at one point
> enter range and provide us/userspace with tool type and serial number
> information.
>
> Fixes: a48324de6d ("HID: wacom: Bluetooth IRQ for Intuos Pro should handl=
e prox/range")
> Cc: <stable@vger.kernel.org> # 4.11+
> Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
> Reviewed-by: Aaron Armstrong Skomra <aaron.skomra@wacom.com>
> ---
> Version of patch specifically targeted to stable v4.14.113
>
>  drivers/hid/wacom_wac.c | 21 ++++++++++++---------
>  1 file changed, 12 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
> index 03b04bc742dd..e4aeffa56018 100644
> --- a/drivers/hid/wacom_wac.c
> +++ b/drivers/hid/wacom_wac.c
> @@ -1271,17 +1271,20 @@ static void wacom_intuos_pro2_bt_pen(struct wacom=
_wac *wacom)
>                         input_report_abs(pen_input, ABS_Z, rotation);
>                         input_report_abs(pen_input, ABS_WHEEL, get_unalig=
ned_le16(&frame[11]));
>                 }
> -               input_report_abs(pen_input, ABS_PRESSURE, get_unaligned_l=
e16(&frame[5]));
> -               input_report_abs(pen_input, ABS_DISTANCE, range ? frame[1=
3] : wacom->features.distance_max);
>
> -               input_report_key(pen_input, BTN_TOUCH, frame[0] & 0x01);
> -               input_report_key(pen_input, BTN_STYLUS, frame[0] & 0x02);
> -               input_report_key(pen_input, BTN_STYLUS2, frame[0] & 0x04)=
;
> +               if (wacom->tool[0]) {
> +                       input_report_abs(pen_input, ABS_PRESSURE, get_una=
ligned_le16(&frame[5]));
> +                       input_report_abs(pen_input, ABS_DISTANCE, range ?=
 frame[13] : wacom->features.distance_max);
>
> -               input_report_key(pen_input, wacom->tool[0], prox);
> -               input_event(pen_input, EV_MSC, MSC_SERIAL, wacom->serial[=
0]);
> -               input_report_abs(pen_input, ABS_MISC,
> -                                wacom_intuos_id_mangle(wacom->id[0])); /=
* report tool id */
> +                       input_report_key(pen_input, BTN_TOUCH, frame[0] &=
 0x01);
> +                       input_report_key(pen_input, BTN_STYLUS, frame[0] =
& 0x02);
> +                       input_report_key(pen_input, BTN_STYLUS2, frame[0]=
 & 0x04);
> +
> +                       input_report_key(pen_input, wacom->tool[0], prox)=
;
> +                       input_event(pen_input, EV_MSC, MSC_SERIAL, wacom-=
>serial[0]);
> +                       input_report_abs(pen_input, ABS_MISC,
> +                                        wacom_intuos_id_mangle(wacom->id=
[0])); /* report tool id */
> +               }
>
>                 wacom->shared->stylus_in_proximity =3D prox;
>
> --
> 2.21.0
>

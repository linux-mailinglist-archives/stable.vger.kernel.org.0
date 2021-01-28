Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BBD3306C9A
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 06:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbhA1FIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 00:08:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbhA1FIy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jan 2021 00:08:54 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE200C061573;
        Wed, 27 Jan 2021 21:08:13 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id ke15so5876832ejc.12;
        Wed, 27 Jan 2021 21:08:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fdsoQ6aqbCvZf0PWuN79SpgzgiUeOULiFlVAD49MHZQ=;
        b=MJOYhrl3fE7B5fqUzUbkBRfz7LFlkZqHestvIb5iCIcLQxBCHa8MAmzn25FCIPpgJU
         7Oww+VaSX4v+CeItvMCfgCyUs4MvZi4Qo+Lj7hgiUWXPw+rSzUhmXvPa76vDwOfTY0Mw
         epEs3Kgqd0SneEU9Hb/KZOgamZvp1OVOVkiDQivGzLIatqA1ZDWm/s2UPZdzAb45UI/1
         buxh4lhqLetmupuZdUrfzAS9crwlQsIZT1Mo0X0TcCWf16wzl94LkiGF7UiJPhEuxb1D
         8qKhW/WnJ8OL/Qr1a4zbr4WArajNkr+uOAU2/fhC8+AgrwUQQvbHzwWsvdlACwYCjeeP
         08hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fdsoQ6aqbCvZf0PWuN79SpgzgiUeOULiFlVAD49MHZQ=;
        b=KYUk3UbqunY4zkFPVwP28HGsEvoJoedPDCiAAe//VK0yToY42xd7vHh9urJK4P4aiB
         2SuQsVRGrT6J7qKiHXwD0dj9vX0WSPpGHg08F/ItpX0nCDDsouTRK08Hrl52LppfEAd9
         9+g5ESWxtRt3r/1Fiu6zCYqPnbfN8TQJo7BQGlYXOdAqeCGnqFj2OzbJbwAlyr+Gi8Tz
         5NBig8PNNteZkTQsFIk+5CCHUsN5rfZNZbz4ge8IQyr75KxcCdGeNwRaSLg1nZxQDJXp
         AKnJmREsvgusede6g0QXvXG3gX6oe0FlksmSZ5EMDUHJmIh18tU+AWfbbISt9lpjMFwF
         BcmQ==
X-Gm-Message-State: AOAM532vCtJi75DpdDUZqqAAJ3FIBp7za6JE+Rvu8qrCNlJ3jvMEWced
        DI+ngAseaMQcXRkgoICLL/lfj7vzxuSsnnOm/AE=
X-Google-Smtp-Source: ABdhPJz4dD8JjSQiV7vDT8TkDrvQdCi57sJHQzZD95/ulLOlrEpUuGT2zcUp0u7Kuh3knjWTWudW9K7sYT3Y9wVPQgg=
X-Received: by 2002:a17:906:5ad0:: with SMTP id x16mr9495925ejs.135.1611810492671;
 Wed, 27 Jan 2021 21:08:12 -0800 (PST)
MIME-Version: 1.0
References: <a09eea7616881d40d2db2fb5fa2770dc6166bdae.1611456351.git.tommyhebb@gmail.com>
 <20210125100540.55wbgdsem3htplx3@pali> <20210125201938.GB78651@roeck-us.net>
 <20210125202130.afwhcuznietmqo5s@pali> <20210127230001.7zeeczkfj33zj5sw@pali> <aef96a2a-9e27-32a2-62a5-92b8d87b9136@roeck-us.net>
In-Reply-To: <aef96a2a-9e27-32a2-62a5-92b8d87b9136@roeck-us.net>
From:   Bob Hepple <bob.hepple@gmail.com>
Date:   Thu, 28 Jan 2021 15:08:01 +1000
Message-ID: <CAHzpm2jOi1VnQR_kun-Y15jXskExYF7dV-o0-T0-pvLy+J8jsQ@mail.gmail.com>
Subject: Re: [PATCH] hwmon: (dell-smm) Add XPS 15 L502X to fan control blacklist
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
        Thomas Hebb <tommyhebb@gmail.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jean Delvare <jdelvare@suse.com>, linux-hwmon@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I've posted something on the Dell Community site as I can't get to the
proper support pages (expired warranty).

https://www.dell.com/community/XPS/Linux-kernel-regression-in-fan-control-d=
ell-smm-hwmon-c-on-XPS/m-p/7794672#M77826

I have read that the Dell Social Networks people forward this sort of
stuff to the Dell Developers ...

Cheers

Bob

On Thu, 28 Jan 2021 at 11:46, Guenter Roeck <linux@roeck-us.net> wrote:
>
> On 1/27/21 3:00 PM, Pali Roh=C3=A1r wrote:
> > On Monday 25 January 2021 21:21:30 Pali Roh=C3=A1r wrote:
> >> On Monday 25 January 2021 12:19:38 Guenter Roeck wrote:
> >>> On Mon, Jan 25, 2021 at 11:05:40AM +0100, Pali Roh=C3=A1r wrote:
> >>>> On Saturday 23 January 2021 18:46:08 Thomas Hebb wrote:
> >>>>> It has been reported[0] that the Dell XPS 15 L502X exhibits similar
> >>>>> freezing behavior to the other systems[1] on this blacklist. The is=
sue
> >>>>> was exposed by a prior change of mine to automatically load
> >>>>> dell_smm_hwmon on a wider set of XPS models. To fix the regression,=
 add
> >>>>> this model to the blacklist.
> >>>>>
> >>>>> [0] https://bugzilla.kernel.org/show_bug.cgi?id=3D211081
> >>>>> [1] https://bugzilla.kernel.org/show_bug.cgi?id=3D195751
> >>>>>
> >>>>> Fixes: b8a13e5e8f37 ("hwmon: (dell-smm) Use one DMI match for all X=
PS models")
> >>>>> Cc: stable@vger.kernel.org
> >>>>> Reported-by: Bob Hepple <bob.hepple@gmail.com>
> >>>>> Tested-by: Bob Hepple <bob.hepple@gmail.com>
> >>>>> Signed-off-by: Thomas Hebb <tommyhebb@gmail.com>
> >>>>> ---
> >>>>>
> >>>>>  drivers/hwmon/dell-smm-hwmon.c | 7 +++++++
> >>>>>  1 file changed, 7 insertions(+)
> >>>>>
> >>>>> diff --git a/drivers/hwmon/dell-smm-hwmon.c b/drivers/hwmon/dell-sm=
m-hwmon.c
> >>>>> index ec448f5f2dc3..73b9db9e3aab 100644
> >>>>> --- a/drivers/hwmon/dell-smm-hwmon.c
> >>>>> +++ b/drivers/hwmon/dell-smm-hwmon.c
> >>>>> @@ -1159,6 +1159,13 @@ static struct dmi_system_id i8k_blacklist_fa=
n_support_dmi_table[] __initdata =3D {
> >>>>>                   DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "XPS13 9333"),
> >>>>>           },
> >>>>>   },
> >>>>> + {
> >>>>> +         .ident =3D "Dell XPS 15 L502X",
> >>>>> +         .matches =3D {
> >>>>> +                 DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
> >>>>> +                 DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Dell System XP=
S L502X"),
> >>>>
> >>>> Hello! Are you sure that it is required to completely disable fan
> >>>> support? And not only access to fan type label for which is differen=
t
> >>>> blaclist i8k_blacklist_fan_type_dmi_table?
> >>>>
> >>>
> >>> I'll drop this patch from my branch. Please send a Reviewed-by: or Ac=
ked-by: tag
> >>> if/when I should apply it.
> >>
> >> Of course! We will just wait for Bob test results.
> >
> > Guenter, now we have all needed information, fix is really needed in
> > this form. So you can add my:
> >
> > Reviewed-by: Pali Roh=C3=A1r <pali@kernel.org>
> >
>
> Applied (again)
>
> Thanks,
> Guenter

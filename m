Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7193046F7
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 19:48:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390070AbhAZRRy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 12:17:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730243AbhAZIQH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 03:16:07 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DB10C061574;
        Tue, 26 Jan 2021 00:15:25 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id u8so18861562ior.13;
        Tue, 26 Jan 2021 00:15:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4c7gADz6jMi7sBEnpGX3NOxZxjJzfvoNQ5bl8temnIs=;
        b=KCzl4c4tpeZ10i66NLwb+5sXArCAG6es5mMwcKHw+NrhLrGCcDEBkfYSPqfJNonto8
         gUq/H/LuoV3PNYOex5gmcgUCSCDWnwC2P9sked6Vnkei11U7c3T8aSAS1t4Mg1CGfXLS
         MNbKXIgKiEKsV2owS31XiXIHKNJEM1rKnFhGNbeSgk+u8KYIIa4XYNKEQu7JHTk5gRb/
         xoDUKpTTzcLrht/Zdi3b79P/byAXHkFuItfdaXSWTfAvq+rzlIPVR1WDSVOOgZyRGtEg
         MfjWHMMgxLjJlL9MZYwBqAzAweZWR+MBrsBpPGm+Kay6o5XW1KKqMBpSac8Q50UNOMKe
         2UOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4c7gADz6jMi7sBEnpGX3NOxZxjJzfvoNQ5bl8temnIs=;
        b=XspaL1X/s0Q/R2IhQTt6E8fWlb6qVaBnAJmlPLqzVtrT4AEcfy7BVHZE2nVPXVAYEE
         w3oi1LPV+N2ly75M3wlziw3j5IayWPDqKftWQZ/OXhkOHvxFCv4UtZvDGEH6NISEB5yP
         7qjqPygINrHXGAaygSndrMVmIxtw6dUlME0tuwBPjyCYwdhlmN0EIAXgQPRukm7yOjG+
         aZwKRR3vR2NowFRAWZKqnVT/vsa/drV6ZKGSaUaoleOrQ7V+hQ6KXu9VPkngKmdWve0q
         i+RzwfhE4bWafayx1SAxOL4pQdpg2idkibH32x6Q8F+vYN/Vgf3mD1mdXQ4I8JI0bYJb
         5Pgg==
X-Gm-Message-State: AOAM530NWlkIqkyOOspdOHuxjeeeRoGih6N5XuU4PeCqmbrp72mljqfW
        QApPbdDvkHB2zK0CZRknULH5Y/rZ1b8kki6UMCs=
X-Google-Smtp-Source: ABdhPJxYOmkTgltga9xoLC0alaqiftrNh1mNkk9Lj2Vw1J2HdaXF9jkhPkrKKL178VCUALqbNVAZpQXXZSosbCOyIDk=
X-Received: by 2002:a6b:9346:: with SMTP id v67mr3323741iod.108.1611648924777;
 Tue, 26 Jan 2021 00:15:24 -0800 (PST)
MIME-Version: 1.0
References: <a09eea7616881d40d2db2fb5fa2770dc6166bdae.1611456351.git.tommyhebb@gmail.com>
 <20210125100540.55wbgdsem3htplx3@pali> <CAMcCCgTo87HmwexZS696ok16e9s_8gRgFd38uoLP34r7TbAzBg@mail.gmail.com>
 <CAHzpm2hk4+0FyFrcGYN-JJfx5Ka8yoM8mTsYZA_4WHfWYGa4yQ@mail.gmail.com> <CAHzpm2h2X8ZKEtRxnD-mwyEv=B8J+tH_spFGD2VzfwGdRAaHMw@mail.gmail.com>
In-Reply-To: <CAHzpm2h2X8ZKEtRxnD-mwyEv=B8J+tH_spFGD2VzfwGdRAaHMw@mail.gmail.com>
From:   Tom Hebb <tommyhebb@gmail.com>
Date:   Tue, 26 Jan 2021 00:15:13 -0800
Message-ID: <CAMcCCgQRDRi1LpxJBTvKcB+dALJJsn=n5Q=Wyvfcw9LGqqjq7Q@mail.gmail.com>
Subject: Re: [PATCH] hwmon: (dell-smm) Add XPS 15 L502X to fan control blacklist
To:     =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>
Cc:     Thomas Hebb <tommyhebb@gmail.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Bob Hepple <bob.hepple@gmail.com>,
        Jean Delvare <jdelvare@suse.com>, linux-hwmon@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Bob reports that blacklisting the fan type label is not sufficient.
See his message to me below.

On Mon, Jan 25, 2021 at 3:38 PM Bob Hepple <bob.hepple@gmail.com> wrote:
>
> Hi Tom,
>
> Big nope this end with L502x in i8k_blacklist_fan_type_dmi_table:
>
> Jan 26 09:35:47 achar kernel: psmouse serio1: TouchPad at
> isa0060/serio1/input0 lost synchronization, throwing 1 bytes>
>
> ... and lots of trackpad stall/stutters.
>
> Cheers
>
>
> Bob
>
>
>
> On Tue, 26 Jan 2021 at 08:09, Bob Hepple <bob.hepple@gmail.com> wrote:
> >
> > ... compiling now ... results in a coupla hours
> >
> > Cheers
> >
> >
> > Bob
> >
> > On Tue, 26 Jan 2021 at 04:05, Tom Hebb <tommyhebb@gmail.com> wrote:
> > >
> > > On Mon, Jan 25, 2021 at 2:05 AM Pali Roh=C3=A1r <pali@kernel.org> wro=
te:
> > > >
> > > > On Saturday 23 January 2021 18:46:08 Thomas Hebb wrote:
> > > > > It has been reported[0] that the Dell XPS 15 L502X exhibits simil=
ar
> > > > > freezing behavior to the other systems[1] on this blacklist. The =
issue
> > > > > was exposed by a prior change of mine to automatically load
> > > > > dell_smm_hwmon on a wider set of XPS models. To fix the regressio=
n, add
> > > > > this model to the blacklist.
> > > > >
> > > > > [0] https://bugzilla.kernel.org/show_bug.cgi?id=3D211081
> > > > > [1] https://bugzilla.kernel.org/show_bug.cgi?id=3D195751
> > > > >
> > > > > Fixes: b8a13e5e8f37 ("hwmon: (dell-smm) Use one DMI match for all=
 XPS models")
> > > > > Cc: stable@vger.kernel.org
> > > > > Reported-by: Bob Hepple <bob.hepple@gmail.com>
> > > > > Tested-by: Bob Hepple <bob.hepple@gmail.com>
> > > > > Signed-off-by: Thomas Hebb <tommyhebb@gmail.com>
> > > > > ---
> > > > >
> > > > >  drivers/hwmon/dell-smm-hwmon.c | 7 +++++++
> > > > >  1 file changed, 7 insertions(+)
> > > > >
> > > > > diff --git a/drivers/hwmon/dell-smm-hwmon.c b/drivers/hwmon/dell-=
smm-hwmon.c
> > > > > index ec448f5f2dc3..73b9db9e3aab 100644
> > > > > --- a/drivers/hwmon/dell-smm-hwmon.c
> > > > > +++ b/drivers/hwmon/dell-smm-hwmon.c
> > > > > @@ -1159,6 +1159,13 @@ static struct dmi_system_id i8k_blacklist_=
fan_support_dmi_table[] __initdata =3D {
> > > > >                       DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "XPS13 93=
33"),
> > > > >               },
> > > > >       },
> > > > > +     {
> > > > > +             .ident =3D "Dell XPS 15 L502X",
> > > > > +             .matches =3D {
> > > > > +                     DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
> > > > > +                     DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Dell Sys=
tem XPS L502X"),
> > > >
> > > > Hello! Are you sure that it is required to completely disable fan
> > > > support? And not only access to fan type label for which is differe=
nt
> > > > blaclist i8k_blacklist_fan_type_dmi_table?
> > >
> > > This is a good question. We didn't try the other list. Bob is the one=
 with the
> > > affected system. Could you try moving the added block of code from
> > > i8k_blacklist_fan_support_dmi_table a few lines up to
> > > i8k_blacklist_fan_type_dmi_table, Bob, to see if the issue reappears =
or if it
> > > remains fixed?
> > >
> > > >
> > > > And have you reported this issue to Dell support?
> > > >
> > > > > +             },
> > > > > +     },
> > > > >       { }
> > > > >  };
> > > > >
> > > > > --
> > > > > 2.30.0
> > > > >
> > >
> > > (Apologies for the previous HTML copy of this reply, to those directl=
y CCed.)
> > >
> > > -Tom

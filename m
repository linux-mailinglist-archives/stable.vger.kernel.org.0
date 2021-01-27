Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9CCE3067D7
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 00:27:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235724AbhA0XZI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 18:25:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232339AbhA0W41 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jan 2021 17:56:27 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46CF6C061794;
        Wed, 27 Jan 2021 14:40:50 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id j13so4431478edp.2;
        Wed, 27 Jan 2021 14:40:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=iXTvbMuq3HhEnmBcA+i2YKqjm1qMVKD6f8nz7srtjj8=;
        b=AvnsMhNL+EOCr85jmdmfvcTsPF5QLZVLiJwSxIqgSV1P6OOpq+HXCs5qCRps/bjrUY
         BcqdEn2HMPmmTCnBMuo6SFwSIb4wDkj47DQSOKdsS9TyW69Tz0GgiIqqhOm6ZiA/TMy6
         D1d8LNzF/DHjMf6bydAV8xyr2pwBWh6LXUW+DoqjnyF+4eVn47vBStld3/id9KpKXk9E
         qGxm5uNqYyLV7DzEyRlvyoVXbae/GS9rSLIVtvZRR7v4KysRORK39ntUP7+gHlW4NUnt
         R0yBYlSRj/gNoqHAGnHauYgjjEbQXmnfTffWh7j58GuWEf925b0s6aRiARZdEUmWTdXA
         u24A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=iXTvbMuq3HhEnmBcA+i2YKqjm1qMVKD6f8nz7srtjj8=;
        b=X3TIRvHjMZERGkitbVgIwTCX45ClLUNu/ayEBAHsnfU4iEx8JG8CUcnq5cy0cx2bYV
         Hmd2pSVp899krFxC8BLv25CuLXVQVbTA4fIEztIZ2Hm3nAwfLd88CAEZYbAgEHE9c82Q
         gBTlZjMvAijSWyor2dOQMjHed6rb97X9WFc3s0T0QxCGNFsfU4IgVOA2cpjUnBY3pAsv
         0pGL5ARiZi8OWtGk1SjmUZE6LReJmzOj24owmbyBlj2XtzqTbwflOC07Nd21i/BuWa/d
         /kDYnNYUOoaftSSzFV7usZzL1eB/DWLSKVUvxQ/r3117fqcNfMJ9VdrDn/QSYOORLbki
         qciQ==
X-Gm-Message-State: AOAM533O3blNKUj3I++UvlSiaQgStfGq1TN2eBBEhI7VhkoA24rlzcDN
        EoCVOchHWVl8npJvLc2788gU88KtkXLO4P44+jVTb042EjQdog==
X-Google-Smtp-Source: ABdhPJxXz4v6MJrNWZHtF6mMlQ2cq3QOh/o42wPt10Hda0pk0esnXcar+N2ie3PBLsTH20/ni2bbSNfBUSJ94g27JOs=
X-Received: by 2002:a05:6402:26d3:: with SMTP id x19mr11092718edd.0.1611787248203;
 Wed, 27 Jan 2021 14:40:48 -0800 (PST)
MIME-Version: 1.0
References: <a09eea7616881d40d2db2fb5fa2770dc6166bdae.1611456351.git.tommyhebb@gmail.com>
 <20210125100540.55wbgdsem3htplx3@pali> <CAMcCCgTo87HmwexZS696ok16e9s_8gRgFd38uoLP34r7TbAzBg@mail.gmail.com>
 <CAHzpm2hk4+0FyFrcGYN-JJfx5Ka8yoM8mTsYZA_4WHfWYGa4yQ@mail.gmail.com>
 <CAHzpm2h2X8ZKEtRxnD-mwyEv=B8J+tH_spFGD2VzfwGdRAaHMw@mail.gmail.com>
 <CAMcCCgQRDRi1LpxJBTvKcB+dALJJsn=n5Q=Wyvfcw9LGqqjq7Q@mail.gmail.com> <20210127091933.haq6nmbmx3cskh5t@pali>
In-Reply-To: <20210127091933.haq6nmbmx3cskh5t@pali>
From:   Bob Hepple <bob.hepple@gmail.com>
Date:   Thu, 28 Jan 2021 08:40:36 +1000
Message-ID: <CAHzpm2j9N3ywMy6HLruCt1VaQLmB1-xVusvXUb8wa2ores+KAQ@mail.gmail.com>
Subject: Re: [PATCH] hwmon: (dell-smm) Add XPS 15 L502X to fan control blacklist
To:     =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc:     Tom Hebb <tommyhebb@gmail.com>, Guenter Roeck <linux@roeck-us.net>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jean Delvare <jdelvare@suse.com>, linux-hwmon@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Pali,

No, I have not contacted Dell about this and I'm not sure that they
would be terribly interested given that my machine is 12 years old -
but I'll have a go if I can find the right place to do it.

Do you have a good email or other Dell target to report it? I don't
have access to official Dell support as my warranty ran out about 10
years ago. Perhaps there's an existing Dell bug report that references
the original https://bugzilla.kernel.org/show_bug.cgi?id=3D195751 ??? I
could add my report there if someone has already informed Dell about
the other instances of the bug.

Thanks



Bob

On Wed, 27 Jan 2021 at 19:19, Pali Roh=C3=A1r <pali@kernel.org> wrote:
>
> On Tuesday 26 January 2021 00:15:13 Tom Hebb wrote:
> > Bob reports that blacklisting the fan type label is not sufficient.
> > See his message to me below.
>
> Ok! Thank you for confirmation.
>
> And my second question which I have asked:
> And have you reported this issue to Dell support?
>
> > On Mon, Jan 25, 2021 at 3:38 PM Bob Hepple <bob.hepple@gmail.com> wrote=
:
> > >
> > > Hi Tom,
> > >
> > > Big nope this end with L502x in i8k_blacklist_fan_type_dmi_table:
> > >
> > > Jan 26 09:35:47 achar kernel: psmouse serio1: TouchPad at
> > > isa0060/serio1/input0 lost synchronization, throwing 1 bytes>
> > >
> > > ... and lots of trackpad stall/stutters.
> > >
> > > Cheers
> > >
> > >
> > > Bob
> > >
> > >
> > >
> > > On Tue, 26 Jan 2021 at 08:09, Bob Hepple <bob.hepple@gmail.com> wrote=
:
> > > >
> > > > ... compiling now ... results in a coupla hours
> > > >
> > > > Cheers
> > > >
> > > >
> > > > Bob
> > > >
> > > > On Tue, 26 Jan 2021 at 04:05, Tom Hebb <tommyhebb@gmail.com> wrote:
> > > > >
> > > > > On Mon, Jan 25, 2021 at 2:05 AM Pali Roh=C3=A1r <pali@kernel.org>=
 wrote:
> > > > > >
> > > > > > On Saturday 23 January 2021 18:46:08 Thomas Hebb wrote:
> > > > > > > It has been reported[0] that the Dell XPS 15 L502X exhibits s=
imilar
> > > > > > > freezing behavior to the other systems[1] on this blacklist. =
The issue
> > > > > > > was exposed by a prior change of mine to automatically load
> > > > > > > dell_smm_hwmon on a wider set of XPS models. To fix the regre=
ssion, add
> > > > > > > this model to the blacklist.
> > > > > > >
> > > > > > > [0] https://bugzilla.kernel.org/show_bug.cgi?id=3D211081
> > > > > > > [1] https://bugzilla.kernel.org/show_bug.cgi?id=3D195751
> > > > > > >
> > > > > > > Fixes: b8a13e5e8f37 ("hwmon: (dell-smm) Use one DMI match for=
 all XPS models")
> > > > > > > Cc: stable@vger.kernel.org
> > > > > > > Reported-by: Bob Hepple <bob.hepple@gmail.com>
> > > > > > > Tested-by: Bob Hepple <bob.hepple@gmail.com>
> > > > > > > Signed-off-by: Thomas Hebb <tommyhebb@gmail.com>
> > > > > > > ---
> > > > > > >
> > > > > > >  drivers/hwmon/dell-smm-hwmon.c | 7 +++++++
> > > > > > >  1 file changed, 7 insertions(+)
> > > > > > >
> > > > > > > diff --git a/drivers/hwmon/dell-smm-hwmon.c b/drivers/hwmon/d=
ell-smm-hwmon.c
> > > > > > > index ec448f5f2dc3..73b9db9e3aab 100644
> > > > > > > --- a/drivers/hwmon/dell-smm-hwmon.c
> > > > > > > +++ b/drivers/hwmon/dell-smm-hwmon.c
> > > > > > > @@ -1159,6 +1159,13 @@ static struct dmi_system_id i8k_blackl=
ist_fan_support_dmi_table[] __initdata =3D {
> > > > > > >                       DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "XPS1=
3 9333"),
> > > > > > >               },
> > > > > > >       },
> > > > > > > +     {
> > > > > > > +             .ident =3D "Dell XPS 15 L502X",
> > > > > > > +             .matches =3D {
> > > > > > > +                     DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
> > > > > > > +                     DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Dell=
 System XPS L502X"),
> > > > > >
> > > > > > Hello! Are you sure that it is required to completely disable f=
an
> > > > > > support? And not only access to fan type label for which is dif=
ferent
> > > > > > blaclist i8k_blacklist_fan_type_dmi_table?
> > > > >
> > > > > This is a good question. We didn't try the other list. Bob is the=
 one with the
> > > > > affected system. Could you try moving the added block of code fro=
m
> > > > > i8k_blacklist_fan_support_dmi_table a few lines up to
> > > > > i8k_blacklist_fan_type_dmi_table, Bob, to see if the issue reappe=
ars or if it
> > > > > remains fixed?
> > > > >
> > > > > >
> > > > > > And have you reported this issue to Dell support?
> > > > > >
> > > > > > > +             },
> > > > > > > +     },
> > > > > > >       { }
> > > > > > >  };
> > > > > > >
> > > > > > > --
> > > > > > > 2.30.0
> > > > > > >
> > > > >
> > > > > (Apologies for the previous HTML copy of this reply, to those dir=
ectly CCed.)
> > > > >
> > > > > -Tom

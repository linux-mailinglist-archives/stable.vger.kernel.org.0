Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAD5B3068B3
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 01:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbhA1Aga (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 19:36:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231448AbhA1AgL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jan 2021 19:36:11 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4656C061573;
        Wed, 27 Jan 2021 16:35:30 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id h11so3816112ioh.11;
        Wed, 27 Jan 2021 16:35:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+mpOELqBv4eOMPwrZc+PB+YZmZrvjUIDL2Cgb7DpHRg=;
        b=gyrHG5XDi6yWgBpMB//AxGIc393Q+1lziAAQW3g+SlNTQQkeCsrud4kbrKujdfa6jV
         GP5Th/tTK4NNDztnoQjn6ABNdLigmHfGgcztrBF+KRHTCxIXR8+sIMUSTx5yIwZM18iu
         71326ebPGnKAUoX5FxzRh3zHoBOEzIHsM/F+PShm6ovOSnWjwFofnWHU1tdqe6VNOsik
         vecHW7z+DDkBNhEbXhVzUL73MkDOeb4XVrUpitZ1I2xUpFUFMQ/drV5T7nRq3Sgv/LQL
         a89oobP0WyBHlyCaqLy0hymNTeIsaQ873cbndGy4aHWj8kzrhg6ydirC2wNs52lXvQCb
         4Q1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+mpOELqBv4eOMPwrZc+PB+YZmZrvjUIDL2Cgb7DpHRg=;
        b=VExwjXaEe21JrcaatFXrLKRovtSNwoKe2/MQ8xEN8DL+i6gLoLd1o4yjUd3MnIkEXB
         pwf9njgB2e910fNNVkhz6Mi3eDWOjTg5Oe670YhK1PNwtENr9vOtaV7O0C2P+I7ykB0c
         pbCdeAh5h/Ey8/9UXSgGZc9H3iSEfI+rVfyrvPE0c6buqHPM1yOBjJS3KrnJsNTnkOGp
         KCk5bmXREdiJ+7QR7FznFhlGVWgh45i8Od8sxt2PDdy7L+jbbtVsYJfz2D8+ckOyzk7S
         hx4jdzDPOEd+ucIv/Qd8fneI5dd5dmOPkqywzqwsvLDJrGh0mF9JiCndpYW/WKqa2r91
         q63A==
X-Gm-Message-State: AOAM531qmghQHD8iWOoDQTjsESZJ45w1hGlPy8WB13r7zbGuvqDhGlld
        2M3YYcVezG9IdX29NR/EMfU/4ptVmI1Wbjs9aIU=
X-Google-Smtp-Source: ABdhPJwNKkjiCpmy1G/BFY/O/LBXJPEKQgswM9wdAbw51YpMo5MzdDDxe4K16G8u8yFQQ72SQ68uaXZ9902eHp8zZ8k=
X-Received: by 2002:a6b:6e0c:: with SMTP id d12mr9644327ioh.74.1611794129942;
 Wed, 27 Jan 2021 16:35:29 -0800 (PST)
MIME-Version: 1.0
References: <a09eea7616881d40d2db2fb5fa2770dc6166bdae.1611456351.git.tommyhebb@gmail.com>
 <20210125100540.55wbgdsem3htplx3@pali> <CAMcCCgTo87HmwexZS696ok16e9s_8gRgFd38uoLP34r7TbAzBg@mail.gmail.com>
 <CAHzpm2hk4+0FyFrcGYN-JJfx5Ka8yoM8mTsYZA_4WHfWYGa4yQ@mail.gmail.com>
 <CAHzpm2h2X8ZKEtRxnD-mwyEv=B8J+tH_spFGD2VzfwGdRAaHMw@mail.gmail.com>
 <CAMcCCgQRDRi1LpxJBTvKcB+dALJJsn=n5Q=Wyvfcw9LGqqjq7Q@mail.gmail.com>
 <20210127091933.haq6nmbmx3cskh5t@pali> <CAHzpm2j9N3ywMy6HLruCt1VaQLmB1-xVusvXUb8wa2ores+KAQ@mail.gmail.com>
 <20210127225802.wcnr6mw7dp7nnk2e@pali>
In-Reply-To: <20210127225802.wcnr6mw7dp7nnk2e@pali>
From:   Tom Hebb <tommyhebb@gmail.com>
Date:   Wed, 27 Jan 2021 16:35:18 -0800
Message-ID: <CAMcCCgROxKaT6B+maU+mmZQbJ+1y6nB_gV0MAt97Mm7HpA6jdg@mail.gmail.com>
Subject: Re: [PATCH] hwmon: (dell-smm) Add XPS 15 L502X to fan control blacklist
To:     =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc:     Bob Hepple <bob.hepple@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jean Delvare <jdelvare@suse.com>, linux-hwmon@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 27, 2021 at 2:58 PM Pali Roh=C3=A1r <pali@kernel.org> wrote:
>
> Hello Bob!
>
> On Thursday 28 January 2021 08:40:36 Bob Hepple wrote:
> > Hi Pali,
> >
> > No, I have not contacted Dell about this and I'm not sure that they
> > would be terribly interested given that my machine is 12 years old -
> > but I'll have a go if I can find the right place to do it.
>
> If it is 12 years old machine then I doubt that anybody would do any
> support for it...
>
> > Do you have a good email or other Dell target to report it?
>
> In this post is information how to contact Dell Linux support team which
> can open (internal) BIOS issue:
>
> https://github.com/dell/libsmbios/issues/48#issuecomment-391328501
>
> But it is possible that still only available for USA.
>
> Mario (superm1 on github) is active also in kernel and can help with
> firmware issues on new machines.
>
> But for this your 12 years old machine is proposed blacklist quirk the
> only option.
>
> I just do not know if this issue was already fixed in new BIOS which is
> available on new machines. And therefore I'm worried if these issues
> would continue to appear also on other machines, or we are just
> collecting list of old machines.

My XPS 13 9350 from 2015 does not exhibit this issue, FWIW. I think we
would be seeing a lot more reports like this if new BIOSes were also
affected.


> Just I do not want to see situation when manufacture says "it is
> working, nothing needed to fix" and it would work just because of
> blacklist... As such scenario would lead only to increasing blacklist
> without ability to start fixing issues.
>
> > I don't
> > have access to official Dell support as my warranty ran out about 10
> > years ago. Perhaps there's an existing Dell bug report that references
> > the original https://bugzilla.kernel.org/show_bug.cgi?id=3D195751 ??? I
> > could add my report there if someone has already informed Dell about
> > the other instances of the bug.
> >
> > Thanks
> >
> >
> >
> > Bob
> >
> > On Wed, 27 Jan 2021 at 19:19, Pali Roh=C3=A1r <pali@kernel.org> wrote:
> > >
> > > On Tuesday 26 January 2021 00:15:13 Tom Hebb wrote:
> > > > Bob reports that blacklisting the fan type label is not sufficient.
> > > > See his message to me below.
> > >
> > > Ok! Thank you for confirmation.
> > >
> > > And my second question which I have asked:
> > > And have you reported this issue to Dell support?
> > >
> > > > On Mon, Jan 25, 2021 at 3:38 PM Bob Hepple <bob.hepple@gmail.com> w=
rote:
> > > > >
> > > > > Hi Tom,
> > > > >
> > > > > Big nope this end with L502x in i8k_blacklist_fan_type_dmi_table:
> > > > >
> > > > > Jan 26 09:35:47 achar kernel: psmouse serio1: TouchPad at
> > > > > isa0060/serio1/input0 lost synchronization, throwing 1 bytes>
> > > > >
> > > > > ... and lots of trackpad stall/stutters.
> > > > >
> > > > > Cheers
> > > > >
> > > > >
> > > > > Bob
> > > > >
> > > > >
> > > > >
> > > > > On Tue, 26 Jan 2021 at 08:09, Bob Hepple <bob.hepple@gmail.com> w=
rote:
> > > > > >
> > > > > > ... compiling now ... results in a coupla hours
> > > > > >
> > > > > > Cheers
> > > > > >
> > > > > >
> > > > > > Bob
> > > > > >
> > > > > > On Tue, 26 Jan 2021 at 04:05, Tom Hebb <tommyhebb@gmail.com> wr=
ote:
> > > > > > >
> > > > > > > On Mon, Jan 25, 2021 at 2:05 AM Pali Roh=C3=A1r <pali@kernel.=
org> wrote:
> > > > > > > >
> > > > > > > > On Saturday 23 January 2021 18:46:08 Thomas Hebb wrote:
> > > > > > > > > It has been reported[0] that the Dell XPS 15 L502X exhibi=
ts similar
> > > > > > > > > freezing behavior to the other systems[1] on this blackli=
st. The issue
> > > > > > > > > was exposed by a prior change of mine to automatically lo=
ad
> > > > > > > > > dell_smm_hwmon on a wider set of XPS models. To fix the r=
egression, add
> > > > > > > > > this model to the blacklist.
> > > > > > > > >
> > > > > > > > > [0] https://bugzilla.kernel.org/show_bug.cgi?id=3D211081
> > > > > > > > > [1] https://bugzilla.kernel.org/show_bug.cgi?id=3D195751
> > > > > > > > >
> > > > > > > > > Fixes: b8a13e5e8f37 ("hwmon: (dell-smm) Use one DMI match=
 for all XPS models")
> > > > > > > > > Cc: stable@vger.kernel.org
> > > > > > > > > Reported-by: Bob Hepple <bob.hepple@gmail.com>
> > > > > > > > > Tested-by: Bob Hepple <bob.hepple@gmail.com>
> > > > > > > > > Signed-off-by: Thomas Hebb <tommyhebb@gmail.com>
> > > > > > > > > ---
> > > > > > > > >
> > > > > > > > >  drivers/hwmon/dell-smm-hwmon.c | 7 +++++++
> > > > > > > > >  1 file changed, 7 insertions(+)
> > > > > > > > >
> > > > > > > > > diff --git a/drivers/hwmon/dell-smm-hwmon.c b/drivers/hwm=
on/dell-smm-hwmon.c
> > > > > > > > > index ec448f5f2dc3..73b9db9e3aab 100644
> > > > > > > > > --- a/drivers/hwmon/dell-smm-hwmon.c
> > > > > > > > > +++ b/drivers/hwmon/dell-smm-hwmon.c
> > > > > > > > > @@ -1159,6 +1159,13 @@ static struct dmi_system_id i8k_bl=
acklist_fan_support_dmi_table[] __initdata =3D {
> > > > > > > > >                       DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "=
XPS13 9333"),
> > > > > > > > >               },
> > > > > > > > >       },
> > > > > > > > > +     {
> > > > > > > > > +             .ident =3D "Dell XPS 15 L502X",
> > > > > > > > > +             .matches =3D {
> > > > > > > > > +                     DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc=
."),
> > > > > > > > > +                     DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "=
Dell System XPS L502X"),
> > > > > > > >
> > > > > > > > Hello! Are you sure that it is required to completely disab=
le fan
> > > > > > > > support? And not only access to fan type label for which is=
 different
> > > > > > > > blaclist i8k_blacklist_fan_type_dmi_table?
> > > > > > >
> > > > > > > This is a good question. We didn't try the other list. Bob is=
 the one with the
> > > > > > > affected system. Could you try moving the added block of code=
 from
> > > > > > > i8k_blacklist_fan_support_dmi_table a few lines up to
> > > > > > > i8k_blacklist_fan_type_dmi_table, Bob, to see if the issue re=
appears or if it
> > > > > > > remains fixed?
> > > > > > >
> > > > > > > >
> > > > > > > > And have you reported this issue to Dell support?
> > > > > > > >
> > > > > > > > > +             },
> > > > > > > > > +     },
> > > > > > > > >       { }
> > > > > > > > >  };
> > > > > > > > >
> > > > > > > > > --
> > > > > > > > > 2.30.0
> > > > > > > > >
> > > > > > >
> > > > > > > (Apologies for the previous HTML copy of this reply, to those=
 directly CCed.)
> > > > > > >
> > > > > > > -Tom

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41B542E8426
	for <lists+stable@lfdr.de>; Fri,  1 Jan 2021 17:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbhAAQKV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jan 2021 11:10:21 -0500
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:49601 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726798AbhAAQKU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jan 2021 11:10:20 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 60C0D5802BF;
        Fri,  1 Jan 2021 11:09:14 -0500 (EST)
Received: from imap1 ([10.202.2.51])
  by compute6.internal (MEProxy); Fri, 01 Jan 2021 11:09:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
        mime-version:message-id:in-reply-to:references:date:from:to:cc
        :subject:content-type:content-transfer-encoding; s=fm1; bh=/B+zc
        badMivrkhaw15JYpZp/FYr1FoYPsHqR9ju2nis=; b=2Xcz7jCUAXDwMcgtEUyYM
        TZ7EqoXW8GfLB1rDfE1UbbYnZdG91dBWVM9ig2uY1JWwF9Gsz7wha4htjR5d235p
        jkgtha55o3jJ5M2FpVZ0grdLI52f7AAQ5cUNkLCLK2WE0iR/soBfJqmUD0iGxzWs
        RCiOa3TFXOncaCYVKpvJcYJHjJ0zb9vYAblBDYsuB5vwr1NwZT56OC+p4UhCSXFR
        EQWCcacGTkfH/O5NUkEhvTDgY/P6NvQ1p+t7Iii5RpwYbjgzf6MWPWL+TbNFmG99
        9kkQDu5GpLAjT3wPZ+p0Ulg/Hsj3qn/Z4Ked0yeOlZtRr+Bdg7uP+ebWUQ6BD7Ye
        w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=/B+zcbadMivrkhaw15JYpZp/FYr1FoYPsHqR9ju2n
        is=; b=G3en5zMfhyT+Yl5H1u5+PE8iEZtoYmcgVWx0zzsVKyUxOoIXxp0cKV5lS
        5BJ4jJH21ChwPSEw4yO9Q6xNg4tkiWCkY2EpA4y+JlsONwF9JLuy3kAIp38FUNxO
        N1CiN24JIDQbxQXclluhw/ZG84hDNV0GEIjh4frY3a4g6bYh21U2BvnliIsLJ1an
        6BSZ6ygE7s4nKtnkBpdYuvz36lwMZqGTneX0t81gmhAM2ccPCg+IOIxRdM0j4XiQ
        oOoFQMWuhSRoZ0Jo9qPgOhKxWgVJTLyNFJEmoBOhuFQSJjoLVR4iX5jUuEm92+wc
        Pn7jg1YuUw9sZfyE9xIdeIJa0+/ww==
X-ME-Sender: <xms:KEnvXwt-ejDnh-MD_JBQ-er5ugjunYiONt-6dTlDULwc1rokuPdtXg>
    <xme:KEnvX9eof7XLQph4Yt6JBsUITTTbIEFG5tzwPYDOX6PkSp1x8bMbsk_WVq0RUVbur
    QofEaIOB6e4qb9oigM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddvjedgkeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvffutgfgsehtqhertderreejnecuhfhrohhmpedflfhi
    rgiguhhnucgjrghnghdfuceojhhirgiguhhnrdihrghnghesfhhlhihgohgrthdrtghomh
    eqnecuggftrfgrthhtvghrnhepfeetgeekveeftefhgfduheegvdeuuddvieefvddvlefh
    feehkeetfeeukedtfeejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepjhhirgiguhhnrdihrghnghesfhhlhihgohgrthdrtghomh
X-ME-Proxy: <xmx:KEnvX7xloAgn9bw7QGbz-OlNriM5Z5CaBy4dDPoQpo8j3c_8KFL9tg>
    <xmx:KEnvXzOl5d1quGDY6DuILtP9DDcYFsSOlbrMI1EkAkygWDl3c7SaZA>
    <xmx:KEnvXw_teo7rwYRDLrUP-qE_4CYRt9c06Xu3ilkCnH808zDlhpv-Ug>
    <xmx:KUnvX_aMCmQkPgs-w-lYhx4poFZCEJgHUSyb-ooktPRTpWJH3bELeQ>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 3450BC200A5; Fri,  1 Jan 2021 11:09:13 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.3.1-61-gb52c239-fm-20201210.001-gb52c2396
Mime-Version: 1.0
Message-Id: <bcb3bc76-da83-4ee1-8c2d-0453d359ae37@www.fastmail.com>
In-Reply-To: <_kQDaYPt7vh_mQfPr1tLJV2IP-p40OBPcU5zk-1xHhF9XJsm8Y-efANBgiRdWU-J2QTtOjmrfE0Tw6UrZpm6uG-zZGlfpaVOp9FuoKAbjzA=@protonmail.com>
References: <20210101061140.27547-1-jiaxun.yang@flygoat.com>
 <_kQDaYPt7vh_mQfPr1tLJV2IP-p40OBPcU5zk-1xHhF9XJsm8Y-efANBgiRdWU-J2QTtOjmrfE0Tw6UrZpm6uG-zZGlfpaVOp9FuoKAbjzA=@protonmail.com>
Date:   Sat, 02 Jan 2021 00:08:50 +0800
From:   "Jiaxun Yang" <jiaxun.yang@flygoat.com>
To:     =?UTF-8?Q?Barnab=C3=A1s_P=C5=91cze?= <pobrn@protonmail.com>
Cc:     "platform-driver-x86@vger.kernel.org" 
        <platform-driver-x86@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Ike Panhc" <ike.pan@canonical.com>,
        "Hans de Goede" <hdegoede@redhat.com>,
        "Mark Gross" <mgross@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] platform/x86: ideapad-laptop: Add has_touchpad_switch
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On Fri, Jan 1, 2021, at 10:20 PM, Barnab=C3=A1s P=C5=91cze wrote:
> Hi
>=20
>=20
> 2021. janu=C3=A1r 1., p=C3=A9ntek 7:11 keltez=C3=A9ssel, Jiaxun Yang =C3=
=ADrta:
>=20
> > Newer ideapads (e.g.: Yoga 14s, 720S 14) comes with I2C HID
> > Touchpad and do not use EC to switch touchpad. Reading VPCCMD_R_TOUC=
HPAD
> > will return zero thus touchpad may be blocked. Writing VPCCMD_W_TOUC=
HPAD
> > may cause a spurious key press.
> >
> > Add has_touchpad_switch to workaround these machines.
> >
> > Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> > Cc: stable@vger.kernel.org # 5.4+
>=20
> Interestingly, the Lenovo Yoga 540-14IKB 80X8 has an HID-over-I2C touc=
hpad,
> and yet it can be controlled by reading/writing the appropriate EC reg=
isters.
>=20
>=20
> > ---
> >  drivers/platform/x86/ideapad-laptop.c | 18 +++++++++++++++++-
> >  1 file changed, 17 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platfor=
m/x86/ideapad-laptop.c
> > index 7598cd46cf60..b6a4db37d0fc 100644
> > --- a/drivers/platform/x86/ideapad-laptop.c
> > +++ b/drivers/platform/x86/ideapad-laptop.c
> > @@ -92,6 +92,7 @@ struct ideapad_private {
> >  	struct dentry *debug;
> >  	unsigned long cfg;
> >  	bool has_hw_rfkill_switch;
> > +	bool has_touchpad_switch;
> >  	const char *fnesc_guid;
> >  };
> >
> > @@ -535,7 +536,9 @@ static umode_t ideapad_is_visible(struct kobject=
 *kobj,
> >  	} else if (attr =3D=3D &dev_attr_fn_lock.attr) {
> >  		supported =3D acpi_has_method(priv->adev->handle, "HALS") &&
> >  			acpi_has_method(priv->adev->handle, "SALS");
> > -	} else
> > +	} else if (attr =3D=3D &dev_attr_touchpad.attr)
> > +		supported =3D priv->has_touchpad_switch;
> > +	else
> >  		supported =3D true;
> >
> >  	return supported ? attr->mode : 0;
> > @@ -867,6 +870,9 @@ static void ideapad_sync_touchpad_state(struct i=
deapad_private *priv)
> >  {
> >  	unsigned long value;
> >
> > +	if (!priv->has_touchpad_switch)
> > +		return;
> > +
> >  	/* Without reading from EC touchpad LED doesn't switch state */
> >  	if (!read_ec_data(priv->adev->handle, VPCCMD_R_TOUCHPAD, &value)) =
{
> >  		/* Some IdeaPads don't really turn off touchpad - they only
> > @@ -989,6 +995,12 @@ static int ideapad_acpi_add(struct platform_dev=
ice *pdev)
> >  	priv->platform_device =3D pdev;
> >  	priv->has_hw_rfkill_switch =3D dmi_check_system(hw_rfkill_list);
> >
> > +	/* Most ideapads with I2C HID don't use EC touchpad switch */
> > +	if (acpi_dev_present("PNP0C50", NULL, -1))
> > +		priv->has_touchpad_switch =3D false;
> > +	else
> > +		priv->has_touchpad_switch =3D true;
> > +
>=20
> `priv->has_touchpad_switch =3D !acpi_dev_present(...)`
> ?

Will fix.

>=20
>=20
> >  	ret =3D ideapad_sysfs_init(priv);
> >  	if (ret)
> >  		return ret;
> > @@ -1006,6 +1018,10 @@ static int ideapad_acpi_add(struct platform_d=
evice *pdev)
> >  	if (!priv->has_hw_rfkill_switch)
> >  		write_ec_cmd(priv->adev->handle, VPCCMD_W_RF, 1);
> >
> > +	/* The same for Touchpad */
> > +	if (!priv->has_touchpad_switch)
> > +		write_ec_cmd(priv->adev->handle, VPCCMD_W_TOUCHPAD, 1);
> > +
>=20
> Shouldn't it be the other way around: `if (priv->has_touchpad_switch)`=
?

It is to prevent accidentally disable touchpad on machines that do have =
EC switch,
so it's intentional.

Thanks.

- Jiaxun

>=20
>=20
>=20
> >  	for (i =3D 0; i < IDEAPAD_RFKILL_DEV_NUM; i++)
> >  		if (test_bit(ideapad_rfk_data[i].cfgbit, &priv->cfg))
> >  			ideapad_register_rfkill(priv, i);
> > --
> > 2.30.0
>=20
>=20
> Regards,
> Barnab=C3=A1s P=C5=91cze
>

--=20
- Jiaxun

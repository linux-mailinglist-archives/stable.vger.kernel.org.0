Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 758D560F715
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 14:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233099AbiJ0MWl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 08:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233961AbiJ0MWk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 08:22:40 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 506E713331B;
        Thu, 27 Oct 2022 05:22:38 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id r14so2491905lfm.2;
        Thu, 27 Oct 2022 05:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BUAJ0Yam9jB8cnIc3GMtzCrzsgz9qeznvvkKrNOb2Xc=;
        b=Iew6zV4bUfWoOG82RXzL4Q7bT5nNSzi7RXlJEueKTqk3CXDXdmN6Nbuzt/KRecnGDP
         eKrro8H+7BCLObPdprd54Pz8xEhd1eMorc6TuhDxpP7Ajri5dm6li6Zj/Gp3HfoRlgbK
         giaMIejtfzloOicaqe7KCLIqDB9k/yUk7biAovkh/v7eadyO+5GRLZwXJyVnkKb8r5Wq
         QfjSRmNIwQnCPNf8tQdBz9pIsUE+JJH26slpsKIqgXKq/xdBdPwrRsz/DvC+QctYJ2Ud
         7pxYPXdedNNIjE608PQYffTRShEoTUgGBRbitJI9d3W57Ceobd8hWQ7Q34fB9CwYu+iX
         N/CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:in-reply-to:message-id:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BUAJ0Yam9jB8cnIc3GMtzCrzsgz9qeznvvkKrNOb2Xc=;
        b=XB+Q/Vq89VH0p2IZFedrRnkxIdOVjq6aBfSQ2+DP/ZIkwFpWiufAY/4qpWDr0LGP45
         3ls5oVGOiBKxw1/PfNnGGe6FO7pa/8IbSghNAEWAlSuLLwr5GeOODv1+ydbygk5MegaN
         FEdmYbvcekwUVqO+QXe8D5tHJUgwx4ppteZySFrfs0bCUlUSBbRF6wIbTYGJZTWcGZEn
         c3AJwB4kT4sbG1cfsYVQCAAkDONAHuvsa1yGNql3XmjAfCHKWq17wxFMMWbVaQG2W7Ez
         8Ri//KxjU25owT2uJyjBkWI704b+ZXv4+/T+pMDuikJtf5NAX/YPp7sFSNmxhGEQcr9E
         6GhQ==
X-Gm-Message-State: ACrzQf0FViFoYY14bZIyyiGpvg4DDc6wdEZJi7le4M9OPyF5T5805ezG
        J8XOQGTyK4oYiATblADMdTI=
X-Google-Smtp-Source: AMsMyM6v95gActdOgMoaBJ6tPrmCSQZVBmd+VuWknz2siOdZJ3Br9C0Ey9SbfKc0Dy/10CiDW2QFWg==
X-Received: by 2002:ac2:5ca7:0:b0:4af:b896:8841 with SMTP id e7-20020ac25ca7000000b004afb8968841mr2479342lfq.349.1666873356402;
        Thu, 27 Oct 2022 05:22:36 -0700 (PDT)
Received: from eldfell ([194.136.85.206])
        by smtp.gmail.com with ESMTPSA id j23-20020a2e3c17000000b0026fb4458c5fsm210448lja.44.2022.10.27.05.22.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 05:22:36 -0700 (PDT)
Date:   Thu, 27 Oct 2022 15:22:22 +0300
From:   Pekka Paalanen <ppaalanen@gmail.com>
To:     Thomas Zimmermann <tzimmermann@suse.de>
Cc:     Hector Martin <marcan@marcan.st>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Javier Martinez Canillas <javierm@redhat.com>,
        dri-devel@lists.freedesktop.org, asahi@lists.linux.dev,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] drm/simpledrm: Only advertise formats that are
 supported
Message-ID: <20221027152222.60e84e79@eldfell>
In-Reply-To: <fa4efcfd-91b6-dc76-2e5c-eed538bccff3@suse.de>
References: <20221027101327.16678-1-marcan@marcan.st>
        <fa4efcfd-91b6-dc76-2e5c-eed538bccff3@suse.de>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/fHYiBmgng1laXpPX_HJNlOb";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--Sig_/fHYiBmgng1laXpPX_HJNlOb
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 27 Oct 2022 13:08:24 +0200
Thomas Zimmermann <tzimmermann@suse.de> wrote:

> Hi
>=20
> Am 27.10.22 um 12:13 schrieb Hector Martin:
> > Until now, simpledrm unconditionally advertised all formats that can be
> > supported natively as conversions. However, we don't actually have a
> > full conversion matrix of helpers. Although the list is arguably
> > provided to userspace in precedence order, userspace can pick something
> > out-of-order (and thus break when it shouldn't), or simply only support
> > a format that is unsupported (and thus think it can work, which results
> > in the appearance of a hang as FB blits fail later on, instead of the
> > initialization error you'd expect in this case).
> >=20
> > Split up the format table into separate ones for each required subset,
> > and then pick one based on the native format. Also remove the
> > native<->conversion overlap check from the helper (which doesn't make
> > sense any more, since the native format is advertised anyway and this
> > way RGB565/RGB888 can share a format table), and instead print the same
> > message in simpledrm when the native format is not one for which we have
> > conversions at all.
> >=20
> > This fixes a real user regression where the ?RGB2101010 support commit
> > started advertising it unconditionally where not supported, and KWin
> > decided to start to use it over the native format, but also the fixes
> > the spurious RGB565/RGB888 formats which have been wrongly
> > unconditionally advertised since the dawn of simpledrm.
> >=20
> > Note: this patch is merged because splitting it into two patches, one
> > for the helper and one for simpledrm, would regress at the midpoint
> > regardless of the order. If simpledrm is changed first, that would break
> > working conversions to RGB565/RGB888 (since those share a table that
> > does not include the native formats). If the helper is changed first, it
> > would start spuriously advertising all conversion formats when the
> > native format doesn't have any supported conversions at all.
> >=20
> > Acked-by: Pekka Paalanen <pekka.paalanen@collabora.com>
> > Fixes: 6ea966fca084 ("drm/simpledrm: Add [AX]RGB2101010 formats")
> > Fixes: 11e8f5fd223b ("drm: Add simpledrm driver")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Hector Martin <marcan@marcan.st>
> > ---
> >   drivers/gpu/drm/drm_format_helper.c | 15 -------
> >   drivers/gpu/drm/tiny/simpledrm.c    | 62 +++++++++++++++++++++++++---=
- =20
>=20
> We currently have two DRM drivers that call drm_fb_build_fourcc_list():=20
> simpledrm and ofdrm. I've been very careful to keep the format selection=
=20
> in sync between them. (That's the reason why the helper exists at all.)=20
> If the drivers start to use different logic, it will only become more=20
> chaotic.
>=20
> The format array of ofdrm is at [1]. At a minimum, ofdrm should get the=20
> same fix as simpledrm.
>=20
> [1]=20
> https://cgit.freedesktop.org/drm/drm-tip/tree/drivers/gpu/drm/tiny/ofdrm.=
c#n760

Hi Thomas,

yes, the principle applies to all drivers except VKMS: do not emulate
anything in software unless it must be done to prevent kernel
regressions on specific hardware.

ofdrm should indeed do the same.

> >   2 files changed, 55 insertions(+), 22 deletions(-)
> >=20
> > diff --git a/drivers/gpu/drm/drm_format_helper.c b/drivers/gpu/drm/drm_=
format_helper.c
> > index e2f76621453c..c60c13f3a872 100644
> > --- a/drivers/gpu/drm/drm_format_helper.c
> > +++ b/drivers/gpu/drm/drm_format_helper.c
> > @@ -864,20 +864,6 @@ size_t drm_fb_build_fourcc_list(struct drm_device =
*dev,
> >   		++fourccs;
> >   	}
> >  =20
> > -	/*
> > -	 * The plane's atomic_update helper converts the framebuffer's color =
format
> > -	 * to a native format when copying to device memory.
> > -	 *
> > -	 * If there is not a single format supported by both, device and
> > -	 * driver, the native formats are likely not supported by the convers=
ion
> > -	 * helpers. Therefore *only* support the native formats and add a
> > -	 * conversion helper ASAP.
> > -	 */
> > -	if (!found_native) {
> > -		drm_warn(dev, "Format conversion helpers required to add extra forma=
ts.\n");
> > -		goto out;
> > -	}
> > -
> >   	/*
> >   	 * The extra formats, emulated by the driver, go second.
> >   	 */
> > @@ -898,7 +884,6 @@ size_t drm_fb_build_fourcc_list(struct drm_device *=
dev,
> >   		++fourccs;
> >   	}
> >  =20
> > -out:
> >   	return fourccs - fourccs_out;
> >   }
> >   EXPORT_SYMBOL(drm_fb_build_fourcc_list);
> > diff --git a/drivers/gpu/drm/tiny/simpledrm.c b/drivers/gpu/drm/tiny/si=
mpledrm.c
> > index 18489779fb8a..1257411f3d44 100644
> > --- a/drivers/gpu/drm/tiny/simpledrm.c
> > +++ b/drivers/gpu/drm/tiny/simpledrm.c
> > @@ -446,22 +446,48 @@ static int simpledrm_device_init_regulators(struc=
t simpledrm_device *sdev)
> >    */
> >  =20
> >   /*
> > - * Support all formats of simplefb and maybe more; in order
> > - * of preference. The display's update function will do any
> > + * Support the subset of formats that we have conversion helpers for,
> > + * in order of preference. The display's update function will do any
> >    * conversion necessary.
> >    *
> >    * TODO: Add blit helpers for remaining formats and uncomment
> >    *       constants.
> >    */
> > -static const uint32_t simpledrm_primary_plane_formats[] =3D {
> > +
> > +/*
> > + * Supported conversions to RGB565 and RGB888:
> > + *   from [AX]RGB8888
> > + */
> > +static const uint32_t simpledrm_primary_plane_formats_base[] =3D {
> > +	DRM_FORMAT_XRGB8888,
> > +	DRM_FORMAT_ARGB8888,
> > +};
> > +
> > +/*
> > + * Supported conversions to [AX]RGB8888:
> > + *   A/X variants (no-op)
> > + *   from RGB565
> > + *   from RGB888
> > + */
> > +static const uint32_t simpledrm_primary_plane_formats_xrgb8888[] =3D {
> >   	DRM_FORMAT_XRGB8888,
> >   	DRM_FORMAT_ARGB8888,
> > +	DRM_FORMAT_RGB888,
> >   	DRM_FORMAT_RGB565,
> >   	//DRM_FORMAT_XRGB1555,
> >   	//DRM_FORMAT_ARGB1555,
> > -	DRM_FORMAT_RGB888,
> > +};
> > +
> > +/*
> > + * Supported conversions to [AX]RGB2101010:
> > + *   A/X variants (no-op)
> > + *   from [AX]RGB8888
> > + */
> > +static const uint32_t simpledrm_primary_plane_formats_xrgb2101010[] =
=3D {
> >   	DRM_FORMAT_XRGB2101010,
> >   	DRM_FORMAT_ARGB2101010,
> > +	DRM_FORMAT_XRGB8888,
> > +	DRM_FORMAT_ARGB8888,
> >   };
> >  =20
> >   static const uint64_t simpledrm_primary_plane_format_modifiers[] =3D {
> > @@ -642,7 +668,8 @@ static struct simpledrm_device *simpledrm_device_cr=
eate(struct drm_driver *drv,
> >   	struct drm_encoder *encoder;
> >   	struct drm_connector *connector;
> >   	unsigned long max_width, max_height;
> > -	size_t nformats;
> > +	const uint32_t *conv_formats;
> > +	size_t conv_nformats, nformats;
> >   	int ret;
> >  =20
> >   	sdev =3D devm_drm_dev_alloc(&pdev->dev, drv, struct simpledrm_device=
, dev);
> > @@ -755,10 +782,31 @@ static struct simpledrm_device *simpledrm_device_=
create(struct drm_driver *drv,
> >   	dev->mode_config.funcs =3D &simpledrm_mode_config_funcs;
> >  =20
> >   	/* Primary plane */
> > +	switch (format->format) { =20
>=20
> I trust you when you say that <native>->XRGB8888 is not enough. But=20
> although I've read your replies, I still don't understand why this=20
> switch is necessary.
>=20
> Why don't we call drm_fb_build_fourcc_list() with the native=20
> format/formats and let it append a number of formats, such as adding=20
> XRGB888, adding ARGB8888 if necessary, adding ARGB2101010 if necessary.=20
> Each with a elaborate comment why and which userspace needs the format. (=
?)

Something like

uint32_t conv_formats[] =3D {
	DRM_FORMAT_XRGB8888, /* expected by old userspace */
	DRM_FORMAT_ARGB8888, /* historically exposed and working */
	0,
	0,
	0,
};
size_t conv_nformats =3D 2;

if (native_format =3D=3D DRM_FORMAT_XRGB2101010)
	conv_formats[conv_nformats++] =3D DRM_FORMAT_ARGB2101010; /* historically =
exposed and working */

if (native_format =3D=3D DRM_FORMAT_XRGB8888) {
	conv_formats[conv_nformats++] =3D DRM_FORMAT_RGB565; /* historically expos=
ed and working */
	conv_formats[conv_nformats++] =3D DRM_FORMAT_RGB888; /* historically expos=
ed and working */
}

maybe?



Thanks,
pq


>=20
> Best regards
> Thomas
>=20
> > +	case DRM_FORMAT_RGB565:
> > +	case DRM_FORMAT_RGB888:
> > +		conv_formats =3D simpledrm_primary_plane_formats_base;
> > +		conv_nformats =3D ARRAY_SIZE(simpledrm_primary_plane_formats_base);
> > +		break;
> > +	case DRM_FORMAT_XRGB8888:
> > +	case DRM_FORMAT_ARGB8888:
> > +		conv_formats =3D simpledrm_primary_plane_formats_xrgb8888;
> > +		conv_nformats =3D ARRAY_SIZE(simpledrm_primary_plane_formats_xrgb888=
8);
> > +		break;
> > +	case DRM_FORMAT_XRGB2101010:
> > +	case DRM_FORMAT_ARGB2101010:
> > +		conv_formats =3D simpledrm_primary_plane_formats_xrgb2101010;
> > +		conv_nformats =3D ARRAY_SIZE(simpledrm_primary_plane_formats_xrgb210=
1010);
> > +		break;
> > +	default:
> > +		conv_formats =3D NULL;
> > +		conv_nformats =3D 0;
> > +		drm_warn(dev, "Format conversion helpers required to add extra forma=
ts.\n");
> > +		break;
> > +	}
> >  =20
> >   	nformats =3D drm_fb_build_fourcc_list(dev, &format->format, 1,
> > -					    simpledrm_primary_plane_formats,
> > -					    ARRAY_SIZE(simpledrm_primary_plane_formats),
> > +					    conv_formats, conv_nformats,
> >   					    sdev->formats, ARRAY_SIZE(sdev->formats));
> >  =20
> >   	primary_plane =3D &sdev->primary_plane; =20
>=20


--Sig_/fHYiBmgng1laXpPX_HJNlOb
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEJQjwWQChkWOYOIONI1/ltBGqqqcFAmNad/4ACgkQI1/ltBGq
qqca0g/9EZyE+t5iKJlNHZ6Y1NNpMUiw49okIWFGtCG6k/uw/ckIZRvr6xBAHlRP
6RFviElFG06LIqcvWYUjlgvgfJ9ZumkUEkMcfJ0nEf4Kr4pAh7bpka8rIn0z7J7p
ivGTWih+445MuR6e4ngycCFhF5X6VDyUQM3gzVZWwKS2LNBRNAHa+bNhJ0AyE30t
o1SNuB6u1PRKfAQuQt7cfpYWOLJr4Q4r70fJRAFRrxpXD068DINAt4KXoQOF5wDB
jfN5f9J33Fi9bdcgjYfJs6q0fP0a5CNn1VPIFO/5GrhJKGXNv/i+DKduelPljtc0
ti0C2nHKWYlGPlMNlH9YOjbmWK1zyqBXVGZ3hYD1J3jVpKp3Bz1mwOHE62Ir8RIc
6m8ZXz9AwuvqQ60Rfr/DgBpTmmBMOZjalnNvxgBVW7Qeqfq3OIP6KpfaGvnHvyUi
9Z/gtZXeA1OwzczhtSkqvU4BnPGknzzZCu4Uox76L8CoAlM/zGD7Es7JFSLABr+O
XuYb+fOypXrE+F1/6us0qrAmRbK/ckh2T7vhp3POCcby8bzGqiY6jSjw3q4laGDe
OcSfgN54jbbfhAXGEkOB9ys4hZvr/UWGd4MQzPo4+xsFynirk5jrLZUM7c6bxrwr
XffUbVJBvJ2XW6foOIBAOgQ08GPTryz1kTxakV56DU2m0MICG7w=
=MTtI
-----END PGP SIGNATURE-----

--Sig_/fHYiBmgng1laXpPX_HJNlOb--

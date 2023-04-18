Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 783366E5E5E
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 12:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbjDRKNL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 06:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbjDRKNK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 06:13:10 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4F849006
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 03:12:46 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-54ee0b73e08so453361417b3.0
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 03:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681812765; x=1684404765;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xC5HB+JoQGOIOmvA/qusKibRWMlQntrXoL6/Tv+XLo8=;
        b=LwIiAS+sbus0YfZsq1wK26u+6YvvJTXbGyOSOfN5zPJAPIH20GDOVMk+SKwTUIGFVP
         ulbtJ/upRLYSBffzsHN8ZeUr88MiE7tqzVsYDXdMaiF46NduMQSUybBGuLvPWFHuNfit
         reBp1ZCFhsWFMjGPDBhospSBJf1seNfH6SUjOjL3eBshDwhLS6IZOsLRxoZSkxpzj4R5
         1ecAVrHE79EAeD4VegIvsAri5aYvRdIea7xh1JasmiH+sMTiPnoCr2okq1QV/9yTyjLP
         vm3r+Qoelio034KvfioMlccmrwFTqv3tSi+CkBSB8Uv7SiAbM7Ix5dAH9m1Lz2D0HSP7
         RRXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681812765; x=1684404765;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xC5HB+JoQGOIOmvA/qusKibRWMlQntrXoL6/Tv+XLo8=;
        b=XbHkAI0v3U4ax4dX0l7BGD4oQqmb+JXeMV3bwsZmWQlK4FRYCcp1+kIWVjTFpm5/JO
         ZuyIstSh/vZiojKx2fkw5HKu9RRBlUuMWmESZOI4rlEd1yR7k79bp02+4udmU7gQd40C
         clghe+6maZoWXkmdcduMglSIK2e4Zltl01I+ct3LUCHGI2L6kgbtts5dAUGPcJd5hxoI
         Xfwys/dM1tyOff+QBHQySvLCEUatxS26xUVmjt10HP+p2RDlA5ygHPFJfNiEuJi95f1F
         cYbZMF6OGFUM8UbpxuvYUI9iyyruLsDJFXZeNphhPe1MSVsGYD+uDxySWJRvNRiQSRv3
         sTNQ==
X-Gm-Message-State: AAQBX9fpfEXrnNI3i/l0xubcoxSywaQbA79iaAIdBOrafBhR7pVSAr8Z
        ZLObFXDM6MbiiWrgNc4g3aHEBw==
X-Google-Smtp-Source: AKy350ZqW9zyMrBAeUs8Uv0xL5UJaBmFtbubbnptID+PuJSnkIkt8wxq2EHb4R5D6Xt6TE7mlYZGaQ==
X-Received: by 2002:a81:4f09:0:b0:541:66e8:d4da with SMTP id d9-20020a814f09000000b0054166e8d4damr16303547ywb.29.1681812765594;
        Tue, 18 Apr 2023 03:12:45 -0700 (PDT)
Received: from fedora (69-109-179-158.lightspeed.dybhfl.sbcglobal.net. [69.109.179.158])
        by smtp.gmail.com with ESMTPSA id 62-20020a811741000000b0054605c23114sm3671343ywx.66.2023.04.18.03.12.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 03:12:44 -0700 (PDT)
Date:   Tue, 18 Apr 2023 06:12:43 -0400
From:   William Breathitt Gray <william.gray@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Cameron <jic23@kernel.org>, stable@vger.kernel.org
Subject: Re: [RESEND PATCH 5.15 v3 5/5] counter: 104-quad-8: Fix race
 condition between FLAG and CNTR reads
Message-ID: <ZD5tG45rXLemtkrX@fedora>
References: <20230411155220.9754-1-william.gray@linaro.org>
 <20230411155220.9754-5-william.gray@linaro.org>
 <ZD1MZO3KpRmuzy42@fedora>
 <2023041849-nursing-cling-8729@gregkh>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="GjX2gYdKDPhjx3jN"
Content-Disposition: inline
In-Reply-To: <2023041849-nursing-cling-8729@gregkh>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--GjX2gYdKDPhjx3jN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 18, 2023 at 11:41:29AM +0200, Greg Kroah-Hartman wrote:
> On Mon, Apr 17, 2023 at 09:40:52AM -0400, William Breathitt Gray wrote:
> > On Tue, Apr 11, 2023 at 11:52:20AM -0400, William Breathitt Gray wrote:
> > > commit 4aa3b75c74603c3374877d5fd18ad9cc3a9a62ed upstream.
> > >=20
> > > The Counter (CNTR) register is 24 bits wide, but we can have an
> > > effective 25-bit count value by setting bit 24 to the XOR of the Borr=
ow
> > > flag and Carry flag. The flags can be read from the FLAG register, bu=
t a
> > > race condition exists: the Borrow flag and Carry flag are instantaneo=
us
> > > and could change by the time the count value is read from the CNTR
> > > register.
> > >=20
> > > Since the race condition could result in an incorrect 25-bit count
> > > value, remove support for 25-bit count values from this driver.
> > >=20
> > > Fixes: 28e5d3bb0325 ("iio: 104-quad-8: Add IIO support for the ACCES =
104-QUAD-8")
> > > Cc: <stable@vger.kernel.org> # 5.15.x
> > > Signed-off-by: William Breathitt Gray <william.gray@linaro.org>
> > > ---
> > >  drivers/counter/104-quad-8.c | 18 +++---------------
> > >  1 file changed, 3 insertions(+), 15 deletions(-)
> > >=20
> > > diff --git a/drivers/counter/104-quad-8.c b/drivers/counter/104-quad-=
8.c
> > > index 0caa60537b..643aae0c9f 100644
> > > --- a/drivers/counter/104-quad-8.c
> > > +++ b/drivers/counter/104-quad-8.c
> > > @@ -61,10 +61,6 @@ struct quad8 {
> > >  #define QUAD8_REG_CHAN_OP 0x11
> > >  #define QUAD8_REG_INDEX_INPUT_LEVELS 0x16
> > >  #define QUAD8_DIFF_ENCODER_CABLE_STATUS 0x17
> > > -/* Borrow Toggle flip-flop */
> > > -#define QUAD8_FLAG_BT BIT(0)
> > > -/* Carry Toggle flip-flop */
> > > -#define QUAD8_FLAG_CT BIT(1)
> > >  /* Error flag */
> > >  #define QUAD8_FLAG_E BIT(4)
> > >  /* Up/Down flag */
> > > @@ -121,17 +117,9 @@ static int quad8_count_read(struct counter_devic=
e *counter,
> > >  {
> > >  	struct quad8 *const priv =3D counter->priv;
> > >  	const int base_offset =3D priv->base + 2 * count->id;
> > > -	unsigned int flags;
> > > -	unsigned int borrow;
> > > -	unsigned int carry;
> > >  	int i;
> > > =20
> > > -	flags =3D inb(base_offset + 1);
> > > -	borrow =3D flags & QUAD8_FLAG_BT;
> > > -	carry =3D !!(flags & QUAD8_FLAG_CT);
> > > -
> > > -	/* Borrow XOR Carry effectively doubles count range */
> > > -	*val =3D (unsigned long)(borrow ^ carry) << 24;
> > > +	*val =3D 0;
> > > =20
> > >  	mutex_lock(&priv->lock);
> > > =20
> > > @@ -699,8 +687,8 @@ static ssize_t quad8_count_ceiling_read(struct co=
unter_device *counter,
> > > =20
> > >  	mutex_unlock(&priv->lock);
> > > =20
> > > -	/* By default 0x1FFFFFF (25 bits unsigned) is maximum count */
> > > -	return sprintf(buf, "33554431\n");
> > > +	/* By default 0xFFFFFF (24 bits unsigned) is maximum count */
> > > +	return sprintf(buf, "16777215\n");
> > >  }
> > > =20
> > >  static ssize_t quad8_count_ceiling_write(struct counter_device *coun=
ter,
> > >=20
> > > base-commit: d86dfc4d95cd218246b10ca7adf22c8626547599
> > > --=20
> > > 2.39.2
> >=20
> > Greg,
> >=20
> > This patch will no longer apply to 5.15.x when the "counter: Internalize
> > sysfs interface code" patch in the stable-queue tree is merged [0].
> > However, I believe the 6.1 backport [1] will apply instead at that
> > point. What is the best way to handle this situation? Should I resend
> > the 6.1 backport with the stable list Cc tag adjusted for 5.15.x, or are
> > you able to apply the 6.1 backport patch directly to the 5.15.x tree?
>=20
> The 6.1.y backport didn't apply either :(
>=20
> Can you resend all of these rebased against the next round of stable
> releases when they are released later this week?
>=20
> thanks,
>=20
> greg k-h

Sure, I'll rebase and resend these after the next round of stable
releases is available.

William Breathitt Gray

--GjX2gYdKDPhjx3jN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSNN83d4NIlKPjon7a1SFbKvhIjKwUCZD5tGwAKCRC1SFbKvhIj
K5nIAQD0P+faGjAKpFGYha1jg2kvB+Vw8HGrbzC9gQ3NUv+ZqQEA4/PRFI//Kzjq
UalBMdVBq8Y+BSd2RlOInpa0i9oBsgc=
=u9fk
-----END PGP SIGNATURE-----

--GjX2gYdKDPhjx3jN--

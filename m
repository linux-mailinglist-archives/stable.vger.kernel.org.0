Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96DA66E4A1F
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 15:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbjDQNk7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 09:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbjDQNk6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 09:40:58 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3ADD1FF0
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 06:40:56 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id m14so8380601ybk.4
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 06:40:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681738856; x=1684330856;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AgAeLT4BnWajcrqgoxcZh6tBPEYk/HGw1hDR98TYQNY=;
        b=y1iADw5/4l0GfEHMttoKUqmjvN/6WGWR6y1yacGKFhv6dEwtxK5UlSKuOBmiB9ntQA
         VZImwCo78aJ+bU25ULXPfUFN9rlhqZMmXXSXX1Abg+AM7PUa+l8ytWnfHq4Tl+sNohtV
         5XhY+g6W2SIGTgv/A0S4Gj1BhaSUhLji4ckmH62BrpglTOWSYyi+KWblM07W8W2BpOqp
         UC77q1KPzRU9XtxtpwZnxmUGwP4nAUDOX3N+n/5sT+Bero7AjN5lXPLWfiHER72tS3qs
         BwE9Ugdc01qZM2Z5ucaN8rcAEvjeqlXwsFSsnq1a9/9MLM/ehEd6Ib+fSawRa2NA8M6B
         CCQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681738856; x=1684330856;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AgAeLT4BnWajcrqgoxcZh6tBPEYk/HGw1hDR98TYQNY=;
        b=KT/gm9bhdG74BUGoilY6ax6pKIABn4YNDMZQWkdTmEGbVT9zDZRclOksdCAU8WqOnz
         jSmlW+p6aOiK/IKTQMQb+CnTHF0bWCIXIxtrdTAvFifyFlGEDWJsuIxA5EjvXSecBaoA
         JePQqgv5RR02PBZyKdOqMyKM3x/rL4+di2g4RQfHPVxqoJydGx0GdcXwxI7V+HifjwS5
         8flGjJem7VNEUibzbpZ6G+DE2YMKEOcgGfle7zdjjeyF7VVP4kEm7S2GWntAs84RT7C8
         0DS2W47MYN0t/up3kSLgQJt6IIghOzKDlU+7+DoqE6tZWOSfNxUwAyge/JHUeaDozNok
         Lm+A==
X-Gm-Message-State: AAQBX9e7SG2XaOzgTEwsShTdaO5o/nd4ApvkTbWb7l5JfQ8GDnGZtIQ3
        VoBO4+4maI67M55+KrgErqCndA==
X-Google-Smtp-Source: AKy350Yn/WGkz+8XCLIJPJ4xLrb26M3kCR3KHvopTRvYYcyYXmn8nKhwNcfwxE39cjWp65B6BhD7pQ==
X-Received: by 2002:a25:1d09:0:b0:b8f:54c1:37f5 with SMTP id d9-20020a251d09000000b00b8f54c137f5mr14290018ybd.35.1681738855803;
        Mon, 17 Apr 2023 06:40:55 -0700 (PDT)
Received: from fedora (69-109-179-158.lightspeed.dybhfl.sbcglobal.net. [69.109.179.158])
        by smtp.gmail.com with ESMTPSA id a6-20020a259386000000b00b923b9e0a82sm1284432ybm.45.2023.04.17.06.40.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 06:40:55 -0700 (PDT)
Date:   Mon, 17 Apr 2023 09:40:52 -0400
From:   William Breathitt Gray <william.gray@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Cameron <jic23@kernel.org>, stable@vger.kernel.org
Subject: Re: [RESEND PATCH 5.15 v3 5/5] counter: 104-quad-8: Fix race
 condition between FLAG and CNTR reads
Message-ID: <ZD1MZO3KpRmuzy42@fedora>
References: <20230411155220.9754-1-william.gray@linaro.org>
 <20230411155220.9754-5-william.gray@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="vYFH3cBku7yaeL9d"
Content-Disposition: inline
In-Reply-To: <20230411155220.9754-5-william.gray@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--vYFH3cBku7yaeL9d
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 11, 2023 at 11:52:20AM -0400, William Breathitt Gray wrote:
> commit 4aa3b75c74603c3374877d5fd18ad9cc3a9a62ed upstream.
>=20
> The Counter (CNTR) register is 24 bits wide, but we can have an
> effective 25-bit count value by setting bit 24 to the XOR of the Borrow
> flag and Carry flag. The flags can be read from the FLAG register, but a
> race condition exists: the Borrow flag and Carry flag are instantaneous
> and could change by the time the count value is read from the CNTR
> register.
>=20
> Since the race condition could result in an incorrect 25-bit count
> value, remove support for 25-bit count values from this driver.
>=20
> Fixes: 28e5d3bb0325 ("iio: 104-quad-8: Add IIO support for the ACCES 104-=
QUAD-8")
> Cc: <stable@vger.kernel.org> # 5.15.x
> Signed-off-by: William Breathitt Gray <william.gray@linaro.org>
> ---
>  drivers/counter/104-quad-8.c | 18 +++---------------
>  1 file changed, 3 insertions(+), 15 deletions(-)
>=20
> diff --git a/drivers/counter/104-quad-8.c b/drivers/counter/104-quad-8.c
> index 0caa60537b..643aae0c9f 100644
> --- a/drivers/counter/104-quad-8.c
> +++ b/drivers/counter/104-quad-8.c
> @@ -61,10 +61,6 @@ struct quad8 {
>  #define QUAD8_REG_CHAN_OP 0x11
>  #define QUAD8_REG_INDEX_INPUT_LEVELS 0x16
>  #define QUAD8_DIFF_ENCODER_CABLE_STATUS 0x17
> -/* Borrow Toggle flip-flop */
> -#define QUAD8_FLAG_BT BIT(0)
> -/* Carry Toggle flip-flop */
> -#define QUAD8_FLAG_CT BIT(1)
>  /* Error flag */
>  #define QUAD8_FLAG_E BIT(4)
>  /* Up/Down flag */
> @@ -121,17 +117,9 @@ static int quad8_count_read(struct counter_device *c=
ounter,
>  {
>  	struct quad8 *const priv =3D counter->priv;
>  	const int base_offset =3D priv->base + 2 * count->id;
> -	unsigned int flags;
> -	unsigned int borrow;
> -	unsigned int carry;
>  	int i;
> =20
> -	flags =3D inb(base_offset + 1);
> -	borrow =3D flags & QUAD8_FLAG_BT;
> -	carry =3D !!(flags & QUAD8_FLAG_CT);
> -
> -	/* Borrow XOR Carry effectively doubles count range */
> -	*val =3D (unsigned long)(borrow ^ carry) << 24;
> +	*val =3D 0;
> =20
>  	mutex_lock(&priv->lock);
> =20
> @@ -699,8 +687,8 @@ static ssize_t quad8_count_ceiling_read(struct counte=
r_device *counter,
> =20
>  	mutex_unlock(&priv->lock);
> =20
> -	/* By default 0x1FFFFFF (25 bits unsigned) is maximum count */
> -	return sprintf(buf, "33554431\n");
> +	/* By default 0xFFFFFF (24 bits unsigned) is maximum count */
> +	return sprintf(buf, "16777215\n");
>  }
> =20
>  static ssize_t quad8_count_ceiling_write(struct counter_device *counter,
>=20
> base-commit: d86dfc4d95cd218246b10ca7adf22c8626547599
> --=20
> 2.39.2

Greg,

This patch will no longer apply to 5.15.x when the "counter: Internalize
sysfs interface code" patch in the stable-queue tree is merged [0].
However, I believe the 6.1 backport [1] will apply instead at that
point. What is the best way to handle this situation? Should I resend
the 6.1 backport with the stable list Cc tag adjusted for 5.15.x, or are
you able to apply the 6.1 backport patch directly to the 5.15.x tree?

Thanks,

William Breathitt Gray

[0] https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git=
/tree/queue-5.15/counter-internalize-sysfs-interface-code.patch
[1] https://lore.kernel.org/all/20230412082840.822017654@linuxfoundation.or=
g/

--vYFH3cBku7yaeL9d
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSNN83d4NIlKPjon7a1SFbKvhIjKwUCZD1MZAAKCRC1SFbKvhIj
Kw3aAP9gXLzMdyqUoa0eraz/ltqJ+WGxU7DoCqlMykA7tZvRJgD+JPK60SzhmFHh
aU0QBgt38/+j3aXUlMCE87k7TYQW4gI=
=T28Y
-----END PGP SIGNATURE-----

--vYFH3cBku7yaeL9d--

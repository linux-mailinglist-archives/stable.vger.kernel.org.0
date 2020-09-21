Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10166272517
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 15:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727560AbgIUNOH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 09:14:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727207AbgIUNOG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Sep 2020 09:14:06 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27BE9C061755;
        Mon, 21 Sep 2020 06:14:06 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id k18so12627948wmj.5;
        Mon, 21 Sep 2020 06:14:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wLc0I+gr3bbTgUnHLxgw23apPJqDNVY2tpCF/LCfrZw=;
        b=YNVt0hlXjAbrKgboq6q8k+gGktriN5nklkYfCPG4g72C+OUZyAusB50caFlwWb38p6
         YLJXBWs5+K2IE94h+hwiudmFUSCFVNqLwh4/e1ZREonVYexA6SquKhIeeGeURtqhXLJ2
         uoPDB3tyXsseGt57dMCjh2HlztklrHuMCI8YAMKzozSQYLYfStq8iNrp85COoY78fvuZ
         +NwMhzbO4o+b3A1TpM448oAW/Tb6LruCAEBc16xaKLrnwWZgpLOPA0aCVsqsRbZQ0ArC
         tilyb1tMYZKrRJy1aSu60sSI45g2H4ISuldrLDuiHdOrgauXaDtt8jUIs8MmK3jT7HI8
         EX0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wLc0I+gr3bbTgUnHLxgw23apPJqDNVY2tpCF/LCfrZw=;
        b=ElTmpZADYRLu6waGZH5vY3xyPkauXk31eBRZQTfvkthyaY3L0aZ27AZczNUa8A/BAW
         2VQuexQXmOwoUVkxJ/S0zTIadg7CHYjYvv/fUHHGT8cJJUpqaVIx4HWJAiaW6/Pfcb8i
         sNGcaU/twJWnmw92xEW7ho3HHK23dNVr8gEV2LVFkjdI0lb84y2MGrIHTE8YQKcbQxf/
         igYbwkCqkhUm27lANT7tXlOoS7jrg2VCSOlsAjqhecozmlz30doiOtr3HWWY6R0+snGP
         vsYzhfz+N/+AfZK8wmi7/ae1nX3gOg/AeEX8DgDKWzoBqdWSPRlAJICb0U8bCHHAR+bk
         F8NQ==
X-Gm-Message-State: AOAM53080eZau9lphxlRXE5ZPv9RYtknD2TazNspl7RQD54LFpi9U9RH
        8/G65aJSF4/3sdHI9L6y2h4=
X-Google-Smtp-Source: ABdhPJzT+zzaKejpCfixWbdhj6IU4/+8I0Vfx/pTYVA45F0nlLUI6KZYV8CIB3xZ59O508TUsibSLw==
X-Received: by 2002:a1c:e256:: with SMTP id z83mr32396469wmg.137.1600694044841;
        Mon, 21 Sep 2020 06:14:04 -0700 (PDT)
Received: from localhost ([217.111.27.204])
        by smtp.gmail.com with ESMTPSA id b84sm21458987wmd.0.2020.09.21.06.14.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 06:14:03 -0700 (PDT)
Date:   Mon, 21 Sep 2020 15:14:01 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Nicolas Chauvet <kwizart@gmail.com>
Cc:     Jonathan Hunter <jonathanh@nvidia.com>,
        linux-tegra@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 4/4] ARM: tegra: Avoid setting edp_irq when not relevant
Message-ID: <20200921131401.GA3955907@ulmo>
References: <20200914133739.60020-1-kwizart@gmail.com>
 <20200914133739.60020-5-kwizart@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="rwEMma7ioTxnRzrJ"
Content-Disposition: inline
In-Reply-To: <20200914133739.60020-5-kwizart@gmail.com>
User-Agent: Mutt/1.14.6 (2020-07-11)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 14, 2020 at 03:37:39PM +0200, Nicolas Chauvet wrote:
> According to the binding, the edp_irq is not available on tegra124/132
>=20
> This commit moves the initialization of tegra->edp_irq after the
> introduced SoCs condition. This will have the following effects:
>  - soctherm_interrupts_init will not return prematurely with unfinished
> thermal_irq initialization on tegra124 and tegra132
>  - edp_irq initialization will be bypassed when not relevant
>=20
> As a result, this will clear the following error when loading the driver:
>   kernel: tegra_soctherm 700e2000.thermal-sensor: IRQ index 1 not found
>=20
> Fixes: 4a04beb1bf2e (thermal: tegra: add support for EDP IRQ)
> Cc: stable@vger.kernel.org
> Signed-off-by: Nicolas Chauvet <kwizart@gmail.com>
> ---
>  drivers/thermal/tegra/soctherm.c | 17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)

Your subject needs a different prefix. As it is this looks like
something to apply to the Tegra tree, but it actually needs to go
through Zhang's and Daniel's thermal tree. Also make sure to send
patches To: the maintainers of the subsystem.

>=20
> diff --git a/drivers/thermal/tegra/soctherm.c b/drivers/thermal/tegra/soc=
therm.c
> index 66e0639da4bf..0a7dc988f25f 100644
> --- a/drivers/thermal/tegra/soctherm.c
> +++ b/drivers/thermal/tegra/soctherm.c
> @@ -2025,12 +2025,6 @@ static int soctherm_interrupts_init(struct platfor=
m_device *pdev,
>  		return 0;
>  	}
> =20
> -	tegra->edp_irq =3D platform_get_irq(pdev, 1);
> -	if (tegra->edp_irq < 0) {
> -		dev_dbg(&pdev->dev, "get 'edp_irq' failed.\n");
> -		return 0;
> -	}
> -
>  	ret =3D devm_request_threaded_irq(&pdev->dev,
>  					tegra->thermal_irq,
>  					soctherm_thermal_isr,
> @@ -2043,6 +2037,17 @@ static int soctherm_interrupts_init(struct platfor=
m_device *pdev,
>  		return ret;
>  	}
> =20
> +	/* None of the tegra124 and tegra132 SoCs have edp_irq */
> +	if (of_machine_is_compatible("nvidia,tegra124") ||
> +		of_machine_is_compatible("nvidia,tegra132"))
> +			return 0;
> +

I'd prefer to turn this into a per-SoC capability flag. You can add
something like this:

	struct tegra_soctherm_soc {
		...
		bool has_edp_irq;
	};

	...

	const struct tegra_soctherm_soc tegra124_soctherm =3D {
		...
		.has_edp_irq =3D false,
	};

	...

	const struct tegra_soctherm_soc tegra210_soctherm =3D {
		...
		.has_edp_irq =3D true,
	};

	...

and so on. This makes it more obvious why you conditionalize certain
code segments and avoids complicated conditionals.

Also, please avoid returning success early. That's very confusing
because it can lead to people adding code to the end of this function
that will never be run on the chips that you've excluded above.

So I think a better way to write this would be:

	if (tegra->soc->has_edp_irq) {
		/* get IRQ */

		/* request IRQ */
	}

That way people can simply continue adding to the bottom of the function
and that code will get executed, which is much more straightforward than
if you invert the condition.

Thierry

> +	tegra->edp_irq =3D platform_get_irq(pdev, 1);
> +	if (tegra->edp_irq < 0) {
> +		dev_dbg(&pdev->dev, "get 'edp_irq' failed.\n");
> +		return 0;
> +	}
> +
>  	ret =3D devm_request_threaded_irq(&pdev->dev,
>  					tegra->edp_irq,
>  					soctherm_edp_isr,
> --=20
> 2.25.4
>=20

--rwEMma7ioTxnRzrJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAl9opxcACgkQ3SOs138+
s6F/4g//R/FWTeyXe9H8sKZKeg1mh4ng6gwewJUQJms4T3FYN4PxupCieCEWY1li
ZlN7KQFwXiyGyHuNqib2nPKCXWy4inPAnXzy3LTeBX1xKsVtYQHHy2frp735FWWT
1AZ4sful5sSiQWW3UEyCbv01XAONhuDJeuIsoqAlp4lR21Pv1UaTiFSD1wrix+My
xVyNEB/dGZzAx09P56zF49lKHAmhkGGaYtGsCUkGpNQGplQRP3T3uB1g1frvIjm7
3RH+NFwDifMuaNdcjYn2BBLjzuiHsibZW5jSDv+28FC9/hb/fMeFfZ1AWS9PfWOW
wpF6TQ+XptH2HKuTDcs65JUlSPWYnf4vPglj7StpTv1vEpB5IE0f/hee7R5MOuyH
HnDU98xpv0ky2eYGeXQ+NmyQbJbI4r9kjH5/NukR/j4qG7cHoG8g5m3QnYDkXBvY
qd+sNT4xSXLI16Qx8qFVLQdFuoR3dsYLUSq2vpeVZCW614OKg5vZk5keM21GrMqP
4CaJ7iRcUQW6CSCXYwnnBmliGG6/JnExTtllqVM5BnTYcVQGQTR/X+GPDK7nkCXC
jmuTrgvCSi17e/ty9OX/VLU/ZstVZ814rTbGu++A4Wnn+pFrD5gcpAKrQVGQuLAn
V2ImAK0UIQLs6upgXV2UT7Jg1F28xjyzFikrsWthX1K9zeyelSU=
=Av8i
-----END PGP SIGNATURE-----

--rwEMma7ioTxnRzrJ--

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 950643B81B0
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 14:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234376AbhF3MLh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 08:11:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234301AbhF3MLh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Jun 2021 08:11:37 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 419F5C061756;
        Wed, 30 Jun 2021 05:09:07 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id t3so2854422edt.12;
        Wed, 30 Jun 2021 05:09:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=yv6G0XlLyx0cNOQs1yjuDHkPDLgd8do+KRNU+Bsw+0s=;
        b=CkRrjJ/lY+3bATyA92auA3pghlGCQ2eFNmp4H3pXt+NRbRWGhBB4hltIOTFH3pRix6
         p0lCxBkhh9zbj9bbTsdBrexjgi3fjYO0t3k1bc811RNUyuEIbrvnbZop/lWDNPU3gtOd
         dgmjQ8BwQd/EN2igFwT5J0ZOZeCYv7ckefvh+PkOyiWxmqDjK9tUl5jTA27c0cmGJtQx
         h+cKtoeGlA/nhGnwRSyCRwALTae6coD4kx0eJ1uHqfb2uhhDiOB5N05/h/s0g3uIQrPW
         qLjx94Sl46KLPnvsJ3RSr0HnslRIQErnDgH3Xy8OBo46oGd6IgFjGNzkjy5XIvu8KYgz
         tXhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=yv6G0XlLyx0cNOQs1yjuDHkPDLgd8do+KRNU+Bsw+0s=;
        b=fs7NEe8RcrQ/9pozkKz3AiZyiLbElaxVoIz5SLNVCvTUyPIr/AjpPGw6PEFIYaROZ1
         y5yhklwJl1lXXTO9tNTEy/GOB6xCjkIRZU+bkqELatKgjX1NKU8It12pE2he1v1S9u7v
         UL4Y6TCNpJW7Wyp3nqy5Oo2I/NSGhlUhMi4cPsEQ2kySSrzey48ICs3fwTJU4vxJ4aMI
         42m8N/1vkuOaWIXeZu6kFEqPkP5ruOtC2lIEkbdNP4ClLrg/MBdR5ttGdX8ZqTwaBFC+
         V8taWDYUWesMxXhDpMfstBxt8DXL5IEHbMxVLiXK4QER61punHyhqdSPkVnZKDIshW5s
         qvYg==
X-Gm-Message-State: AOAM5301vY+vI4zJS0NuMBdo1VXzfLdXD0sMDsxlSMLOT2vNw3CIAqvo
        GZDHtKGqk6AYRdtl8By7jtY=
X-Google-Smtp-Source: ABdhPJzWMorsWU9d5ILFTqwqY3jORo1NxDTXRBq7dmVffuaKlaYjuobtomju7gLCQyQbhqEAhKm+CA==
X-Received: by 2002:aa7:d592:: with SMTP id r18mr12085582edq.269.1625054945856;
        Wed, 30 Jun 2021 05:09:05 -0700 (PDT)
Received: from localhost ([62.96.65.119])
        by smtp.gmail.com with ESMTPSA id p5sm9388990ejm.115.2021.06.30.05.09.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 05:09:04 -0700 (PDT)
Date:   Wed, 30 Jun 2021 14:11:20 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Krishna Yarlagadda <kyarlagadda@nvidia.com>,
        linux-serial@vger.kernel.org, linux-tegra@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] serial: tegra: Only print FIFO error message when an
 error occurs
Message-ID: <YNxfaEDFIW7d7rYi@orome.fritz.box>
References: <20210630094601.136280-1-jonathanh@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="RV9/iY+PrzN4D53L"
Content-Disposition: inline
In-Reply-To: <20210630094601.136280-1-jonathanh@nvidia.com>
User-Agent: Mutt/2.1 (4b100969) (2021-06-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--RV9/iY+PrzN4D53L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 30, 2021 at 10:46:01AM +0100, Jon Hunter wrote:
> The Tegra serial driver always prints an error message when enabling the
> FIFO for devices that have support for checking the FIFO enable status.
> Fix this by only display the error message, when an error occurs.
>=20
> Fixes: 222dcdff3405 ("serial: tegra: check for FIFO mode enabled status")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
> ---
>  drivers/tty/serial/serial-tegra.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/tty/serial/serial-tegra.c b/drivers/tty/serial/seria=
l-tegra.c
> index 222032792d6c..cd481f7ba8eb 100644
> --- a/drivers/tty/serial/serial-tegra.c
> +++ b/drivers/tty/serial/serial-tegra.c
> @@ -1045,9 +1045,10 @@ static int tegra_uart_hw_init(struct tegra_uart_po=
rt *tup)
> =20
>  	if (tup->cdata->fifo_mode_enable_status) {
>  		ret =3D tegra_uart_wait_fifo_mode_enabled(tup);
> -		dev_err(tup->uport.dev, "FIFO mode not enabled\n");
> -		if (ret < 0)
> +		if (ret < 0) {
> +			dev_err(tup->uport.dev, "FIFO mode not enabled\n");

The error message seems a bit confusing. I read this as meaning "FIFO
mode was expected to be enabled but wasn't" whereas this really seems to
mean that for some reason the FIFO enable timed out.

In the former case it sounds like a some configuration mismatch, while
it's really something that went wrong during the process of enabling the
FIFO mode.

So I wonder if this should perhaps be something like:

	dev_err(tup->uport.dev, "FIFO mode enable timed out\n");

or something along those lines.

That said, this is a pre-existing problem and it's a bit pedantic, so in
either case:

Acked-by: Thierry Reding <treding@nvidia.com>

--RV9/iY+PrzN4D53L
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmDcX2UACgkQ3SOs138+
s6HGfBAAhJ56RUVkZakA6i0f8fZvbqOVfkvQ4AKu9idObDl5ZBDSvQIHKaJ5xM0q
sEB+kFXswZ1tH3Sy8/oAMASrT0uTH/uS+MGNdEYBM3XDN/oxU2Ep8IWHSh0Zbn8x
P9Vfx/NAqvzRLZ6bDl1v6CRMHgzr+caTbTsuWEDiHL97F1jDsURaA1LGEEg78FF3
8q6Aw6msOrSNHlSt6q5Jz72gI40inCz1EVlS1o+LkaTFLuQs4g4paIUDQg+lnO7N
JyEpiavuX6ypPCyKLm1pI0J09fFSL/AzUaDpA1ELkVhiXdn3cWexLaCrvlhy0cGM
N8WAcgGLCKEw5Ft0LbeeAZzS278Kv+uVdx9X6MWrHNEGnULCyVf5dte16hkpufYR
80haGhJYGmh2f729yO696MVVYeqqhND/qm2e0uweAifjUWB7OP5JGil+p/JxjLgk
v0C6tmD7N3x6Z0snBCULe/l4+k87IS9tVnApB4UbVV4W4KGf17dqeI12jyNRqC0N
H8FBGoIpNId/LWe++Zwz8gb6ewftNoa3tY5lI3k2azp/FE8UMYP0w+ppEE117DBO
eYZ9rSuBppleHvz0Z1m7cfWniegSum/bGr63tRil/Mh13y86HUtJ0x93PPshcqvw
wU5szYWJgPsySIqECQrOzf71f4OgDcgv9BTgB4xspCdsm0FH8hQ=
=liif
-----END PGP SIGNATURE-----

--RV9/iY+PrzN4D53L--

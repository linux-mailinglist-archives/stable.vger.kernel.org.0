Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BDBD15FBC4
	for <lists+stable@lfdr.de>; Sat, 15 Feb 2020 01:47:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727680AbgBOAqa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 19:46:30 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39444 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727641AbgBOAqa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Feb 2020 19:46:30 -0500
Received: by mail-pg1-f193.google.com with SMTP id j15so5765487pgm.6;
        Fri, 14 Feb 2020 16:46:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yq48rcKsoBJadqH8CrxKLMuvLWBQ4Q7pHZITM4ZIuPs=;
        b=GTqabMbIs14z8FNs/mlnRvM0hdYUdH2278vKKh2S8VaMb9X8bGCBWhIKkXzNhBaSn8
         NtewMkPNnUtd4+fXpivheJBFO0aHHceumXDGSYcfBFSVfHJrszrYSjYXYNB34eKwnB7n
         YU0OR3VsEPbPgpZulU1BDTMTYH6HEHAZyVaWOqiblwxjf6V8xbFxki/wsRrZYv/HdzB/
         bFl/u/TN3stRABQWiZR2tHuKHtuLKT9NX70OvMJPXY3A7ALmJKpHjeynZo4FVkOx4f4G
         PVR2/m/Khy7PHpWaxUKAAkxCXilCGhsSeZcIxvoDkD1GjBaZFiwzEZdoHjUUY56Gr0ho
         gwZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yq48rcKsoBJadqH8CrxKLMuvLWBQ4Q7pHZITM4ZIuPs=;
        b=hc3kjEYqvjOIyh74SSxpse/TaN9cBMwez15KSH3cyp2reObMHph7OM+DDIVvM62n08
         MJVanDvDs3GQ6rESME/yyLMteCUQ6d/d05acFW3dbBJ7uKaHu3yLVd9/PupHvMdxBSOT
         2T/oTinP74ctx51g+5YHtab7lmBq4G7Evn6UzFX4u2cOmQdCkh7Z/+0Xk6WMKZ35ILcI
         QW4WPbYQJdfgGLSYJyWWejhrxpjKrTLb9f6fuBAtYVjXDFr3z9nBaluNXvdZK97NLP+u
         fnFK8tL+ydDNLAB2gOFXiPp1CLf5Ezge6LlbjIukdwJ+ZK/CzBSNrmSrDdQm8BgPiK1B
         mHUg==
X-Gm-Message-State: APjAAAUEvrrg15DR2neq+4t+TiCj8oHI2uKU0mnFqFppkXOfqF14nQag
        VusUcyxW/NC32hpDuvk2tlQ=
X-Google-Smtp-Source: APXvYqxGypd7xlEUpYWu5JLzosw54btkTR/5wb7n5Fl/MdXFSmiDUo4BQqbqhWIevUam2M88DtoC1w==
X-Received: by 2002:a63:7419:: with SMTP id p25mr6117307pgc.430.1581727589339;
        Fri, 14 Feb 2020 16:46:29 -0800 (PST)
Received: from pek-khao-d2.corp.ad.wrs.com (unknown-105-123.windriver.com. [147.11.105.123])
        by smtp.gmail.com with ESMTPSA id 13sm8046633pfj.68.2020.02.14.16.46.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2020 16:46:28 -0800 (PST)
Date:   Sat, 15 Feb 2020 08:46:20 +0800
From:   Kevin Hao <haokexin@gmail.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kbuild test robot <lkp@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-gpio@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.4 332/459] gpio: Fix the no return statement
 warning
Message-ID: <20200215004620.GB499724@pek-khao-d2.corp.ad.wrs.com>
References: <20200214160149.11681-1-sashal@kernel.org>
 <20200214160149.11681-332-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5I6of5zJg18YgZEa"
Content-Disposition: inline
In-Reply-To: <20200214160149.11681-332-sashal@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--5I6of5zJg18YgZEa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 14, 2020 at 10:59:42AM -0500, Sasha Levin wrote:
> From: Kevin Hao <haokexin@gmail.com>
>=20
> [ Upstream commit 9c6722d85e92233082da2b3623685bba54d6093e ]
>=20
> In commit 242587616710 ("gpiolib: Add support for the irqdomain which
> doesn't use irq_fwspec as arg") we have changed the return type of
> gpiochip_populate_parent_fwspec_twocell/fourcell() from void to void *,
> but forgot to add a return statement for these two dummy functions.
> Add "return NULL" to fix the build warnings.
>=20
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Kevin Hao <haokexin@gmail.com>
> Link: https://lore.kernel.org/r/20200116095003.30324-1-haokexin@gmail.com
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  include/linux/gpio/driver.h | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/include/linux/gpio/driver.h b/include/linux/gpio/driver.h
> index 5dd9c982e2cbe..d7dc2b425532e 100644
> --- a/include/linux/gpio/driver.h
> +++ b/include/linux/gpio/driver.h
> @@ -545,6 +545,7 @@ static inline void gpiochip_populate_parent_fwspec_tw=
ocell(struct gpio_chip *chi
>  						    unsigned int parent_hwirq,
>  						    unsigned int parent_type)
>  {
> +	return NULL;

Hi Sasha,

This commit shouldn't go to the v5.4.x kernel. This is a fix for the=20
commit 242587616710, but that commit doesn't exist in the v5.4.x kernel,
then it will trigger a build warning due to the wrong returning type.      =
                                                                           =
                                       =20

Thanks,
Kevin
>  }
> =20
>  static inline void gpiochip_populate_parent_fwspec_fourcell(struct gpio_=
chip *chip,
> @@ -552,6 +553,7 @@ static inline void gpiochip_populate_parent_fwspec_fo=
urcell(struct gpio_chip *ch
>  						     unsigned int parent_hwirq,
>  						     unsigned int parent_type)
>  {
> +	return NULL;
>  }
> =20
>  #endif /* CONFIG_IRQ_DOMAIN_HIERARCHY */
> --=20
> 2.20.1
>=20

--5I6of5zJg18YgZEa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEHc6qFoLCZqgJD98Zk1jtMN6usXEFAl5HP1wACgkQk1jtMN6u
sXFjBAf9HJVjCr0SihI4ekE3g+yTdTEkNc3DNI0tCJMgjjEB5Jai7YvCWDsxRWpQ
w1Ibx5b8foGIRc1NUsBBYrblvNG1n53JFWYLtamZiBFBPaMLH0Q/krVSBBFkcFgv
92SU//b78eYlh+RQx4w/8ty+wA6J2WiJJywqCXeb0ie+lXm1n54v7U4Q3UMN3g8F
BdzZ+/LpRH4rdnwNNJGoiNboKhjSyFN6WF2BYyPpqJ1WlixxKX9vz24K67ulqBP1
dDnuzi+3XblIoVo/Qzoa/eK60mG3MC4SzLLD8VEGs0Kh8vi4amVW5SG/TepkQC19
XeY2/Gu6tNvm1C993bSGGTzPE+YeXA==
=M8Oq
-----END PGP SIGNATURE-----

--5I6of5zJg18YgZEa--

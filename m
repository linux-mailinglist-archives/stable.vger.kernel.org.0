Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBF0F15FBB5
	for <lists+stable@lfdr.de>; Sat, 15 Feb 2020 01:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727684AbgBOApG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 19:45:06 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37872 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727529AbgBOApG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Feb 2020 19:45:06 -0500
Received: by mail-pg1-f194.google.com with SMTP id z12so5773875pgl.4;
        Fri, 14 Feb 2020 16:45:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Inbpr5SUPGLkcjnM3zqZWFjhSSN/XzwloYji45Ik41g=;
        b=qILc5+gfYKMSzGidu7TKz0BUH3dEliL76Jb1MTlbfHvq9iV3K8loYwDwn0wseOrqAu
         94H6WKuOzKQjmSU/MyAgtTApcoS2Btz0VKITLOAAU9ObsNJoFwXwolIQ6Te62Tm+Emvq
         /FpBFw16w1JwM9rnle+iWOeXFjqQJWC/t7FAybA32H4Kxi/h36KhHsk/9lLQ4Y5baMSA
         v6EmauQBK28MSFeBdBTlG9WmnBX5eP38DxWQAuWIh3x40UAsENpHwesZu7KChWchViwe
         RIpgHr8k4uY9wOG00Al/lEziaJ0U7Rys4kh1DwThJcehg2+SnLouesl8eXNM5akJqEoK
         HMlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Inbpr5SUPGLkcjnM3zqZWFjhSSN/XzwloYji45Ik41g=;
        b=gM9i4PtLLu0AA3LRix4f4MenqrJCd4Lw6UerRLjZq2GlBmls70qLgwBNvDCXy+IcZk
         E2OeyWDlaB/dRapQMDbKeEgQy6/vHkoPdem1eyviyzHzZzoi8NEhc9IzSGrwtoWildro
         Hl7rjhI2Ovlc0qulfZ7US57gwNqGafXk+urjq6M9JJlwVJZ3sIOJa8N4Z8jw4U9mWBM4
         0sl5kCI0tI25ai7VxTG+7+nABJXTbu01/bU/1MX45JiTWlPzR+5pKoAMU3i1hROSbZeE
         atjN+B80tub1/GzkpljNMD6vAr2EIYHmiMFtiqNisHs1Ccmh2RZSKhgww2t6SCZkuyiY
         BnAQ==
X-Gm-Message-State: APjAAAUCeqYgcQxK/tBVyN49jmdJlTCkTtzVlXcaTyCobhU/RKqkMKJd
        eEYD9JZGYFDuxt5zyTq6cQ4=
X-Google-Smtp-Source: APXvYqwRCvRCj1qf/sZ0lBE8EJ5azZEmrZY0vt8K2aQzMUcWONkpG//iAdu0rHsoXkcEWinlc3lkxQ==
X-Received: by 2002:a63:b257:: with SMTP id t23mr5954577pgo.17.1581727505276;
        Fri, 14 Feb 2020 16:45:05 -0800 (PST)
Received: from pek-khao-d2.corp.ad.wrs.com (unknown-105-123.windriver.com. [147.11.105.123])
        by smtp.gmail.com with ESMTPSA id p23sm8775258pgn.92.2020.02.14.16.44.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2020 16:45:04 -0800 (PST)
Date:   Sat, 15 Feb 2020 08:44:55 +0800
From:   Kevin Hao <haokexin@gmail.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kbuild test robot <lkp@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-gpio@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.5 383/542] gpio: Fix the no return statement
 warning
Message-ID: <20200215004455.GA499724@pek-khao-d2.corp.ad.wrs.com>
References: <20200214154854.6746-1-sashal@kernel.org>
 <20200214154854.6746-383-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Content-Disposition: inline
In-Reply-To: <20200214154854.6746-383-sashal@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 14, 2020 at 10:46:15AM -0500, Sasha Levin wrote:
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
> index e2480ef94c559..5dce9c67a961e 100644
> --- a/include/linux/gpio/driver.h
> +++ b/include/linux/gpio/driver.h
> @@ -553,6 +553,7 @@ static inline void gpiochip_populate_parent_fwspec_tw=
ocell(struct gpio_chip *chi
>  						    unsigned int parent_hwirq,
>  						    unsigned int parent_type)
>  {
> +	return NULL;

Hi Sasha,

This commit shouldn't go to the v5.5.x kernel. This is a fix for the
commit 242587616710, but that commit doesn't exist in the v5.5.x kernel,
then it will trigger a build warning due to the wrong returning type.

Thanks,
Kevin

>  }
> =20
>  static inline void gpiochip_populate_parent_fwspec_fourcell(struct gpio_=
chip *chip,
> @@ -560,6 +561,7 @@ static inline void gpiochip_populate_parent_fwspec_fo=
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

--DocE+STaALJfprDB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEHc6qFoLCZqgJD98Zk1jtMN6usXEFAl5HPwcACgkQk1jtMN6u
sXH1+QgAqwTTpd0/hYff7/VtzeJUpLfUh91ajN/y7kSgpT/0d6euuyWvofP3BmH7
79A7gvj1rm9wKEOKb/lLbsiBxaYmR+vLXIQHyiMsu4r6qfSmUfAHR69I0eRiU7hM
EawgQxbCV6QfEPN11d8/1ucvrOnoY6cGBw2adVN4I4H8f+CX4ZKlqCctMc7qrPtV
Uui55j6amhzBvE/a/oFM+sRoyM/VMc6ottdTCtKrBuZLAbnHD+bEi45ixEhCxBtz
C1jdPaZl30/53Xkw5m5/weEWVLlML08+f8IRcdo7Aws9mA998zsSvCMe3i2v+85c
KKIE+rx+fqDk/lqlD/vo8qEpnJ8Gtw==
=7hqF
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--

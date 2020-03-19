Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4300318B789
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:34:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727228AbgCSNeH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:34:07 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:55285 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727159AbgCSNeG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Mar 2020 09:34:06 -0400
Received: by mail-pj1-f67.google.com with SMTP id np9so1036887pjb.4;
        Thu, 19 Mar 2020 06:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=F2L50Kf5vxV4m1X5xHH97b0ZIljM+Ez6EQ+o7n8lyF8=;
        b=ZkxuJeM+PiMgUQSprSTt3xmHy0tEdg1/l4+eNMox9P0RhnMGk+jkYcJau7WyFNECpy
         XEk1RMfvkF7QrCPKhMJe62C87fBIaDL09qUFPSQgHwnYNpbdbyshNjwTypGa+/Z1lFOq
         3sJJO9D9/5KDcyxuu459lkfjelid2j8kXtgQbM6nBJF+iGCx5MVeg+ueEHm0REbR8R7v
         S8VNw81MpJz7+p79b/DusxX8vxf/xBGUt0gfG2yD4jhJ1lquaZTWrsq3UEiup+IlLNOT
         LkpUOg+lL7nmr8bC3YbcfQKqc8AfJ8e8YZ+DPPNXtjAySEkBwVEYf0oEgSTSkjxiB8Sn
         n7YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=F2L50Kf5vxV4m1X5xHH97b0ZIljM+Ez6EQ+o7n8lyF8=;
        b=rFRtEVWY+NpquVnqzDyBAbwfmfx7GbLKeme6aFzDnO7kN7grl/BEYBsQu1LAzdAT+z
         BdWAlz+WO5Q2Kofe2S6ae7oxwd4M41zAsrxOD9CmWPg+l3gJABqnUtrjO9ymsJd07Ebd
         Q/RQkefwmi2TCnzlnbheux3XnIIgxRupQwaYXuTxg0UKcmJWWPjIIEhtgDTQ9nF8+L9T
         R//aB77/CUaGGREemOS5JdmXlABC/JQrgQxTntYYczp+sMKX+0BkrEH1QPuC3r+2VEWs
         DHjIm0rUPgg2Zbcdno/gt0xKCmVOA8MPHGSauTt4u2NKJqwSj9+IxOU69GkniFcxqzyJ
         0QAQ==
X-Gm-Message-State: ANhLgQ106K63ApIqQ/rA2DogsF3B3Cpk7ye/eiNTta7PICZ5Tc+3WRJQ
        xQB996dv1GavXJ5HS1is75g=
X-Google-Smtp-Source: ADFU+vsTeguCzwnRhAH8BYGxM2n/vHfe0GuP3u1PEvzbPnvVmJWGG6xIWhxyIXiKEZsZR4Qf+wAMDQ==
X-Received: by 2002:a17:902:444:: with SMTP id 62mr3429788ple.109.1584624844901;
        Thu, 19 Mar 2020 06:34:04 -0700 (PDT)
Received: from pek-khao-d2.corp.ad.wrs.com (unknown-105-123.windriver.com. [147.11.105.123])
        by smtp.gmail.com with ESMTPSA id d23sm2587996pfq.210.2020.03.19.06.33.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 06:34:04 -0700 (PDT)
Date:   Thu, 19 Mar 2020 21:33:55 +0800
From:   Kevin Hao <haokexin@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.5 01/65] gpiolib: Add support for the irqdomain which
 doesnt use irq_fwspec as arg
Message-ID: <20200319133355.GB711692@pek-khao-d2.corp.ad.wrs.com>
References: <20200319123926.466988514@linuxfoundation.org>
 <20200319123926.902914624@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="MfFXiAuoTsnnDAfZ"
Content-Disposition: inline
In-Reply-To: <20200319123926.902914624@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--MfFXiAuoTsnnDAfZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 19, 2020 at 02:03:43PM +0100, Greg Kroah-Hartman wrote:
> From: Kevin Hao <haokexin@gmail.com>
>=20
> [ Upstream commit 242587616710576808dc8d7cdf18cfe0d7bf9831 ]
>=20
> Some gpio's parent irqdomain may not use the struct irq_fwspec as
> argument, such as msi irqdomain. So rename the callback
> populate_parent_fwspec() to populate_parent_alloc_arg() and make it
> allocate and populate the specific struct which is needed by the
> parent irqdomain.

Hi Greg,

This commit shouldn't go to stable because it is not a bug fix. It is just a
prerequisite of switching to general GPIOLIB_IRQCHIP for thunderx gpio driv=
er
(commit 7a9f4460f74d "gpio: thunderx: Switch to GPIOLIB_IRQCHIP").

Thanks,
Kevin

>=20
> Signed-off-by: Kevin Hao <haokexin@gmail.com>
> Link: https://lore.kernel.org/r/20200114082821.14015-3-haokexin@gmail.com
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/gpio/gpio-tegra186.c             | 13 +++++--
>  drivers/gpio/gpiolib.c                   | 45 +++++++++++++++---------
>  drivers/pinctrl/qcom/pinctrl-spmi-gpio.c |  2 +-
>  drivers/pinctrl/qcom/pinctrl-ssbi-gpio.c |  2 +-
>  include/linux/gpio/driver.h              | 21 +++++------
>  5 files changed, 49 insertions(+), 34 deletions(-)
>=20
> diff --git a/drivers/gpio/gpio-tegra186.c b/drivers/gpio/gpio-tegra186.c
> index 55b43b7ce88db..de241263d4be3 100644
> --- a/drivers/gpio/gpio-tegra186.c
> +++ b/drivers/gpio/gpio-tegra186.c
> @@ -448,17 +448,24 @@ static int tegra186_gpio_irq_domain_translate(struc=
t irq_domain *domain,
>  	return 0;
>  }
> =20
> -static void tegra186_gpio_populate_parent_fwspec(struct gpio_chip *chip,
> -						 struct irq_fwspec *fwspec,
> +static void *tegra186_gpio_populate_parent_fwspec(struct gpio_chip *chip,
>  						 unsigned int parent_hwirq,
>  						 unsigned int parent_type)
>  {
>  	struct tegra_gpio *gpio =3D gpiochip_get_data(chip);
> +	struct irq_fwspec *fwspec;
> =20
> +	fwspec =3D kmalloc(sizeof(*fwspec), GFP_KERNEL);
> +	if (!fwspec)
> +		return NULL;
> +
> +	fwspec->fwnode =3D chip->irq.parent_domain->fwnode;
>  	fwspec->param_count =3D 3;
>  	fwspec->param[0] =3D gpio->soc->instance;
>  	fwspec->param[1] =3D parent_hwirq;
>  	fwspec->param[2] =3D parent_type;
> +
> +	return fwspec;
>  }
> =20
>  static int tegra186_gpio_child_to_parent_hwirq(struct gpio_chip *chip,
> @@ -621,7 +628,7 @@ static int tegra186_gpio_probe(struct platform_device=
 *pdev)
>  	irq->chip =3D &gpio->intc;
>  	irq->fwnode =3D of_node_to_fwnode(pdev->dev.of_node);
>  	irq->child_to_parent_hwirq =3D tegra186_gpio_child_to_parent_hwirq;
> -	irq->populate_parent_fwspec =3D tegra186_gpio_populate_parent_fwspec;
> +	irq->populate_parent_alloc_arg =3D tegra186_gpio_populate_parent_fwspec;
>  	irq->child_offset_to_irq =3D tegra186_gpio_child_offset_to_irq;
>  	irq->child_irq_domain_ops.translate =3D tegra186_gpio_irq_domain_transl=
ate;
>  	irq->handler =3D handle_simple_irq;
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index 175c6363cf611..cdbaa8bf72f74 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -2003,7 +2003,7 @@ static int gpiochip_hierarchy_irq_domain_alloc(stru=
ct irq_domain *d,
>  	irq_hw_number_t hwirq;
>  	unsigned int type =3D IRQ_TYPE_NONE;
>  	struct irq_fwspec *fwspec =3D data;
> -	struct irq_fwspec parent_fwspec;
> +	void *parent_arg;
>  	unsigned int parent_hwirq;
>  	unsigned int parent_type;
>  	struct gpio_irq_chip *girq =3D &gc->irq;
> @@ -2042,24 +2042,21 @@ static int gpiochip_hierarchy_irq_domain_alloc(st=
ruct irq_domain *d,
>  			    NULL, NULL);
>  	irq_set_probe(irq);
> =20
> -	/*
> -	 * Create a IRQ fwspec to send up to the parent irqdomain:
> -	 * specify the hwirq we address on the parent and tie it
> -	 * all together up the chain.
> -	 */
> -	parent_fwspec.fwnode =3D d->parent->fwnode;
>  	/* This parent only handles asserted level IRQs */
> -	girq->populate_parent_fwspec(gc, &parent_fwspec, parent_hwirq,
> -				     parent_type);
> +	parent_arg =3D girq->populate_parent_alloc_arg(gc, parent_hwirq, parent=
_type);
> +	if (!parent_arg)
> +		return -ENOMEM;
> +
>  	chip_info(gc, "alloc_irqs_parent for %d parent hwirq %d\n",
>  		  irq, parent_hwirq);
>  	irq_set_lockdep_class(irq, gc->irq.lock_key, gc->irq.request_key);
> -	ret =3D irq_domain_alloc_irqs_parent(d, irq, 1, &parent_fwspec);
> +	ret =3D irq_domain_alloc_irqs_parent(d, irq, 1, parent_arg);
>  	if (ret)
>  		chip_err(gc,
>  			 "failed to allocate parent hwirq %d for hwirq %lu\n",
>  			 parent_hwirq, hwirq);
> =20
> +	kfree(parent_arg);
>  	return ret;
>  }
> =20
> @@ -2096,8 +2093,8 @@ static int gpiochip_hierarchy_add_domain(struct gpi=
o_chip *gc)
>  	if (!gc->irq.child_offset_to_irq)
>  		gc->irq.child_offset_to_irq =3D gpiochip_child_offset_to_irq_noop;
> =20
> -	if (!gc->irq.populate_parent_fwspec)
> -		gc->irq.populate_parent_fwspec =3D
> +	if (!gc->irq.populate_parent_alloc_arg)
> +		gc->irq.populate_parent_alloc_arg =3D
>  			gpiochip_populate_parent_fwspec_twocell;
> =20
>  	gpiochip_hierarchy_setup_domain_ops(&gc->irq.child_irq_domain_ops);
> @@ -2123,27 +2120,43 @@ static bool gpiochip_hierarchy_is_hierarchical(st=
ruct gpio_chip *gc)
>  	return !!gc->irq.parent_domain;
>  }
> =20
> -void gpiochip_populate_parent_fwspec_twocell(struct gpio_chip *chip,
> -					     struct irq_fwspec *fwspec,
> +void *gpiochip_populate_parent_fwspec_twocell(struct gpio_chip *chip,
>  					     unsigned int parent_hwirq,
>  					     unsigned int parent_type)
>  {
> +	struct irq_fwspec *fwspec;
> +
> +	fwspec =3D kmalloc(sizeof(*fwspec), GFP_KERNEL);
> +	if (!fwspec)
> +		return NULL;
> +
> +	fwspec->fwnode =3D chip->irq.parent_domain->fwnode;
>  	fwspec->param_count =3D 2;
>  	fwspec->param[0] =3D parent_hwirq;
>  	fwspec->param[1] =3D parent_type;
> +
> +	return fwspec;
>  }
>  EXPORT_SYMBOL_GPL(gpiochip_populate_parent_fwspec_twocell);
> =20
> -void gpiochip_populate_parent_fwspec_fourcell(struct gpio_chip *chip,
> -					      struct irq_fwspec *fwspec,
> +void *gpiochip_populate_parent_fwspec_fourcell(struct gpio_chip *chip,
>  					      unsigned int parent_hwirq,
>  					      unsigned int parent_type)
>  {
> +	struct irq_fwspec *fwspec;
> +
> +	fwspec =3D kmalloc(sizeof(*fwspec), GFP_KERNEL);
> +	if (!fwspec)
> +		return NULL;
> +
> +	fwspec->fwnode =3D chip->irq.parent_domain->fwnode;
>  	fwspec->param_count =3D 4;
>  	fwspec->param[0] =3D 0;
>  	fwspec->param[1] =3D parent_hwirq;
>  	fwspec->param[2] =3D 0;
>  	fwspec->param[3] =3D parent_type;
> +
> +	return fwspec;
>  }
>  EXPORT_SYMBOL_GPL(gpiochip_populate_parent_fwspec_fourcell);
> =20
> diff --git a/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c b/drivers/pinctrl/q=
com/pinctrl-spmi-gpio.c
> index 653d1095bfeaf..fe0be8a6ebb7b 100644
> --- a/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c
> +++ b/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c
> @@ -1060,7 +1060,7 @@ static int pmic_gpio_probe(struct platform_device *=
pdev)
>  	girq->fwnode =3D of_node_to_fwnode(state->dev->of_node);
>  	girq->parent_domain =3D parent_domain;
>  	girq->child_to_parent_hwirq =3D pmic_gpio_child_to_parent_hwirq;
> -	girq->populate_parent_fwspec =3D gpiochip_populate_parent_fwspec_fource=
ll;
> +	girq->populate_parent_alloc_arg =3D gpiochip_populate_parent_fwspec_fou=
rcell;
>  	girq->child_offset_to_irq =3D pmic_gpio_child_offset_to_irq;
>  	girq->child_irq_domain_ops.translate =3D pmic_gpio_domain_translate;
> =20
> diff --git a/drivers/pinctrl/qcom/pinctrl-ssbi-gpio.c b/drivers/pinctrl/q=
com/pinctrl-ssbi-gpio.c
> index dca86886b1f99..73d986a903f1b 100644
> --- a/drivers/pinctrl/qcom/pinctrl-ssbi-gpio.c
> +++ b/drivers/pinctrl/qcom/pinctrl-ssbi-gpio.c
> @@ -794,7 +794,7 @@ static int pm8xxx_gpio_probe(struct platform_device *=
pdev)
>  	girq->fwnode =3D of_node_to_fwnode(pctrl->dev->of_node);
>  	girq->parent_domain =3D parent_domain;
>  	girq->child_to_parent_hwirq =3D pm8xxx_child_to_parent_hwirq;
> -	girq->populate_parent_fwspec =3D gpiochip_populate_parent_fwspec_fource=
ll;
> +	girq->populate_parent_alloc_arg =3D gpiochip_populate_parent_fwspec_fou=
rcell;
>  	girq->child_offset_to_irq =3D pm8xxx_child_offset_to_irq;
>  	girq->child_irq_domain_ops.translate =3D pm8xxx_domain_translate;
> =20
> diff --git a/include/linux/gpio/driver.h b/include/linux/gpio/driver.h
> index e2480ef94c559..9bb43467ed11d 100644
> --- a/include/linux/gpio/driver.h
> +++ b/include/linux/gpio/driver.h
> @@ -94,16 +94,15 @@ struct gpio_irq_chip {
>  				     unsigned int *parent_type);
> =20
>  	/**
> -	 * @populate_parent_fwspec:
> +	 * @populate_parent_alloc_arg :
>  	 *
> -	 * This optional callback populates the &struct irq_fwspec for the
> -	 * parent's IRQ domain. If this is not specified, then
> +	 * This optional callback allocates and populates the specific struct
> +	 * for the parent's IRQ domain. If this is not specified, then
>  	 * &gpiochip_populate_parent_fwspec_twocell will be used. A four-cell
>  	 * variant named &gpiochip_populate_parent_fwspec_fourcell is also
>  	 * available.
>  	 */
> -	void (*populate_parent_fwspec)(struct gpio_chip *chip,
> -				       struct irq_fwspec *fwspec,
> +	void *(*populate_parent_alloc_arg)(struct gpio_chip *chip,
>  				       unsigned int parent_hwirq,
>  				       unsigned int parent_type);
> =20
> @@ -537,26 +536,22 @@ struct bgpio_pdata {
> =20
>  #ifdef CONFIG_IRQ_DOMAIN_HIERARCHY
> =20
> -void gpiochip_populate_parent_fwspec_twocell(struct gpio_chip *chip,
> -					     struct irq_fwspec *fwspec,
> +void *gpiochip_populate_parent_fwspec_twocell(struct gpio_chip *chip,
>  					     unsigned int parent_hwirq,
>  					     unsigned int parent_type);
> -void gpiochip_populate_parent_fwspec_fourcell(struct gpio_chip *chip,
> -					      struct irq_fwspec *fwspec,
> +void *gpiochip_populate_parent_fwspec_fourcell(struct gpio_chip *chip,
>  					      unsigned int parent_hwirq,
>  					      unsigned int parent_type);
> =20
>  #else
> =20
> -static inline void gpiochip_populate_parent_fwspec_twocell(struct gpio_c=
hip *chip,
> -						    struct irq_fwspec *fwspec,
> +static inline void *gpiochip_populate_parent_fwspec_twocell(struct gpio_=
chip *chip,
>  						    unsigned int parent_hwirq,
>  						    unsigned int parent_type)
>  {
>  }
> =20
> -static inline void gpiochip_populate_parent_fwspec_fourcell(struct gpio_=
chip *chip,
> -						     struct irq_fwspec *fwspec,
> +static inline void *gpiochip_populate_parent_fwspec_fourcell(struct gpio=
_chip *chip,
>  						     unsigned int parent_hwirq,
>  						     unsigned int parent_type)
>  {
> --=20
> 2.20.1
>=20
>=20
>=20

--MfFXiAuoTsnnDAfZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEHc6qFoLCZqgJD98Zk1jtMN6usXEFAl5zdMMACgkQk1jtMN6u
sXFlQwf/fH0MvS3u14Ky8kR/dDDjcyx34OY5SeD4WlmtCPugd06TX9aYT+yhmk+l
02E6cj7DC9m2opWBp11PiZ1Ld0lK4OHVCrPoqKeGgknW3IE7Tj14jy+Q4HlP0X1a
CPDmpOJ890IqXuSWiRj0Vwr8an8Ye5jc8JPyqwQYslO0pOEjVda1FzPWVq+9Wypu
7E63rXYBmN4XNp0Y9Z1JtJpeKwcRDb/n4rIGzXbTj3MDs27Mu8cv+evL6uMAZChW
NZMzV1kbVCfHLCuNvvTWEgcNPelLbQK/SB1b1GW9y249QoC2WyUyzLROcmpnrt3z
e8R2J0ve2kyI9tGAHq2SrCUn05vDeg==
=Z5p2
-----END PGP SIGNATURE-----

--MfFXiAuoTsnnDAfZ--

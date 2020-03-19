Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F21018B9B4
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 15:48:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727602AbgCSOsE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 10:48:04 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:51649 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727095AbgCSOsE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Mar 2020 10:48:04 -0400
Received: by mail-pj1-f65.google.com with SMTP id hg10so1130921pjb.1;
        Thu, 19 Mar 2020 07:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iK05xzM+yXMlMMBB96Ty+jVySQdFzOrOyJ1jKAUfrII=;
        b=BZ+tPJYYDOYMpI+L4jin21gfyTgBL+CRJLQFsyPJAWy5RCjqyUdEkzijUGf41MX/zU
         aHFUAmJ831sfBn4uvRfx4Yi4FnzKta6x+IiNtw695VVcV6fmNVfIenmYXn/glPL6sx5l
         2m8n5YB2NZ6sP6JFUt5jRgUQfyArfdueifhYq5Rt1bcZG5auj0SqVQryhGRBmRpMyeNS
         hwSxiuNTfww9prPYT/DQUe4dO/fYkKCgAWGMjJxBM6QFpph17YXi7HspCd8ppxShKvUL
         aw2ZL++NQo0+9Z26XgRtPaosdh+4xJYzFuifpCuAEPpndKKcyj88HlP5kqmRfs2RvkNm
         F0tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iK05xzM+yXMlMMBB96Ty+jVySQdFzOrOyJ1jKAUfrII=;
        b=Rh7WK/2gIBUxluS1/+QuZKPJC9HMDxij/Z1yNTEOPXxJw5OZTvXmB4fzLqm7U0DZrW
         ly0W40pQFNezigreD/XWT5nZlLaHqrD2KnTabLpNeKbMKqE4pZBJVUGJnv/xsuC5GTpH
         hK7bu9HLCcbgrIrU+RuSRy0aAhUy6Ax2+2spaUBU1wQjijR5ra/52gr3uUKPj6bdJnrO
         tZRK0A0jntEvt/5FgyqYVyYgSt9uZiWTI4GiJ/o5vOsqvhEYCc8I7IQJIFKPwiNzJSBL
         p5NDbjt47ApefegPeZ0OP9s7tNBMr5tBZeKezw6hwLQbwUjYCrWofAMcw35J9WX6paFj
         RaeA==
X-Gm-Message-State: ANhLgQ2eJacRNADNKjB5Yf9RpXQOJovyfy9IT8Ls/cRBjAsjo7mKhHVG
        9bxQdcYodDg4Jv+DqxrbQ5xApiEJ31Y=
X-Google-Smtp-Source: ADFU+vtdCSYXWtpFnsVhOE0kaIaAPwen+HYz6MCw8i52mb1uyYlVrW2AAy1bhF9Gkkz0QjUWRfRxxg==
X-Received: by 2002:a17:90b:1918:: with SMTP id mp24mr4064031pjb.98.1584629282451;
        Thu, 19 Mar 2020 07:48:02 -0700 (PDT)
Received: from pek-khao-d2.corp.ad.wrs.com (unknown-105-123.windriver.com. [147.11.105.123])
        by smtp.gmail.com with ESMTPSA id i197sm2896948pfe.137.2020.03.19.07.47.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 07:48:01 -0700 (PDT)
Date:   Thu, 19 Mar 2020 22:47:53 +0800
From:   Kevin Hao <haokexin@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.5 01/65] gpiolib: Add support for the irqdomain which
 doesnt use irq_fwspec as arg
Message-ID: <20200319144753.GD711692@pek-khao-d2.corp.ad.wrs.com>
References: <20200319123926.466988514@linuxfoundation.org>
 <20200319123926.902914624@linuxfoundation.org>
 <20200319133355.GB711692@pek-khao-d2.corp.ad.wrs.com>
 <20200319134710.GA4092809@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jCrbxBqMcLqd4mOl"
Content-Disposition: inline
In-Reply-To: <20200319134710.GA4092809@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--jCrbxBqMcLqd4mOl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 19, 2020 at 02:47:10PM +0100, Greg Kroah-Hartman wrote:
> On Thu, Mar 19, 2020 at 09:33:55PM +0800, Kevin Hao wrote:
> > On Thu, Mar 19, 2020 at 02:03:43PM +0100, Greg Kroah-Hartman wrote:
> > > From: Kevin Hao <haokexin@gmail.com>
> > >=20
> > > [ Upstream commit 242587616710576808dc8d7cdf18cfe0d7bf9831 ]
> > >=20
> > > Some gpio's parent irqdomain may not use the struct irq_fwspec as
> > > argument, such as msi irqdomain. So rename the callback
> > > populate_parent_fwspec() to populate_parent_alloc_arg() and make it
> > > allocate and populate the specific struct which is needed by the
> > > parent irqdomain.
> >=20
> > Hi Greg,
> >=20
> > This commit shouldn't go to stable because it is not a bug fix. It is j=
ust a
> > prerequisite of switching to general GPIOLIB_IRQCHIP for thunderx gpio =
driver
> > (commit 7a9f4460f74d "gpio: thunderx: Switch to GPIOLIB_IRQCHIP").
>=20
> This seems to be a prerequisite for f98371476f36 ("pinctrl: qcom:
> ssbi-gpio: Fix fwspec parsing bug") to apply properly.  With that
> information, is it ok to keep?

Yes, this commit does change the context of commit f98371476f36 ("pinctrl: =
qcom:
ssbi-gpio: Fix fwspec parsing bug"). So I am fine to keep this in order to =
apply
f98371476f36 cleanly. But there is no really logical dependency between the=
se two
commits, so another option is that we can adjust the commit f98371476f36 a =
bit in order
to apply to v5.5.x cleanly without this commit, something like below. IMHO,=
 it is more
suitable for the stable kernel.

=46rom 2678327511f77edd8692634e81ef04cd9ca4b249 Mon Sep 17 00:00:00 2001
=46rom: Linus Walleij <linus.walleij@linaro.org>
Date: Fri, 6 Mar 2020 15:34:15 +0100
Subject: [PATCH] pinctrl: qcom: ssbi-gpio: Fix fwspec parsing bug

[ Upstream commit f98371476f36359da2285d1807b43e5b17fd18de ]

We are parsing SSBI gpios as fourcell fwspecs but they are
twocell. Probably a simple copy-and-paste bug.

Tested on the APQ8060 DragonBoard and after this ethernet
and MMC card detection works again.

Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: stable@vger.kernel.org
Reviewed-by: Brian Masney <masneyb@onstation.org>
Fixes: ae436fe81053 ("pinctrl: ssbi-gpio: convert to hierarchical IRQ helpe=
rs in gpio core")
Link: https://lore.kernel.org/r/20200306143416.1476250-1-linus.walleij@lina=
ro.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
[Kevin: Replace .populate_parent_alloc_arg with .populate_parent_fwspec]
Signed-off-by: Kevin Hao <haokexin@gmail.com>
---
 drivers/pinctrl/qcom/pinctrl-ssbi-gpio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-ssbi-gpio.c b/drivers/pinctrl/qco=
m/pinctrl-ssbi-gpio.c
index dca86886b1f9..6b7f0d56a532 100644
--- a/drivers/pinctrl/qcom/pinctrl-ssbi-gpio.c
+++ b/drivers/pinctrl/qcom/pinctrl-ssbi-gpio.c
@@ -794,7 +794,7 @@ static int pm8xxx_gpio_probe(struct platform_device *pd=
ev)
 	girq->fwnode =3D of_node_to_fwnode(pctrl->dev->of_node);
 	girq->parent_domain =3D parent_domain;
 	girq->child_to_parent_hwirq =3D pm8xxx_child_to_parent_hwirq;
-	girq->populate_parent_fwspec =3D gpiochip_populate_parent_fwspec_fourcell;
+	girq->populate_parent_fwspec =3D gpiochip_populate_parent_fwspec_twocell;
 	girq->child_offset_to_irq =3D pm8xxx_child_offset_to_irq;
 	girq->child_irq_domain_ops.translate =3D pm8xxx_domain_translate;
=20
--=20
2.25.1.377.g2d2118b814c1

Thanks,
Kevin


>=20
> thanks,
>=20
> greg k-h

--jCrbxBqMcLqd4mOl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEHc6qFoLCZqgJD98Zk1jtMN6usXEFAl5zhhkACgkQk1jtMN6u
sXHR3wgAywMvs8wwG1TaRcINULc9kLjcErY5rTQW88zFOdaVHuINLIHX5X+7KsqV
WOau24KOiK36M5UwW4B9cVh3Q12ue3IGKRT6mOdKkW3RLeBZrjjLWeqyDB6P8SBf
X7lKt6g4utPBcJAITbrKmA3ukPNUIQBH7HFsBPm2BRsA50KqzdU4iTen/N/CQTSc
wohyrROTRjDDqJ2MVRsQ6UIwNqWCcgxaxMh0RiTwq9Q3+YVOOrTCffAtk1DwwY9S
r19EZVUk00t2NMVz3ySDf+nuFgcvgXszwyVG+MLZSR5fVQpEuJNIFcHDknbV/OzQ
1Lg5ng7p0Gore8GQoStR9vuGyn1GnA==
=pwIq
-----END PGP SIGNATURE-----

--jCrbxBqMcLqd4mOl--

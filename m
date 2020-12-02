Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7C32CC04F
	for <lists+stable@lfdr.de>; Wed,  2 Dec 2020 16:05:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730421AbgLBPEz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Dec 2020 10:04:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:50698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730417AbgLBPEy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Dec 2020 10:04:54 -0500
Date:   Wed, 2 Dec 2020 16:04:09 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606921453;
        bh=Me6ioMBcD1xjBiZBNjZz4qGyOW40j2fz16WXis1EvgA=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=A6Nm1e/8VCsSoL4Dyvo29gkEpT2FWZoPsH58dKsfXJrjdUNQmIcjd7XyoFTRG0gWL
         aSLNSzWCcGOJZr1Io9S/1MpjoVPEL3GUvjkaIyJcimpTf3/5mtusSg7ryOAWzbLYNA
         yfDVzEAKJBPRXJL4KDPjRc5gAuAI30/5hsxmDTXE=
From:   Wolfram Sang <wsa@kernel.org>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Oleksij Rempel <linux@rempel-privat.de>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        David Laight <David.Laight@aculab.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH v6 1/3] i2c: imx: Fix reset of I2SR_IAL flag
Message-ID: <20201202150409.GB874@kunai>
Mail-Followup-To: Wolfram Sang <wsa@kernel.org>,
        Christian Eggers <ceggers@arri.de>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
        David Laight <David.Laight@aculab.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>, linux-i2c@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>, stable@vger.kernel.org
References: <20201009110320.20832-1-ceggers@arri.de>
 <20201009110320.20832-2-ceggers@arri.de>
 <20201010110920.GB4669@ninjato>
 <18285740.IRuNKOj0Az@n95hx1g2>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="UugvWAfsgieZRqgk"
Content-Disposition: inline
In-Reply-To: <18285740.IRuNKOj0Az@n95hx1g2>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> > Applied to for-next, thanks!
> >
> I cannot find my patches in kernel/git/wsa/linux.git, branch "for-next".
> Did they get lost?

It seems like it :( I seem to have forgotten to push out and then
continued to to work on another computer with an older state. It is
highly embarassing but I can't find out what exactly happened. I hope I
didn't lose more patches. I am really sorry!

Pushed to for-next again.


--UugvWAfsgieZRqgk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl/HrN8ACgkQFA3kzBSg
KbabCg/7BbTFqzvSLDsd8ooftIfdeb+JkCdWlguMzBwqdSFFs9jXv8SJMWVVfmVB
tKgLTqD1HCe/PpbuPPuZrIdNvy5WQ0qq0mknlXreAh++tn7xUjaQ6uUP9aZeSmKP
jIAwdg0Q9LF70ojW8oQfAvgZ70+LBOFH+VKcW4eag0/eR9axmhUf08kcML5PsKaG
ctJczn6Ni0Xba7JI+0yzU6ZkM14RDZzMMLXUf1BVj+f0oi0h8sCUH+8oL+Aq5NtF
X46xk35SPD27LewXqWXMHgDBGvlk+xgs9t1yVOuE61zfhDuH3YCUIQtd67HB3iGb
cb86kuWzOjtBj+Rxrv5RaHrcjunusVwCRCEKsQIuHJESoqhtqI1vtwjWlkfA5pJ+
lOH54Gnah42aJ4aHbLQtkBDmIIctX1GlU7bAP3O7falAH/ezR89zLxYiFiYJtsnI
3/YNzIIaRH8w4yVZntj7zEC58nb0+VeSuOOUxdVTKIFoV4/gJUG06yCzpRAlEvJ7
14o9oWSwC1TzVRAURC0CvHS5Tbx7R18Uq9e+KQEmagBt7X6Mb7UvGqh5z3B89+yI
IpvqFOFUuSRUo3ckj1XLZlbRAk1GP1GIG91faiWtoEe8/STjJph7I0z1hoJUOEpy
Ptc+G5i33CDsXkh1H05Qp0Qoj8tDlC0TqypdWHhIFww9GUGHv+A=
=LYvd
-----END PGP SIGNATURE-----

--UugvWAfsgieZRqgk--

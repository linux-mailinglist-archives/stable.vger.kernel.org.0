Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58FB828A252
	for <lists+stable@lfdr.de>; Sun, 11 Oct 2020 00:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390334AbgJJW44 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Oct 2020 18:56:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:57002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731608AbgJJTyP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Oct 2020 15:54:15 -0400
Received: from localhost (p5486c996.dip0.t-ipconnect.de [84.134.201.150])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD28A21D46;
        Sat, 10 Oct 2020 11:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602328170;
        bh=t7al5w5BieFitDjitckP3mPrbG7YcyWWXG1nP1aMJ40=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Heocty798Mk4lRLO1z6/g9IhhRKNrGZUZkjDVmkmwV/Gn2bKF9P85KfaMaFLi1QSy
         fsWqU0m+y7F8G+dic/PmXFwe3M9OLH7dluuKRNfRgbE5BaItQw+GvkzdlV+X3FzJnb
         DYqWiZZ7H0dUDhvy4QIp7OgD6LsqwOTA5u0JYA0E=
Date:   Sat, 10 Oct 2020 13:09:27 +0200
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
Subject: Re: [PATCH v6 2/3] i2c: imx: Check for I2SR_IAL after every byte
Message-ID: <20201010110927.GC4669@ninjato>
References: <20201009110320.20832-1-ceggers@arri.de>
 <20201009110320.20832-3-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="qjNfmADvan18RZcF"
Content-Disposition: inline
In-Reply-To: <20201009110320.20832-3-ceggers@arri.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--qjNfmADvan18RZcF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 09, 2020 at 01:03:19PM +0200, Christian Eggers wrote:
> Arbitration Lost (IAL) can happen after every single byte transfer. If
> arbitration is lost, the I2C hardware will autonomously switch from
> master mode to slave. If a transfer is not aborted in this state,
> consecutive transfers will not be executed by the hardware and will
> timeout.
>=20
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> Tested (not extensively) on Vybrid VF500 (Toradex VF50):
> Tested-by: Krzysztof Kozlowski <krzk@kernel.org>
> Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Cc: stable@vger.kernel.org

Applied to for-next, thanks!


--qjNfmADvan18RZcF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl+BlmcACgkQFA3kzBSg
KbafYQ/+M+tg4UJCR0bClfylxiM2x+NgKiJFR1xhe3/Eba3W7Je0rdC1gvGT+hQz
SkcdXhP7p2D5UjbD3CPL72PjDDr1pLBH3b7nNhnl/QNxMERLBD6j7nGDRrA/3b+J
DRkz3dYBxSs99gvQtqFu/sqAk1en98WiKOAHcGXXnC1xQ19Q6TUd5oEGQYSC0MQQ
WSxnchFXcCo/s4MusxS0NowQAmcSSPgQf4oxt9SDIyH+CIYMFLblgFysSaGCJYMt
LlR/6NIE125XLOL61oNj1qNdn5kuu7sxoL9yukeh/2Yc+KqzBYjbM+wWepMrdAta
GM20nit0RWOrU0bqApYvfa4/7Wam+3TmhRGSS7vM5Hm1boxHpLmFnkcarFSsrken
aAZ/tIkliEuaMHjv+RAfFuQg2Q4vsAWz3XTfDJBPJhzlDhiC74/54yYg4whLDX7g
I1La5oe7l8p/3zIB6MtzQUmbbreyQ4d+wroQKOeL4qETZfDjm7i9XtXWgeQkb79p
9MQt8I7iGzK3/R0Bvn7gqdQ7oNlitjl1vuQnoFgLDRrcUGVuoAIK0E0kYoFaI7el
hGxYDBeo+NpdVg2dQAltEcXD4HDsr4hk5DgDoNxw+VmUS6pUrDDQZEhmJpMuyhjX
fWwnTVSBJUFT3q5g34e9u3mW5uYgNESHPBbeMVUdzX9xr7UD+UI=
=I8DM
-----END PGP SIGNATURE-----

--qjNfmADvan18RZcF--

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED9728A387
	for <lists+stable@lfdr.de>; Sun, 11 Oct 2020 01:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730730AbgJJW45 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Oct 2020 18:56:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:57030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732658AbgJJTys (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Oct 2020 15:54:48 -0400
Received: from localhost (p5486c996.dip0.t-ipconnect.de [84.134.201.150])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4E2F215A4;
        Sat, 10 Oct 2020 11:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602328163;
        bh=guPsHCw4PMTVOWJTZw4CsPJSCk9MAFXYM2VZvw2WA4k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i7phJFa3z6bYqbhOf7Xa2rFx5F++Iu6q9just5v7UZvPg7FGxS5F54wuZDo1mf6Lf
         RIeW3V0yHIf/Lfm91VCCBlSglcBUp2Th3orwmRh/X7e8wRAj0pmlZUrYJIk+Xy/RQ7
         BoBo6L9ZFSiZQ7TD6Rqlc/3KSv94746GghhlYKLk=
Date:   Sat, 10 Oct 2020 13:09:20 +0200
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
Message-ID: <20201010110920.GB4669@ninjato>
References: <20201009110320.20832-1-ceggers@arri.de>
 <20201009110320.20832-2-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="yEPQxsgoJgBvi8ip"
Content-Disposition: inline
In-Reply-To: <20201009110320.20832-2-ceggers@arri.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--yEPQxsgoJgBvi8ip
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 09, 2020 at 01:03:18PM +0200, Christian Eggers wrote:
> According to the "VFxxx Controller Reference Manual" (and the comment
> block starting at line 97), Vybrid requires writing a one for clearing
> an interrupt flag. Syncing the method for clearing I2SR_IIF in
> i2c_imx_isr().
>=20
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> Fixes: 4b775022f6fd ("i2c: imx: add struct to hold more configurable quir=
ks")
> Reviewed-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
> Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Cc: stable@vger.kernel.org

Applied to for-next, thanks!


--yEPQxsgoJgBvi8ip
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl+BlmAACgkQFA3kzBSg
KbbC/g/+J3lmdYmZN+MyWSAAetqyLefppTqeUIVJCkpDWPxL9EX+w95GwIRhRXeT
ssG6heAi9Jfd6JZh3I6JL8b64KtpDFfHGbtbAVlHNerlxPTN8G3uJPJ3fCN/pLWl
toaYPfNaaILFJADg5qIuyeRPWBQEzvDEAmto/ZxrqIKw4bmxgGahxcNSHqufPSm6
HOtjvkexaNaGU3b6bCn9+PfaFJPmlzQt0q8wDJtLFG0Mt5WTA2Hij//7jSYEf4Pr
m2tK61bE3NhkhP27oF9lrELFiU0Jcwf8hge8t1dKOkOvRwioC1i83aJtj7Qk9coA
M6t9ug1TnDuDm84iGDwXL0wpIgFmiJ8hrlaBVawlI127D8drgCIpSmApVoSzPhD7
h/XDPQU0fCXDc7IU2P92k+JQIK/V9t6pSyJzJEwCBErsgeTSX/F/zkV6SJSwhabf
p868NtBjIkoFLOQJ1x6LzF3Qkp7mWN9mRNav99fyLERJ+8g2DmLYbs42hM1PsxUc
wYmksyqt53UegAQNy1/WgPtnTQQGvmtr8qaA9OEL51O9Nekkco3pbJfKMyKlM+az
T8YvUbprSVXRctP2lYhDEIDMGgLnScByUXqjTTs3wG0TDeD6d5gGUeHGJZ7X0z2t
o95VgwchByOAS00njE6YX7FX3JUM5CDl492pegyTSqoukR7xQk0=
=Dbak
-----END PGP SIGNATURE-----

--yEPQxsgoJgBvi8ip--

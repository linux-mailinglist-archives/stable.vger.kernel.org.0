Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31A603C997C
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 09:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240281AbhGOHUA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 03:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239659AbhGOHT7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Jul 2021 03:19:59 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A0BFC061760
        for <stable@vger.kernel.org>; Thu, 15 Jul 2021 00:17:07 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1m3vcE-00052b-0e; Thu, 15 Jul 2021 09:17:02 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1m3vcD-0007wJ-Cc; Thu, 15 Jul 2021 09:17:01 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1m3vcD-0006U3-BJ; Thu, 15 Jul 2021 09:17:01 +0200
Date:   Thu, 15 Jul 2021 09:16:58 +0200
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Shawn Guo <shawnguo@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 5.13 024/108] ARM: dts: imx25-pinfunc: Fix gpio
 function name for pads GPIO_[A-F]
Message-ID: <20210715071658.mwcve4wghdoalspk@pengutronix.de>
References: <20210714193800.52097-1-sashal@kernel.org>
 <20210714193800.52097-24-sashal@kernel.org>
 <20210714203550.zlbvfh6rfnah6iir@pengutronix.de>
 <YO9QKRUOT0Kg0jZ9@sashalap>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="yqkwbe5xcciyc3ar"
Content-Disposition: inline
In-Reply-To: <YO9QKRUOT0Kg0jZ9@sashalap>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--yqkwbe5xcciyc3ar
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 14, 2021 at 04:59:21PM -0400, Sasha Levin wrote:
> On Wed, Jul 14, 2021 at 10:35:50PM +0200, Uwe Kleine-K=F6nig wrote:
> > On Wed, Jul 14, 2021 at 03:36:36PM -0400, Sasha Levin wrote:
> > > From: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
> > >=20
> > > [ Upstream commit e0cdd26af8eb9001689a4cde4f72c61c1c4b06be ]
> > >=20
> > > The pinfunc definitions used GPIO_A as function instead of GPIO_1_0 as
> > > done for all the other pins with GPIO functionality. Fix for consiste=
ncy.
> > >=20
> > > There are no mainline users that needs adaption.
> > >=20
> > > Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
> > > Signed-off-by: Shawn Guo <shawnguo@kernel.org>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> >=20
> > I'm not convinced it's a good idea to take this patch for stable.
> > in-tree users are unaffected and the only effect this can have on
> > out-of-tree users is to break them. So the gain of having this is not
> > positive.
> >=20
> > Am I missing something?
>=20
> Hm, if those definitions don't have an in-tree users, why are they still
> around to begin with?

It's hardware description and out-of-tree dts might make use of it. Even
if no in-tree user benefits, it's IMO better to have this included, but
I admit you could judge differently here.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--yqkwbe5xcciyc3ar
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmDv4OcACgkQwfwUeK3K
7An2Fgf/ddo/to5QAC9EOSvn7Cfd5AFD82Soed00daFgBCoCP3tGH3gbYVV3kzh3
ChYWoYMQCN1e6GZ8qYIC3vNm0iSuJSbrosMcIqJnowjOwitM8eTyykGLSXlqrArI
qOnQMgqc1pEma07mjoJDaMTEWSHssncYLcbAEe+I+ygXDrcb4r/ApV6+Ag3502iW
kA7YEJRZPaGCzN2+pCtoYF3ZyCC7zytQewW0gWV5eSKvwFlEks6UunzY7koQGfGL
XTjKypKN5u/dqgmk+RSFYNYMZTv2Sr01skvf1V5RkIpTs/UsQSopZPCMJbIHgZH+
Th37WM7QEP+1Qg7qKZA7lDtHdGujXg==
=moso
-----END PGP SIGNATURE-----

--yqkwbe5xcciyc3ar--

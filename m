Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3422032C833
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 02:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377000AbhCDAey (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 19:34:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387963AbhCCUES (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 15:04:18 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0008AC06175F
        for <stable@vger.kernel.org>; Wed,  3 Mar 2021 12:03:37 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1lHXiX-0004Mp-Kk; Wed, 03 Mar 2021 21:03:33 +0100
Received: from ukl by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1lHXiU-0002ed-5s; Wed, 03 Mar 2021 21:03:30 +0100
Date:   Wed, 3 Mar 2021 21:03:30 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     'Dmitry Torokhov' <dmitry.torokhov@gmail.com>
Cc:     jingle <jingle.wu@emc.com.tw>, kernel@pengutronix.de,
        linux-input@vger.kernel.org, stable@vger.kernel.org
Subject: Re: elan_i2c: failed to read report data: -71
Message-ID: <20210303200330.udsge64hxlrdkbwt@pengutronix.de>
References: <20210302210934.iro3a6chigx72r4n@pengutronix.de>
 <016d01d70fdb$2aa48b00$7feda100$@emc.com.tw>
 <20210303183223.rtqi63hdl3a7hahv@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="wa5ad73hp45elh6x"
Content-Disposition: inline
In-Reply-To: <20210303183223.rtqi63hdl3a7hahv@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--wa5ad73hp45elh6x
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Dmitry,

On Wed, Mar 03, 2021 at 07:32:23PM +0100, Uwe Kleine-K=F6nig wrote:
> Hello,
>=20
> On Wed, Mar 03, 2021 at 11:13:21AM +0800, jingle wrote:
> > HI uwe:
> >=20
> > Please updates this patchs.
> >=20
> > https://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git/commit/?=
h=3Dnext&id=3D056115daede8d01f71732bc7d778fb85acee8eb6
> >=20
> > https://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git/commit/?=
h=3Dnext&id=3De4c9062717feda88900b566463228d1c4910af6d
>=20
> The first was one of the two patches I already tried, but the latter
> indeed fixes my problem \o/.
>=20
> @Dmitry: If you don't consider your tree stable, feel free to add a
>=20
> 	Tested-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
>=20
> to e4c9062717feda88900b566463228d1c4910af6d.

Do you consider this patch for stable? I'd like to see it in Debian's
5.10 kernel and I guess I'm not the only one who would benefit from such
a backport.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--wa5ad73hp45elh6x
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmA/644ACgkQwfwUeK3K
7Anqxwf9EOPlADvUYQuCa4/aUGEygs+uagcfGN/aWDcyz4SF2ugpuAnOV4suwlNo
fO0wN6NPdzEMZkLIC747hN8yWGT7P4Yu9SCXIfaekgUEOsuZfvbObD92sKZt2MFp
qgjClLqlZ5DyVcMwitihLqUuA/eE53J6ugJoooOv+WFms9oS4EgbaWl8/epMT8Y3
RMrIAB1WF4FCQ8SGystd7SMbll9xRR9rCxCr2t/MaAdWo3wXf9/+O4BdJX1uXH11
T44QmyDQ1GBHuPp/BJy7vUAm6Ob/SnCPfzV3PdtO/Uy7AIr8b91FUJOJPa7jlZ5c
NkUjEKmyEUwYeqykrBg4FWihe05neg==
=g0fP
-----END PGP SIGNATURE-----

--wa5ad73hp45elh6x--

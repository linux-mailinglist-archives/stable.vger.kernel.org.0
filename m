Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75E9C49B6CB
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 15:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357419AbiAYOrL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 09:47:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1579410AbiAYOoM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 09:44:12 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23A64C061747
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 06:44:05 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1nCN3B-0000ct-3n; Tue, 25 Jan 2022 15:44:01 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1nCN3A-00CMRg-As; Tue, 25 Jan 2022 15:43:59 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1nCN39-001Jns-0U; Tue, 25 Jan 2022 15:43:59 +0100
Date:   Tue, 25 Jan 2022 15:43:56 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     linux-pwm@vger.kernel.org, thierry.reding@gmail.com,
        lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        andrey@lebedev.lt, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] pwm-sun4i: convert "next_period" to local variable
Message-ID: <20220125144356.zofft3jd4ov564gd@pengutronix.de>
References: <20220125123429.3490883-1-max.kellermann@gmail.com>
 <20220125143158.qbelqvr5mjq33zay@pengutronix.de>
 <YfALlLgo3MAcbFrZ@swift.blarg.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="2tr2cnvnwymsukbg"
Content-Disposition: inline
In-Reply-To: <YfALlLgo3MAcbFrZ@swift.blarg.de>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--2tr2cnvnwymsukbg
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 25, 2022 at 03:39:16PM +0100, Max Kellermann wrote:
> On 2022/01/25 15:31, Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de> =
wrote:
> > I think I'd drop this. This isn't a fix worth on it's own to be
> > backported and if this is needed for one of the next patches, the stable
> > maintainers will notice themselves (and it might be worth to shuffle
> > this series to make the fixes come first).
>=20
> The first two patches are preparation for the third patch, which fixes
> the actual bug.
>=20
> Of course, I could have done everything in one patch, but I thought
> splitting the first two out makes review easier.  This way, every step
> is almost trivial.
>=20
> If you want me to fold the three patches into one, I can do that.  But
> I can't reorder them (or backport only the bug fix to stable).

That sounds fine. Note my statement "I'd drop this" only refers to the
Cc: stable line.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--2tr2cnvnwymsukbg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmHwDKkACgkQwfwUeK3K
7An5GggAgauWhA0u9+PUGQow7LIjuLcOmmqR5fZWPNxeM+6iNujkn9jpHGaIcx60
Ibf7pV4uAB05bXJz08LRNocUBDqvsGk0/o1SpqixiRuZ5l9NOvc1SEwpoiePfzjx
XmYvy+rjk1DjrAt4f2+jQyEmj7GT/lGkldHBZQXHvP6FQSBvxQbu0rTMYEAjR378
85qnSKiNKf1R8gixkqTljnLYKjM9KeDyh7H4EkFByLP6e0vbNoysslHxiVGVudpy
8W+s84Xf08JwoE3EW0vvT4yKXjeSb8x8kZT+MV383F0qQBQh8Fx19baBqUCRb5mk
8haO/OWNH2t1MDpkmJzYCKr4995mmA==
=FZEp
-----END PGP SIGNATURE-----

--2tr2cnvnwymsukbg--

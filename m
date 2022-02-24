Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB9014C320F
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 17:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbiBXQuz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Feb 2022 11:50:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231131AbiBXQum (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Feb 2022 11:50:42 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 248422023B1
        for <stable@vger.kernel.org>; Thu, 24 Feb 2022 08:49:41 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1nNHIu-0000ql-Hk; Thu, 24 Feb 2022 17:49:20 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1nNHIu-00138R-1I; Thu, 24 Feb 2022 17:49:19 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1nNHIs-005Gmk-Jb; Thu, 24 Feb 2022 17:49:18 +0100
Date:   Thu, 24 Feb 2022 17:49:18 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Thierry Reding <thierry.reding@gmail.com>
Cc:     Max Kellermann <max.kellermann@gmail.com>,
        linux-pwm@vger.kernel.org, lee.jones@linaro.org,
        linux-kernel@vger.kernel.org, andrey@lebedev.lt,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/3] pwm-sun4i: convert "next_period" to local variable
Message-ID: <20220224164918.ycdjmfsqqasehzks@pengutronix.de>
References: <20220125123429.3490883-1-max.kellermann@gmail.com>
 <20220125143158.qbelqvr5mjq33zay@pengutronix.de>
 <YheCV0RKJcB/ppCn@orome>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="qlqvaaqanoepdo5f"
Content-Disposition: inline
In-Reply-To: <YheCV0RKJcB/ppCn@orome>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--qlqvaaqanoepdo5f
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 24, 2022 at 02:04:23PM +0100, Thierry Reding wrote:
> On Tue, Jan 25, 2022 at 03:31:58PM +0100, Uwe Kleine-K=F6nig wrote:
> > Hello,
> >=20
> > On Tue, Jan 25, 2022 at 01:34:27PM +0100, Max Kellermann wrote:
> > > Its value is calculated in sun4i_pwm_apply() and is used only there.
> > >=20
> > > Cc: stable@vger.kernel.org
> >=20
> > I think I'd drop this. This isn't a fix worth on it's own to be
> > backported and if this is needed for one of the next patches, the stable
> > maintainers will notice themselves (and it might be worth to shuffle
> > this series to make the fixes come first).
> >=20
> > > Signed-off-by: Max Kellermann <max.kellermann@gmail.com>
> >=20
> > Other than that, LGTM:
> >=20
> > Reviewed-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
>=20
> Does that apply to patches 2 & 3 as well?

No, at that time I only looked at patch 1.

I just looked at 2 and 3 and will reply to them individually.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--qlqvaaqanoepdo5f
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmIXtwsACgkQwfwUeK3K
7AnapAgAg+SjkyiP1o2sdudhtyt/I8k3O97+iBe5pyPY0TLq1NP5yp3vZhqf7NMz
DTGcIrQxmSbQa4/NKXhBbP/78Rc+5PIYJhYYxUBk50IX98DHegOIYP1IqMv8X4DF
mlNGshVaFj+kbUnSVoLYqjrbCcV9DD2XLJRt4E7F5qGQuLSES4uzpud03Pa9XkzU
E+U9m045ILyAxjXXbS1Que16WcYxvo1cdDo4cvQM9lhGQKCY7iobmSykBTR3SVhW
F5XCQb+0TZ9lBSGlzeE5FHKpRP8387mMfYA97G03pUGx+n409affOSB5sWS5uBBY
oG5GnrIdRe2evQEXH+xwLz+6S7LN7A==
=vqBF
-----END PGP SIGNATURE-----

--qlqvaaqanoepdo5f--

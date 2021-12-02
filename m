Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40B4C466752
	for <lists+stable@lfdr.de>; Thu,  2 Dec 2021 16:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359146AbhLBP6N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Dec 2021 10:58:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359275AbhLBP6A (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Dec 2021 10:58:00 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89A6AC06174A
        for <stable@vger.kernel.org>; Thu,  2 Dec 2021 07:54:37 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1msoPr-00070h-DI; Thu, 02 Dec 2021 16:54:35 +0100
Received: from pengutronix.de (2a03-f580-87bc-d400-d636-361b-782d-7914.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:d636:361b:782d:7914])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 9452C6BAEA1;
        Thu,  2 Dec 2021 15:54:33 +0000 (UTC)
Date:   Thu, 2 Dec 2021 16:54:32 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, stable@vger.kernel.org,
        Zhang Changzhong <zhangchangzhong@huawei.com>
Subject: Re: [PATCH v1] can: j1939: j1939_tp_cmd_recv(): check the dst
 address of TP.CM_BAM
Message-ID: <20211202155432.pir2rihyhxo7xibm@pengutronix.de>
References: <20211201102549.3079360-1-o.rempel@pengutronix.de>
 <Yajnz5OhwHyCfFaq@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="e5q6td5gara5vgyt"
Content-Disposition: inline
In-Reply-To: <Yajnz5OhwHyCfFaq@kroah.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--e5q6td5gara5vgyt
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 02.12.2021 16:35:43, Greg KH wrote:
> On Wed, Dec 01, 2021 at 11:25:49AM +0100, Oleksij Rempel wrote:
> > From: Zhang Changzhong <zhangchangzhong@huawei.com>
> >=20
> > commit 164051a6ab5445bd97f719f50b16db8b32174269 upstream.
> >=20
> > The TP.CM_BAM message must be sent to the global address [1], so add a
> > check to drop TP.CM_BAM sent to a non-global address.
> >=20
> > Without this patch, the receiver will treat the following packets as
> > normal RTS/CTS transport:
> > 18EC0102#20090002FF002301
> > 18EB0102#0100000000000000
> > 18EB0102#020000FFFFFFFFFF
> >=20
> > [1] SAE-J1939-82 2015 A.3.3 Row 1.
> >=20
> > Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
> > Link: https://lore.kernel.org/all/1635431907-15617-4-git-send-email-zha=
ngchangzhong@huawei.com
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> > Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> > ---
> > changes:
> >  - rebase against v5.10.82
>=20
> Now queued up, thanks!  Can you also do this for 5.4.y?

Here you go:
https://lore.kernel.org/all/20211202155256.2405492-1-mkl@pengutronix.de

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--e5q6td5gara5vgyt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmGo7DYACgkQqclaivrt
76mVzwf9F3/YIi/vh0U7vlpT7mswXufFhONGvFjFkGQfpNZdrtrXzbYBdDqLrmB1
3ZbZsu4z3xR+gTP+F8zGBJS2of2P/RkbQG2V/gMAMx4wgiI5SCng/+yZtv0SQxUI
4Uvpq4iWw/FAXYmI8iR8lo709jsjnrxV9lHy+QZNhdovKHl9pv1CnI8JzF7C5eQS
K+yFtXkbkA8yPbClYD9yb647UpcmKpLUHnIMJkAV+xlIMEYa7rkTI/rNoXK4BUDm
TKXfQH/cPP8NLH5tcDqpWE8NHu4yg2Lup+LBykJ7dyTOqfkAAHIypvAcdYhFiKnf
k68dX6pA7ABrqrHngjQS74QyVNHMlw==
=W0Is
-----END PGP SIGNATURE-----

--e5q6td5gara5vgyt--

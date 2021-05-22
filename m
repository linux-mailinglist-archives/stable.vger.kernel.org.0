Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B82238D65F
	for <lists+stable@lfdr.de>; Sat, 22 May 2021 17:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbhEVPiV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 May 2021 11:38:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231206AbhEVPiU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 May 2021 11:38:20 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E79AFC061574
        for <stable@vger.kernel.org>; Sat, 22 May 2021 08:36:54 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lkTgB-0002II-Aj; Sat, 22 May 2021 17:36:44 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:99ad:3825:19a7:30b2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id DCFFE6296AD;
        Sat, 22 May 2021 15:36:37 +0000 (UTC)
Date:   Sat, 22 May 2021 17:36:36 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Francois Gervais <fgervais@distech-controls.com>,
        linux-rtc@vger.kernel.org,
        Michael McCormick <michael.mccormick@enatel.net>,
        Alessandro Zummo <a.zummo@towertech.it>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] rtc: pcf85063: fallback to parent of_node
Message-ID: <20210522153636.ymyyq4vtzz2dq5k2@pengutronix.de>
References: <20210310211026.27299-1-fgervais@distech-controls.com>
 <161861118020.865088.6364463756780633947.b4-ty@bootlin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="pzbk4hzqlwyu5qjc"
Content-Disposition: inline
In-Reply-To: <161861118020.865088.6364463756780633947.b4-ty@bootlin.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--pzbk4hzqlwyu5qjc
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Greg,

On 17.04.2021 00:16:40, Alexandre Belloni wrote:
> On Wed, 10 Mar 2021 16:10:26 -0500, Francois Gervais wrote:
> > The rtc device node is always or at the very least can possibly be NULL.
> >=20
> > Since v5.12-rc1-dontuse/3c9ea42802a1fbf7ef29660ff8c6e526c58114f6 this
> > will lead to a NULL pointer dereference.
> >=20
> > To fix this we fallback to using the parent node which is the i2c client
> > node as set by devm_rtc_allocate_device().
> >=20
> > [...]
>=20
> Applied, thanks!
>=20
> [1/1] rtc: pcf85063: fallback to parent of_node
>       commit: 03531606ef4cda25b629f500d1ffb6173b805c05
>=20
> I made the fallback unconditionnal because this should have been that way=
 from
> the beginning as you point out.

can you queue this for stable, as it causes a NULL Pointer deref with
(at least) v5.12.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--pzbk4hzqlwyu5qjc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmCpJQAACgkQqclaivrt
76k/iQf/QcxlRhflnlSiP8ESURfSgR8O5+8RvqZAMRJwn9Bl5DOCgwjmD+GjEaC0
HJGRgPs7k7K9sDq9UrwViBsvaaLK2FbSL9HcNjIdOB/NYOKj/XNv2PepyCq57vEZ
dv829GdChEtxsqsJYwDbEDyAhXSF2B1GksCllxuEx+Wv79vYoOvlueVGbshJSYMS
U5pZCDNV5CLNbb3I7pNEZDOIh6CshU1MYSHqgnQonVBMY8AM9Wamsl5ZIIHkUP1h
ctLcXwpIwQK3fa3SB2dgXDxeipl24BXhfwMkUwxdFNV6YzzpXbNpbM+RmtvCfAaX
/4kfTwMtRO5dCk4eT+uz+N+WFt6/4w==
=3mQB
-----END PGP SIGNATURE-----

--pzbk4hzqlwyu5qjc--

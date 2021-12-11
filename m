Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18C624716C1
	for <lists+stable@lfdr.de>; Sat, 11 Dec 2021 22:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbhLKVat (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Dec 2021 16:30:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbhLKVas (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Dec 2021 16:30:48 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 610E7C061714
        for <stable@vger.kernel.org>; Sat, 11 Dec 2021 13:30:48 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mw9x7-0007VH-Vr; Sat, 11 Dec 2021 22:30:46 +0100
Received: from pengutronix.de (2a03-f580-87bc-d400-f0ff-1fb6-7598-46d7.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:f0ff:1fb6:7598:46d7])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 594536C2051;
        Sat, 11 Dec 2021 21:30:45 +0000 (UTC)
Date:   Sat, 11 Dec 2021 22:30:44 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     gregkh@linuxfoundation.org
Cc:     brian.silverman@bluerivertech.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] can: m_can: Disable and ignore ELO
 interrupt" failed to apply to 5.10-stable tree
Message-ID: <20211211213044.kjgpp7kkfn7kdc3k@pengutronix.de>
References: <163913603815470@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="6s57pkeudz4w3dy6"
Content-Disposition: inline
In-Reply-To: <163913603815470@kroah.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--6s57pkeudz4w3dy6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 10.12.2021 12:33:58, gregkh@linuxfoundation.org wrote:
>=20
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here you are:

https://lore.kernel.org/all/20211211213011.813419-1-mkl@pengutronix.de

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--6s57pkeudz4w3dy6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmG1GIEACgkQqclaivrt
76kZ6gf9GkbQb8+Brk04W9nJ3Jvq4zTQbFuRGg2IyPPi7FFmuM8jSeKloFYjGZDT
rylkGuPNP7GUNmVsBC/oWvz4QLl3Nvu5SxdmvDxePc2DapvtgcBXlXo7eC+b70xy
AzOFERUwHhJ6nzMr0jQqm7JaRACEr9FPiTtzSlUBwLV47DFC5m2f2vD3lqw9WBS/
kGvXIonsCUI0HCtlECAIghXwhqqDWLhTteisupeuYCY2Q2L9hoLi625Xx6LrbtN+
43S3Z+gmL65cGw9j9en1XU8/MVkGjMx1qcVbDqupgP6tAUmUSB7jIViwvM6v7xZK
99YtMbL8vYBR9uc8pZPBpqLd0ZzlOQ==
=keTi
-----END PGP SIGNATURE-----

--6s57pkeudz4w3dy6--

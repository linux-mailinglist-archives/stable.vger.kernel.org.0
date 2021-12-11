Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A02F74716B5
	for <lists+stable@lfdr.de>; Sat, 11 Dec 2021 22:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbhLKVYM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Dec 2021 16:24:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbhLKVYM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Dec 2021 16:24:12 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1763BC061714
        for <stable@vger.kernel.org>; Sat, 11 Dec 2021 13:24:12 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mw9qk-00075x-Gn; Sat, 11 Dec 2021 22:24:10 +0100
Received: from pengutronix.de (2a03-f580-87bc-d400-f0ff-1fb6-7598-46d7.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:f0ff:1fb6:7598:46d7])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id AE0DD6C2004;
        Sat, 11 Dec 2021 21:24:09 +0000 (UTC)
Date:   Sat, 11 Dec 2021 22:24:08 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     gregkh@linuxfoundation.org
Cc:     mailhol.vincent@wanadoo.fr, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] can: pch_can: pch_can_rx_normal: fix use
 after free" failed to apply to 5.10-stable tree
Message-ID: <20211211212408.sby6kj62gysufr53@pengutronix.de>
References: <16391359271643@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="s34eo4r5mro2gkzs"
Content-Disposition: inline
In-Reply-To: <16391359271643@kroah.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--s34eo4r5mro2gkzs
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 10.12.2021 12:32:07, gregkh@linuxfoundation.org wrote:
>=20
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here you are:

https://lore.kernel.org/all/20211211212306.797338-1-mkl@pengutronix.de

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--s34eo4r5mro2gkzs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmG1FvUACgkQqclaivrt
76kNBwf/Qg1MEM3baNJS032LHw277AR+qLs4rnUby8iEBeZDuGSE+jFBoezd2eaI
OOmYTmFvcAXx+3ZVS9rMA2w6V8jr2G8Yvt2TlTS4gPCiWeGnLSbL+3Lcez6aKYI5
qh21OrQ+VnAYEWeyZfM2cWG2uleYHhYPIsNtLXD6Ot/t7lw0j9foS9zHUa8wSN2t
xMfPq/0YcrlMI1PFSZIXkfE2njJQpqR0pmsqtTzgJ84zHArtOwW0bDXRXk+nZSYo
afisSLa51ViJ61o5a8ENgocDh4Kf4Gx8HSJ70MWz5l77QekQQynS7fa+kUEPRrI1
LRJWmAKHF28c0kgnPh8qMwFGpBGbww==
=WdgZ
-----END PGP SIGNATURE-----

--s34eo4r5mro2gkzs--

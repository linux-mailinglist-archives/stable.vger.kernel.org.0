Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD17A354375
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 17:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238106AbhDEPah (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 11:30:37 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:43944 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232714AbhDEPag (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 11:30:36 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id A1A401C0B81; Mon,  5 Apr 2021 17:30:29 +0200 (CEST)
Date:   Mon, 5 Apr 2021 17:30:29 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 039/126] can: dev: move driver related
 infrastructure into separate subdir
Message-ID: <20210405153029.GB32232@amd>
References: <20210405085031.040238881@linuxfoundation.org>
 <20210405085032.339701089@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="lEGEL1/lMxI0MVQ2"
Content-Disposition: inline
In-Reply-To: <20210405085032.339701089@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--lEGEL1/lMxI0MVQ2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Marc Kleine-Budde <mkl@pengutronix.de>
>=20
> [ Upstream commit 3e77f70e734584e0ad1038e459ed3fd2400f873a ]
>=20
> This patch moves the CAN driver related infrastructure into a separate su=
bdir.
> It will be split into more files in the coming patches.

I don't think this is suitable for stable. I don't think any of the
follow up patches depend on it...?

Best regards,
								Pavel

>  drivers/net/can/Makefile               | 7 +------
>  drivers/net/can/dev/Makefile           | 7 +++++++
>  drivers/net/can/{ =3D> dev}/dev.c        | 0
>  drivers/net/can/{ =3D> dev}/rx-offload.c | 0

--=20
http://www.livejournal.com/~pavelmachek

--lEGEL1/lMxI0MVQ2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmBrLRQACgkQMOfwapXb+vLz2QCfQi57uvjSLOc0libOSz6A+Ox6
hb8Anj+y8PiT1bKf7tNq7B4i2+Fw4UIG
=O/ji
-----END PGP SIGNATURE-----

--lEGEL1/lMxI0MVQ2--

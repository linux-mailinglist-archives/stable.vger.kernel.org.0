Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FCEC10463B
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 22:59:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725820AbfKTV7I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 16:59:08 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:57234 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfKTV7I (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Nov 2019 16:59:08 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 0972C1C1AB8; Wed, 20 Nov 2019 22:59:06 +0100 (CET)
Date:   Wed, 20 Nov 2019 22:59:05 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 065/422] ice: Fix and update driver version string
Message-ID: <20191120215905.GB23361@duo.ucw.cz>
References: <20191119051400.261610025@linuxfoundation.org>
 <20191119051403.893600135@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="v9Ux+11Zm5mwPlX6"
Content-Disposition: inline
In-Reply-To: <20191119051403.893600135@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--v9Ux+11Zm5mwPlX6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2019-11-19 06:14:22, Greg Kroah-Hartman wrote:
> From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
>=20
> [ Upstream commit 9ea47d81a7f17c6b77211ab75fbca2127719ad39 ]
>=20
> Remove the "ice" prefix for the driver version string and bump version
> to 0.7.1-k.

This sounds like a bad idea. 0.7.1 in mainline contains patches that
were not backported to stable, so marking this as 0.7.1 version is
wrong.

Best regards,
								Pavel
							=09
> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> @@ -7,7 +7,7 @@
> =20
>  #include "ice.h"
> =20
> -#define DRV_VERSION	"ice-0.7.0-k"
> +#define DRV_VERSION	"0.7.1-k"
>  #define DRV_SUMMARY	"Intel(R) Ethernet Connection E800 Series Linux Driv=
er"
>  const char ice_drv_ver[] =3D DRV_VERSION;
>  static const char ice_driver_string[] =3D DRV_SUMMARY;
> --=20
> 2.20.1
>=20
>=20

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--v9Ux+11Zm5mwPlX6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXdW3KQAKCRAw5/Bqldv6
8qbnAJ95jYlYKQb49gcVOUCqafkEAwA+1QCcCZYdh2nFht8OZK4E+HFamL/WskI=
=Uf/9
-----END PGP SIGNATURE-----

--v9Ux+11Zm5mwPlX6--

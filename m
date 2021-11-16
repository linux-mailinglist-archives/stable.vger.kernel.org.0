Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A08745319C
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 13:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235578AbhKPMEI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 07:04:08 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:57250 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235807AbhKPMDW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 07:03:22 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 933DD1C0BA4; Tue, 16 Nov 2021 13:00:24 +0100 (CET)
Date:   Tue, 16 Nov 2021 13:00:23 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Lad Prabhakar <prabhakar.csengg@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 294/575] media: i2c: ths8200 needs V4L2_ASYNC
Message-ID: <20211116120023.GB24443@amd>
References: <20211115165343.579890274@linuxfoundation.org>
 <20211115165353.946824789@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="aM3YZ0Iwxop3KEKx"
Content-Disposition: inline
In-Reply-To: <20211115165353.946824789@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--aM3YZ0Iwxop3KEKx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!
>=20
> [ Upstream commit e4625044d656f3c33ece0cc9da22577bc10ca5d3 ]
>=20
> Fix the build errors reported by the kernel test robot by
> selecting V4L2_ASYNC:
>=20
> mips-linux-ld: drivers/media/i2c/ths8200.o: in function `ths8200_remove':
> ths8200.c:(.text+0x1ec): undefined reference to `v4l2_async_unregister_su=
bdev'
> mips-linux-ld: drivers/media/i2c/ths8200.o: in function `ths8200_probe':
> ths8200.c:(.text+0x404): undefined reference to
`v4l2_async_register_subdev'

CONFIG_V4L2_ASYNC is not present in 5.10 kernel, this is should not be
applied here.

Best regards,
								Pavel

> +++ b/drivers/media/i2c/Kconfig
> @@ -595,6 +595,7 @@ config VIDEO_AK881X
>  config VIDEO_THS8200
>  	tristate "Texas Instruments THS8200 video encoder"
>  	depends on VIDEO_V4L2 && I2C
> +	select V4L2_ASYNC
>  	help
>  	  Support for the Texas Instruments THS8200 video encoder.
> =20

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--aM3YZ0Iwxop3KEKx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmGTnVcACgkQMOfwapXb+vJDCwCeP3cYMN8dSWkFt1LXiG09YUct
kXcAn0D00fraAMBHM6atroWXdiWx3pyw
=Dzbo
-----END PGP SIGNATURE-----

--aM3YZ0Iwxop3KEKx--

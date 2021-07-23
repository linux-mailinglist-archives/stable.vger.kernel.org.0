Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F2183D414E
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 22:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbhGWTad (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 15:30:33 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:38990 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbhGWTac (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Jul 2021 15:30:32 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 4EE821C0B88; Fri, 23 Jul 2021 22:11:04 +0200 (CEST)
Date:   Fri, 23 Jul 2021 22:11:04 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mian Yousaf Kaukab <ykaukab@suse.de>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 31/39] arm64: dts: ls208xa: remove bus-num
 from dspi node
Message-ID: <20210723201104.GC22684@duo.ucw.cz>
References: <20210714194625.55303-1-sashal@kernel.org>
 <20210714194625.55303-31-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="4jXrM3lyYWu4nBt5"
Content-Disposition: inline
In-Reply-To: <20210714194625.55303-31-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--4jXrM3lyYWu4nBt5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit 8240c972c1798ea013cbb407722295fc826b3584 ]
>=20
> On LS2088A-RDB board, if the spi-fsl-dspi driver is built as module
> then its probe fails with the following warning:
>=20
> [   10.471363] couldn't get idr
> [   10.471381] WARNING: CPU: 4 PID: 488 at drivers/spi/spi.c:2689 spi_reg=
ister_controller+0x73c/0x8d0
> ...
> [   10.471651] fsl-dspi 2100000.spi: Problem registering DSPI ctlr
> [   10.471708] fsl-dspi: probe of 2100000.spi failed with error -16
>=20
> Reason for the failure is that bus-num property is set for dspi node.
> However, bus-num property is not set for the qspi node. If probe for
> spi-fsl-qspi happens first then id 0 is dynamically allocated to it.
> Call to spi_register_controller() from spi-fsl-dspi driver then fails.
> Since commit 29d2daf2c33c ("spi: spi-fsl-dspi: Make bus-num property
> optional") bus-num property is optional. Remove bus-num property from
> dspi node to fix the issue.

According to changelog this depends on 29d2daf2c33c. Than one is
present in 5.10-stable, but not in 4.19-stable, AFAICT.

Best regards,
								Pavel

> +++ b/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi
> @@ -479,7 +479,6 @@ dspi: spi@2100000 {
>  			clocks =3D <&clockgen 4 3>;
>  			clock-names =3D "dspi";
>  			spi-num-chipselects =3D <5>;
> -			bus-num =3D <0>;
>  		};
> =20
>  		esdhc: esdhc@2140000 {

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--4jXrM3lyYWu4nBt5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYPsiWAAKCRAw5/Bqldv6
8h5oAJ9lBrVSGmwOWXAuOS9iE1zT6+ykXACeJoTOYLzfZQHLTA/Xlwbyk7vzCuw=
=86RN
-----END PGP SIGNATURE-----

--4jXrM3lyYWu4nBt5--

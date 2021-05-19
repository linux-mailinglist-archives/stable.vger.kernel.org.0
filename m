Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF393897A6
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 22:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbhESUOc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 May 2021 16:14:32 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:56860 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbhESUO2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 May 2021 16:14:28 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 1F6161C0B82; Wed, 19 May 2021 22:13:07 +0200 (CEST)
Date:   Wed, 19 May 2021 22:13:05 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Wolfram Sang <wsa@kernel.org>,
        Bence =?iso-8859-1?B?Q3Pza+Fz?= <bence98@sch.bme.hu>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 041/289] i2c: Add I2C_AQ_NO_REP_START adapter quirk
Message-ID: <20210519201305.GB14212@amd>
References: <20210517140305.140529752@linuxfoundation.org>
 <20210517140306.584198139@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="zx4FCpZtqtKETZ7O"
Content-Disposition: inline
In-Reply-To: <20210517140306.584198139@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--zx4FCpZtqtKETZ7O
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon 2021-05-17 15:59:26, Greg Kroah-Hartman wrote:
> From: Bence Cs=F3k=E1s <bence98@sch.bme.hu>
>=20
> [ Upstream commit aca01415e076aa96cca0f801f4420ee5c10c660d ]
>=20
> This quirk signifies that the adapter cannot do a repeated
> START, it always issues a STOP condition after transfers.
>=20
> Suggested-by: Wolfram Sang <wsa@kernel.org>
> Signed-off-by: Bence Cs=F3k=E1s <bence98@sch.bme.hu>
> Signed-off-by: Wolfram Sang <wsa@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Why is this pushed to 5.10 and 4.19? The define is not used anywhere
AFAICT.

Best regards,
							Pavel
						=09
> +++ b/include/linux/i2c.h
> @@ -687,6 +687,8 @@ struct i2c_adapter_quirks {
> +/* adapter cannot do repeated START */
> +#define I2C_AQ_NO_REP_START		BIT(7)

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--zx4FCpZtqtKETZ7O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmClcVEACgkQMOfwapXb+vKuwACaAxInM4XGAjXPEdx+0ilIh1gq
bpYAnjPLbgfaMCiTVemw1FAOCx9eseDJ
=lw2y
-----END PGP SIGNATURE-----

--zx4FCpZtqtKETZ7O--

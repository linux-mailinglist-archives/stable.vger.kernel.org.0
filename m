Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2F0F3C65AA
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 23:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbhGLVvs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 17:51:48 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:45824 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbhGLVvr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Jul 2021 17:51:47 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 93F431C0B77; Mon, 12 Jul 2021 23:48:57 +0200 (CEST)
Date:   Mon, 12 Jul 2021 23:48:57 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>, linux-leds@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.10 01/93] leds: tlc591xx: fix return value
 check in tlc591xx_probe()
Message-ID: <20210712214856.GA8934@amd>
References: <20210710022428.3169839-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="1yeeQ81UyVL57Vl7"
Content-Disposition: inline
In-Reply-To: <20210710022428.3169839-1-sashal@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit ee522bcf026ec82ada793979c3a906274430595a ]
>=20
> After device_get_match_data(), tlc591xx is not checked, add
> check for it and also check np after dev_of_node.
>=20
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

This was found by code review, is not known to cause real problems,
and received very little testing. Please drop it from stable.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--1yeeQ81UyVL57Vl7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmDsuMgACgkQMOfwapXb+vJAWQCfXdiWKQHNFpcbXCQMJlUlCZ4e
30IAoIyrTB1ryOjspzSQBws3TdZSITNs
=mxED
-----END PGP SIGNATURE-----

--1yeeQ81UyVL57Vl7--

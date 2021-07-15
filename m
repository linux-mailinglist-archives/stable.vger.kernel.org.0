Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B25E3C9AD4
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 10:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240777AbhGOIsT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 04:48:19 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:46396 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbhGOIsS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Jul 2021 04:48:18 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 013E91C0B96; Thu, 15 Jul 2021 10:45:24 +0200 (CEST)
Date:   Thu, 15 Jul 2021 10:45:24 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jian Shen <shenjian15@huawei.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH AUTOSEL 4.19 35/55] net: fix mistake path for
 netdev_features_strings
Message-ID: <20210715084524.GA29090@amd>
References: <20210706112638.2065023-1-sashal@kernel.org>
 <20210706112638.2065023-35-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Content-Disposition: inline
In-Reply-To: <20210706112638.2065023-35-sashal@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Jian Shen <shenjian15@huawei.com>
>=20
> [ Upstream commit 2d8ea148e553e1dd4e80a87741abdfb229e2b323 ]
>=20
> Th_strings arrays netdev_features_strings, tunable_strings, and
> phy_tunable_strings has been moved to file net/ethtool/common.c.
> So fixes the comment.

This patch is incorrect for 4.19, as is still uses original filename,
not "net/ethtool/common.c".

[Plus it really should not be suitable for any stable release according
to our rules.]

Best regards,
								Pavel

> +++ b/include/linux/netdev_features.h
> @@ -88,7 +88,7 @@ enum {
> =20
>  	/*
>  	 * Add your fresh new feature above and remember to update
> -	 * netdev_features_strings[] in net/core/ethtool.c and maybe
> +	 * netdev_features_strings[] in net/ethtool/common.c and maybe
>  	 * some feature mask #defines below. Please also describe it
>  	 * in Documentation/networking/netdev-features.txt.
>  	 */

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--DocE+STaALJfprDB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmDv9aMACgkQMOfwapXb+vIvlACfQn5wS6a993KLaoI2U66pTtIA
UwEAn3r/YIffEeGFZiu59272Dusx0YVc
=/hUI
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--

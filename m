Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C17EA31D22C
	for <lists+stable@lfdr.de>; Tue, 16 Feb 2021 22:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbhBPVgH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Feb 2021 16:36:07 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:59904 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbhBPVgG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Feb 2021 16:36:06 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 2BA151C0B9E; Tue, 16 Feb 2021 22:35:09 +0100 (CET)
Date:   Tue, 16 Feb 2021 22:35:08 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 5.10 098/104] switchdev: mrp: Remove
 SWITCHDEV_ATTR_ID_MRP_PORT_STAT
Message-ID: <20210216213508.GA32671@amd>
References: <20210215152719.459796636@linuxfoundation.org>
 <20210215152722.633343806@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
In-Reply-To: <20210215152722.633343806@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Horatiu Vultur <horatiu.vultur@microchip.com>
>=20
> commit 059d2a1004981dce19f0127dabc1b4ec927d202a upstream.
>=20
> Now that MRP started to use also SWITCHDEV_ATTR_ID_PORT_STP_STATE to
> notify HW, then SWITCHDEV_ATTR_ID_MRP_PORT_STAT is not used anywhere
> else, therefore we can remove it.

Are you sure this is suitable for 5.10 backport? Unlike mainline,
net/bridge use is not removed, so this will cause compile problem...?

pavel@amd:~/cip/krc$ grep -ri SWITCHDEV_ATTR_ID_MRP_PORT_STATE .
=2E/include/net/switchdev.h:    SWITCHDEV_ATTR_ID_MRP_PORT_STATE,
=2E/net/bridge/br_mrp_switchdev.c:		.id =3D SWITCHDEV_ATTR_ID_MRP_PORT_STAT=
E,
pavel@amd:~/cip/krc$ e ./net/bridge/br_mrp_switchdev.c

Best regards,
								Pavel

> --- a/include/net/switchdev.h
> +++ b/include/net/switchdev.h
> @@ -41,7 +41,6 @@ enum switchdev_attr_id {
>  	SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED,
>  	SWITCHDEV_ATTR_ID_BRIDGE_MROUTER,
>  #if IS_ENABLED(CONFIG_BRIDGE_MRP)
> -	SWITCHDEV_ATTR_ID_MRP_PORT_STATE,
>  	SWITCHDEV_ATTR_ID_MRP_PORT_ROLE,
>  #endif
>  };

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmAsOowACgkQMOfwapXb+vKVJQCcDIcS2WwINzf5ghcr5730FQh0
LIUAnRcLy99KXw1KpKNj4itKHCP2Wju/
=Z9wu
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--

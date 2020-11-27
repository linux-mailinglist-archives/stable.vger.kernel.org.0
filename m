Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBA082C6D4A
	for <lists+stable@lfdr.de>; Fri, 27 Nov 2020 23:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731595AbgK0Wkj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Nov 2020 17:40:39 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:58310 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732251AbgK0WiW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Nov 2020 17:38:22 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id D8DF71C0B7C; Fri, 27 Nov 2020 23:38:03 +0100 (CET)
Date:   Fri, 27 Nov 2020 23:38:03 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Jiri Kosina <trivial@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        linux-renesas-soc@vger.kernel.org, Pavel Machek <pavel@denx.de>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-kernel@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/5] memory: renesas-rpc-if: Return correct value to
 the caller of rpcif_manual_xfer()
Message-ID: <20201127223803.GA19743@duo.ucw.cz>
References: <20201126191146.8753-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20201126191146.8753-2-prabhakar.mahadev-lad.rj@bp.renesas.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
In-Reply-To: <20201126191146.8753-2-prabhakar.mahadev-lad.rj@bp.renesas.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu 2020-11-26 19:11:42, Lad Prabhakar wrote:
> In the error path of rpcif_manual_xfer() the value of ret is overwritten
> by value returned by reset_control_reset() function and thus returning
> incorrect value to the caller.
>=20
> This patch makes sure the correct value is returned to the caller of
> rpcif_manual_xfer() by dropping the overwrite of ret in error path.
> Also now we ignore the value returned by reset_control_reset() in the
> error path and instead print a error message when it fails.
>=20
> Fixes: ca7d8b980b67f ("memory: add Renesas RPC-IF driver")
> Reported-by: Pavel Machek <pavel@denx.de>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Cc: stable@vger.kernel.org
> Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>

Reviewed-by: Pavel Machek (CIP) <pavel@denx.de>

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX8F/ywAKCRAw5/Bqldv6
8sJlAJ9fTid4o1km6GdynHQGgwdTjZ+VGgCgl/kASNL5bG8vz5uJ1VZMGINCKxo=
=vOP0
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--

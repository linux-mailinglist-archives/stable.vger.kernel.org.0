Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4C74AFD39
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 20:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbiBITSH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 14:18:07 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:52720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbiBITSH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 14:18:07 -0500
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [IPv6:2a00:da80:fff0:2::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4C3BC1DC076;
        Wed,  9 Feb 2022 11:18:00 -0800 (PST)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 7A0EE1C0B9D; Wed,  9 Feb 2022 20:08:47 +0100 (CET)
Date:   Wed, 9 Feb 2022 20:08:46 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 5.10 72/74] net: dsa: mt7530: make NET_DSA_MT7530 select
 MEDIATEK_GE_PHY
Message-ID: <20220209190846.GB10459@duo.ucw.cz>
References: <20220207103757.232676988@linuxfoundation.org>
 <20220207103759.591363633@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="nVMJ2NtxeReIH9PS"
Content-Disposition: inline
In-Reply-To: <20220207103759.591363633@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--nVMJ2NtxeReIH9PS
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc9.com>
>=20
> commit 4223f86512877b04c932e7203648b37eec931731 upstream.
>=20
> Make MediaTek MT753x DSA driver enable MediaTek Gigabit PHYs driver to
> properly control MT7530 and MT7531 switch PHYs.
>=20
> A noticeable change is that the behaviour of switchport interfaces going
> up-down-up-down is no longer there.

This is unsuitable for 5.10 at least:

> +++ b/drivers/net/dsa/Kconfig
> @@ -36,6 +36,7 @@ config NET_DSA_MT7530
>  	tristate "MediaTek MT753x and MT7621 Ethernet switch support"
>  	depends on NET_DSA
>  	select NET_DSA_TAG_MTK
> +	select MEDIATEK_GE_PHY

This symbol does not exist in 5.10.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--nVMJ2NtxeReIH9PS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYgQRPgAKCRAw5/Bqldv6
8jNBAKCLi7o81Oh3+eEX68xMQ6bbp6QmOwCfTdPN8978QiP05Lak6LMh5P/o7Uw=
=Y7q2
-----END PGP SIGNATURE-----

--nVMJ2NtxeReIH9PS--

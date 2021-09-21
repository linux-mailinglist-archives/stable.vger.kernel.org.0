Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3C77413C70
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 23:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235122AbhIUVaH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 17:30:07 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:45534 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235066AbhIUVaH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 17:30:07 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 7162F1C0B76; Tue, 21 Sep 2021 23:28:37 +0200 (CEST)
Date:   Tue, 21 Sep 2021 23:28:37 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 079/122] net: phylink: add suspend/resume support
Message-ID: <20210921212837.GA29170@duo.ucw.cz>
References: <20210920163915.757887582@linuxfoundation.org>
 <20210920163918.373775935@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
In-Reply-To: <20210920163918.373775935@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Joakim Zhang reports that Wake-on-Lan with the stmmac ethernet driver bro=
ke
> when moving the incorrect handling of mac link state out of mac_config().
> This reason this breaks is because the stmmac's WoL is handled by the MAC
> rather than the PHY, and phylink doesn't cater for that scenario.
>=20
> This patch adds the necessary phylink code to handle suspend/resume events
> according to whether the MAC still needs a valid link or not. This is the
> barest minimum for this support.

This adds functions that end up being unused in 5.10. AFAICT we do not
need this in 5.10.

Best regards,
								Pavel


> +++ b/include/linux/phylink.h
> @@ -446,6 +446,9 @@ void phylink_mac_change(struct phylink *, bool up);
>  void phylink_start(struct phylink *);
>  void phylink_stop(struct phylink *);
> =20
> +void phylink_suspend(struct phylink *pl, bool mac_wol);
> +void phylink_resume(struct phylink *pl);
> +
>  void phylink_ethtool_get_wol(struct phylink *, struct ethtool_wolinfo *);
>  int phylink_ethtool_set_wol(struct phylink *, struct ethtool_wolinfo *);


--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYUpOhQAKCRAw5/Bqldv6
8locAJ9DhHBYbh7xMHQhEo+x6kC4HRvZhQCfdY/0GTWDdKSunFC/EFTxWKmc/uw=
=c5Bh
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--

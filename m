Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07F3F28A95F
	for <lists+stable@lfdr.de>; Sun, 11 Oct 2020 20:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbgJKSeM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Oct 2020 14:34:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:57264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725909AbgJKSeL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 11 Oct 2020 14:34:11 -0400
Received: from localhost (unknown [176.207.245.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76A7A2078B;
        Sun, 11 Oct 2020 18:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602441251;
        bh=vQ4BUhZu0KplQhMQGxB4KoIroZ4+H8bJccgyqHjVpAk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hINV7kfxHnVvJ2zXEssTTtOSGfex/EksgQKeDTPwDnsFPQP4kBMWJFJfZPZjW1BLW
         hsudETQI5CaUtofKKBAfGIhWcWN/eOhE6UxohgDmhi9llt9EuEjglVPo24mplUGy1L
         V12/esrQZwaUVY7j9b13EzD0ccCJNkSArWyIEgFA=
Date:   Sun, 11 Oct 2020 20:34:06 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mt76: add back the SUPPORTS_REORDERING_BUFFER flag
Message-ID: <20201011183406.GA3761987@lore-desk>
References: <20201011162040.63714-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
In-Reply-To: <20201011162040.63714-1-nbd@nbd.name>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> It was accidentally dropped while adding multiple wiphy support
> Fixes fast-rx support and avoids handling reordering in both mac80211
> and the driver
>=20
> Cc: stable@vger.kernel.org
> Fixes: c89d36254155 ("mt76: add function for allocating an extra wiphy")
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>

> ---
>  drivers/net/wireless/mediatek/mt76/mac80211.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/=
wireless/mediatek/mt76/mac80211.c
> index a778ecc65261..2bc1ef1cbfea 100644
> --- a/drivers/net/wireless/mediatek/mt76/mac80211.c
> +++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
> @@ -305,6 +305,7 @@ mt76_phy_init(struct mt76_dev *dev, struct ieee80211_=
hw *hw)
>  	ieee80211_hw_set(hw, SUPPORT_FAST_XMIT);
>  	ieee80211_hw_set(hw, SUPPORTS_CLONED_SKBS);
>  	ieee80211_hw_set(hw, SUPPORTS_AMSDU_IN_AMPDU);
> +	ieee80211_hw_set(hw, SUPPORTS_REORDERING_BUFFER);
> =20
>  	if (!(dev->drv->drv_flags & MT_DRV_AMSDU_OFFLOAD)) {
>  		ieee80211_hw_set(hw, TX_AMSDU);
> --=20
> 2.28.0
>=20

--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCX4NQFQAKCRA6cBh0uS2t
rBp2AP9kRzZ//FyGegdR5g+MLPx/hN1/UiKPPRLYEJ9zvy9dRAEAvpsLSFi5y55s
fJjB2gQ6UQrtMmiH2uwkQWxlw/CQLwo=
=TTMs
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--

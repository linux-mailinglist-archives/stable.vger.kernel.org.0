Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 814AC149BED
	for <lists+stable@lfdr.de>; Sun, 26 Jan 2020 17:50:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725944AbgAZQuy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Jan 2020 11:50:54 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:43832 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbgAZQux (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Jan 2020 11:50:53 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 26A661C25AF; Sun, 26 Jan 2020 17:50:52 +0100 (CET)
Date:   Sun, 26 Jan 2020 17:50:51 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 587/639] net: stmmac: gmac4+: Not all Unicast
 addresses may be available
Message-ID: <20200126165051.GC19082@duo.ucw.cz>
References: <20200124093047.008739095@linuxfoundation.org>
 <20200124093202.992850194@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="3siQDZowHQqNOShm"
Content-Disposition: inline
In-Reply-To: <20200124093202.992850194@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--3siQDZowHQqNOShm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Some setups may not have all Unicast addresses filters available. Check
> the number of available filters before trying to setup it.
=2E..
> @@ -443,7 +443,7 @@ static void dwmac4_set_filter(struct mac_device_info =
*hw,
>  	}
> =20
>  	/* Handle multiple unicast addresses */
> -	if (netdev_uc_count(dev) > GMAC_MAX_PERFECT_ADDRESSES) {
> +	if (netdev_uc_count(dev) > hw->unicast_filter_entries) {
>  		/* Switch to promiscuous mode if more than 128 addrs
>  		 * are required
>  		 */

Do I understand correctly that 128 in the comment is no longer
accurate?

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--3siQDZowHQqNOShm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXi3DawAKCRAw5/Bqldv6
8qd5AJ42RQ/LLZFhq53sJOEdpGApoFdcEgCgvbFPsqXIs5KT2TgekSFio4UIP/c=
=d7yK
-----END PGP SIGNATURE-----

--3siQDZowHQqNOShm--

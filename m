Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8005A19BF85
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 12:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387610AbgDBKmv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 06:42:51 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:38236 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728612AbgDBKmu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 06:42:50 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id A65211C2EC0; Thu,  2 Apr 2020 12:42:48 +0200 (CEST)
Date:   Thu, 2 Apr 2020 12:42:48 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 040/116] fsl/fman: detect FMan erratum A050385
Message-ID: <20200402104247.GA31202@duo.ucw.cz>
References: <20200401161542.669484650@linuxfoundation.org>
 <20200401161547.550838813@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="IJpNTDwzlM2Ie8A6"
Content-Disposition: inline
In-Reply-To: <20200401161547.550838813@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Madalin Bucur <madalin.bucur@nxp.com>
>=20
> [ Upstream commit b281f7b93b258ce1419043bbd898a29254d5c9c7 ]
>=20
> Detect the presence of the A050385 erratum.

This and the other two patches... _detect_ the erratum, but there are
no patches that actually use the information. Mainline has such code
(3c68b8fffb48c0018c24e73c48f2bac768c6203e) but it was not queued for
stable.

So all this is simply adding unused code, and not suitable for stable.

Best regards,
								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--IJpNTDwzlM2Ie8A6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXoXBpwAKCRAw5/Bqldv6
8g8KAJ4sTcUFEu2qK1MtG7mlrnTASn460QCeOA68yrcX4ErnCWUH07Y0KUNXjQ0=
=L8Je
-----END PGP SIGNATURE-----

--IJpNTDwzlM2Ie8A6--

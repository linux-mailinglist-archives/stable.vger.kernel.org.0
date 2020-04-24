Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5863C1B7710
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 15:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbgDXNgj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 09:36:39 -0400
Received: from sauhun.de ([88.99.104.3]:47884 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726489AbgDXNgj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Apr 2020 09:36:39 -0400
Received: from localhost (p5486CE62.dip0.t-ipconnect.de [84.134.206.98])
        by pokefinder.org (Postfix) with ESMTPSA id 05ECF2C1FE8;
        Fri, 24 Apr 2020 15:36:36 +0200 (CEST)
Date:   Fri, 24 Apr 2020 15:36:35 +0200
From:   Wolfram Sang <wsa@the-dreams.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.6 28/38] i2c: remove i2c_new_probed_device API
Message-ID: <20200424133635.GB4070@kunai>
References: <20200424122237.9831-1-sashal@kernel.org>
 <20200424122237.9831-28-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="XOIedfhf+7KOe/yw"
Content-Disposition: inline
In-Reply-To: <20200424122237.9831-28-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--XOIedfhf+7KOe/yw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 24, 2020 at 08:22:26AM -0400, Sasha Levin wrote:
> From: Wolfram Sang <wsa+renesas@sang-engineering.com>
>=20
> [ Upstream commit 3c1d1613be80c2e17f1ddf672df1d8a8caebfd0d ]
>=20
> All in-tree users have been converted to the new i2c_new_scanned_device
> function, so remove this deprecated one.
>=20
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

This should not be backported. It is only since this merge window that
all in-tree users are converted!


--XOIedfhf+7KOe/yw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl6i62MACgkQFA3kzBSg
KbbQNBAAtJhXZl6VUNZIu7Dk8NGhFEOvsMgmA1GVLzGWYh0Ev/ipJIN9OX2r26Yc
9M6M1qc2FBJW9n1fTdGK+FrbO/+BCFkrMUOECIyImlSmZ1W+sNyZYhmg1ZQxo2g3
eSobZIV8JzjDhDDV55GdwerVjq0fOmckdD/MjFVtpmcYNsL4P1J//6cVtifn6W5a
eVhj4k9WURYjWQ8I0q6CLn4ys1BjPZ40/HOBAdZU6sG3u3Jqlvavdtoo71LNLYz9
/KEk8fWcYRu8F9FF18PPhJg/C4T8vba2FdQz4rmKzEAdLkckwrsFtIxhFWhA1tZl
SaR2OLNJGO9kUI+vYLOXhNC6LK+XY9SuqLF9z6oVyuICqoVH4Z4ARBi4yl5dT+rZ
sC3pjL7NlJBOomyzt5S0rflnNFE4xDmtoQ0uxeEBLfu+4nyMpSUxdoexH4fp22xF
G50cRTK2rfmV0iawMgnR8JmXi13QVrDX7gp8FvckorSheJ39I8g1jIjU4b8EhQyI
yuWvxIqlp6aw8q2C7J9fIEFogHdsEOIRUvMHNPEbbeTU3v64lj5VW+wPz3la4KFP
JMaU7QnPdoW5kkCjSMxbnosaFx9X/wXXvYMd3r2Fh3ltzmAhyoPa5h30TP2JtCCy
2JlkanjPialjwrH4FBazHSlLImTjdCK5FFfdbBsTYDkTgXXhT8w=
=Skfi
-----END PGP SIGNATURE-----

--XOIedfhf+7KOe/yw--

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 935E03B1F0B
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 18:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbhFWQzr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 12:55:47 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:42480 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbhFWQzq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Jun 2021 12:55:46 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id D71601C0B76; Wed, 23 Jun 2021 18:53:27 +0200 (CEST)
Date:   Wed, 23 Jun 2021 18:53:27 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 038/146] mptcp: do not warn on bad input from the
 network
Message-ID: <20210623165327.GA4150@amd>
References: <20210621154911.244649123@linuxfoundation.org>
 <20210621154912.589676201@linuxfoundation.org>
 <20210623142235.GA27348@amd>
 <254a0b83518083416abdae4cd27659bc10760773.camel@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
In-Reply-To: <254a0b83518083416abdae4cd27659bc10760773.camel@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > From: Paolo Abeni <pabeni@redhat.com>
> > >=20
> > > [ Upstream commit 61e710227e97172355d5f150d5c78c64175d9fb2 ]
> > >=20
> > > warn_bad_map() produces a kernel WARN on bad input coming
> > > from the network. Use pr_debug() to avoid spamming the system
> > > log.
> >=20
> > So... we switched from WARN _ONCE_ to pr_debug, as many times as we
> > detect the problem.
> >=20
> > Should this be pr_debug_once?
>=20
> Thank you for double checking this!
>=20
> In the MPTCP code, we use pr_debug() statements as a debug tool, e.g.
> when enabled, it could print per-packet info with no restriction.=20
>=20
> There are (a few) similar use in the plain TCP code.
>=20
> pr_debug() is not supposed to be enabled on any production system,
> while the WARN_ONCE could trigger automated tools for irrelevant
> network noise.

Correct me if I'm wrong, but I believe pr_debug will result in
messages being stored in the dmesg buffer, even on production
systems.

Best regards,
							Pavel
--=20
http://www.livejournal.com/~pavelmachek

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmDTZwYACgkQMOfwapXb+vLbUACfTkpdQc/zNyx4Zx9cOFG2kmYU
7MYAnjvIgmPHboyiCqxdaPK0XXhSx4I2
=y0g6
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--

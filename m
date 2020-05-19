Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B683B1D95D9
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 14:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728626AbgESMG1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 08:06:27 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:47016 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726949AbgESMG1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 May 2020 08:06:27 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 107141C025A; Tue, 19 May 2020 14:06:26 +0200 (CEST)
Date:   Tue, 19 May 2020 14:06:25 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Stefano Brivio <sbrivio@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 41/80] netfilter: nft_set_rbtree: Introduce and use
 nft_rbtree_interval_start()
Message-ID: <20200519120625.GA8342@amd>
References: <20200518173450.097837707@linuxfoundation.org>
 <20200518173458.612903024@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Content-Disposition: inline
In-Reply-To: <20200518173458.612903024@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit 6f7c9caf017be8ab0fe3b99509580d0793bf0833 ]
>=20
> Replace negations of nft_rbtree_interval_end() with a new helper,
> nft_rbtree_interval_start(), wherever this helps to visualise the
> problem at hand, that is, for all the occurrences except for the
> comparison against given flags in __nft_rbtree_get().
>=20
> This gets especially useful in the next patch.

This looks like cleanup in preparation for the next patch. Next patch
is there for some series, but not for 4.19.124. Should this be in
4.19, then?

Best regards,
								Pavel
							=09
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl7Dy8EACgkQMOfwapXb+vKMeACglJuua3KLDV+n29v1IdzX5+Z5
rhQAnRwxKY8T+VPoAhyhs9QipmJAUiK+
=w+if
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49C4D248213
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 11:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbgHRJlj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 05:41:39 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:48146 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbgHRJlj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Aug 2020 05:41:39 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 6C3F71C0BB6; Tue, 18 Aug 2020 11:41:36 +0200 (CEST)
Date:   Tue, 18 Aug 2020 11:41:35 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 040/168] drm/radeon: disable AGP by default
Message-ID: <20200818094135.GC10974@amd>
References: <20200817143733.692105228@linuxfoundation.org>
 <20200817143735.768643197@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="V88s5gaDVPzZ0KCq"
Content-Disposition: inline
In-Reply-To: <20200817143735.768643197@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--V88s5gaDVPzZ0KCq
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon 2020-08-17 17:16:11, Greg Kroah-Hartman wrote:
> From: Christian K=F6nig <christian.koenig@amd.com>
>=20
> [ Upstream commit ba806f98f868ce107aa9c453fef751de9980e4af ]
>=20
> Always use the PCI GART instead. We just have to many cases
> where AGP still causes problems. This means a performance
> regression for some GPUs, but also a bug fix for some others.

Yes, and the regressions mean this is not suitable for -stable, right?

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--V88s5gaDVPzZ0KCq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl87ok0ACgkQMOfwapXb+vI1twCcCbmk7JCG2L844+59rQVtnMCy
P2wAn2sDw4AS3tdZJMleH5mIAx3M4kIB
=JVX2
-----END PGP SIGNATURE-----

--V88s5gaDVPzZ0KCq--

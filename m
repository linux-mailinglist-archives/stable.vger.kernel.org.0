Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE5F149C62
	for <lists+stable@lfdr.de>; Sun, 26 Jan 2020 19:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727493AbgAZS5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Jan 2020 13:57:06 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:51010 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbgAZS5G (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Jan 2020 13:57:06 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 8F44D1C2453; Sun, 26 Jan 2020 19:57:04 +0100 (CET)
Date:   Sun, 26 Jan 2020 19:57:03 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jonathan Billings <jsbillings@jsbillings.org>,
        David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 325/639] afs: Fix AFS file locking to allow fine
 grained locks
Message-ID: <20200126185703.GB26911@amd>
References: <20200124093047.008739095@linuxfoundation.org>
 <20200124093127.839498079@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="K8nIJk4ghYZn606h"
Content-Disposition: inline
In-Reply-To: <20200124093127.839498079@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--K8nIJk4ghYZn606h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri 2020-01-24 10:28:15, Greg Kroah-Hartman wrote:
> From: David Howells <dhowells@redhat.com>
>=20
> [ Upstream commit 68ce801ffd82e72d5005ab5458e8b9e59f24d9cc ]
>=20
> Fix AFS file locking to allow fine grained locks as some applications, su=
ch
> as firefox, won't work if they can't take such locks on certain state fil=
es
> - thereby preventing the use of kAFS to distribute a home directory.
>=20
> Note that this cannot be made completely functional as the protocol only
> has provision for whole-file locks, so there exists the possibility

Is this suitable for -stable?

"AFS does not support fine-grained locks" is fine and easy to
understand. "AFS pretends it supports locks and hopes for the best for
benefit of firefox"... may be good idea for mainline, but I don't
think it matches -stable criteria.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--K8nIJk4ghYZn606h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl4t4P8ACgkQMOfwapXb+vLwFwCfUbbP5RtR+59gSByjFhKJunBx
wUQAnj0ugFS44DPkt38iQT3IQFA9QQQo
=rQzi
-----END PGP SIGNATURE-----

--K8nIJk4ghYZn606h--

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC186152B
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 16:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbfGGOD4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 10:03:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54860 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726975AbfGGOD4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 10:03:56 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hk7lf-0004oJ-JN; Sun, 07 Jul 2019 15:03:51 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hk7lf-0002dy-Cj; Sun, 07 Jul 2019 15:03:51 +0100
Message-ID: <ef1625b5c6921289e2f87cdbb0101ff6301b2a7d.camel@decadent.org.uk>
Subject: Re: [PATCH 3.16 0/2] Fix FUSE read/write deadlock on stream-like
 files
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Kirill Smelkov <kirr@nexedi.com>, stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Sun, 07 Jul 2019 15:03:45 +0100
In-Reply-To: <20190609135607.9840-1-kirr@nexedi.com>
References: <20190609135607.9840-1-kirr@nexedi.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-mIwC/MMSrvLMA24p43nN"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-mIwC/MMSrvLMA24p43nN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2019-06-09 at 15:41 +0000, Kirill Smelkov wrote:
> Hello stable team,
>=20
> Please consider applying the following 2 patches to Linux-3.16 stable
> tree. The patches fix regression introduced in 3.14 where both read and
> write started to run under lock taken, which resulted in FUSE (and many
> other drivers) deadlocks for cases where stream-like files are used with
> read and write being run simultaneously.
>=20
> Please see complete problem description in upstream commit 10dce8af3422
> ("fs: stream_open - opener for stream-like files so that read and write
> can run simultaneously without deadlock").
>=20
> The actual FUSE fix (upstream commit bbd84f33652f "fuse: Add
> FOPEN_STREAM to use stream_open()") was merged into 5.2 with `Cc:
> stable@vger.kernel.org # v3.14+` mark and is already included into 5.1,
> 5.0 and 4.19 stable trees. However for some reason it is not (yet ?)
> included into 4.14, 4.9, 4.4, 3.18 and 3.16 trees.
>=20
> The patches fix a real problem into which my FUSE filesystem ran, and
> which also likely affects OSSPD (full details are in the patches
> description). Please consider including the fixes into 3.16 (as well as
> into other stable trees - I'm sending corresponding series separately -
> - one per tree).
[...]

I've queued these up for 3.16, thanks.

Ben.

--=20
Ben Hutchings
Time is nature's way of making sure that
everything doesn't happen at once.



--=-mIwC/MMSrvLMA24p43nN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl0h+8EACgkQ57/I7JWG
EQnq9hAAlR7vZ/nErBhetKPo9cqvBuwzcvrDaJZom1x3Ks/kj91MzoAIc4hBdMFc
PtwUcAuBvOkURSDY/M2g1cGWs0gdxzNVHSchXw/C5wYErh01t0YHSOSBU9BW5Klb
QI7bNm4RWZrnQ4CNfReXhfltbo4DzpBTJG1Ocxw0dNbe+uPFyRRdyC9EZNHCiCf5
XLo8Ik3Yv7plQ1KWG+20fq+8xmwgYqJ1ZDJ3OOwSbTf2d9Zk4jawbMQ4vmZJ62vQ
LaLQXCQ/qH0yD99/GGEdaFxCGjnKpGCwLSgs+yZjOyUGrnL5y5kJ5LdZZBRCMhj2
eiaFrJa1YWp6ICH3FSIIZTnYvUvUVSo49QCq37Q9gImsyu+076ytnvVMW14wRuCP
GpyVRineOgBo/6iIEykr9juO1XqpqfDLQyGj4bl/9XEPbPqR+lDy9RSY6Cokjfrb
9/5iuoIIipswy40XO6vYSG6RkYKsR2bUOCVcA1E4yckwPNMwxDqVYAix2wlIx7yl
UBfQYdf5an5f3fUW3D/0oSA3ZEhgIKbNH6nCV9+24MtqnApGUwdifTEq2hVnHRen
m3ScBfD+HL6ON2/swBvJqAUsmD0PQ9k2Z3Yav4daQfxsoSCwCKgYJTO1h8omNPJN
kh0nWxvkxqQO925KfQzDuy3kqeDN+EKF++jDSSW4O/EAscUIsZk=
=CVYb
-----END PGP SIGNATURE-----

--=-mIwC/MMSrvLMA24p43nN--

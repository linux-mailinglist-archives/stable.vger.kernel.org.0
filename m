Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DBE527538B
	for <lists+stable@lfdr.de>; Wed, 23 Sep 2020 10:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbgIWIoa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Sep 2020 04:44:30 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:46174 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgIWIo3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Sep 2020 04:44:29 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 3ACE61C0BB3; Wed, 23 Sep 2020 10:44:28 +0200 (CEST)
Date:   Wed, 23 Sep 2020 10:44:27 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Willy Tarreau <w@1wt.eu>
Cc:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, jikos@suse.cz,
        vojtech@suse.cz, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Yuan Ming <yuanmingbuaa@gmail.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 4.19 66/78] fbcon: remove soft scrollback code
Message-ID: <20200923084427.GA32110@amd>
References: <20200915140633.552502750@linuxfoundation.org>
 <20200915140636.861676717@linuxfoundation.org>
 <20200916075759.GC32537@duo.ucw.cz>
 <20200916082510.GB509119@kroah.com>
 <20200916090723.GA4151@duo.ucw.cz>
 <20200916091420.GF13670@1wt.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline
In-Reply-To: <20200916091420.GF13670@1wt.eu>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > I believe it will need to be reverted in Linus' tree, too. In fact,
> > the patch seems to be a way for Linus to find a maintainer for the
> > code, and I already stated I can do it. Patch is so new it was not
> > even in -rc released by Linus.
>=20
> I can honestly see how it can be missed from fbcon, but using vgacon
> myself for cases like you described, I still benefit from the hw scroll
> buffer which is OK.
>=20
> > > See the email recently on oss-devel for one such reason why this was
> > > removed...
> >=20
> > Would you have a link for that?
>=20
> Here it is:
>=20
>   https://www.openwall.com/lists/oss-security/2020/09/15/2

Thank you for the pointer!

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl9rCusACgkQMOfwapXb+vJD9QCgq8uPa3CErsd9aG+WeyQHw58W
5rkAn1hcOezryPDv6NTJS4D5olmgVTPF
=Eekr
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--

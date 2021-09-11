Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF8A407585
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 09:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235334AbhIKH5B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 03:57:01 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:40984 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235331AbhIKH5B (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Sep 2021 03:57:01 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id DC96B1C0B7A; Sat, 11 Sep 2021 09:46:19 +0200 (CEST)
Date:   Sat, 11 Sep 2021 09:46:19 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Pavel Machek <pavel@denx.de>, nobuhiro1.iwamatsu@toshiba.co.jp,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: Re: Backporting CVE-2020-3702 ath9k patches to stable
Message-ID: <20210911074619.GB27612@amd>
References: <20210818084859.vcs4vs3yd6zetmyt@pali>
 <YRzMt53Ca/5irXc0@kroah.com>
 <20210818091027.2mhqrhg5pcq2bagt@pali>
 <YRzQZZIp/LfMy/xG@kroah.com>
 <20210902114814.GA525@amd>
 <YTC9QBWPoulIhZYq@kroah.com>
 <20210903063440.GC9690@amd>
 <YTXWDE4NStB8ZOf8@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="H+4ONPRPur6+Ovig"
Content-Disposition: inline
In-Reply-To: <YTXWDE4NStB8ZOf8@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--H+4ONPRPur6+Ovig
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > Odd, I don't remember why I didn't even try to apply them to older
> > > kernels.  I'll do that after this next round is released in a few day=
s,
> > > sorry about that.
> >=20
> > Thank you! If there are problems, let me know and I'll try to help.
>=20
> Now all queued up.

Thank you! One less CVE to watch.

Best regards,

								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--H+4ONPRPur6+Ovig
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmE8XssACgkQMOfwapXb+vJXGgCdEBevk0mnjsCtLPGyfIcB42wW
jVYAn2qsxzyXMxHxqWhK9nDVOoKwMCeb
=ijDV
-----END PGP SIGNATURE-----

--H+4ONPRPur6+Ovig--

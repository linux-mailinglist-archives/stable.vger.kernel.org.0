Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2EEE3FFA74
	for <lists+stable@lfdr.de>; Fri,  3 Sep 2021 08:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344995AbhICGfm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 02:35:42 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:54612 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbhICGfm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Sep 2021 02:35:42 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 53E3A1C0B7F; Fri,  3 Sep 2021 08:34:41 +0200 (CEST)
Date:   Fri, 3 Sep 2021 08:34:40 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Pavel Machek <pavel@denx.de>, nobuhiro1.iwamatsu@toshiba.co.jp,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: Re: Backporting CVE-2020-3702 ath9k patches to stable
Message-ID: <20210903063440.GC9690@amd>
References: <20210818084859.vcs4vs3yd6zetmyt@pali>
 <YRzMt53Ca/5irXc0@kroah.com>
 <20210818091027.2mhqrhg5pcq2bagt@pali>
 <YRzQZZIp/LfMy/xG@kroah.com>
 <20210902114814.GA525@amd>
 <YTC9QBWPoulIhZYq@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="bKyqfOwhbdpXa4YI"
Content-Disposition: inline
In-Reply-To: <YTC9QBWPoulIhZYq@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--bKyqfOwhbdpXa4YI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > > > > See also:
> > > > > > https://lore.kernel.org/linux-wireless/87o8hvlx5g.fsf@codeauror=
a.org/
> > ...
> > > > > What stable tree(s) do you want to see these go into?
> > > >=20
> > > > Commits were introduced in 5.12, so it should go to all stable tree=
s << 5.12
> >=20
> > ...
> >=20
> > > Great, all now queued up.  Sad that qcom didn't want to do this
> > > themselves :(
> >=20
> > Thanks for the fixes; I see them in 4.14 and newer stable trees.
> >=20
> > But I don't see them in 4.4 and 4.9, nor can I see reason why they
> > were not applied.
> >=20
> > Can someone help?
>=20
> Odd, I don't remember why I didn't even try to apply them to older
> kernels.  I'll do that after this next round is released in a few days,
> sorry about that.

Thank you! If there are problems, let me know and I'll try to help.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--bKyqfOwhbdpXa4YI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmExwgAACgkQMOfwapXb+vL3TQCglF+Ay6yLbttelKWaUQRvV57f
YBQAoJr6RzNptQw8rpn6beL9D77IQDe2
=AWOu
-----END PGP SIGNATURE-----

--bKyqfOwhbdpXa4YI--

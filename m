Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0933B3FED21
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 13:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234069AbhIBLtS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Sep 2021 07:49:18 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:38676 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343520AbhIBLtP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Sep 2021 07:49:15 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id C60C11C0B7F; Thu,  2 Sep 2021 13:48:15 +0200 (CEST)
Date:   Thu, 2 Sep 2021 13:48:14 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg KH <gregkh@linuxfoundation.org>,
        nobuhiro1.iwamatsu@toshiba.co.jp
Cc:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: Re: Backporting CVE-2020-3702 ath9k patches to stable
Message-ID: <20210902114814.GA525@amd>
References: <20210818084859.vcs4vs3yd6zetmyt@pali>
 <YRzMt53Ca/5irXc0@kroah.com>
 <20210818091027.2mhqrhg5pcq2bagt@pali>
 <YRzQZZIp/LfMy/xG@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
Content-Disposition: inline
In-Reply-To: <YRzQZZIp/LfMy/xG@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > > Hello! I would like to request for backporting following ath9k comm=
its
> > > > which are fixing CVE-2020-3702 issue.
> > > >=20
> > > > 56c5485c9e44 ("ath: Use safer key clearing with key cache entries")
> > > > 73488cb2fa3b ("ath9k: Clear key cache explicitly on disabling hardw=
are")
> > > > d2d3e36498dd ("ath: Export ath_hw_keysetmac()")
> > > > 144cd24dbc36 ("ath: Modify ath_key_delete() to not need full key en=
try")
> > > > ca2848022c12 ("ath9k: Postpone key cache entry deletion for TXQ fra=
mes reference it")
> > > >=20
> > > > See also:
> > > > https://lore.kernel.org/linux-wireless/87o8hvlx5g.fsf@codeaurora.or=
g/
=2E..
> > > What stable tree(s) do you want to see these go into?
> >=20
> > Commits were introduced in 5.12, so it should go to all stable trees <<=
 5.12

=2E..

> Great, all now queued up.  Sad that qcom didn't want to do this
> themselves :(

Thanks for the fixes; I see them in 4.14 and newer stable trees.

But I don't see them in 4.4 and 4.9, nor can I see reason why they
were not applied.

Can someone help?

Thanks,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmEwuf4ACgkQMOfwapXb+vIm/gCdGuBXgVUMyW8u0yCi/++bCcSp
c6QAnisM4rRbz2FGsxdNDrH1xoemMiG+
=/t8a
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--

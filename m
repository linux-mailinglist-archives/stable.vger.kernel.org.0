Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA9D19F86C
	for <lists+stable@lfdr.de>; Mon,  6 Apr 2020 17:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728787AbgDFPBF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Apr 2020 11:01:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33822 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728766AbgDFPBF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Apr 2020 11:01:05 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jLTFG-0002uc-Cg; Mon, 06 Apr 2020 16:01:02 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jLTFF-000LUn-Mr; Mon, 06 Apr 2020 16:01:01 +0100
Message-ID: <b23ff81a4149585a74d38e91a199ae145ac1e881.camel@decadent.org.uk>
Subject: Re: [PING] EFI/PTI fix not backported to 3.16.XX?
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Martin Galvan <omgalvan.86@gmail.com>
Cc:     Pavel Tatashin <pasha.tatashin@soleen.com>,
        stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>
Date:   Mon, 06 Apr 2020 16:00:57 +0100
In-Reply-To: <CAN19L9FP1cSGX6Nhvq--furWcAgx3Gmm84ffy2tRzsgvCdSU+g@mail.gmail.com>
References: <CAN19L9Fi0h0wHOyY3zdAU4vX=J+T_3sVkL_wsq89W+RgF7gBxA@mail.gmail.com>
         <CA+CK2bCEtgvkG7jd3rm2gipKE6KQ4dzfgFGERoib5W-=pchDWw@mail.gmail.com>
         <8508c19359077ac33c9ef305c468a44c6ddff772.camel@decadent.org.uk>
         <CAN19L9FP1cSGX6Nhvq--furWcAgx3Gmm84ffy2tRzsgvCdSU+g@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-JOwlnl1wgCe2zuxq6vJb"
User-Agent: Evolution 3.36.1-1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-JOwlnl1wgCe2zuxq6vJb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2020-04-06 at 11:37 -0300, Martin Galvan wrote:
> Hi all,
>=20
> Was this included in a new release? I'm unaware of the release
> schedule for 3.16, so perhaps it's still pending.

Not yet.  It should be released later this month.

Ben.

> Thanks!
>=20
> El dom., 15 mar. 2020 a las 17:36, Ben Hutchings
> (<ben@decadent.org.uk>) escribi=C3=B3:
> > On Fri, 2020-03-13 at 18:41 +0000, Pavel Tatashin wrote:
> > > Hi Ben,
> > >=20
> > > I have tested and it cherry-picks cleanly on 3.16. I do not see
> > > any
> > > issues with backporting it to 3.16. Do you want me to send a
> > > patch for
> > > review, or can you just cherry-pick 7ec5d87df34a to 3.16?
> >=20
> > I've queued this up, thanks.
> >=20
> > Ben.
> >=20
> > > Thank you,
> > > Pasha
> > >=20
> > >=20
> > > On Fri, Mar 13, 2020 at 10:09 AM Martin Galvan <
> > > omgalvan.86@gmail.com> wrote:
> > > > Hi all,
> > > >=20
> > > > I've been running some tests on Debian 8 (which uses a 3.16.XX
> > > > kernel), and saw that my system would occasionally reboot when
> > > > performing an EFI variables dump. I did some digging and saw
> > > > that this
> > > > problem first appeared in 4.4.110 and was fixed by Pavel
> > > > Tatashin in
> > > > commit 7ec5d87df34a. At the same time, 4.9.XX, 4.14.XX and
> > > > mainline
> > > > have commit 67a9108ed431, which also solves the issue. However,
> > > > the
> > > > 3.16 stable line doesn't seem to have either fix, and therefore
> > > > the
> > > > crash is still there.
> > > >=20
> > > > I don't know whether any distros use 3.16 other than Debian,
> > > > but it'd
> > > > still be good to have this fix backported as well.
> > --
> > Ben Hutchings
> > Humour is the best antidote to reality.
> >=20
> >=20
--=20
Ben Hutchings
Logic doesn't apply to the real world. - Marvin Minsky



--=-JOwlnl1wgCe2zuxq6vJb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl6LRCkACgkQ57/I7JWG
EQnvZw//adka5jurSj207ujj+yu4j1ECIqs76FgRb4sOjbEzSYC/X1GP2heuRnij
sjkwePZYodGg1tELeER47EAhPumPLxRVlodfU9lRMpqhYPughyg4I4Z922cb+Slc
a3SaB8fVg4h22bBXvXTnjghU9ucz+wALcMkXRGbGD7Uv0klDoUL1FfUpKy+jfFQc
DVP8kk+tkGTg1nM1FtFWqMsTxPjaWCBI0/bnPokO15BfuvproK9xHv4AkgEJMPPo
k6KY9EbeDpBgvQ7yk41c1Q+LmAJ0QHqukP8OEhTilmRW8MKumpXvhWV83kmIr//e
6bJtg1j8OAKpzN/jaXxGBto9rzC9IY5NKz2Hw6rw/cTaUzxwpaN1yP6lfC5wJf1V
tIcKzucjrvjP7+Q+fvrC4CqpTDxDxW1Vt3h5mAyba3bw7rEhPKhiQ4WV+w8cTPDE
gFC9VQUQ8sB473PRahccCVj7swnhROOujtIzJhQ4MO+7dQgbs3a1gmCBYFivng/c
V/CpqB7IPK1bTjKiUjx4BC9TG8oReTzaLHYqqTfRQywzC9xcLaNBxkQeATy1kkQq
Ts8FTTpM/hKOqMwg+6IUC6pvU6H142ePMhoztRoMyaVnfKAszDp3IxEcJ7n6z6JG
Ngc8R0qbAh24/7NRWdSvSUyZdY3O4uRXaSsmatJSaHEkW3Mnphc=
=38dc
-----END PGP SIGNATURE-----

--=-JOwlnl1wgCe2zuxq6vJb--

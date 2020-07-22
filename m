Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DDBE22926D
	for <lists+stable@lfdr.de>; Wed, 22 Jul 2020 09:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728123AbgGVHnU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jul 2020 03:43:20 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:54696 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbgGVHnU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jul 2020 03:43:20 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id A1ACB1C0BD8; Wed, 22 Jul 2020 09:43:17 +0200 (CEST)
Date:   Wed, 22 Jul 2020 09:43:17 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Viresh Kumar <viresh.kumar@linaro.org>
Cc:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Finley Xiao <finley.xiao@rock-chips.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH 4.19 123/133] thermal/drivers/cpufreq_cooling: Fix wrong
 frequency converted from power
Message-ID: <20200722074317.GA11366@amd>
References: <20200720152803.732195882@linuxfoundation.org>
 <20200720152809.664822211@linuxfoundation.org>
 <20200721114344.GC17778@duo.ucw.cz>
 <20200722053453.xmfcezyiabz2e2dd@vireshk-mac-ubuntu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="rwEMma7ioTxnRzrJ"
Content-Disposition: inline
In-Reply-To: <20200722053453.xmfcezyiabz2e2dd@vireshk-mac-ubuntu>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > commit 371a3bc79c11b707d7a1b7a2c938dc3cc042fffb upstream.
> > >=20
> > > The function cpu_power_to_freq is used to find a frequency and set the
> > > cooling device to consume at most the power to be converted. For exam=
ple,
> > > if the power to be converted is 80mW, and the em table is as follow.
> > > struct em_cap_state table[] =3D {
> > > 	/* KHz     mW */
> > > 	{ 1008000, 36, 0 },
> > > 	{ 1200000, 49, 0 },
> > > 	{ 1296000, 59, 0 },
> > > 	{ 1416000, 72, 0 },
> > > 	{ 1512000, 86, 0 },
> > > };
> > > The target frequency should be 1416000KHz, not 1512000KHz.
> > >
=2E..
> > Something is very wrong here, if table is sorted like described in the
> > changelog, it will always break at i=3D=3D0 or i=3D=3D1... not working =
at all
> > in the old or the new version.
>=20
> As I understand from the other email you sent, this works fine now.
> Right ?

Yes, I believe the code is okay now.

OTOH the changelog is extremely confusing, because code would not work
on the table presented there as an example.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--rwEMma7ioTxnRzrJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl8X7hQACgkQMOfwapXb+vKpMgCgwuRyVSw2DJ+btfPSjCGHML62
ghwAnivBnXVlAXWbqM7yDaCFDlqBKcxD
=Vljm
-----END PGP SIGNATURE-----

--rwEMma7ioTxnRzrJ--

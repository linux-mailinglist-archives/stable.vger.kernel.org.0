Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F15305FD92
	for <lists+stable@lfdr.de>; Thu,  4 Jul 2019 21:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbfGDT4B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jul 2019 15:56:01 -0400
Received: from sauhun.de ([88.99.104.3]:40170 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726038AbfGDT4B (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Jul 2019 15:56:01 -0400
Received: from localhost (p5DCB43A6.dip0.t-ipconnect.de [93.203.67.166])
        by pokefinder.org (Postfix) with ESMTPSA id C1E012C290E;
        Thu,  4 Jul 2019 21:55:58 +0200 (CEST)
Date:   Thu, 4 Jul 2019 21:55:58 +0200
From:   Wolfram Sang <wsa@the-dreams.de>
To:     Marek Vasut <marek.vasut@gmail.com>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Jonathan Cameron <jic23@kernel.org>,
        stable <stable@vger.kernel.org>,
        Marek Vasut <marek.vasut+renesas@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        Rob Herring <robh@kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        linux-iio@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] iio: adc: gyroadc: fix uninitialized return code
Message-ID: <20190704195557.GA1338@kunai>
References: <20190704113800.3299636-1-arnd@arndb.de>
 <20190704120756.GA1582@kunai>
 <CAMuHMdXDN60WWFerok1h05COdNNPZTMDCgKXejmQZMj9B6y5Cw@mail.gmail.com>
 <fc3b8b4e-fe0e-9573-124d-4b41efa409e4@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
In-Reply-To: <fc3b8b4e-fe0e-9573-124d-4b41efa409e4@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> >> This is correct but missing that the above 'return ret' is broken, too.
> >> ret is initialized but 0 in that case.
> >=20
> > Nice catch! Oh well, given enough eyeballs, ...
>=20
> I don't think ret is initialized, reg is, not ret .

It is initialized for the broken 'return ret' *above* the one which gets
rightfully fixed in this patch.


--ibTvN161/egqYuK8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl0eWckACgkQFA3kzBSg
Kbb/Aw/+JS8QiD+5YFD08Aece1AYJ2md7n6gHKlrgxsleiM3hY40m90l6ayrIq8Q
YW6n4kloAs8QtzaPv7zjHAhs2n/bs8RubGDv+N+M3fkJnbxUijW1iw15r8DtPsDH
m5a8BW9khGfbGpZdRBD7LXfKNryoCymGxx/izJS6ZfQFnTrlEXzrTtHXv78Ynsv9
hvp2jkywnNZRK27pzzKRG/B3adb1Xq3yz+uHMhQRLvJSQPKLXsS4wyGqmDBONjgC
sX681ZgKl632cIbxkvUUApF3UMShkVZzXi05lMo2V+9dFa8P+T+RAX3/7kH2roAR
dOfo92O9ZR7q6J2t3H00pL3bpPJKPZ14Dxk39fO6xx2zB4av9EVHzRRgdlzPwvfI
K+XTGFjLTAcPiteVVeaueiLhjANJNkGYq4ayZvkf+tZhuglkWjZadUv+oYVVUWcW
dD8bzYwhok8l3ChtB5Kd8455aM9uPvMbjv++UbDAHP73L1IEuU3I4pvGEt3+mhmG
HMKdFKboVp1auLUlgnNjylt1lb4jG7OJfs0TjJA/v8HoaJPWq6guaD5v+vIoVgCB
PXTjIiLo9GpaXJiAGnlZLPisQlt9Y0pvyj8dLAeiS/k8ZtXsIEehZs4pIUhIdDzV
h8pzF3R/Zh0WEcFte0RVbbhSaGyDFrJK5uc0eNqCC+a4OTYhVi0=
=qqM5
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--

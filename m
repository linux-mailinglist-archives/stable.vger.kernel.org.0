Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B44AA2E78BB
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 13:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgL3M51 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 07:57:27 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:33850 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbgL3M51 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Dec 2020 07:57:27 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 499FB1C0B78; Wed, 30 Dec 2020 13:56:29 +0100 (CET)
Date:   Wed, 30 Dec 2020 13:56:28 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: Re: [PATCH 5.10 527/717] media: ipu3-cio2: Validate mbus format in
 setting subdev format
Message-ID: <20201230125628.GB13161@duo.ucw.cz>
References: <20201228125020.963311703@linuxfoundation.org>
 <20201228125046.214023397@linuxfoundation.org>
 <20201230122508.GA12190@duo.ucw.cz>
 <CAHp75VdFT-SUUj2LiPTs1_RJ-n97OiyQ2pF0jVbHsARkDshfwA@mail.gmail.com>
 <X+x2OakYZ5GGCxuS@pendragon.ideasonboard.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="jq0ap7NbKX2Kqbes"
Content-Disposition: inline
In-Reply-To: <X+x2OakYZ5GGCxuS@pendragon.ideasonboard.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--jq0ap7NbKX2Kqbes
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed 2020-12-30 14:44:41, Laurent Pinchart wrote:
> On Wed, Dec 30, 2020 at 02:32:46PM +0200, Andy Shevchenko wrote:
> > On Wed, Dec 30, 2020 at 2:25 PM Pavel Machek wrote:
> >=20
> > > > commit a86cf9b29e8b12811cf53c4970eefe0c1d290476 upstream.
> > > >
> > > > Validate media bus code, width and height when setting the subdev f=
ormat.
> > > >
> > > > This effectively reworks how setting subdev format is implemented i=
n the
> > > > driver.
> > >
> > > Something is wrong here:
> > >
> > > > +     fmt->format.code =3D formats[0].mbus_code;
> > > > +     for (i =3D 0; i < ARRAY_SIZE(formats); i++) {
> >=20
> > Looks like 'i =3D 1' should be...
> >=20
> > > > +             if (formats[i].mbus_code =3D=3D fmt->format.code) {
>=20
> More likely
>=20
> 			if (formats[i].mbus_code =3D=3D mbus_code) {
>=20
> I think.

That looks reasonable, but I don't have hardware to test.

> Pavel, would you like to submit a patch ?

Done, should be in your inbox.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--jq0ap7NbKX2Kqbes
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX+x4/AAKCRAw5/Bqldv6
8ut1AKCeguNK4/d1qTU2rUmE6uQxl7TiiACfaiFUMA/wZpA/nrNhCbhoVqVnUr8=
=9SGb
-----END PGP SIGNATURE-----

--jq0ap7NbKX2Kqbes--

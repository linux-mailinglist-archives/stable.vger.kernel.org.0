Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16C142AF147
	for <lists+stable@lfdr.de>; Wed, 11 Nov 2020 13:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbgKKMyC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Nov 2020 07:54:02 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:46514 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726392AbgKKMyC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Nov 2020 07:54:02 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 901E41C0B7C; Wed, 11 Nov 2020 13:54:00 +0100 (CET)
Date:   Wed, 11 Nov 2020 13:53:59 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 48/71] of: Fix reserved-memory overlap detection
Message-ID: <20201111125359.GB26508@amd>
References: <20201109125019.906191744@linuxfoundation.org>
 <20201109125022.156835188@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="+g7M9IMkV8truYOl"
Content-Disposition: inline
In-Reply-To: <20201109125022.156835188@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--+g7M9IMkV8truYOl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> For example, there are two overlaps in this case but they are not
> currently reported:

=2E..

> but they are after this patch:
>=20
>  OF: reserved mem: OVERLAP DETECTED!
>  bar@0 (0x00000000--0x00001000) overlaps with foo@0 (0x00000000--0x000020=
00)
>  OF: reserved mem: OVERLAP DETECTED!
>  foo@0 (0x00000000--0x00002000) overlaps with baz@1000 (0x00001000--0x000=
02000)

Is it good idea to push this into 4.19 so early? It does not fix
anything, it just causes warnings.

Such overlap currently exists in 4.19:

arch/arm/boot/dts/s5pv210.dtsi and can not be fixed easily, see:

> > > > >               clocks: clock-controller@e0100000 {
> > > > > +                     compatible =3D "samsung,s5pv210-clock";
> > > > >                       reg =3D <0xe0100000 0x10000>;
> > > > ...
> > > > > +             pmu_syscon: syscon@e0108000 {
> > > > > +                     reg =3D <0xe0108000 0x8000>;
> > > > >               };

Date: Fri, 6 Nov 2020 22:10:38 +0100
=46rom: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH 4.19 107/191] ARM: dts: s5pv210: move PMU node out of c=
lock controller
			=09
Best regards,
									Pavel

--=20
http://www.livejournal.com/~pavelmachek

--+g7M9IMkV8truYOl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl+r3ucACgkQMOfwapXb+vJ0vwCfeaa/88Rjgb0zfZ2yCcnzKtfQ
iGUAoLQdkTEn3s1bUri8kT40lvlvzVpY
=cvp3
-----END PGP SIGNATURE-----

--+g7M9IMkV8truYOl--

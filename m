Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D135F2B23BE
	for <lists+stable@lfdr.de>; Fri, 13 Nov 2020 19:26:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbgKMS00 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Nov 2020 13:26:26 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:51998 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbgKMS0Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Nov 2020 13:26:25 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id E8FEA1C0B7D; Fri, 13 Nov 2020 19:26:21 +0100 (CET)
Date:   Fri, 13 Nov 2020 19:26:21 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jonathan Bakker <xc-racer2@live.ca>,
        Sasha Levin <sashal@kernel.org>,
        =?utf-8?B?UGF3ZcWC?= Chmiel <pawel.mikolaj.chmiel@gmail.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH 4.19 107/191] ARM: dts: s5pv210: move PMU node out of
 clock controller
Message-ID: <20201113182621.GA7102@duo.ucw.cz>
References: <20201103203232.656475008@linuxfoundation.org>
 <20201103203243.594174920@linuxfoundation.org>
 <20201105114648.GB9009@duo.ucw.cz>
 <CAJKOXPeexYuH1_9HZUGn4Q80QBtKmqCKiEd=hNd46VKTM4kGgA@mail.gmail.com>
 <20201105195508.GB19957@duo.ucw.cz>
 <20201106201245.GA332560@kozik-lap>
 <20201106211038.GA400980@kozik-lap>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
In-Reply-To: <20201106211038.GA400980@kozik-lap>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > > I don't think this commit should be backported to stable. It is sim=
ple
> > > > dtbs_check - checking whether Devicetree source matches device tree
> > > > schema. Neither the schema nor the warning existed in v4.19. I think
> > > > dtbs_check fixes should not be backported, unless a real issue is
> > > > pointed out.
> > >=20
> > > I agree with you about the backporting. Hopefully Greg drops the
> > > commit.
> > >=20
> > > But the other issue is: should mainline be fixed so that ranges do no=
t overlap?
> >=20
> > Yes, it should be. This should fail on mapping resources...
> >=20
> > I'll take a look, thanks for the report.
>=20
> +Cc Pawe=C5=82 and Marek,
>=20
> The IO memory mappings overlap unfortunately on purpose. Most of the
> clock driver registers are in the first range of 0x3000 but it also uses
> two registers at offset 0xe000.
>=20
> The samsung-s5pv210-pmu is used only as a syscon by phy-s5pv210-usb2.c
> which wants to play with 0x680c.
>=20
> The solution could be to split the mapping into two parts but I don't
> want to do this. I don't have the hardware so there is a chance I will
> break things.
>=20
> However if Pawe=C5=82, Jonathan or Marek want to improve it - patches are
> welcomed. :)

Okay, it would be nice to at least have a comment there.

Best regards,
								Pavel
--=20
http://www.livejournal.com/~pavelmachek

--5vNYLRcllDrimb99
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX67PzQAKCRAw5/Bqldv6
8hHkAJ0ZbOImgXDcxxJOlzR/bIB/mVCXIACff68HKiF8eXGf8iWV+1ymXlDQRrc=
=ThZD
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--

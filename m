Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3003F0BCA
	for <lists+stable@lfdr.de>; Wed, 18 Aug 2021 21:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232404AbhHRTaq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 15:30:46 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:33654 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbhHRTaq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Aug 2021 15:30:46 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 4FF751C0B77; Wed, 18 Aug 2021 21:30:10 +0200 (CEST)
Date:   Wed, 18 Aug 2021 21:30:09 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Pavel Machek <pavel@denx.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, Ashok Raj <ashok.raj@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 5.4 49/62] PCI/MSI: Enable and mask MSI-X early
Message-ID: <20210818193009.GC28932@amd>
References: <20210816125428.198692661@linuxfoundation.org>
 <20210816125429.897761686@linuxfoundation.org>
 <20210817073655.GA15132@amd>
 <YRyuefFT4N/y0plX@kroah.com>
 <YRzQvhDRyBWdEs5G@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="1SQmhf2mF2YjsYvc"
Content-Disposition: inline
In-Reply-To: <YRzQvhDRyBWdEs5G@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--1SQmhf2mF2YjsYvc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed 2021-08-18 11:19:58, Greg Kroah-Hartman wrote:
> On Wed, Aug 18, 2021 at 08:53:45AM +0200, Greg Kroah-Hartman wrote:
> > On Tue, Aug 17, 2021 at 09:36:55AM +0200, Pavel Machek wrote:
> > > Hi!
> > >=20
> > > I'm sorry to report here, but 4.4 patches were not yet sent to the
> > > lists (and it may be worth correcting before release).
> >=20
> > Yes, they are known to not be complete and incorrect at the moment,
> > others have reported this to me.  I will be working on these later
> > today, thanks.
>=20
> Now should be all fixed up thanks to some patches sent by Thomas.

I can't spot a bug any more; thank you,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--1SQmhf2mF2YjsYvc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmEdX8EACgkQMOfwapXb+vJYpACgjotMosSK9t6sgItT0VM8Mscn
1y0An3mTg3hr2U1XAW7aXC+A1+jA7Xur
=Tbc4
-----END PGP SIGNATURE-----

--1SQmhf2mF2YjsYvc--

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B36AD1350E7
	for <lists+stable@lfdr.de>; Thu,  9 Jan 2020 02:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbgAIBOX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 20:14:23 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45890 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726654AbgAIBOX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 20:14:23 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipMOz-0008Oi-J2; Thu, 09 Jan 2020 01:14:21 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipMOz-007fLg-5i; Thu, 09 Jan 2020 01:14:21 +0000
Message-ID: <4f30b4b46b24a498fca7c4b540bc1723c9ff569f.camel@decadent.org.uk>
Subject: Re: [PATCH 3.16 00/63] 3.16.81-rc1 review
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        Denis Kirjanov <kda@linux-powerpc.org>
Date:   Thu, 09 Jan 2020 01:14:15 +0000
In-Reply-To: <20200108225224.GA29712@roeck-us.net>
References: <lsq.1578512578.117275639@decadent.org.uk>
         <20200108225224.GA29712@roeck-us.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-gAE8Rj3J3DtYeniKFiiG"
User-Agent: Evolution 3.34.1-2+b1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-gAE8Rj3J3DtYeniKFiiG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2020-01-08 at 14:52 -0800, Guenter Roeck wrote:
> On Wed, Jan 08, 2020 at 07:42:58PM +0000, Ben Hutchings wrote:
> > This is the start of the stable review cycle for the 3.16.81 release.
> > There are 63 patches in this series, which will be posted as responses
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >=20
> > Responses should be made by Fri Jan 10 20:00:00 UTC 2020.
> > Anything received after that time might be too late.
> >=20
>=20
> Build results:
> 	total: 136 pass: 136 fail: 0
> Qemu test results:
> 	total: 227 pass: 227 fail: 0

Great, thanks for checking,

Ben.

--=20
Ben Hutchings
If God had intended Man to program,
we'd have been born with serial I/O ports.



--=-gAE8Rj3J3DtYeniKFiiG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl4WfmgACgkQ57/I7JWG
EQl6aw/+I6sYnW50Y2lEb1yIKHKsebZY5CJnMgcfxnHdCEhJ+YPQxoixcz6AYVwY
B+R+UDRzeBwEtJO0aEPKtEpZZisfG2zY5ul5V+CQjhjdosYLSV1yaTwiL9y5DyP9
0AKu6u95xKn2r+GcgqSLCFzTQfjDyQX54pp/9XSZa98+C8NxIKCgROJqaNQVa5f0
KucuRXMAaynBbIZUHKbDgE72JiEzx14AmmaHJ5QcPbpNSHg/3YhxB60Bv/Lh6Nl3
mT1ISJ4rJWeTeEhJGnqn924ZDdOeVhvjI7WbtGsQgcitDfG3LdAMg1XM9ihfAeHl
xOvlH26sDWsl/RJQXrZnr3+ZWJAXqEB2mpUMiCa4EBinUR4gDgC6hzib2O9A7Ssg
eGoFQffurIrER/5VS5hzNRwl6XPaGE2rYujYidMaIxRlLBuPEiK2FtEBuS6Q4m3y
IYZtrwge2q1gYQUz8ntsGfDqt/mCRk3ebSSwX5KQssXYWNFZVrkNo3e4whxHSkAX
Fs5iT81pSz/+FvKsVIJl6XBBuqhaaYQIqjWHU/FHBy/HUPRNqV2SRYb5UPq9b8P9
Tj8aaM40eUR74pptJvk3mL5FsPgrPmsx2PaRvWcq98HnQB5tvC+SF/f1KNN5MGpr
60H5X4dFc8urZucA96VLhYkOvwU+6NJRSrRMn9wgHl/D1S9hVjU=
=eQmm
-----END PGP SIGNATURE-----

--=-gAE8Rj3J3DtYeniKFiiG--

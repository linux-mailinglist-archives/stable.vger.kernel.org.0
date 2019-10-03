Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0B9CB1BE
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 00:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388148AbfJCWGM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 18:06:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46876 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726002AbfJCWGL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Oct 2019 18:06:11 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iG9Ef-0005Eg-F1; Thu, 03 Oct 2019 23:06:09 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iG9Ef-0006YM-7d; Thu, 03 Oct 2019 23:06:09 +0100
Message-ID: <8b056b3df2460d6830a0de97b9cbf3e41d434bbc.camel@decadent.org.uk>
Subject: Re: [PATCH 3.16 29/87] staging: iio: cdc: Don't put an else right
 after a return
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        Catalina Mocanu <catalina.mocanu@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Thu, 03 Oct 2019 23:06:03 +0100
In-Reply-To: <de5e7cd39ce661f8441fb4f5bdf21ee37ada1366.camel@perches.com>
References: <lsq.1570043211.136218297@decadent.org.uk>
         <6436567dd141e5528a5363dd3aaad21815a1c111.camel@perches.com>
         <3fe1cd65a7860464d3780b57c734d12880df4b92.camel@decadent.org.uk>
         <de5e7cd39ce661f8441fb4f5bdf21ee37ada1366.camel@perches.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-K7+kU2VDaIgLJJPm0KQZ"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-K7+kU2VDaIgLJJPm0KQZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2019-10-03 at 08:09 -0700, Joe Perches wrote:
> On Thu, 2019-10-03 at 15:47 +0100, Ben Hutchings wrote:
> > On Wed, 2019-10-02 at 14:36 -0700, Joe Perches wrote:
> > > On Wed, 2019-10-02 at 20:06 +0100, Ben Hutchings wrote:
> > > > 3.16.75-rc1 review patch.  If anyone has any objections, please let=
 me know.
> > >=20
> > > This doesn't look necessary.
> >=20
> > It allows the next patch to apply cleanly.
>=20
> Perhaps when you pick patches that are unnecessary
> for any other reason but to allow easier picking of
> actual fixes, the nominal unnecessary patches could
> be marked as necessary for follow-on patches.

I have been doing that lately, but just forgot to do so for this patch.

> Also, when you send these patch series, please use
> an email delay of at least 1 second between each
> entry in the series as the threading is otherwise
> poor in various email clients when sorting by time.

The dates are actually generated before I send them, but I can probably
arrange to override them.  Thanks for the suggestion.

Ben.

--=20
Ben Hutchings
Unix is many things to many people,
but it's never been everything to anybody.



--=-K7+kU2VDaIgLJJPm0KQZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl2WcMwACgkQ57/I7JWG
EQlNEBAAq72EtDC5xDcFYTXWF+om8rjKWt8yWTy9bJeDUZUnxvi1KgQpp9rOiWoN
0t3U/2vey22gHD5KSwKfwiGdxJWLgbL0aK70/K2s7UmMrFUHiu+TA9ixIR5di+YQ
i+BcEARttmq4dsuNwBme/aGtn2rvLH3MevWjJvtjJJdpusxsKUCBlDINSkRMeeTs
Cgm9IIJAgfWwCuNjmWyUBPBpgmXsPZUYiaCbhgG26Fv0DT2ofc9V52x4E9QMG60b
HIWp23SobHYtXXq/KBwky9CQG/Dop17HqsticqEl7yhv1G8q/QBOrj7Wxgll3OaT
8FLzaWGcorBDbUx3Rq60ODUsX9+tp5sfEjxZXgDIcNFKGFvPGcK6Jl/B1+d0OgWd
u0tPqvhywK9XsEny5TSATk0slqMDGuX1Zck6Vk9Lk2KtL514neGNEG7liBYAj9jd
uEt3Q+RzfXlJGGpHkZTJGjyLaHMlFKG3th9CAkHB2Mqh4H7tY5dHFQZ8exTK9qvI
9HiMcjkzBRugULF0A0NoGl3fdvemEjvreRzrpy7ISeDG9ldeabVij6VMf+P1OE+g
FEiphWPmP/8o/o3wQBXkQ3FXIvD3fQgtAx/Ml9I76ZMYTBn7pe9Q2OKW3bOSn+xQ
v6+VpAwbkqycR7vOWtG2/BJGbIfyNCkcifnY7151pCL+1WkX/Ls=
=jIA7
-----END PGP SIGNATURE-----

--=-K7+kU2VDaIgLJJPm0KQZ--

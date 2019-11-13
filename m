Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DFE2FB79E
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 19:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728262AbfKMSby (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Nov 2019 13:31:54 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35478 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726564AbfKMSby (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Nov 2019 13:31:54 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iUxQl-0007ig-9k; Wed, 13 Nov 2019 18:31:51 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iUxQk-0003zJ-Rp; Wed, 13 Nov 2019 18:31:50 +0000
Message-ID: <bd28cd04b9c609303c0a14a003a76fac91bafa6d.camel@decadent.org.uk>
Subject: Re: [PATCH 3.16 00/25] 3.16.77-rc1 review
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        Denis Kirjanov <kda@linux-powerpc.org>
Date:   Wed, 13 Nov 2019 18:31:50 +0000
In-Reply-To: <20191113181354.GA19912@roeck-us.net>
References: <lsq.1573602477.548403712@decadent.org.uk>
         <20191113181354.GA19912@roeck-us.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-/UbXt/om7lVUTchhVZBS"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-/UbXt/om7lVUTchhVZBS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2019-11-13 at 10:13 -0800, Guenter Roeck wrote:
> On Tue, Nov 12, 2019 at 11:47:57PM +0000, Ben Hutchings wrote:
> > This is the start of the stable review cycle for the 3.16.77 release.
> > There are 25 patches in this series, which will be posted as responses
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >=20
> > Responses should be made by Fri Nov 15 00:00:00 UTC 2019.
> > Anything received after that time might be too late.
> >=20
>=20
> Build results:
> 	total: 136 pass: 136 fail: 0
> Qemu test results:
> 	total: 229 pass: 229 fail: 0

Great, thanks for testing,

Ben.

--=20
Ben Hutchings
Anthony's Law of Force: Don't force it, get a larger hammer.



--=-/UbXt/om7lVUTchhVZBS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl3MTBYACgkQ57/I7JWG
EQmEvA//T0JH9LV2byfb52J98dgmvihx3stY043ow14Ry12rx/ZMVaOWidLGK/HM
TU3rDVuoRiTqILqoTr71pIadO2sZjtWcbDGMqm+CVM2+7QBmDACUHLaiLdsXS5QK
8+YTNR9xe5gbkdYYOx89KA/wOtG5vQU8bo2ZcGMu/Ei7p1Gjb7wew5KOzFaaReeW
XM2NWAyZAqtW9r0/HmNrSsF1b53zsy9mspR3tatu3mfzzm1Fo5Uu2xRuXPzmqEpb
ZZ4QfuzoJe5xuZ+GDewFJm4UPfJ0EtbEFH8Zgd7ozdT3RZTZNTxMbhEiusxhXhjx
A4Jgh0YTvNs5snCpGZwthHHGrOgxVzOWibJiXzzyPdLLIA/TGuCmMjZrPABjUIOH
0iQwBDwY7GNKj+IDfHlzIDEg7+KTyhCv+Y4PcbCYwh+4VhapeL03yfTvpKj2uE++
xMw1urHViGG33NKsx+GWX1iWHVE92P0FU0JVq+Za5F03N2rTJ66UrHzj/E4lwvhV
2j5r6AbSjsylzpczNR6t9zfgnpSsWDBjYElixPmRJFt05AI2YMRZziB0XARadP9u
IaDu+r+SEL38jtp0KZ1joIGkahpJ9Xyv9YxeuqiUnpTRpl1Oa8PkOdDqoiR5OqJP
FMqzpfleErtNEZguusSyti+3CBzHWGPhHM8/0SZBbovpcNUxMbc=
=7sAw
-----END PGP SIGNATURE-----

--=-/UbXt/om7lVUTchhVZBS--

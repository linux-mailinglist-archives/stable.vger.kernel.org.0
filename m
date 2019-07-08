Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6827623FB
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389489AbfGHP33 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:29:29 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37168 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389481AbfGHP33 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jul 2019 11:29:29 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkVa3-00057b-E6; Mon, 08 Jul 2019 16:29:27 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkVa2-00036G-T0; Mon, 08 Jul 2019 16:29:26 +0100
Message-ID: <85820ecbcc368f992eb061481c388bb2ebb8ad65.camel@decadent.org.uk>
Subject: Re: [PATCH 3.16 000/129] 3.16.70-rc1 review
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, Guenter Roeck <linux@roeck-us.net>,
        akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>
Date:   Mon, 08 Jul 2019 16:29:22 +0100
In-Reply-To: <20190708130511.GA4626@luke-XPS-13>
References: <lsq.1562518456.876074874@decadent.org.uk>
         <20190708130511.GA4626@luke-XPS-13>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-UBYcyYUNPEIlvLKJ/Id1"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-UBYcyYUNPEIlvLKJ/Id1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2019-07-08 at 06:05 -0700, Luke Nowakowski-Krijger wrote:
> Hello,=20
>=20
> I got 1 error when applying this patch series to the latest linux-3.16.y
> stable branch
>=20
> fs/fuse/file.c:218:3: error: implicit declaration of function =E2=80=98st=
ream_open=E2=80=99

It is added by the previous patch and declared in <linux/fs.h>.=20
fs/fuse/file.c always includes that (via fs/fuse/fuse_i.h), so I don't
see how this error can happen.

Ben.

--=20
Ben Hutchings
Time is nature's way of making sure that
everything doesn't happen at once.



--=-UBYcyYUNPEIlvLKJ/Id1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl0jYVIACgkQ57/I7JWG
EQknpBAAvk1RxrLlsgscIZSmkbexOcj+NwhyieFM9Mc8zhCaEnj7OBTU+i6oABXO
weQgt59Nm7byVZqHPYt9B1F4blgt9oj6dqSQWUDtOYECjp9MEFPA1jNYBMwomsEE
/DSH2wC1fN1qvfTBATR9n8UilqlM4mzIMUQ3taiCmp8sUp1VRem09qCKfP5kNkzb
HYhWLbJPkyUD1ii650Aa5K3M/+u6HVUpDEZ3UAXlkPJi19YRrL9NcmQNEceUsK1j
GH/JrsrEgQqOshx5a9bzH69BNpradteS0eBV4oGhc82mywXvrsPdBxlrM+O5LQa2
o4BltIEd3z25Lh+TrZm9OUtXk319s4h/FHyanHUl31V1e7zVxEes2DlDnRR8PPMI
J2xJDBMOiBZOswtie6cF3w+Oa5PZvvYMY/9VlQ6IX2b451Jf+UCl9M6ta8NahowR
jo1PAr5oGwzrogpEeZLSGDGFpZDsznUUUsFbRJoSJOaHC+06pxnSgHSPmmUc8eZM
mioe22HfoRHJQ1LN06EkdbwvHS6Nogjpt0a15TGPrU5CIgkyXtOsoELFA42o+Iip
89O0HahTYZAztYv74GBOrG60o3qd4KqxlHFknfD13qB2rG6/1zLNZg2DWHYhEwqM
S7cZFBL23eu3o/EnFHQDKqL/2UHNS1p4AYPv8Tblz/MQVdFDvwg=
=hRS3
-----END PGP SIGNATURE-----

--=-UBYcyYUNPEIlvLKJ/Id1--

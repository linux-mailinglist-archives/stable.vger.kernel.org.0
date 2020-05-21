Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2817F1DD827
	for <lists+stable@lfdr.de>; Thu, 21 May 2020 22:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728979AbgEUUU5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 16:20:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41746 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726814AbgEUUU5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 16:20:57 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbrgV-0004jq-5o; Thu, 21 May 2020 21:20:55 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbrgU-007KuX-OM; Thu, 21 May 2020 21:20:54 +0100
Message-ID: <c01feeb17ecceeca18c852008bf0227079fbb38a.camel@decadent.org.uk>
Subject: Re: [PATCH 3.16 00/99] 3.16.84-rc1 review
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        Denis Kirjanov <kda@linux-powerpc.org>
Date:   Thu, 21 May 2020 21:20:50 +0100
In-Reply-To: <68f801f8-ceb2-13cf-ad29-b6404e2f1142@roeck-us.net>
References: <lsq.1589984008.673931885@decadent.org.uk>
         <68f801f8-ceb2-13cf-ad29-b6404e2f1142@roeck-us.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-3czPOrO9sd4hBMHihSv/"
User-Agent: Evolution 3.36.2-1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-3czPOrO9sd4hBMHihSv/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2020-05-20 at 14:23 -0700, Guenter Roeck wrote:
> On 5/20/20 7:13 AM, Ben Hutchings wrote:
> > This is the start of the stable review cycle for the 3.16.84 release.
> > There are 99 patches in this series, which will be posted as responses
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >=20
> > Responses should be made by Fri May 22 20:00:00 UTC 2020.
> > Anything received after that time might be too late.
> >=20
> Build results:
> 	total: 135 pass: 135 fail: 0
> Qemu test results:
> 	total: 230 pass: 227 fail: 3
> Failed tests:
> 	arm:cubieboard:multi_v7_defconfig:mem512:sun4i-a10-cubieboard:initrd
> 	arm:cubieboard:multi_v7_defconfig:usb:mem512:sun4i-a10-cubieboard:rootfs
> 	arm:cubieboard:multi_v7_defconfig:sata:mem512:sun4i-a10-cubieboard:rootf=
s
>=20
> The arm tests fail due to a compile error.
>=20
> drivers/clk/tegra/clk-tegra-periph.c:524:65: error: 'CLK_IS_CRITICAL' und=
eclared here (not in a function); did you mean 'CLK_IS_BASIC'?

I already looked at your first test results and dropped the patch that
uses CLK_IS_CRITICAL, so there's something else going wrong there...

Ben.

--=20
Ben Hutchings
Reality is just a crutch for people who can't handle science fiction.



--=-3czPOrO9sd4hBMHihSv/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl7G4qIACgkQ57/I7JWG
EQn4jhAAjA/dVCc9WU1mkJSYM7H+h92gdVal8UsqNeTQqaZ3vTXIfQPfQhgGa1S2
W/BpWIC3TO2jtVozG7rFp6C4StG/CE2vQbM7rkWONpMYJ5h3TQSWV3tMMrLeLFuX
hc1OCqASORL5UD5U80xvFZfxckQv/qaDHsmqWtJDYdi2vgXh+rmLDifFPBVYrIJV
ee3LEmT5gpZN8NXl4usFdoKhD92+xFVdGgGh56NQ5oxhHsuRf3jrvXVDtq1mEOvy
SdeIeSgm7vb6uen0+VJc6BHJLCpLZ9vHpOL/sA3NDqk9Y+KqKotJmi6Hid8S4Bhr
CCjM8fpdktLhAAVxNeZit3mbWz12VKP/VE+wLGmk4r5Q4Yixl6pTXPTY/3vzDnGP
tfmwjJwrk+nqb3zMhBd7Axs9CIu1gZP76ZOrKV0Rh57Z5zr5LT8kH8QZe7EwzGOh
OVuC1mSjt0P+/sOSggiMMAbaVyVVQcCMP75d0CvqZcaQzEZ7NE7uI5w8P3Ku5eKG
uI09bSDL0feuqenDCxQNfmXEpjlc5DTdl45QJjpO4x2i5gOpkd68hxiN9RfM4pcl
UtID/uJWdQf0pvShTnzMkL1go0uYug7waLm2PoY/QBOJ9zJ0qfyorq5J1oxoCHG1
hGCz+rQQCYSndo2abk/jIHd+03KBH9//JRUKusfxvbrakiyw2Qo=
=6J+S
-----END PGP SIGNATURE-----

--=-3czPOrO9sd4hBMHihSv/--

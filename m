Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 428728924A
	for <lists+stable@lfdr.de>; Sun, 11 Aug 2019 17:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726313AbfHKPZ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Aug 2019 11:25:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33334 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726014AbfHKPZ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Aug 2019 11:25:59 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwpjJ-0000rz-8w; Sun, 11 Aug 2019 16:25:57 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwpjJ-0006mY-1m; Sun, 11 Aug 2019 16:25:57 +0100
Message-ID: <078beee0929d7632913611a0ba3cd000b1e27474.camel@decadent.org.uk>
Subject: Re: [PATCH 3.16 000/157] 3.16.72-rc1 review
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        Denis Kirjanov <kda@linux-powerpc.org>
Date:   Sun, 11 Aug 2019 16:25:52 +0100
In-Reply-To: <06733f55-19b7-6192-736c-fa1014f120ea@roeck-us.net>
References: <lsq.1565469607.188083258@decadent.org.uk>
         <06733f55-19b7-6192-736c-fa1014f120ea@roeck-us.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-hgH8ajv8mnTRUcpAfvv/"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-hgH8ajv8mnTRUcpAfvv/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2019-08-11 at 07:05 -0700, Guenter Roeck wrote:
> On 8/10/19 1:40 PM, Ben Hutchings wrote:
> > This is the start of the stable review cycle for the 3.16.72 release.
> > There are 157 patches in this series, which will be posted as responses
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >=20
> > Responses should be made by Tue Aug 13 12:00:00 UTC 2019.
> > Anything received after that time might be too late.
> >=20
>=20
> Build results:
> 	total: 136 pass: 136 fail: 0
> Qemu test results:
> 	total: 229 pass: 229 fail: 0

Thanks for testing,

Ben.

--=20
Ben Hutchings
Time is nature's way of making sure that
everything doesn't happen at once.



--=-hgH8ajv8mnTRUcpAfvv/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl1QM4AACgkQ57/I7JWG
EQn0HQ//Yat8+tNFQMWS/0qNS7jleupMxcIeJVgSB2JHMjNwQdGP7+63ocLRMNzk
YtdV3fRw2oXioS6ZXKr0xrymllCqUq2+vfodpkq/VkoFctdobTRS1I2gUJflv7Dm
rCKuq3lT6HUauBMfk4VXne6a6NGxELpYXhzTGzuiBgoBHTrBvmMpZKgL4nC4YwPw
I2xEp7txYgUx6E3w42opaxSZT5kcCc0OOhZK3n+6EC2BwWGKnQzs9Wk06mCim3sj
29w5o7O4cjkL90OOCygP7SYEAk9WgL7+i2GzM/8mi77kSlZGv+wKDc+m16E99o26
Mw55xH8C0m19uKV1nbsG8vhZQBbKvwRd/RWdgHmcO86BYekVRWut/3PBNEOfFrm1
B67S8y+1QqJXEN/r+wIMmC+VdD3/Nx6hipXkRGTzm58YbngYI8X7q0hJh3/FW3/C
QUVIJ5WNIT4VRZfL6jus6b/DoiXnP/j241hahbddfRwR9ta2aMX7tEfHBv8JcAWl
iaLNLv3RHXkM101bPkV6ZUxBq4b0HN7APlhvqW7y/e1kWN8X046DYzxWs29Z1yZx
6NO/yXVC0IxL7z/S0MhOjQQs4CPbyS40eNWmUSoX+/tmQ2XAth3TXvYbnK96NRr3
kHZYRTzqzuahYUF+syir2d6eIOCN8pX6qKFRaOAXSRd9qqdSq+4=
=1bQW
-----END PGP SIGNATURE-----

--=-hgH8ajv8mnTRUcpAfvv/--

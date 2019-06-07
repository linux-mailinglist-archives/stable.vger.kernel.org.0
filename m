Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 163EF38AD5
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 15:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728257AbfFGNCX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 09:02:23 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47644 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727566AbfFGNCX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jun 2019 09:02:23 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hZEVg-0005wI-0v; Fri, 07 Jun 2019 14:02:20 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hZEVe-0007qz-VX; Fri, 07 Jun 2019 14:02:18 +0100
Message-ID: <b1c9339054e583569888243331c0c7dd28591410.camel@decadent.org.uk>
Subject: Re: 425aa0e1d015 ("ip_sockglue: Fix missing-check bug in
 ip_ra_control()")
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Gen Zhang <blackgod016574@gmail.com>
Cc:     Zubin Mithra <zsm@chromium.org>, stable@vger.kernel.org,
        gregkh@linuxfoundation.org, groeck@chromium.org,
        davem@davemloft.net, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net
Date:   Fri, 07 Jun 2019 14:02:09 +0100
In-Reply-To: <20190607024115.GA4196@zhanggen-UX430UQ>
References: <20190603230239.GA168284@google.com>
         <69e47f52ec342b6c70c1cae6cd0140a51a713752.camel@decadent.org.uk>
         <20190607024115.GA4196@zhanggen-UX430UQ>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-Qd9Ufj6EiP5bIp/Df7vp"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-Qd9Ufj6EiP5bIp/Df7vp
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2019-06-07 at 10:41 +0800, Gen Zhang wrote:
> On Thu, Jun 06, 2019 at 07:58:35PM +0100, Ben Hutchings wrote:
> > On Mon, 2019-06-03 at 16:02 -0700, Zubin Mithra wrote:
> > > Hello,
> > >=20
> > > CVE-2019-12381 was fixed in the upstream linux kernel with the commit=
 :-
> > > * 425aa0e1d015 ("ip_sockglue: Fix missing-check bug in ip_ra_control(=
)")
> > >=20
> > > Could the patch be applied in order to v4.19.y, v4.14.y, v4.9.y and v=
4.4.y ?
> > >=20
> > > Tests run:
> > > * Chrome OS tryjobs
> >=20
> > This doesn't fix a security vulnerability.  There already was a check
> > for allocation failure before dereferencing the returned pointer; it
> > just wasn't in the most obvious place.
> >=20
> > I've requested rejection of this CVE, and several other invalid reports
> > from the same person.
> And where did this 'invalid' come from? Did any maintainers claimed the=
=20
> patch 'invalid' or something? I am confused...

I'm not saying the patch is invalid.  It makes the code clearer and
seems to result in returning a more appropriate error code.  So I don't
disagree with the patch, only the claim that it's fixing a security
issue.

My requests to reject the CVE assignments were made using MITRE's web
form.

Ben.

--=20
Ben Hutchings
Life would be so much easier if we could look at the source code.



--=-Qd9Ufj6EiP5bIp/Df7vp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAlz6YFIACgkQ57/I7JWG
EQk46RAAwfQQsPrNU/YlsrNH0Sn381nC3NpYoH2dj8LGU4/WrwU+Hj2kzwGPVFyL
VzXSEUjQkrLE0bXDjpBgSrsdbxdZ3qG90I0uq6zZleg7MnR7Nw5m0KxFVaCz1/Of
Cxp5eU8dcAEioc3L4V4ww11VU4FDXyGGSf6mb0poq6VL9ZriOEghm/UJZ1abST5X
ol2NUxs/4fXoe5RFFEV4eiJeIkllAnV9mFSkBCD12U7sTtDTvXdtI3NuRCHqIEnl
kJuXa3EV2tZaoesJsKqPbkyAr7sZ/IQ/iltqlboxkGcTqqhsIXeURsptRWooRhjJ
LzaYKVR6+B12V1jUqL8QiFsLLVDYVtj4+X0ABs6QfQfJX3maOdDAOvCTA2elUL/m
QJw2MkBgSAJ1ex041nw0n2e5n7DJ7fNdkzr5ZbiX7s915t0sZCXNlvw9sD5nDESG
ZksthJUh/rNHbKWmFRekXeJ6u2C5idI6t4BsJDvlNzevekrr6TrhJoK6jljjOVVv
crrM0YIOe4k1tDieCSqdK7rupz5HjMV59yJX4AbIKanaNSu0Fgt6qUcy2aQhVsym
lguLKZvrl6NwIF4KOfaw+qH5y5snnb7OlnEoxjuniElKz7uzaGFvPoIg0YoaciDm
BIUq9Qk5Il+9S3q33660eRmRg1IV47txjoM+ACov8GIveWEFfiw=
=f5dO
-----END PGP SIGNATURE-----

--=-Qd9Ufj6EiP5bIp/Df7vp--

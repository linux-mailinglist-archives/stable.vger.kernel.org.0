Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD82437CE0
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 20:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbfFFS64 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 14:58:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41396 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726762AbfFFS64 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jun 2019 14:58:56 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hYxb9-0003Ws-U8; Thu, 06 Jun 2019 19:58:52 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hYxb8-0007s6-QA; Thu, 06 Jun 2019 19:58:50 +0100
Message-ID: <69e47f52ec342b6c70c1cae6cd0140a51a713752.camel@decadent.org.uk>
Subject: Re: 425aa0e1d015 ("ip_sockglue: Fix missing-check bug in
 ip_ra_control()")
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Zubin Mithra <zsm@chromium.org>, stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, groeck@chromium.org,
        blackgod016574@gmail.com, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net
Date:   Thu, 06 Jun 2019 19:58:35 +0100
In-Reply-To: <20190603230239.GA168284@google.com>
References: <20190603230239.GA168284@google.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-ewz7wmQAJfdAc6SwDq22"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-ewz7wmQAJfdAc6SwDq22
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2019-06-03 at 16:02 -0700, Zubin Mithra wrote:
> Hello,
>=20
> CVE-2019-12381 was fixed in the upstream linux kernel with the commit :-
> * 425aa0e1d015 ("ip_sockglue: Fix missing-check bug in ip_ra_control()")
>=20
> Could the patch be applied in order to v4.19.y, v4.14.y, v4.9.y and v4.4.=
y ?
>=20
> Tests run:
> * Chrome OS tryjobs

This doesn't fix a security vulnerability.  There already was a check
for allocation failure before dereferencing the returned pointer; it
just wasn't in the most obvious place.

I've requested rejection of this CVE, and several other invalid reports
from the same person.

Ben.

--=20
Ben Hutchings
Experience is what causes a person to make new mistakes
instead of old ones.



--=-ewz7wmQAJfdAc6SwDq22
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAlz5YlwACgkQ57/I7JWG
EQkvBhAA1IW9L8a4Qn2X/JqEo1W+S5a5nRTVcXx7bTVcQYMMIpj2kgLoSV6ifhUP
JB8qxdBBfHKuaHtApdHoMqJynCO4SHJLzxuOokdCRtMC+6ho+jc+9NWhnqq01YBW
hoRxqPnAr8JCE8CBKypCK0WKkKJbKhIBmHJaonIp8nbBHIMG/2Vq/4qmJUwnlnHO
KBP0hgaLC598tvchLnanFDYrTMH/SwR/eixbipUGS45mMa7dY6Cy725xTa5VknOJ
U0/f/zAu5sFb4TrT5LNb+V9iCUcN9dOt6vLs2guctCa55NzM8QTzN7cDZoAt7kgS
YEFjHmWpRqKEDYjeR818kH7Z5LwcqPx6ZtewwHWpbaI3BReqKLzWLjKz0Q7aReyp
QZY5Obeipd5buJlc2Jhl/6kRGQJUVAc1i6n1OG0JFrAGQfAd0O6hb6pcsqC9gw6J
4Yoxhxa1W5+3G0XmeAcB5sx1+RIobDh+EL1TBZppX7IUIHybPBJKbamL8QnzI3vY
jGPDhJHFo+WJiCNcL74yAxJaLyygcwuR+YMxbCTr981Tx6+1WK15DRoxfyYgmjOi
evu0LPW80ZM0NGWo7e+kWn0vcBKTuArwddQuRGJGafb6YMhbpfX7OsXcfCFCMYCy
z1PyQcRDDlmFi9lSXAsEeYdyiyjrVXPMwgXP5rfCImcmmBl+pUo=
=gRo3
-----END PGP SIGNATURE-----

--=-ewz7wmQAJfdAc6SwDq22--

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1A61AFD40
	for <lists+stable@lfdr.de>; Sun, 19 Apr 2020 21:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726022AbgDSTKN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Apr 2020 15:10:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51436 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725848AbgDSTKN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Apr 2020 15:10:13 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jQFKS-0001sS-Ri; Sun, 19 Apr 2020 20:10:09 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jQFKS-003EXP-E8; Sun, 19 Apr 2020 20:10:08 +0100
Message-ID: <bfae889d03f1890e00abf29a184ba1e955cb150b.camel@decadent.org.uk>
Subject: [stable] dm flakey: check for null arg_name in parse_features()
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable <stable@vger.kernel.org>
Date:   Sun, 19 Apr 2020 20:10:03 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-gMYNu1V0BCgW/n6CWMhl"
User-Agent: Evolution 3.36.1-1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-gMYNu1V0BCgW/n6CWMhl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Please pick this fix for 4.4, 4.9, and 4.14 stable branches:

commit 7690e25302dc7d0cd42b349e746fe44b44a94f2b
Author: Goldwyn Rodrigues <rgoldwyn@suse.com>
Date:   Sun Dec 3 21:14:12 2017 -0600

    dm flakey: check for null arg_name in parse_features()

Ben.

--=20
Ben Hutchings
I say we take off; nuke the site from orbit.
It's the only way to be sure.



--=-gMYNu1V0BCgW/n6CWMhl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl6cogsACgkQ57/I7JWG
EQlVHRAAjtQcAipQITaeGt4r2r0HtkLqhfKmxfDNPejK7bKdlZY36fByayTCQ7On
LBZbAu1/l8+Kevwy53sh1O+ji52j3qV12o5VG9RUyrNaW+Sn5V+Ao/24Ta7XG90B
Tnm2TLl1QXKX/BfDSdsyiXhLof9/1ZVV4AwvuqMdlZr8QqVh6FsgLyc4TrGBQLLL
Agl5itAcPlsUghQt7CSMVy5SFoqVChowBsgk91XhyUKAK1eoCB/TzEnztCNOnIeJ
kGHKRzj7dus8/1bx6Lttgk72sZQHQ0kZVGi1IEqfO6q7zghJvdeyDuzXgDNCriKn
ccPcw20dv5bJnDFrle+La7TYEneamnpVviFcTVr7xcJsPTj4muFxS/f3kYXhhvj+
TmzGNjme6Jz3nnzM/t8FOyFtJUZE9iElDc5Q7jrdeSNkGMBtP95qYag9FpamfUWS
9tQoFJhrXPmUYuBEedlWmVzlHeLz2B5J59MM6fjdjgjk5DB+Pj7TMy07LWV6j53+
b9nqGkJmt3z99quk/sbmyz9WO/TTiBUEUFBFB+KkjZTSvSqrSPhKf2qZ9LEsV1lu
NzyOkOpOykhVkEIm2c71tYpqkK1R/BLd95O2uyN4zhs4sFyEQa6yfUbMj52J9+Af
eIt2mAfMgEhJCNfqL68ErwROFtzVzbIHhtU4DDRYF4Lw7nz5Cys=
=lDxz
-----END PGP SIGNATURE-----

--=-gMYNu1V0BCgW/n6CWMhl--

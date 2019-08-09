Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2817878FC
	for <lists+stable@lfdr.de>; Fri,  9 Aug 2019 13:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406127AbfHILqo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Aug 2019 07:46:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42736 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726157AbfHILqo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Aug 2019 07:46:44 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hw3M2-0000Lp-GF; Fri, 09 Aug 2019 12:46:42 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hw3M2-0004Fy-9u; Fri, 09 Aug 2019 12:46:42 +0100
Message-ID: <2df1e3caea566bcfd0338734f1cea6083264d597.camel@decadent.org.uk>
Subject: Re: Grand Schemozzle, 4.9 backport
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date:   Fri, 09 Aug 2019 12:46:37 +0100
In-Reply-To: <20190809084444.GA9820@kroah.com>
References: <1fcba38ae50cb4e740839c825fb2eb96b3c54956.camel@decadent.org.uk>
         <20190809084444.GA9820@kroah.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-pOPz/3CZWcBQTfXTKi2P"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-pOPz/3CZWcBQTfXTKi2P
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2019-08-09 at 10:44 +0200, Greg Kroah-Hartman wrote:
> On Fri, Aug 09, 2019 at 01:05:28AM +0100, Ben Hutchings wrote:
> > Here's a lightly tested backport of the Spectre v1 swapgs
> > mitigation,
> > for 4.9.
>=20
> Hm, you backported 64dbc122b20f ("x86/entry/64: Use JMP instead of
> JMPQ") which is not in 4.14.y,

For 4.14, it was apparently folded into the backport of
"x86/speculation: Prepare entry code for Spectre v1 swapgs
mitigations".

> yet you did not backport 4c92057661a3
> ("Documentation: Add swapgs description to the Spectre v1
> documentation") which should go to this kernel too, right?

That touches a file that doesn't exist.  We'd first need a backport of
commit 6e88559470f5 "Documentation: Add section about CPU
vulnerabilities for Spectre".

Ben.

--=20
Ben Hutchings
If you seem to know what you are doing, you'll be given more to do.


--=-pOPz/3CZWcBQTfXTKi2P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl1NXR0ACgkQ57/I7JWG
EQlDGQ//dkLbwUVRshUQw3sQoR+zvgog4dOZBoYPP96KwJq2dMr07Rz0JRyXQMe+
USqSEvH6RqZmp7tFm2pwxytLSwKeWfvtARQ+uG+RUFLwQpA9AifYmxOIkPIRfZuq
c74Irxfsb9UsrvAHBiUgxgxBuTknUICPormiUAQlhneN3zQTJX7uHIY/O+dOW7aj
YtCzvmjmyEc040KuqFrpvdxDw11NpNda+uq9rL2RIWSbWrupteJE0xpJ06iCsRHn
yE4j/YXykb4/OBfuM7jXThFvQFkj5U1DO/itfQkrJJXPTovE0v+bHqfwg3fS63jd
kDl2qpdPwJ983HooEt+uCoUsJQHOT5+5gZd1Nzsy0xKZo5A0XFMjX5ousmuVs0JJ
mbDSbjtPKyNO102ITpNHaYtlmnBD+E6uXd+SKyJiIAad3CoDdczLy89dC9DVmyBR
PnwCnwjbkgFDSSZcFfA58+SdDVmDhMjc+DsdyEyI7+TRwO/a+YdpsvRLefRrN9YJ
Gr1sPelmiQQt5J82e9HvvaRuVeTDhk7flRkqvogGm+dfGj3yidwlOfgnl0GjvnHS
YQftyra027ypHOJfcXD5VT93MTA4k/ikGEBeFTWjF+y6jLfQJlZ66CZiiFLgPFD1
Vxa1zS5ZAkuaJI33dZ0D0b+xHR2dKYMMucjYGXJGQXP3ruMDdTY=
=oj5p
-----END PGP SIGNATURE-----

--=-pOPz/3CZWcBQTfXTKi2P--

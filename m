Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6021B7BA3
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 18:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbgDXQbe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 12:31:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56496 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726753AbgDXQbd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Apr 2020 12:31:33 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jS1Ei-0003kV-6C; Fri, 24 Apr 2020 17:31:32 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jS1Eh-00FNTn-OK; Fri, 24 Apr 2020 17:31:31 +0100
Message-ID: <671a7ecd8990a80a7d5c8bd99487a903e5d256f7.camel@decadent.org.uk>
Subject: Re: [PATCH 3.16 246/247] futex: Fix inode life-time issue
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        Jann Horn <jannh@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Fri, 24 Apr 2020 17:31:27 +0100
In-Reply-To: <20200424155629.GB13558@hirez.programming.kicks-ass.net>
References: <lsq.1587743245.5555628@decadent.org.uk>
         <lsq.1587743246.9036831@decadent.org.uk>
         <20200424155629.GB13558@hirez.programming.kicks-ass.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-hJ6t8NK+c2kFVPK4pbOk"
User-Agent: Evolution 3.36.1-1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-hJ6t8NK+c2kFVPK4pbOk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2020-04-24 at 17:56 +0200, Peter Zijlstra wrote:
> On Fri, Apr 24, 2020 at 04:51:31PM +0100, Ben Hutchings wrote:
> > 3.16.83-rc2 review patch.  If anyone has any objections, please let me =
know.
> >=20
> > ------------------
> >=20
> > From: Peter Zijlstra <peterz@infradead.org>
> >=20
> > commit 8019ad13ef7f64be44d4f892af9c840179009254 upstream.
>=20
> Please do not forget:
>=20
>   8d67743653dc ("futex: Unbreak futex hashing")
>=20
> which fixes this fix.

I didn't, Jann reminded me to include both of them.

Ben.

--=20
Ben Hutchings
Knowledge is power.  France is bacon.



--=-hJ6t8NK+c2kFVPK4pbOk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl6jFF8ACgkQ57/I7JWG
EQn5OA/9FNM6d/vEG3o6aVd7cfAuz6oDZPnmIHYxxhoGszWob5/U6HTzP4Fa9GOc
+JZph5F9DOGx1rwx5shIRQgdTv4idkcsfkWw4BnaeKoH/8LlUWk/N4Cq7Am0gMae
zGuVdhQe897vUTzVKuaAUwdefFHCkka7LjJ6I+ggy2hdoSLlAzLljIiMNpvuj4So
m1GQKJGT7SgPAqFjxk94RFYYXiurbkmW/f9401DgS7vE1+FeAXOHIWrkJ+DNiwA3
b9N7PfQoXIIFH4rMygFEMx2ZRb0FETGE5m0U22AAz2CsTn/4dTCvsZ1ynaxC0qZD
OSHnghYSCT1phgKVAZdmR9J3Cst2LBwf6A9zl6Q73jMvdXOUctzy+knvpAV1h2wo
+Q7WQUnrMQ+tfgIDg57tQJMksxVdHC3rVGgIMs7W2X1xEW4xdPM5KwoFrY5Munx5
/UyEDnqA0vF8hQf7huGwtvANxSYcspxtLOhzKvo2RyFEgBazY1IUMd2v8OQb5yK0
70QcsHkqYzrallpAhlqQKlfDmfeOvxdAoPMJBPvymfmc0w1jrwB1FDq34aB/SlPb
MsXtLpm8/kw1ev2B2XmUlwUxB9jneyoAbyhinHXiUZUcZ7YpeuLYzj193JQkjMBN
5cgciLN7XxssV6WycRnJS3d9UorLSW5+JnOVCqN7HAZu8qBrfkk=
=ZGQ9
-----END PGP SIGNATURE-----

--=-hJ6t8NK+c2kFVPK4pbOk--

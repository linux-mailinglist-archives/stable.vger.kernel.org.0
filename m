Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C65413720A
	for <lists+stable@lfdr.de>; Fri, 10 Jan 2020 17:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728452AbgAJQBn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jan 2020 11:01:43 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56712 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728438AbgAJQBn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jan 2020 11:01:43 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipwjE-00057c-Pp; Fri, 10 Jan 2020 16:01:40 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipwjE-007kHf-8R; Fri, 10 Jan 2020 16:01:40 +0000
Message-ID: <06888d5dc85085a47ea1465167c604fd9fec5210.camel@decadent.org.uk>
Subject: Re: [PATCH 3.16 62/63] mwifiex: fix possible heap overflow in
 mwifiex_process_country_ie()
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        huangwen <huangwenabc@gmail.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Brian Norris <briannorris@chromium.org>
Date:   Fri, 10 Jan 2020 16:01:35 +0000
In-Reply-To: <20200109121117.GB1270@lorien.valinor.li>
References: <lsq.1578512578.117275639@decadent.org.uk>
         <lsq.1578512578.718890478@decadent.org.uk>
         <20200109121117.GB1270@lorien.valinor.li>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-ZR8BUZ9emYzfycMaU3ru"
User-Agent: Evolution 3.34.1-2+b1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-ZR8BUZ9emYzfycMaU3ru
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2020-01-09 at 13:12 +0100, Salvatore Bonaccorso wrote:
> Hi Ben,
>=20
> On Wed, Jan 08, 2020 at 07:44:00PM +0000, Ben Hutchings wrote:
> > 3.16.81-rc1 review patch.  If anyone has any objections, please let me =
know.
> >=20
> > ------------------
> >=20
> > From: Ganapathi Bhat <gbhat@marvell.com>
> >=20
> > commit 3d94a4a8373bf5f45cf5f939e88b8354dbf2311b upstream.
[...]
> Brian Norris noted that this commit has unbalanced locking and
> submitted a followup as per:
>=20
> https://lkml.kernel.org/linux-wireless/20200106224212.189763-1-briannorri=
s@chromium.org/T/#u
> https://patchwork.kernel.org/patch/11320227/

Right, but is the new behaviour (possible wrong preemption count)
actually worse than the old behaviour (possible heap buffer overflow)?

I think we are better off applying this now and adding that fix once
it's upstream.

Ben.

--=20
Ben Hutchings
Every program is either trivial or else contains at least one bug



--=-ZR8BUZ9emYzfycMaU3ru
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl4Yn98ACgkQ57/I7JWG
EQn16A//XEMgPF4aBkvCtF9xPbvG++8Vu7mpj9BhAq37kMJ0R6GVlRlS+AnVgNgW
ZgxAQvR3FBu92nLnMcegEJtA7bqXMI2js1oN5zPMrOeeI1mBcv9Y4jl2R8MkGR82
0fK2LHkGl7cF12yL5mQXkZqmXxljnvoJfyY2+XaaHrkSgPDprpvwT+gvbCYVzhA5
VMuWg72TPAB5G1PQ9b+S0i/t2oTff0EIpM98fqp5jq98mcqVaZsPxh3aOpzxDclD
arpTgBk5BNPVxd1fUPx4xK3UGSpqdQeypSy+Gn4xwI0HgQvOBe4K/6i8XO8c5FzR
DLlh+gqs8nx1hqMH1Wg7dYi2DPdydJBgq60/YydezCI7NQmGMPYuE6QZdcxjH468
Pmr6M4KQOTJumP3gEm3U5qK02bGkMobnQ6QNY0FxbJiiOnXvNS89o+LMKoSB+aGq
Rz5/oCnPtZEYhExQcyv2KgrYXwLJ7Ve1zA2svR889YVxRJZiZD3MaJN+MM75I8mZ
5Tq7Np5UXotFEovNv57T30pRXvYCcD6vfrJxNEfZ79ZXlxXAS8X90BAbJ9NC9nEv
+xLYOc1/WWi5M4mfbwQD3m791BFXJkJnFhIoW8MeVkXOn7dzucv1Asb14iNNzvi6
620eyDLyWjXUMVt5MBZhlmgK6l269zk4nbGOjMwjTE9QAOu7ISE=
=JU6T
-----END PGP SIGNATURE-----

--=-ZR8BUZ9emYzfycMaU3ru--

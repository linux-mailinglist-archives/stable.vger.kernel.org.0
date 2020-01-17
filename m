Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A64A14014D
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 02:08:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387678AbgAQBFt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 20:05:49 -0500
Received: from smtp.bonedaddy.net ([45.33.94.42]:35588 "EHLO
        smtp.bonedaddy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727022AbgAQBFt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jan 2020 20:05:49 -0500
X-Greylist: delayed 487 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Jan 2020 20:05:49 EST
Received: from chianamo (n175-38-4-223.per2.wa.optusnet.com.au [175.38.4.223])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pabs3@bonedaddy.net)
        by smtp.bonedaddy.net (Postfix) with ESMTPSA id B8942180043;
        Thu, 16 Jan 2020 19:57:43 -0500 (EST)
Message-ID: <2479db5788a3c776d3c38d2e3b87c570f9a41ea8.camel@bonedaddy.net>
Subject: Re: [PATCH AUTOSEL 4.4 116/174] coredump: split pipe command
 whitespace before expanding template
From:   Paul Wise <pabs3@bonedaddy.net>
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Jakub Wilk <jwilk@jwilk.net>, Neil Horman <nhorman@tuxdriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org
In-Reply-To: <20200116174251.24326-116-sashal@kernel.org>
References: <20200116174251.24326-1-sashal@kernel.org>
         <20200116174251.24326-116-sashal@kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-GSXQFiNy98loWZ2QPEBN"
Date:   Fri, 17 Jan 2020 08:57:35 +0800
MIME-Version: 1.0
User-Agent: Evolution 3.34.1-2+b1 
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-GSXQFiNy98loWZ2QPEBN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2020-01-16 at 12:41 -0500, Sasha Levin wrote:

> From: Paul Wise <pabs3@bonedaddy.net>
>=20
> [ Upstream commit 315c69261dd3fa12dbc830d4fa00d1fad98d3b03 ]

Sasha, we already agreed in [1] and [2] that this patch should not get
backported to earlier versions of Linux, would you mind teaching your
patch autoselection about that so that it doesn't get backported?

1. https://lore.kernel.org/lkml/c835c71b722c3df3d11e7b7f8fd65bbd7da0d482.ca=
mel@bonedaddy.net/
2. https://lore.kernel.org/lkml/20190818014841.GF1318@sasha-vm/

--=20
bye,
pabs

https://bonedaddy.net/pabs3/

--=-GSXQFiNy98loWZ2QPEBN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEYQsotVz8/kXqG1Y7MRa6Xp/6aaMFAl4hBnkACgkQMRa6Xp/6
aaPi0Q//cebVmScish+TwhHnq8zxYtq+fBQYrnLGDtKdSBDnfYalZgtOIi6qRni3
GSvMUuclWoCCWSgWPvnjAhaEPdhg5YLOkc7rvqrBYkxbg2hjmZZ1xdaMOJX1Mgd1
kCnS02u2Lm1BMPY7dtbiXBmrp7eFbL6Pkf/4wzqihGEJhUtZ9+EkbMbYJ0rSxEvP
Z9qsQGoLk+Zfldv/Pn8yH4+HpIEMYB7WM76MjJJS3qmzR6fNvvK/W6ZVVh5N96iL
HHpV33GQnQzl3t9xuh4ryxMTmovQY4D3V1k7DMNP7Akl8CdwZjYBsIJJuv46rMAm
vmwQUpjMxA0xupQ1MOpW4SSvWQdvTM3Js0Q8tIj4tIEZZtQAOB9n3MtKuY2+qQdi
qlqgaM4TgzACPNT4JC291tr7IdkQSQvoPMr+o6fzvmzYKjOxcjpVx3PEfay/BbsN
dO0UJVRLJmG7IlX8ci8Xz8mwCvhiCVWyW5C6ULpSpB3ARgVxUGqndcIIIjUh0lYm
T0aG7fU6FoAOSpAlLtbBS/lfOmmL0ismCqTDrL5+GraILkC24HatXLioHLemnp9s
xmXk3LqOl6YzKKkF/3NH+riAspoweFKbVQKwp7ebUimAVRKjdnsVFeMtL0r96i5W
c19Kn1Xc50RUP0MRo+pAFuhsnjweVV0s2GRbtsI9Q1uasT+rM/Q=
=ShSX
-----END PGP SIGNATURE-----

--=-GSXQFiNy98loWZ2QPEBN--


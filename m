Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A739F413C5B
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 23:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234493AbhIUV05 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 17:26:57 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:45254 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234385AbhIUV04 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 17:26:56 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 583451C0B7C; Tue, 21 Sep 2021 23:25:26 +0200 (CEST)
Date:   Tue, 21 Sep 2021 23:25:26 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 100/122] gpio: mpc8xxx: Fix a potential double
 iounmap call in mpc8xxx_probe()
Message-ID: <20210921212526.GA28467@duo.ucw.cz>
References: <20210920163915.757887582@linuxfoundation.org>
 <20210920163919.067590477@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
Content-Disposition: inline
In-Reply-To: <20210920163919.067590477@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit 7d6588931ccd4c09e70a08175cf2e0cf7fc3b869 ]
>=20
> Commit 76c47d1449fc ("gpio: mpc8xxx: Add ACPI support") has switched to a
> managed version when dealing with 'mpc8xxx_gc->regs'. So the corresponding
> 'iounmap()' call in the error handling path and in the remove should be
> removed to avoid a double unmap.

This is wrong, AFAICT. 5.10 does not have 76c47d1449fc ("gpio:
mpc8xxx: Add ACPI support") so iounmap is still neccessary and this
adds a memory leak.

Best regards,
								Pavel
--=20
'DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk'
'HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany'


--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYUpNxgAKCRAw5/Bqldv6
8pzMAKCzDPu78SUUCBOXMUvMmgSTMVVHaQCdFCPSgYWZJ6SJ641FhcV8C8/7j9g=
=gwmp
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--

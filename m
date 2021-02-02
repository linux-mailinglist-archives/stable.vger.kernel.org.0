Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9847E30C541
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 17:18:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233286AbhBBQR2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 11:17:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:53988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235124AbhBBQOL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 11:14:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40EED64F59;
        Tue,  2 Feb 2021 16:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612282410;
        bh=5HywIx9nRgIariGnFBrJVmtHnLOhr/Cqmp+09dvI/I8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TdO6zUhFNLjFYAJQtZSHzYmq/o6hgfC/Zxy6KNV/bDwHKl36bL2HmrQ1jmkAdEy45
         Ag3BJ/1IpfrSkCvayvz9375lyWK/Ea/WYH2OY+O3CBQhwhqpI5rcwXOe/++y+yrCVG
         MyX5yZ5PS4kmrzJH4M8zsYGIsj9fplZtNWG8XxthZmw8iMDDnweIwb6DaZGApww3YR
         QUCe//TdzVkD7vRBvmNBfFPPxkmEDsAQWi6PCPmWFXtbkM9Xo1GZPS1DYWQUmfNWc6
         BqjB+mb8oYtlzSjm7VpzZ9PAIWZ4tbaRdvzMlxhM0Bx0aORuYmvjTBdRfJFXXWwRFl
         9xkdd/60FU8xw==
Date:   Tue, 2 Feb 2021 16:12:43 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        David Collins <collinsd@codeaurora.org>
Subject: Re: [PATCH AUTOSEL 5.10 02/25] regulator: core: avoid
 regulator_resolve_supply() race condition
Message-ID: <20210202161243.GD5154@sirena.org.uk>
References: <20210202150615.1864175-1-sashal@kernel.org>
 <20210202150615.1864175-2-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="3Gf/FFewwPeBMqCJ"
Content-Disposition: inline
In-Reply-To: <20210202150615.1864175-2-sashal@kernel.org>
X-Cookie: Only God can make random selections.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--3Gf/FFewwPeBMqCJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 02, 2021 at 10:05:52AM -0500, Sasha Levin wrote:
> From: David Collins <collinsd@codeaurora.org>
>=20
> [ Upstream commit eaa7995c529b54d68d97a30f6344cc6ca2f214a7 ]
>=20
> The final step in regulator_register() is to call
> regulator_resolve_supply() for each registered regulator
> (including the one in the process of being registered).  The

This introduces a lockdep warning, there's a follow up commit if you
want to backport it or it should be fine to just not backport either.

--3Gf/FFewwPeBMqCJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmAZefoACgkQJNaLcl1U
h9Bcpwf/bHQxyBpio5OKP8LF+rBXyCd8QztvMgv9ehts7j78n7VP/Baie+Xh0sny
kSfij+3ffTsiUIVYNPG+0fRIg4/obLaEC3BfdIz/zFzI3R5GkpXmcYuwCO0p4RYt
CRE3cgoQBHiHN8n/v22+OTP0llRew1lM+cONZpZ8VANdkKAF0uXZw2tXltVdh5PW
lgjJ6BpX0TijsFzW/vg2eDXGiG/Si3blV/nvDzADVi4SQHyZnc8DYM6sEo0NMGK5
lX7S5Ddiuv3OvIq+/NyiSvzXIMhb6fyLDlzw8N0X0TI/S1ULN3kAQHCwWnYtsqix
a5EQBsutiTGGsIXIPQidT7pEqJjDtw==
=MNov
-----END PGP SIGNATURE-----

--3Gf/FFewwPeBMqCJ--

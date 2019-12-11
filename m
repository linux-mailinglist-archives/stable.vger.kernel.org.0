Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 509B611A96F
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 11:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728432AbfLKK7g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 05:59:36 -0500
Received: from foss.arm.com ([217.140.110.172]:53792 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727469AbfLKK7g (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 05:59:36 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3059B1FB;
        Wed, 11 Dec 2019 02:59:36 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A48093F6CF;
        Wed, 11 Dec 2019 02:59:35 -0800 (PST)
Date:   Wed, 11 Dec 2019 10:59:34 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Peng Fan <peng.fan@nxp.com>
Subject: Re: [PATCH AUTOSEL 5.4 177/350] regulator: fixed: add off-on-delay
Message-ID: <20191211105934.GB3870@sirena.org.uk>
References: <20191210210735.9077-1-sashal@kernel.org>
 <20191210210735.9077-138-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="gj572EiMnwbLXET9"
Content-Disposition: inline
In-Reply-To: <20191210210735.9077-138-sashal@kernel.org>
X-Cookie: NOBODY EXPECTS THE SPANISH INQUISITION!
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--gj572EiMnwbLXET9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 10, 2019 at 04:04:42PM -0500, Sasha Levin wrote:
> From: Peng Fan <peng.fan@nxp.com>
>=20
> [ Upstream commit f7907e57aea2adcd0b57ebcca410e125412ab680 ]
>=20
> Depends on board design, the gpio controlling regulator may
> connects with a big capacitance. When need off, it takes some time
> to let the regulator to be truly off. If not add enough delay, the
> regulator might have always been on, so introduce off-on-delay to
> handle such case.

This is clearly adding a new feature and doesn't include the matching DT
binding addition for that new feature.

--gj572EiMnwbLXET9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl3wzBUACgkQJNaLcl1U
h9DVGwf/UCdcYRsvXW7t9t0abHQsN3v809jgTCzYRJZrmccTdGl8v8iKjMFMw2cN
PB16c/NuRElxjsLIrdQvowd9FYpHElStG9HxYPzEQSLssVt2C984sRZmToRgfLmL
gMoyVqQQYcKTcKyx0VmXjWtpgvLNa/E3Fc5cisufp0duyCtKEnknUx6YYCTAIws4
kwKcle6uZJDocZN+HTOkfg/wypFI3/DXc0/D40Yu38URfaf5mfOIumr4EyOBgtPM
/qRBJWmLyUGffMqAx1gxaYJvAnGKLECwwkOtEByhRmHOWQBphABgtUnxz/gIUGJ2
9GuGQQ7JHV+NIqaqSzWqUNLbT9oYgQ==
=xz7B
-----END PGP SIGNATURE-----

--gj572EiMnwbLXET9--

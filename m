Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF6E042BEC6
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 13:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbhJMLSu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 07:18:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:39994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229490AbhJMLSu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 Oct 2021 07:18:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7452F61027;
        Wed, 13 Oct 2021 11:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634123807;
        bh=DVdgBtdPRXpir9rR8KgPam2ARjHEMD012OTknqLNbjw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rnXG8Z9k/uF0L6NF73nRzeQsFcHjBgaZOzOdJneY7E0pQbUpG5/pnT1PjUOeK4Xqe
         yfl+INzevN80njuoRYY13XKkX807gQwP6dEhYtOB2a85bAmR9Eiab3pZJ++4GQokL2
         +OaiITlSFd+p/mVgYV+BlzcXaJ9uMM6wrd63aBe+FD8tTzrfwt0DpzNiTnBnP/tUZN
         T1ON3PoIJUX+aNA5WG7qSbER2LOllGHlaTUuIqXGk3Sv94IR9eKKM5JDO82rq3NAVz
         L0PHWRf2/bnDp5h022hCMvk6DzRrbswTMPbSrIRkSBhBY7xgrh9+REuFqGRTUTExBS
         Vk/0EWOQe4pmQ==
Date:   Wed, 13 Oct 2021 12:16:44 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Will Deacon <will@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Simon Trimmer <simont@opensource.cirrus.com>,
        Michael Ellerman <mpe@ellerman.id.au>, linux@armlinux.org.uk,
        catalin.marinas@arm.com, tsbogend@alpha.franken.de,
        James.Bottomley@hansenpartnership.com, deller@gmx.de,
        paul.walmsley@sifive.com, palmer@dabbelt.com,
        aou@eecs.berkeley.edu, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, geert+renesas@glider.be,
        linus.walleij@linaro.org, rmk+kernel@armlinux.org.uk,
        akpm@linux-foundation.org, anshuman.khandual@arm.com,
        rppt@kernel.org, ardb@kernel.org, u.kleine-koenig@pengutronix.de,
        lukas.bulwahn@gmail.com, mark.rutland@arm.com,
        wangkefeng.wang@huawei.com, slyfox@gentoo.org, axboe@kernel.dk,
        rientjes@google.com, dan.j.williams@intel.com,
        gregkh@linuxfoundation.org, linux-arm-kernel@lists.infradead.org,
        linux-ia64@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, linux-riscv@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 5.14 17/17] firmware: include
 drivers/firmware/Kconfig unconditionally
Message-ID: <YWbAHCYS/IsGyeEw@sirena.org.uk>
References: <20211013005441.699846-1-sashal@kernel.org>
 <20211013005441.699846-17-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Hzj7Ij7mixgewbmh"
Content-Disposition: inline
In-Reply-To: <20211013005441.699846-17-sashal@kernel.org>
X-Cookie: Where do you think you're going today?
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Hzj7Ij7mixgewbmh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 12, 2021 at 08:54:41PM -0400, Sasha Levin wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>=20
> [ Upstream commit 951cd3a0866d29cb9c01ebc1d9c17590e598226e ]
>=20
> Compile-testing drivers that require access to a firmware layer
> fails when that firmware symbol is unavailable. This happened
> twice this week:

This seems *way* too invasive a change for stable.  It exposes code to
building on entire new architectures.

--Hzj7Ij7mixgewbmh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmFmwBsACgkQJNaLcl1U
h9AFjgf9HNz1iDlvraGZuINQkg4b76glybMJpIJI9Q9/fCTbm75p34EctvP3YnrO
TCUYnuynKAfFn6bLAoHN4AO5JLYPELiK1jd3olKo4QbWgHL449nF7NwkBR/bjHNZ
jwefNQMINnMo7bhrsdhmvYjoC9GuSHPSrHkHLKZRBsiCdc1SopabE67oBmTQ06+4
6JOnbKmjExje2UT0JyJwgp59/YVbDOd06QLxA6gLuCPRmCTgYGqXS3/V1e89VwH1
tK4vtT5ICEUVeBinsBUb2MMEAY41vB410JxWhNL9HFVg30fvQw/YDW7mQSdvCL0G
Gf+lxOl5vhEl0xrMPE8gIqtfQ4Kyyw==
=dgIM
-----END PGP SIGNATURE-----

--Hzj7Ij7mixgewbmh--

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9006A11A974
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 12:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728912AbfLKLAI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 06:00:08 -0500
Received: from foss.arm.com ([217.140.110.172]:53816 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726119AbfLKLAI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 06:00:08 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 075D21FB;
        Wed, 11 Dec 2019 03:00:08 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7B8D53F6CF;
        Wed, 11 Dec 2019 03:00:07 -0800 (PST)
Date:   Wed, 11 Dec 2019 11:00:05 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 5.4 197/350] ASoC: SOF: imx: fix reverse
 CONFIG_SND_SOC_SOF_OF dependency
Message-ID: <20191211110005.GC3870@sirena.org.uk>
References: <20191210210735.9077-1-sashal@kernel.org>
 <20191210210735.9077-158-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="4jXrM3lyYWu4nBt5"
Content-Disposition: inline
In-Reply-To: <20191210210735.9077-158-sashal@kernel.org>
X-Cookie: NOBODY EXPECTS THE SPANISH INQUISITION!
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--4jXrM3lyYWu4nBt5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 10, 2019 at 04:05:02PM -0500, Sasha Levin wrote:
> From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
>=20
> [ Upstream commit f9ad75468453b019b92c5296e6a04bf7c37f49e4 ]
>=20
> updated solution to the problem reported with randconfig:
>=20
> CONFIG_SND_SOC_SOF_IMX depends on CONFIG_SND_SOC_SOF, but is in
> turn referenced by the sof-of-dev driver. This creates a reverse
> dependency that manifests in a link error when CONFIG_SND_SOC_SOF_OF
> is built-in but CONFIG_SND_SOC_SOF_IMX=3Dm:

Are you sure this doesn't depend on any other Kconfig changes?

--4jXrM3lyYWu4nBt5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl3wzDQACgkQJNaLcl1U
h9DlBgf/e35F0BWGMvhT5FNlVpGj/p8IkGszXFooKQx4BsGuvOs6c+gXEwfuEPoR
7bZ56PB4XPlg7EF84n9F+kj+tkim0Ra+nK1cizh6S40bWn6aL2K181WhXcJx2ECu
2eF8SEbahQEAHrabJyjQ7Mhzo+GWe3Clt9t+GGZy3ZMfS3gKVR7An7P/T8DzrPx1
yLyUCKMXuXKIodZTic06E2ZEZYndjaEBNQfR2Dvhm2tNn1pRv7MG0IypgboGu2XH
NAOHagDVS35dY7ODpkP4fVY15WFK7nIBAUrYTaVt2cSpoeKe+uxBJ4Asfh/YhGdF
L33+OFWUVb7aKiWfIgqyLv1CHov2gw==
=l1W0
-----END PGP SIGNATURE-----

--4jXrM3lyYWu4nBt5--

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02517212200
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 13:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728514AbgGBLSi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jul 2020 07:18:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:46568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726475AbgGBLSh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jul 2020 07:18:37 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 203BD20884;
        Thu,  2 Jul 2020 11:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593688717;
        bh=cdxltecagHq0EhFz9ytGE2lSNdIS5KFyWAPrZ4YswO8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aptMTPAOA7IY62Fx1xUbr7O9ST1hTCE5Ki36F+yfcSHwHmOr7oG1Trk1dlPbhtn4y
         kh23SjYSmUsd3oF88DiK6oLsNY4lSvJ5edS1c45cT3mCftIOdRgcoWjjFDPzQ+NAWN
         BHgEWSxVqjWdIOvaGJWIsbubrLtN0THuS6B6/wG0=
Date:   Thu, 2 Jul 2020 12:18:35 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        sound-open-firmware@alsa-project.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH AUTOSEL 5.7 15/53] ASoC: SOF: Intel: add PCI IDs for
 ICL-H and TGL-H
Message-ID: <20200702111835.GB4483@sirena.org.uk>
References: <20200702012202.2700645-1-sashal@kernel.org>
 <20200702012202.2700645-15-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="1LKvkjL3sHcu1TtY"
Content-Disposition: inline
In-Reply-To: <20200702012202.2700645-15-sashal@kernel.org>
X-Cookie: I'm rated PG-34!!
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--1LKvkjL3sHcu1TtY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 01, 2020 at 09:21:24PM -0400, Sasha Levin wrote:
> From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
>=20
> [ Upstream commit c8d2e2bfaeffa0f914330e8b4e45b986c8d30b58 ]
>=20
> Usually the DSP is not traditionally enabled on H skews but this might
> be used moving forward.

"This might be used moving forward"?

--1LKvkjL3sHcu1TtY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl79wooACgkQJNaLcl1U
h9AyIQf/XN9wbFDf4Xk7vo1dpnqGOIeu+UDDCw+HCrfG8Z5Io5AC7HOsDfkBKttH
L05GcIeXRt1Qq7x2EFUSnmLkkhDyQI4nTRl2ujhpcTMLHYNCXGbrocUQTpwJVYok
YsbMN0In//I59ey77NKiQwUIj2p/72Lpsq+20HRMzsmfBqQ21i9T7aSZLJmUBrUT
yU43VWKbJUGnYcbsNLygVJCVQdLAEj997Xdqm/CNGyGfzCtFiyk8jLt7jFfVvvw/
jPCloGH0InhuVrPCyVjxnSxpOdr7mxvK3e84hjPL+SfW4ut8fsdcS+xqogf2DFOf
0zRvJzZMv3nuMbhJUx3wwZXm2k1TyQ==
=/OZK
-----END PGP SIGNATURE-----

--1LKvkjL3sHcu1TtY--

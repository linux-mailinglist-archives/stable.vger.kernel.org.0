Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFA61FF022
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 13:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729439AbgFRLBh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 07:01:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:46768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729402AbgFRLB3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jun 2020 07:01:29 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9E1320885;
        Thu, 18 Jun 2020 11:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592478089;
        bh=uojSHgSubx3hK7KyZszmKecAZ2fxoo+s+cuvPCxsTh0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xiT+CFT6qnWMSDWTrRxP5zxZwz+qHwawf9Z68AqKEb8vyy6mpLDoIONXlZP2WZ+d0
         0B92++CGCGimj0kBymBR2T5rHzkHJRTHZL+vpt6r2/0fnawrXeR//2Of43fk6WBmzX
         h9bOluaq26GXblSodft7tB5zFP40jK4xuUdpXS84=
Date:   Thu, 18 Jun 2020 12:01:26 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Daniel Baluta <daniel.baluta@nxp.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        sound-open-firmware@alsa-project.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH AUTOSEL 5.7 055/388] ASoC: SOF: Do nothing when DSP PM
 callbacks are not set
Message-ID: <20200618110126.GC5789@sirena.org.uk>
References: <20200618010805.600873-1-sashal@kernel.org>
 <20200618010805.600873-55-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="eHhjakXzOLJAF9wJ"
Content-Disposition: inline
In-Reply-To: <20200618010805.600873-55-sashal@kernel.org>
X-Cookie: Androphobia:
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--eHhjakXzOLJAF9wJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 17, 2020 at 09:02:32PM -0400, Sasha Levin wrote:
> From: Daniel Baluta <daniel.baluta@nxp.com>
>=20
> [ Upstream commit c26fde3b15ed41f5f452f1da727795f787833287 ]
>=20
> This provides a better separation between runtime and PM sleep
> callbacks.
>=20
> Only do nothing if given runtime flag is set and calback is not set.
>=20
> With the current implementation, if PM sleep callback is set but runtime
> callback is not set then at runtime resume we reload the firmware even
> if we do not support runtime resume callback.

This doesn't look like a bugfix, just an optimization?

--eHhjakXzOLJAF9wJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl7rSYYACgkQJNaLcl1U
h9As0Af7BPVT1E+OmFZJ2fmGTIygx1ScRtYWAs0iknMEs/lkyrWtWtGAKCMxp3F+
yTbJiBrGj6KGCZvc02UISISUaxtSbHNPNMcjeGeBwM8li9rAjXMJMQcDmxjPB4nV
F+EeRtpZZ5uMhIQk5B3wU4/EgBU7nrCNJUwTMsuwoVWaTRdFPSFLt5EBCxWW8X88
sGadYKYd9aJzuRDce3mbLz88dlEb7OXG9we18xnl9Zy+umNwgRyGzdLTvXisbdGb
rADcI2b33lFMRkHH/ymVLXlvoQ1nISmwpkhxBU0pJspOpIIZ5gjuezx7aViPcTkw
Src3w3xN5i64dl5LQI1ssMAIZe2/LA==
=HpMZ
-----END PGP SIGNATURE-----

--eHhjakXzOLJAF9wJ--

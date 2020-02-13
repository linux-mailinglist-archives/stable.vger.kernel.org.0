Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E589E15BDC1
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 12:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729772AbgBMLhE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 06:37:04 -0500
Received: from foss.arm.com ([217.140.110.172]:45350 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726232AbgBMLhD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 06:37:03 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2B9201FB;
        Thu, 13 Feb 2020 03:37:03 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A4F8C3F6CF;
        Thu, 13 Feb 2020 03:37:02 -0800 (PST)
Date:   Thu, 13 Feb 2020 11:37:01 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Jerome Brunet <jbrunet@baylibre.com>
Cc:     Samuel Holland <samuel@sholland.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Jonathan Corbet <corbet@lwn.net>, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/4] ASoC: codec2codec: avoid invalid/double-free of pcm
 runtime
Message-ID: <20200213113701.GA4333@sirena.org.uk>
References: <20200213061147.29386-1-samuel@sholland.org>
 <20200213061147.29386-2-samuel@sholland.org>
 <1jr1yyannl.fsf@starbuckisacylon.baylibre.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="qMm9M+Fa2AknHoGS"
Content-Disposition: inline
In-Reply-To: <1jr1yyannl.fsf@starbuckisacylon.baylibre.com>
X-Cookie: Academicians care, that's who.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 13, 2020 at 09:37:18AM +0100, Jerome Brunet wrote:

> This brings another question/problem:
> A link which has failed in PMU, could try in PMD to hw_free/shutdown a
> dai which has not gone through startup/hw_params, right ?

I think so, yes.

--qMm9M+Fa2AknHoGS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl5FNNoACgkQJNaLcl1U
h9Anuwf/SQT6ubriSIEq1TwGCzPNYCbx2WjOhRIjTbtNwtmezyCgzCOThrEEuRZh
VjvYkn7VqZBgoHsh43+vqiwtI3eLXwrX02o4izW1srdqfh2ZDAMmHH37qf8zfYmv
S7bC9gDSY8sFOjSevEKgk6MC/3h60PKK0Q7FWc/A1B8Fqo5ZaoeuYrMqw0x2yQVI
1DRTlhVoOKIQ+tjKIPmRwTt1KyJi9FlhN5oW2hEpIpMOK34jnVyKBMHESopGF6tT
fFPPHWKfZlxP8SkwtcYsH1xxrZC5LwlPA8haNBQAtniDaVG+PlndvoN69UfBudPw
s7tJfn+2MEXC0NEJzXukYpwwHkuu1A==
=r51Q
-----END PGP SIGNATURE-----

--qMm9M+Fa2AknHoGS--

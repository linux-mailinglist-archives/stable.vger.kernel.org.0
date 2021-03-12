Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC82F33900A
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 15:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbhCLO3n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 09:29:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:33352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231670AbhCLO30 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Mar 2021 09:29:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4315664F59;
        Fri, 12 Mar 2021 14:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615559365;
        bh=Ew7I58oO5yr5QKDwsafuutxkOSwTubXEyD4x83nFw78=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oCSuOW4E3jjZyMZfdproKJsHPBIMYMTekMwkUJKwMTZD7p2PfuXByZiGfP6msAKJo
         2aXt14/Kp1L4cULfb3xgaQ6Y+guXK1iqrbyKo9fT84iphstD2vYQ3hvexMySdjX0Tu
         FMo8iWD2kXw4aENMXJAFIB84kVwppx1Lf5O/Wu2A3GSm8XXUxbxEPBrrSTiln7ZTV3
         3QLCwWZJ/KqlNyPWGcbcMnvuL3Gcv1nk9u6MZAXppgpkgq671DYgN6xbMqZP1KDFJE
         fJTaEGVQ36gbbpa3Gdf7Tqgunl5mSi0X+U/44pD7xPpxD8hnvTps+cQOyQVWIG3PaP
         kXrNMLYSU8ZRw==
Date:   Fri, 12 Mar 2021 14:28:12 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc:     alsa-devel@alsa-project.org, tiwai@suse.de, stable@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH v3 1/2] ASoC: samsung: tm2_wm5110: check of of_parse
 return value
Message-ID: <20210312142812.GA17802@sirena.org.uk>
References: <20210311003516.120003-1-pierre-louis.bossart@linux.intel.com>
 <20210311003516.120003-2-pierre-louis.bossart@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
In-Reply-To: <20210311003516.120003-2-pierre-louis.bossart@linux.intel.com>
X-Cookie: sillema sillema nika su
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 10, 2021 at 06:35:15PM -0600, Pierre-Louis Bossart wrote:

> Fixes: 8d1513cef51a ("ASoC: samsung: Add support for HDMI audio on TM2board")
> Cc: <stable@vger.kernel.org>

Commit: 11bc3bb24003 ("ASoC: samsung: tm2_wm5110: check of of_parse return value")
	Fixes tag: Fixes: 8d1513cef51a ("ASoC: samsung: Add support for HDMI audio on TM2board")
	Has these problem(s):
		- Subject does not match target commit subject
		  Just use
			git log -1 --format='Fixes: %h ("%s")'

--ibTvN161/egqYuK8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmBLensACgkQJNaLcl1U
h9BDVQf+JmTb2eFaj/+i3MC7LdW/OzcK4abEDlS+MLGWKruSdRPO5cPelqjWL5Xi
1pGsv6YvQus7jg/rfKEY1TY3pt+ml8X3vnTovWjfRhxODR2FSCVFoK7Wso66iRG8
mxwmWuRCXutmJtYD7sI8zGx84wvnDEOXlmFcDUz7pu+66D235Ezoa4xDSeAblxSU
kPrG6rkiSvm8QtlcqV/tjsEODNMWOQgnupg5LLuTYT2LVbPVGabZUTmzDjCu/hYz
unUlyTpJK8LKaYaiIzdz53+yxZzZEwuZEZPS4pPGJGqfV3rODhW66M6xNEsg3CJ5
iJ97ZZcyEn17BR45vU5fl675cvEToQ==
=qXba
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--

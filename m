Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 459BF1BFAF5
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 15:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729208AbgD3N4N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 09:56:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:39192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729202AbgD3N4N (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 09:56:13 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7821E2072A;
        Thu, 30 Apr 2020 13:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254972;
        bh=CtV13aq5EHUV1ZS63QEGO/ZcyB2FMYXMcfBQyRvAbo8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zgED640dEidKBx4f+5IYcttqkLLgMNsPupj8XSvfZrstPPLUzJXejf6/XpjMx1Z0O
         csJYRNoXMxf+3Vgf4ZOVgj1ukvOFOyk6NwEKmYgBbExJWm2MCAwOJKR0Ms+nhM9I2h
         YMM3VPC8n/9CDRCU7aUQSlJVoq1Vv8HuRH1iLURk=
Date:   Thu, 30 Apr 2020 14:56:10 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jerome Brunet <jbrunet@baylibre.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH AUTOSEL 5.6 45/79] ASoC: meson: axg-card: fix
 codec-to-codec link setup
Message-ID: <20200430135610.GD4633@sirena.org.uk>
References: <20200430135043.19851-1-sashal@kernel.org>
 <20200430135043.19851-45-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="mJm6k4Vb/yFcL9ZU"
Content-Disposition: inline
In-Reply-To: <20200430135043.19851-45-sashal@kernel.org>
X-Cookie: Sign here without admitting guilt.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--mJm6k4Vb/yFcL9ZU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 30, 2020 at 09:50:09AM -0400, Sasha Levin wrote:

> Since the addition of commit 9b5db059366a ("ASoC: soc-pcm: dpcm: Only allow
> playback/capture if supported"), meson-axg cards which have codec-to-codec
> links fail to init and Oops:

This clearly describes the issue as only being present after the above
commit which is not in v5.6.

--mJm6k4Vb/yFcL9ZU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl6q2PkACgkQJNaLcl1U
h9DApAf/a8MgVHko2gpdxkUsvbUQwdEzB7YRiWynwvKJ/ud0k+E08H894+NR3LF5
FBgvDURotlT45pncz5G3Rynkgvbr9IluKuJLSfVXhCzrGXHiFXxxDQZncs18Lr+f
/nmdtOzXoRLBHZiYY60a/Wzsw+b3VhM01JmFnvodnIQoEojGAkr09lEIQQhvpr3I
jJjRWp3KzVzU9z0dYXW2m4fqPeDAmvKM6G5USTnXdgx8QlRfWKs5I8EgSLFwG+gR
1pqi95AFL8hQZevt81Jl5qHQuI/Xyn2Wz0lWlGfZG3BaSDJYe6peJSiSfxdpmpV7
Nv7JtglVXZvI6Y33OxL56LJJaPVAng==
=G+K6
-----END PGP SIGNATURE-----

--mJm6k4Vb/yFcL9ZU--

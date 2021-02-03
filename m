Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4D330D99A
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 13:14:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234187AbhBCMOL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 07:14:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:56632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234184AbhBCMOJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Feb 2021 07:14:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9180A64E46;
        Wed,  3 Feb 2021 12:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612354409;
        bh=5QiK5T7XOA7CP/CKThYIvBvkEYWSKxRHcveuJn05EsI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t3Q0YB2pp7v88vq8VN9SLYJu5AxStVFQdo1mVWPGR2kRfq+unf/obg5IJN6Hx0IeJ
         BfJqxV7IDeneaBuc3LXECgh5CQt7ARuvgc653Fl+Sb8hRvv7rQQAqR0C48UOigMcMH
         HjBERLPEOa5eolMMAg4iOGpBJ7yfmUXyaxZls4PIJfAujDl7X3xcfU+nTAzbOhnev4
         /8hWeUR/wpAOtB9KjLB2Zr7oGYgKX/pwM3uLxBSKEU1o7vXar9cdo/Fj++EPWomuds
         r9jySfGk3hfyZkaqlemQR1T6eeSzYzAemef+5+uG4+uQxDBk7LIzM+xTTOSubvpNoB
         66d3+RVMEKf6Q==
Date:   Wed, 3 Feb 2021 12:12:40 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        David Collins <collinsd@codeaurora.org>
Subject: Re: [PATCH AUTOSEL 5.10 02/25] regulator: core: avoid
 regulator_resolve_supply() race condition
Message-ID: <20210203121240.GA4880@sirena.org.uk>
References: <20210202150615.1864175-1-sashal@kernel.org>
 <20210202150615.1864175-2-sashal@kernel.org>
 <20210202161243.GD5154@sirena.org.uk>
 <20210203010421.GT4035784@sasha-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
In-Reply-To: <20210203010421.GT4035784@sasha-vm>
X-Cookie: Who was that masked man?
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 02, 2021 at 08:04:21PM -0500, Sasha Levin wrote:
> On Tue, Feb 02, 2021 at 04:12:43PM +0000, Mark Brown wrote:

> > This introduces a lockdep warning, there's a follow up commit if you
> > want to backport it or it should be fine to just not backport either.

> Okay, I'll see if it made it next week before I queue it up. Thanks!

The fix was sent in the same pull request so it's already there.

--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmAakzcACgkQJNaLcl1U
h9CvSQf6Aw/QQan9eBC4yp3OiHNWFd/wqy45djyf5mw5JxKSMqs49WxyLyKHiVS0
WwvBb5nE+IlSZzifYNaFIIyJRGsPf6NCemcgRwMxNZ+Wiy4A1fSKOtQNOufQTkpP
8lIMevGLG8lf7lBKi6JhCqvy9SxBOvrfpYj9NuIKRClwc5zsALf9Ruk5TftYCbrE
xPcY/UBTDaGx3OxO+UeRvXkXDbVn8xlNGfSMp93v5j2FEFYGFaswHLK1lhsAlAoa
Fx1KUQn7ok51EZKv++O6KeMzEk9IlQ40+GSI/5NgCvWzyuUTCf1dQYTPteZn9+Th
5wFoqni5nwQHa1qtK5sIyCAPoqNysw==
=+dWX
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--

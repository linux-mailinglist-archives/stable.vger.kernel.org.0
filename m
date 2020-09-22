Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A208827447C
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 16:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgIVOnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 10:43:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:37206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726507AbgIVOnO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Sep 2020 10:43:14 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 884782395C;
        Tue, 22 Sep 2020 14:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600785794;
        bh=m1hM4c6dFFDnao7F9PZYKBupx4rTzbl45tccKtkOQjU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VmuJKVX8oP36C9cT3aUT+BZ+z1eEDAm3kR764yQxu4qROx0SIWjH1yFmjoYMzg57W
         ViFCLl3xNJk57KtrYDbEGraAFYAOppbTA+wz4KCHULRmFtfyPP/uaUfCy2J33YXGOX
         FNiDelp7905draUXgZSWkW2KtL/9De70llt0R5fI=
Date:   Tue, 22 Sep 2020 15:42:21 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        patches@opensource.cirrus.com, alsa-devel@alsa-project.org
Subject: Re: [PATCH AUTOSEL 5.8 03/20] ASoC: wm8994: Skip setting of the
 WM8994_MICBIAS register for WM1811
Message-ID: <20200922144221.GW4792@sirena.org.uk>
References: <20200921144027.2135390-1-sashal@kernel.org>
 <20200921144027.2135390-3-sashal@kernel.org>
 <20200921150701.GA12231@sirena.org.uk>
 <20200922142515.GN2431@sasha-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="gvPGo+RAdjC9O5ul"
Content-Disposition: inline
In-Reply-To: <20200922142515.GN2431@sasha-vm>
X-Cookie: Love thy neighbor, tune thy piano.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--gvPGo+RAdjC9O5ul
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 22, 2020 at 10:25:15AM -0400, Sasha Levin wrote:
> On Mon, Sep 21, 2020 at 04:07:01PM +0100, Mark Brown wrote:

> > This is pretty much a cosmetic change - previously we were silently not
> > reading the register, this just removes the attempt to read it since we
> > added an error message in the core.

> Right, the only reason I took it is that error message - I find that
> bogus error messages have almost the same (bad) impact as real kernel
> bugs.

The point is that the error message isn't present in stable kernels so
there is no impact on any user visible behaviour.

--gvPGo+RAdjC9O5ul
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl9qDUwACgkQJNaLcl1U
h9CjdAf+PXoDfp7834wZQ9f1rb79rWZspO34iLgtd2QfsiJLwuTe2hFDIKkdoXXU
ajhzk5ZjNKGpRq9aid6yJWpRor0e3qn1fUDdJgavmPHoNnTQ6q1EKzHv6nDRMSWD
doWsRBkTkSmignj73JlG9keOyvMgihQVIZSZSEafqIsKWYHXMwLE96Qghgt0hFDv
DrDEz6xHrA4AhTGBEMvhQMy2rvU5O8AwfzyD+u2vD6j+ejy/Q3DdldGMhrPbNvB2
W4l2rheJ1a0km9anTOOUUYHDiDp7ttqpvzuDOB42lttBXk+jgLroxkcU4EKZrsuL
nmlsEikx87yrqnX68TKTrlZGqoaxAg==
=7xiC
-----END PGP SIGNATURE-----

--gvPGo+RAdjC9O5ul--

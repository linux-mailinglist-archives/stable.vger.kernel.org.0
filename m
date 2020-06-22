Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2802034AB
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 12:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbgFVKSc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 06:18:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:41964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726853AbgFVKSc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Jun 2020 06:18:32 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0E1020675;
        Mon, 22 Jun 2020 10:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592821112;
        bh=9Y/rtCRYD4aEh3139uBPC2Fcw4zMJcS1iHtnd8Z1zRw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IVLnqSFmSbtxv9lgC1ENDKsj6DhcVTbwS/S24NdVUCpfcA+ZAhDbxODgSOYeXHfyl
         OppQ5vIzrO4c+eCi/drrMwa278Fn5w1kJ/b8Hbn2wCg5eMTtHk8ZUABZmzpDcTsr1n
         QZOUX6IvzvYLEoyxt58sbiak1b3wTuFSOcf7IdzU=
Date:   Mon, 22 Jun 2020 11:18:30 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Wei Li <liwei391@huawei.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH AUTOSEL 5.7 130/388] ASoC: Fix wrong dependency of da7210
 and wm8983
Message-ID: <20200622101830.GA4560@sirena.org.uk>
References: <20200618010805.600873-1-sashal@kernel.org>
 <20200618010805.600873-130-sashal@kernel.org>
 <20200618110258.GD5789@sirena.org.uk>
 <20200621233453.GB1931@sasha-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
In-Reply-To: <20200621233453.GB1931@sasha-vm>
X-Cookie: laser, n.:
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jun 21, 2020 at 07:34:53PM -0400, Sasha Levin wrote:
> On Thu, Jun 18, 2020 at 12:02:58PM +0100, Mark Brown wrote:

> > This is purely about build testing, are you sure this is stable
> > material?

> Is this not something that can happen in practice?

Not outside of build testing.

--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl7whXUACgkQJNaLcl1U
h9BDzQf/RzQdCcVRGWZhfoT1fNalQOZMEnvqtp8b6Y31rlwZ6+PGxc525TkQJ3yM
zgniKy6yj9g6df+e5VG7TAeYXsSG1WT41FMruuBxHeYcBYrHtA/tR8ojN2vaNXRU
dngRsHbjO5iL1+qutTylc//yk2R/ytncWq/4PqECCdkcReGt9/kqfgBOfltTRfNU
DkjR5I5c/FkGveWlgWqIZOjMx3NP7r00oor56FhRbs+IYu0OrhWk8GJd4m/BoxY0
GGvm8Mizp+qFdOTq0ff9CKJm9tWVLHk1uo/YfDAukmHrO+fgcmhckj9EU4vpoGT3
4x26/YcBwCErNU8cUNW3gl6+VlESkQ==
=4bpC
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--

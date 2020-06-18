Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66B621FF4EC
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 16:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgFROje (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 10:39:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:59980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726879AbgFROjd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jun 2020 10:39:33 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B82220773;
        Thu, 18 Jun 2020 14:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592491172;
        bh=etN4J2cAIG1MAkGuXWgQccKMRYufQ7F4qFAKChIOWw4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2U3qhHIsheqY690iXD1qI+ppqRsMzOpm+NzmomO4TavPiWPKf3REImXF7dg36dTEV
         rOLYl4hv03TMsebFcRG1Jqi/47TFJuX0qZDJr5GEkWNWojjz/sWVGx6XZj1aRdwm67
         /58MLjC3dSXuFKj/enxe8zkb+YKjMumDQJK27Wqs=
Date:   Thu, 18 Jun 2020 15:39:30 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dmitry Osipenko <digetx@gmail.com>,
        alsa-devel@alsa-project.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.7 004/388] ASoC: tegra: tegra_wm8903: Support
 nvidia, headset property
Message-ID: <20200618143930.GI5789@sirena.org.uk>
References: <20200618010805.600873-1-sashal@kernel.org>
 <20200618010805.600873-4-sashal@kernel.org>
 <20200618110023.GB5789@sirena.org.uk>
 <20200618143046.GT1931@sasha-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="dMdWWqg3F2Dv/qfw"
Content-Disposition: inline
In-Reply-To: <20200618143046.GT1931@sasha-vm>
X-Cookie: Androphobia:
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--dMdWWqg3F2Dv/qfw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 18, 2020 at 10:30:46AM -0400, Sasha Levin wrote:
> On Thu, Jun 18, 2020 at 12:00:23PM +0100, Mark Brown wrote:
> > On Wed, Jun 17, 2020 at 09:01:41PM -0400, Sasha Levin wrote:
> > > From: Dmitry Osipenko <digetx@gmail.com>
> > >=20
> > > [ Upstream commit 3ef9d5073b552d56bd6daf2af1e89b7e8d4df183 ]
> > >=20
> > > The microphone-jack state needs to be masked in a case of a 4-pin jack
> > > when microphone and ground pins are shorted. Presence of nvidia,heads=
et
> > > tells that WM8903 CODEC driver should mask microphone's status if sho=
rt
> > > circuit is detected, i.e headphones are inserted.

> > This is a new feature not a bugfix.

> I saw this patch more as a hardware quirk.

Pretty much any DT property is a hardware quirk :(

--dMdWWqg3F2Dv/qfw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl7rfKEACgkQJNaLcl1U
h9D4egf9GAyUHzaf4lnzptpzMRgqOKL3WVybRfxzlzkgBkgbNNF3Rxgl2TGJpoPu
DQIe6X4ijMZ/LNocdFZi+BWCr/rh9ml0dUly5TEXbwjHQ1Im5SBdJgy9tLq1yjPD
OY1sD5faXc2gH1A+z3LQ7xYFpNnpRwug4G+SbyiPtfkPXhIXKnx+cF+tdcqYw8hz
dDcihB9jR8gPEYGqPBQOacSjd969ocvYYj2npO9TztHNXfwvFwNxErrg7pebwrI5
7NbFOUdEU7aLAPIx2AfHoHTD9FzDGvqY37Q/UZZYqqFxRQ46ZluGN1cyuOet3sEb
83lXKDitdxTNZOmNGYNNCEZL/dcdTA==
=Ja8t
-----END PGP SIGNATURE-----

--dMdWWqg3F2Dv/qfw--

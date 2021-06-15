Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEEFB3A85C4
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 17:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbhFOQAR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 12:00:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:54934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231815AbhFOP6b (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 11:58:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2309960FE9;
        Tue, 15 Jun 2021 15:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623772586;
        bh=36idZgnOU3LKGeU+scOXXaBT5XE7CPa302LIYn4vuLg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YNJ1uYZI5GYbGSmN9mprHggkI/XDSzE4kQJuo+7pYNKgu89u3GMYX5PUtbKLzJ5G0
         7AknviIQIsOPwkvZ0hvA3iq442Q+e+xpvZ/CPWCnPqHG+Xj51YEm2g35HS9l5YlTLc
         ohao2fGgMVj7gM5TYI1bZOsVK/ihgb3e8bEO14y+o79dh26hfI4XyVQTNH3L3gKhDq
         6wVGXT1ZtCCP5JizIQMgDksKkJlgJNjyNu1g1gDNqtBOEl1zyswI7e6vg4/zzG3Hf3
         a8ls1SadEdOhPkryC7xQ9E2NLC/Efh/W5rq/uBY4L+sF+ij39cVgfi6KG+iY16U+sU
         +VHl32eSFsiMQ==
Date:   Tue, 15 Jun 2021 16:56:07 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mark Pearson <markpearson@lenovo.com>,
        Gabriel Craciunescu <nix.or.die@gmail.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH AUTOSEL 5.12 11/33] ASoC: AMD Renoir - add DMI entry for
 Lenovo 2020 AMD platforms
Message-ID: <20210615155607.GN5149@sirena.org.uk>
References: <20210615154824.62044-1-sashal@kernel.org>
 <20210615154824.62044-11-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="o+ZCuNqY+dEAKBWl"
Content-Disposition: inline
In-Reply-To: <20210615154824.62044-11-sashal@kernel.org>
X-Cookie: See store for details.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--o+ZCuNqY+dEAKBWl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 15, 2021 at 11:48:02AM -0400, Sasha Levin wrote:
> From: Mark Pearson <markpearson@lenovo.com>
>=20
> [ Upstream commit 19a0aa9b04c5ab9a063b6ceaf7211ee7d9a9d24d ]
>=20
> More laptops identified where the AMD ACP bridge needs to be blocked
> or the microphone will not work when connected to HDMI.
>=20
> Use DMI to block the microphone PCM device for these platforms.

You've backported the fix that reverts this a couple of patches later in
the series but might be as well to just not backport either, the end
result is the same.

--o+ZCuNqY+dEAKBWl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmDIzZcACgkQJNaLcl1U
h9Cg4wf/aWyS88Xn4pMmrZ6M1yoelx3k+LJ18g9k0vMcKIcHIpvfo9Gz3XQnpC8A
nhGd5vzUq/xVErjPt7hPaumSo8agpyXr0aj/j/XgniJ6/ZevbRbghnvR9IYIn53V
PW1UFOMbU5kRENPWePjhak7qh1Ifo2IajDiB0qe9go9lLAQe14eusHRL3NBGG8DF
CpHFzKfXx9nbXQ+I3nz2RgU9+LO1P0MH3qMNR3zcv+Rx0qy3vVWl8gHxwrm3h1y6
v54l26h1bDxlVg9RRqpwZvnyrY1bPEuB5yxwY6p23e6+GE7diiElGR7tMfd8jxwS
6vDy2xs893Ao/HWy17RcWnZIpjqNSg==
=15cD
-----END PGP SIGNATURE-----

--o+ZCuNqY+dEAKBWl--

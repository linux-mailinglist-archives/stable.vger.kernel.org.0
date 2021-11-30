Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8504639BD
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 16:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244582AbhK3PXS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 10:23:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244588AbhK3PVB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 10:21:01 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18F93C061758;
        Tue, 30 Nov 2021 07:16:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6BC8ECE1A3B;
        Tue, 30 Nov 2021 15:16:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4884CC53FC1;
        Tue, 30 Nov 2021 15:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638285390;
        bh=CsuglpE/divFk/5CQWjHUMB7KiYZRmVgd/wkp2Q8Q44=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Hl8pDsVkBR89t8Weo7V3jLHabABj06Xa+cUu0TUExCcDe6bkpcmHo71IF77u8mp9O
         LrSanYUkqr4rsCO/qakHXAKyhJ8xppn2MNZDTtdmD3Fca0S28aw2g52TwYTWfQsKSS
         b23452oHk8nMshc8Spg3e7l5KCuiI1DYMSZ7YF9azPK6Oswgl0NhAc1XZqqDlFjF/l
         rEuJAJsy8r9PXXWNjk/Nsz4ukHkzSaprOf4puA+DnZ1sXjbmH6TpL6ZqA2/4sIx/8H
         jWjX3kaf4jDBSkxzRDZQdMIbQh/904d5UMNph8YvQgDmo6xVW/YnwpazGBjMkQAbjB
         fu3sZ5oT3afoA==
Date:   Tue, 30 Nov 2021 15:16:24 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, matthias.bgg@gmail.com,
        alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 5.15 01/68] ASoC: mediatek: mt8173-rt5650: Rename
 Speaker control to Ext Spk
Message-ID: <YaZASLLyOC9EwnMs@sirena.org.uk>
References: <20211130144707.944580-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="EpYEx7V8UqnZBosf"
Content-Disposition: inline
In-Reply-To: <20211130144707.944580-1-sashal@kernel.org>
X-Cookie: Check your local listings.
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--EpYEx7V8UqnZBosf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 30, 2021 at 09:45:57AM -0500, Sasha Levin wrote:
> From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
>=20
> [ Upstream commit 0a8facac0d1e38dc8b86ade6d3f0d8b33dae7c58 ]
>=20
> Some RT5645 and RT5650 powered platforms are using "Ext Spk"
> instead of "Speaker", and this is also reflected in alsa-lib
> configurations for the generic RT5645 usecase manager configs.
>=20
> Rename the "Speaker" control to "Ext Spk" in order to be able
> to make the userspace reuse/inherit the same configurations also
> for this machine, along with the others.

This might cause people's userspace configurations relying on the old
name to break.  Obviously we're hoping nobody was doing that since
that's also true for kernel upgrades but it seems kind of aggressive for
stable...

--EpYEx7V8UqnZBosf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmGmQEgACgkQJNaLcl1U
h9C12Af7BOB8qKYgh1ta/a6KlxNqPdnCcPfgt75Zppjx5a+wS5BhWIW8uhF0Bs67
UjGiaO1WRqrfwtcFWXadhQxa1BrpskWt3afgg0KFYtcjf3KFXCFcdVFhdzRMcCe3
SY9eGKabGIsXJdQ18qKRBEPnQ+gXSQbCatqs2cgCgdS07R4nwfFb008U5P3zFysq
PmN9hWOfC5A0cX1EUWPR/zy7qNdFcCEDQu4n5kJTVdpEjKE7lqEA6wy2zw3pQXyZ
dIb4IGxWKyuZ5yt5D0WPX0IlasJvU6QxPxtDgoVYFLhqi9KPivLJJZ82FO2e0Aw0
oZ3H5YPHbUl9/DueY8z+0kk6ZATmCQ==
=q/3k
-----END PGP SIGNATURE-----

--EpYEx7V8UqnZBosf--

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57DC9492B08
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 17:19:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243758AbiARQTI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 11:19:08 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46812 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346618AbiARQSv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 11:18:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12ECC61444;
        Tue, 18 Jan 2022 16:18:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B6DCC00446;
        Tue, 18 Jan 2022 16:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642522730;
        bh=lWwgMLWeN92CpQV3rny+wqDTYoq0ROE6wIY4Y1P6dnA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jGyX78QRww/d16vaK9s1zbN4lO8EJ0FspYJdZgkvqR+MmqdU0SXHWhsxgJJUXzaN1
         lzFX8CPXjPCWy4dTQzGzSZmlLCFX+mgQ3HFFYtt5y/9Za1Gs8Nvp1rP5dEZ82iKaYK
         PBV5trb3A7sxfw4tquN/NsR54aWamu9CWFAxIlGV9n7ue0UFL6iBspe+pTmPFXuJzL
         ooJXNddznNMqWwdqK1BhGbCOtFdLH5WLoAfm+925oAuVu6bPHMTj37TaaUdFmSU8zu
         1Tz51eidlhe6gQZrDqZ4ERaHlMl4WwvKAs+I/FxcE7ZTFGUHOLr7aIap9o9aGt5ZhC
         0ubF+mQwQRyLw==
Date:   Tue, 18 Jan 2022 16:18:45 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ajit Kumar Pandey <AjitKumar.Pandey@amd.com>,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        vsujithkumar.reddy@amd.com, alsa-devel@alsa-project.org
Subject: Re: [PATCH AUTOSEL 5.16 50/52] ASoC: amd: acp: acp-mach: Change
 default RT1019 amp dev id
Message-ID: <YeboZaJQLVejZCRg@sirena.org.uk>
References: <20220117165853.1470420-1-sashal@kernel.org>
 <20220117165853.1470420-50-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="q6NjtMl96wQVpgwI"
Content-Disposition: inline
In-Reply-To: <20220117165853.1470420-50-sashal@kernel.org>
X-Cookie: Do YOU have redeeming social value?
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--q6NjtMl96wQVpgwI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 17, 2022 at 11:58:51AM -0500, Sasha Levin wrote:
> From: Ajit Kumar Pandey <AjitKumar.Pandey@amd.com>
>=20
> [ Upstream commit 7112550890d7e415188a3351ec0a140be60f6deb ]
>=20
> RT1019 components was initially registered with i2c1 and i2c2 but
> now changed to i2c0 and i2c1 in most of our AMD platforms. Change
> default rt1019 components to 10EC1019:00 and 10EC1019:01 which is
> aligned with most of AMD machines.

This seems like a disruptive change to be backporting into stable...

--q6NjtMl96wQVpgwI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmHm6GQACgkQJNaLcl1U
h9Cc+Af+LysinIPtu2z7k6BtNNgMxopSjDRXmvpFaxTaDINJWKg0Qps9VjZIQoM4
46/b1AnkPLHJW48mtsS0chlzyIB7yvnmY+boA8WHntSxYInSmOXP4tLIw8X/Zq3e
E9UBjPxMYJbPxNNDR97PqEJP7K71maEWwg+hgwkS5O6HsztCWMfO7mW7zOAKidsN
8Kgi6OgkjiPdKs5eFr3bzR6KcK9x5gc759E8Ox4bHLUhDTRy1umZNo8CLxssOCTG
6AjrJCR0pdy3QsONDVh6qnbj5FXeQoj3Tio5INS+4VQVfsffCsa9sI6olp3qcGXF
aIBtW46qLwVqqyjDwhe1QwTVLULb3A==
=YylC
-----END PGP SIGNATURE-----

--q6NjtMl96wQVpgwI--

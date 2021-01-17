Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEDAF2F91ED
	for <lists+stable@lfdr.de>; Sun, 17 Jan 2021 12:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728382AbhAQLUs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jan 2021 06:20:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:34500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726295AbhAQLUr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 17 Jan 2021 06:20:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19BBD206B2;
        Sun, 17 Jan 2021 11:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610882406;
        bh=zIuhWRheLZmQUMRd0qhmmD0m6Hxi2JLajZVc2WmMRzw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i/XUA551ivfCfRGlSRvjL/z/079vBZMKC/WOhXkVLXoMjamVwn5offkPg0Ae8KHA3
         QQ65Q5m6+9x9wbcbb26lGxqy6k4nati2DEOxVgw6dFCVsBKpcddXgdCFqyQOy+IAAg
         YnqYiyAtItw4hulzkFbT35A/sTw2tC2K0KhAJXzOjk4KjdGByGQRrX0JVVAp/aYAM7
         1+p+tHLNZvJq+lKv9w8OTGkYuutm3FNx6Knh+z5n3SIic8TpxtWFrmRDfIBypgJpaB
         JdItkurb6O5U0G4EalOUCXe7sHKd7yTxBUmzuVy0pgrxP4i5Z1WofaSyUkkMUoBPXQ
         Jt/JIPMzzvw5w==
Date:   Sun, 17 Jan 2021 12:20:03 +0100
From:   Wolfram Sang <wsa@kernel.org>
To:     Mikko Perttunen <mperttunen@nvidia.com>
Cc:     thierry.reding@gmail.com, jonathanh@nvidia.com, talho@nvidia.com,
        linux-i2c@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] i2c: bpmp-tegra: Ignore unknown I2C_M flags
Message-ID: <20210117112003.GB1983@ninjato>
References: <20210112102225.3737326-1-mperttunen@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="v9Ux+11Zm5mwPlX6"
Content-Disposition: inline
In-Reply-To: <20210112102225.3737326-1-mperttunen@nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--v9Ux+11Zm5mwPlX6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 12, 2021 at 12:22:25PM +0200, Mikko Perttunen wrote:
> In order to not to start returning errors when new I2C_M flags are
> added, change behavior to just ignore all flags that we don't know
> about. This includes the I2C_M_DMA_SAFE flag that already exists.
>=20
> Cc: stable@vger.kernel.org # v4.19+
> Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>

Applied to for-current, thanks! I added also this sentence from v2 to
the description to justify stable: "but causes -EINVAL to be returned
for valid transactions."

Also, this driver has no dedicated maintainer. Is there someone up for
this task? There is probably little to do and it will speed up patch
acceptance because I pick patches once the driver maintainer is happy.


--v9Ux+11Zm5mwPlX6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmAEHWMACgkQFA3kzBSg
KbZmhg/7BgeQK5idumot2QsUSNDe+VvX+MeQt1dow4WsA+1/fsxofjLwwyQjo3gO
TgW95GxMQTl4iUBLfmXnTd0kwpZ2pTWrA3E/dKk3H1elQjRavUC9K8pMSXXNCB7D
gLk3x4fYxcJVn49NOESthe46mtqXCEExtgTUBVT5OCk/9v8w6pI34WAyly23Tkmg
Mctpu8B+yDAw5J860eoCrTtmmRR/KI4AsG2OfFAo/E+M9L3vGwgAFid6aOWENqaT
fSQ2SfHZOjPrGmF0xA+/ypQDd4wznQfEAzbM4Bo7dkPqRJNanFoLRfb+ySgE52es
zu6HemkZ7cpFDQEuyZkgJ+zYU8QHLPw6B1uCTvrFyEtc0cWPGaZwKzaMl9XjweWT
C+CE6Vg/zvX/1SBwfJzV/8YLR/zFLFiNAkFEXlFzmAyHUKO1QPfDttUjra4o/cil
tGUt9zAgJyoql+5/5dvR1a9ZbjLWw9pd2ftNhXyHw90XxaJW3ygdh3ErGGXeLS+5
mo1VHSUmK2LS5lfQRIAvhFgpoQX9afTlMfbAxfzCQr7LYyNc5qfNswMpg/z0Lt9A
UR0aJ5Q6730pbpKtJDGvkNfYLT5seUX+Y7f2b+RA+RTv2WJS/3/2C0k/Vkttar+m
EsAzVkRHRJE7Jl/uxIcDZUhGW4O4EUX3SP2khbvAfANFfodNUyU=
=+zL6
-----END PGP SIGNATURE-----

--v9Ux+11Zm5mwPlX6--

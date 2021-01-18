Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 745F92F9E4D
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 12:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389119AbhARLgL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 06:36:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:60482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390379AbhARLfn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:35:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 976A9221EC;
        Mon, 18 Jan 2021 11:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610969703;
        bh=oXcjoXT+gCij5gox1DhkN8rids03zLaBhtgQQQ5MTJY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RmJgLCL2ZISwMPkYjh/iygth35csm9is7KQYqg8XxoOr+CtER9Oqbfio/iHQBvhT/
         UXkmXe7XYJK9LRCS3U6qVGGcEMEYuKaVG8/8c+owLWKFGgSJQIxgWtkoRFA4HU8J73
         BqGaR9aAY20JeyXGtLUXw9rpOX4JRz531bNOkSxvZ8yy3OFc1+Y9wqP2TeLHyeXXQd
         Nj7on3j/Gj20v1yCaVVmTS+krhw0SX0p2WWj9l6/aT2gWrrdfFn9LpSphZzfNs8lrd
         XwDPsipwxZd1D4ucGkkPNPeNmBJyaDJ4CItvONoBOtMQeGl9LmEi78tKy8TCsEJ7R3
         OGckGngigMmig==
Date:   Mon, 18 Jan 2021 12:34:59 +0100
From:   Wolfram Sang <wsa@kernel.org>
To:     Mikko Perttunen <cyndis@kapsi.fi>
Cc:     Mikko Perttunen <mperttunen@nvidia.com>, thierry.reding@gmail.com,
        jonathanh@nvidia.com, talho@nvidia.com, linux-i2c@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] i2c: bpmp-tegra: Ignore unknown I2C_M flags
Message-ID: <20210118113459.GF1018@ninjato>
References: <20210112102225.3737326-1-mperttunen@nvidia.com>
 <20210117112003.GB1983@ninjato>
 <99326ffc-7590-84ce-dfa7-7c09bc17ca31@kapsi.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="GLp9dJVi+aaipsRk"
Content-Disposition: inline
In-Reply-To: <99326ffc-7590-84ce-dfa7-7c09bc17ca31@kapsi.fi>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--GLp9dJVi+aaipsRk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > Also, this driver has no dedicated maintainer. Is there someone up for
> > this task? There is probably little to do and it will speed up patch
> > acceptance because I pick patches once the driver maintainer is happy.
> >=20
>=20
> I think it falls under the 'TEGRA ARCHITECTURE SUPPORT' wildcard (Thierry
> and Jon). Do we need a more specific maintainer entry?
>=20
> If it's helpful to Thierry and Jon, I guess I could pick it up.

I am fine with both. I'd just like a line

	"F:	drivers/i2c/busses/i2c-tegra-bpmp.c"

somewhere in MAINTAINERS. If that's in Tegra architecture, also good.
However, i2c-tegra.c already has a dedicated entry and spreading the
work avoids bottlenecks, so I think it might be the better option. But
I'll leave it to you guys. In any case, thanks for volunteering!


--GLp9dJVi+aaipsRk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmAFcl8ACgkQFA3kzBSg
KbZc/A//beRLpHVewEVuZZJb2FkgIZhzbfyfpZ1Dgxsi7Igpk+8UFvvJjOemPWiR
wOml0upHDuiGvAiHRw2W3Qg7d1oRp+TCXH/kEqPSXMh8SoFeXzI/lBxZrMBJFisa
pdvO+OXbTPqCWcXEvhzCB5hS4PGuniB1mMawCs97WZrBWVfSTDjqSZpx5miPAvRR
a8Uj8HZnO4BlwOKJlBc2jwVNBArziEVKvVoxtsrhnUpxJTWV89pOVctHLMAV694R
vAYPH4bdyyGHgPulvRHGE6q4C/tumFKr56oRGEjJHyIN5hgeqMaoQN7hIuVU+bAx
yFGy3xt112LtxJ/H/v8hchliW/8sd5cC9PkYjuIum+P7fCu3eVzmzhIWI85BO6SP
4Cn9Tga/Bho0IUVEwMi84xydG82cKtViRr1/yC4NSynPXnd4E0q+obnZZslU0fPC
N3Q7EDg02vA5wpoDvflGe64V9naLWhpWjsIaz+Ef0X5wbfdD75Fruvb9iEUTnTLW
tkrRx+c5EutkAVBHlfXaHN8TFzZltf8nvdzaLUM5g9Wd2C8ytc/6/EkpTEO+nFa8
w+8Hv5qebGoqYjjN5h5qQNVIf2LwgMN8D0bTCsdJyC6IddOpPlE2DHmTqpE7BpvY
q9uFIrLkLX+/lhGregbh/JqRaYZMMsBY0Se7ZEleu04OygLj+yU=
=MeL+
-----END PGP SIGNATURE-----

--GLp9dJVi+aaipsRk--

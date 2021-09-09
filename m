Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 237D340569A
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349230AbhIINUp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 09:20:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:36126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355407AbhIINNm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 09:13:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4EF260E94;
        Thu,  9 Sep 2021 12:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631191108;
        bh=O8KrY2v/SV5IrfzHUe+Isyg8Inb36F5FzqeXHCuk3Kk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uRoT8EZGuLQ3NDPWvnMgDME2AHbezyRDqTxQ0y2DwR+M/MYdfMUPVUTIfWqn/rrgS
         qnhBYi0lxy2tUw27e+coP/c0YqnVJGmMF/ogTRuibFkm7fDKmkvBDb+Ci5tygyoYDr
         JpGxqktq3QKBtGuOrPx+7FzGOjId5l4PY80w/KvO6k60rq8cG7gHFggLOGjsRBiOlY
         I49Rzue2+rdaIni2jjMs+lXNc/oxiHEID/iQcJsqDNF02CadoQbWkq6kng5PWRaM/X
         16A4l8uO4NguyTvTiFtMuk+kAooA86T0E2O4HCL+QV8ROVRWrWyEhKYBuv5ptZAW+Y
         x2AoioaRdv47Q==
Date:   Thu, 9 Sep 2021 13:37:51 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dmitry Osipenko <digetx@gmail.com>, linux-spi@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.14 133/252] spi: tegra20-slink: Improve runtime
 PM usage
Message-ID: <20210909123751.GA5176@sirena.org.uk>
References: <20210909114106.141462-1-sashal@kernel.org>
 <20210909114106.141462-133-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
In-Reply-To: <20210909114106.141462-133-sashal@kernel.org>
X-Cookie: I have become me without my consent.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 09, 2021 at 07:39:07AM -0400, Sasha Levin wrote:
> From: Dmitry Osipenko <digetx@gmail.com>
>=20
> [ Upstream commit e4bb903fda0e9bbafa1338dcd2ee5e4d3ccc50da ]
>=20
> The Tegra SPI driver supports runtime PM, which controls the clock
> enable state, but the clk is also enabled separately from the RPM
> at the driver probe time, and thus, stays always on. Fix it.
>=20
> Runtime PM now is always available on Tegra, hence there is no need to
> check the RPM presence in the driver anymore. Remove these checks.

This feels new featureish to me - it'll give you runtime PM where
previously there was none.

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmE6AB4ACgkQJNaLcl1U
h9Cchwf8DoVbaphM4/DvCMTyzvIjvMGgt9G5IEM7YoZ5MuLTwLLKGro700hLsyx7
KH7AJpbIFX4AZulur/hC3Uri/22blXfb6yw6Lo7UeJyMmYeIWBQLwP5UoQblrNmV
Ag9EFPlJ+DbXWLAS5vhrzMJuFevT5BYJT+c5v8963F6wsm0OuF8wosXeDC25Nha7
vKXfgkut2ab1PSwWjK/lMg0MCRfAQKcOlnIFND0s6q6q0tcYBbiO3XP/OlnKKmGp
VXW5ssYFEYqRPP2fLbRQ5k9LHVbwPyTM3jvv1HyYLv2aI6OVto39vaL7djOcQWd2
4R4z5w77yTNV2zxXnS5CeJrLobklxA==
=kpf8
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E157419C73
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238063AbhI0R32 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:29:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:41174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236779AbhI0R1c (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:27:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31A7F6140B;
        Mon, 27 Sep 2021 17:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632763013;
        bh=f/BEVjLTb49Z6TVWWDAkvRhydk7RaDnxPLSTajgJNYc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sIlsM4lK4EkXw3AcZ+N6ayBYbjJvte7NeC3D2nnuHIMwY49LwN5+5zBwwT2mf6ecT
         xA8MnpKcZkKOrMs3gCAvIFe5JiTHQgMUmsaDC44ZigYnP20i/UMwkSzItRxQd6Shr2
         cgF58c+n0tzaRaEmm03//ltDP/U21LjZflSv/00snbCevfqVf5W1716noRXKvtNNj3
         EZMGIPIQq7vxYnv6seq7QQ6EsDZH/hCPFWMYZHcrDoqRRaBI009FW/owgwB/V0awV8
         MWHLGtb4B/wuvcaG7uUoW0iwy9IAW01w6yNt/K/A6Ooasyjf4lWy+ZqQInxt/pwhtd
         i0vR2cZITu/+w==
Date:   Mon, 27 Sep 2021 18:16:02 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.14 075/162] kselftest/arm64: signal: Add SVE to the set
 of features we can check for
Message-ID: <20210927171602.GG4199@sirena.org.uk>
References: <20210927170233.453060397@linuxfoundation.org>
 <20210927170236.052759270@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="vJguvTgX93MxBIIe"
Content-Disposition: inline
In-Reply-To: <20210927170236.052759270@linuxfoundation.org>
X-Cookie: 98% lean.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--vJguvTgX93MxBIIe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 27, 2021 at 07:02:01PM +0200, Greg Kroah-Hartman wrote:
> From: Mark Brown <broonie@kernel.org>
>=20
> [ Upstream commit d4e4dc4fab686c5f3f185272a19b83930664bef5 ]
>=20
> Allow testcases for SVE signal handling to flag the dependency and be
> skipped on systems without SVE support.

Unless you're backporting some test that makes use of this I'm not sure
why this is stable material?

--vJguvTgX93MxBIIe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmFR/FIACgkQJNaLcl1U
h9Be4Qf/RiMUSdDNsQDz597c+r5WftWviZyAJ+TdXKwLV4E68sxcJ/LywwZL8w9e
qinCapGHMk5z0EsBkxzTxqFskoBP0Rm0Uub5LfHPO1Kj8pDrro8LI7UZIwYIystn
h3wpj0cvT2RJEimnKTGxPG0+73iND8CipK62v8c6AAPrnWJ6ZRvi4n/EK7N4BWmo
veheNhL/aV46cig+dzLHfih7oZGYHAdOTGrTHwFtY6dONI92GBofSrJ6OgAbju29
n9ZeUB2kfwhT1qEWaIohadXi+oKCzx6rRxXZ6I0tcLnLWrZ1EQWysx/7gtVvbCoa
IiwZpH14A3AkfQHi/5VmfIFP4ar5Tg==
=Zrou
-----END PGP SIGNATURE-----

--vJguvTgX93MxBIIe--

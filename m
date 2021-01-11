Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25FA82F220B
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 22:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387685AbhAKVnG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 16:43:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:48636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387621AbhAKVnG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 16:43:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9634F22AED;
        Mon, 11 Jan 2021 21:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610401345;
        bh=RSQxCvvzEsidqCr3s1Er8NIY72JS7iOzBFjhhvo3rVk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZKVQnKge2rjX2PtHVBdBjdX/mzZ3fmtq3L5QRnjXV/SWkxPHlBA2gS77Qm0hWMotj
         CwIzM4OwN31ovY9q0Ap3ixKzhNxiMVte6BuW/Tw6QV09W2ZHkA8Pt/qXQWwVNLbOaN
         L5Pahxa+2qmbP0X57DPDU5g4BR8ZxC+NpkeTq3xAlrhuJrJInDoozswifcqDOIdxsl
         ZF0wgmYFkIAlA4zVpDSL+rzkNmICkpYKX6kyWC/9kyszVSlcv0XhSnk4DORSF1GMZH
         thlo9V9jrA5u23Kt2833nbabls2m0g+d3w66pqXCqoff63HhteVSvc8h6x86roXEax
         4fH8ZiXhWViZw==
Date:   Mon, 11 Jan 2021 22:42:21 +0100
From:   Wolfram Sang <wsa@kernel.org>
To:     Mikko Perttunen <mperttunen@nvidia.com>
Cc:     thierry.reding@gmail.com, jonathanh@nvidia.com, talho@nvidia.com,
        linux-i2c@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, Muhammed Fazal <mfazale@nvidia.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] i2c: tegra-bpmp: ignore DMA safe buffer flag
Message-ID: <20210111214221.GF17475@kunai>
Mail-Followup-To: Wolfram Sang <wsa@kernel.org>,
        Mikko Perttunen <mperttunen@nvidia.com>, thierry.reding@gmail.com,
        jonathanh@nvidia.com, talho@nvidia.com, linux-i2c@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        Muhammed Fazal <mfazale@nvidia.com>, stable@vger.kernel.org
References: <20210111155816.3656820-1-mperttunen@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="i3lJ51RuaGWuFYNw"
Content-Disposition: inline
In-Reply-To: <20210111155816.3656820-1-mperttunen@nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--i3lJ51RuaGWuFYNw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 11, 2021 at 05:58:16PM +0200, Mikko Perttunen wrote:
> From: Muhammed Fazal <mfazale@nvidia.com>
>=20
> Ignore I2C_M_DMA_SAFE flag as it does not make a difference
> for bpmp-i2c, but causes -EINVAL to be returned for valid
> transactions.

I wonder if bailing out on an unknown flag shouldn't be revisited in
general? I mean this will happen again when a new I2C_M_* flag is
introduced.


--i3lJ51RuaGWuFYNw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl/8xj0ACgkQFA3kzBSg
Kbb+Dg/+NYkFUdqolbfZAAYVzTJSz4FH0Yf/1rrl09nXdSj1tgzG+HCLZsD8cVyJ
N+zAkgf/vGaGmGMv1tKBGn0oxnObDCe9MJOoZWC0TxwqUT9nMnyefhYqX1obMxc9
37rrr/2dTAsU4By4PhfjsyZ6uImnMygUhk5yxcVWShy46+bZG4qBYZjMc3ptyUoI
6wdPuKsYsQBaNQsjOxTqaohLq8KM44XrhqXcqCDRR9SQ/MvpvL4+3KIA9zxEhUas
D/Rc/yiQhPYQ4MavQ4ukC/vr3cC5rElwFSV2Ky7cnfHgbhlWKlg2nB8FjkLt90C7
PxrdY33oqPvfMVUvr7N1FRNy+Nsx7TaqxPQqdm4SNrvXQPkXM+Lvj2Xb5YWtCCrI
y45FNZlMTEHS0hcMz/OXk32q1OtE4hRMFhl0wWRxpH8Y/3NAarI2FNyombNnmnda
X2GY2MMqLixDc4mlv9M8JtJOPyT1sWalxlmPB/xZPPLc97DRCk68b/2XJ/+uOzNt
0p1Ku5wZ7jxjdMDBB6ALj2GCy4PNsf4ev0wm0cNAXxD1u5qYrc6aaLlMyxQqlJOg
ChOEDqpRers0Cl8WKtl7AY90R66uT6NQv/M3TdfKT5vU3WlEo5v1W6107sSEut5Q
IPZtSIEKsBAkHcZd0+2XIdrmKWW+ozvmRG0N/DWfWoz3zmVWk8I=
=llBX
-----END PGP SIGNATURE-----

--i3lJ51RuaGWuFYNw--

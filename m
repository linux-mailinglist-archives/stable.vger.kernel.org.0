Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EEC53BBCAF
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 14:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231266AbhGEMM2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 08:12:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:44656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231193AbhGEMM2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 08:12:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3103961241;
        Mon,  5 Jul 2021 12:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625486991;
        bh=XJa5O9+CzbWx1+qfduFIXaWTzDmkdZ1Br2ZCUrhid1A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fUbfu1/3ScKDbC6HFdQ0H8T+JN7v8NYS2V7Sj71e68CGHDkIGB6iNpLnUuaMwYwdG
         lGDOCHFNQsn2ec+hxvdiy9O8ypiTi1PUxvun9o8itgZZ/r1OqzoEiR4WIFafvNbe+a
         h1xLx6g+uWxu9FUxXxYa6vuoMGqd8o/pvsbm8+1uTWtxv1iJjWkK8LVf9oJHDmeOOh
         lcBTlofBb/jmiV1Za7NmyIYP8+MKpYFDcKHZ9Wfsdd/KIy4Q1TDLdE1ZKukQ6tBZM9
         7e7Np3hZjFgXmvImisQ8QDuUlOg7X3aXcAoRyPo455skdU/KvAc7yEnfdWQowo34qF
         6NSggdi6qX03g==
Date:   Mon, 5 Jul 2021 13:09:20 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Lucas Tanure <tanureal@opensource.cirrus.com>
Subject: Re: [PATCH AUTOSEL 5.13 23/85] regmap-i2c: Set regmap max raw r/w
 from quirks
Message-ID: <20210705120920.GA4574@sirena.org.uk>
References: <20210704230420.1488358-1-sashal@kernel.org>
 <20210704230420.1488358-23-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="wac7ysb48OaltWcw"
Content-Disposition: inline
In-Reply-To: <20210704230420.1488358-23-sashal@kernel.org>
X-Cookie: Star Trek Lives!
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 04, 2021 at 07:03:18PM -0400, Sasha Levin wrote:
> From: Lucas Tanure <tanureal@opensource.cirrus.com>
>=20
> [ Upstream commit ea030ca688193462b8d612c1628c37129aa30072 ]
>=20
> Set regmap raw read/write from i2c quirks max read/write
> so regmap_raw_read/write can split the access into chunks

This seems a bit new featureish to be backporting to stable.

--wac7ysb48OaltWcw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmDi9nAACgkQJNaLcl1U
h9BfLgf/S6c4ru5U0VlxEuRPTm/9S5XpXOiqBUhFfwC7EOU/BpEBlpkUJNGVLZ3X
cB1SU+bt/RYBwJp+xZnVnuCCf9CA3cw82dc0jfHasMtgJynitg6nyCG4wAvgFxfb
vC3TWU/vg5Rnlc2MRhnJsMJudx0R40ob4GSUdhQFwDmvMcuWj+IYrn5sU24pw22e
4GDaYRHsckACotAY5213B4e3drJu0BmnMW7sbYXph4+pJKWxAITOcxdWRxpP5Ka9
iFwrrKnJDP4nB7iwXeKU7PY0lnkWmfUK1eKY01ncH+lWgQ6Hp5mKqRyPQ53RwTDV
NDiKEgCjbzMowdWf4W+sONlhdTDmOQ==
=zwXP
-----END PGP SIGNATURE-----

--wac7ysb48OaltWcw--

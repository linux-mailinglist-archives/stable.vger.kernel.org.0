Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E47742F21F6
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 22:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732846AbhAKVlF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 16:41:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:48306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732793AbhAKVlE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 16:41:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 562D922AED;
        Mon, 11 Jan 2021 21:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610401224;
        bh=qYMbwl1MhEMlh1xDSxBstnVFNWyukQ6+pe+4U3+nXRA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H2pjg2UyZjqF/zYOrx3mggoeCUcAngxTAIfZOngr2BRJw0wgesbhMPZgvwy+qGXY+
         +N7sOupL3BcvAFADoZNTec0RJvS/qDKopgDezXbax2u5IPxpXWlTdnFBS6djPQpNlc
         NuRB7wI+feLot971MGDheWaXYfiPL9/kTvExF0D5PxnoV66vXX3UvMlezT5TXgtEMk
         gIZMAhVQe9e/L+RZnvgMDh7ZnazmKLuNbyo9RSSAu1gOkylkPj8xcPyiNES3bNubx2
         aesjdOHZxt8idgXITGTgvpGNWs2v0oVnubIb1HO53SxCRvyUKYGziOYw6dpa6xTtQv
         vrkuzsYEkX+Lg==
Date:   Mon, 11 Jan 2021 22:40:20 +0100
From:   Wolfram Sang <wsa@kernel.org>
To:     Mikko Perttunen <mperttunen@nvidia.com>
Cc:     ldewangan@nvidia.com, digetx@gmail.com, thierry.reding@gmail.com,
        jonathanh@nvidia.com, linux-i2c@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] i2c: tegra: Wait for config load atomically while in
 ISR
Message-ID: <20210111214020.GE17475@kunai>
Mail-Followup-To: Wolfram Sang <wsa@kernel.org>,
        Mikko Perttunen <mperttunen@nvidia.com>, ldewangan@nvidia.com,
        digetx@gmail.com, thierry.reding@gmail.com, jonathanh@nvidia.com,
        linux-i2c@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20210111160832.3669873-1-mperttunen@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ffoCPvUAPMgSXi6H"
Content-Disposition: inline
In-Reply-To: <20210111160832.3669873-1-mperttunen@nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ffoCPvUAPMgSXi6H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 11, 2021 at 06:08:32PM +0200, Mikko Perttunen wrote:
> Upon a communication error, the interrupt handler can call
> tegra_i2c_disable_packet_mode. This causes a sleeping poll to happen
> unless the current transaction was marked atomic. Fix this by
> making the poll happen atomically if we are in an IRQ.
>=20
> This matches the behavior prior to the patch mentioned
> in the Fixes tag.
>=20
> Fixes: ede2299f7101 ("i2c: tegra: Support atomic transfers")
> Cc: stable@vger.kernel.org
> Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>

Applied to for-current, thanks!


--ffoCPvUAPMgSXi6H
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl/8xb8ACgkQFA3kzBSg
KbZW9A/9FH/4MQMdXA0ErmAFnCBP6GbcVRds2BjdhXHrXJh43j9pSTTeQjX/B2GA
3nIR7YUUj5jRItmvgq0HB0Fx0oOXiCji5LUcYS9AHpDQIjxYm0k5ExEOlzcb68Es
qERH9j7+FMIzGfbwt02Hu7YYsIA1aCy+g6A20kovvd8cAultw2KGCEj9CYSr8Ukj
a9YFMDqU/jbX0EOri5CqbZQ5yizhB2J4oJN/e8O/S38lgqFD+mOwKQSxj0hymOSu
3dKZLLLpBsc+2FwulYGwQfl+keL0KLrZRpfQBf8ePt9tCRiVH7/oDZpJ9CTGJBJl
myH0t0twglTBNlDJL4ue9fSRSxnUJtS84Nsjz9Tc1jg1Ch0lrr6GiZVjnhlAnKMD
TNLS5Sc5C0df0FAd0RnybLYnq4T6uMeeYM44yXStcwHx6ceWbNncXDBExJJZTjr4
Ax4UFHJtJ8Ms6TS6XDGWlc5Eo74cNgFpDsxECzJ2ZnjbwO1dpa5FNslEeqdZwJnm
IPc/2qPiMv2R/nJcekoXtkFpbUo1+eM7IOl0RZqwpjrPIGs00x6VOl/FIgC7fp5e
gZDJ6HNdQ8/ymmSEb4d/XZtuGCttRwKqVZOcv5r28sOAuIlcj+R+bwU+HMLgVc1i
6NXuoSV3k4/bJfK+xDh+tZPXObjCRxh+5lmKhdt38ZExPPk+yUc=
=vWTz
-----END PGP SIGNATURE-----

--ffoCPvUAPMgSXi6H--

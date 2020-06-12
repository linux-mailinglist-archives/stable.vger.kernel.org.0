Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41F5C1F75A8
	for <lists+stable@lfdr.de>; Fri, 12 Jun 2020 11:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbgFLJF0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jun 2020 05:05:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:48050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbgFLJF0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jun 2020 05:05:26 -0400
Received: from localhost (p54b33104.dip0.t-ipconnect.de [84.179.49.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DFBEF204EC;
        Fri, 12 Jun 2020 09:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591952725;
        bh=g+DVVhzwFZZP3ZF6+Ys3Gfc1NPeDfFWz7ksYnNkVqcM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lZBomTF/+JzcIRFMC0KDevuLux+uzv9UCX/MeSRsOpxkw3P5wfPuVc2sNezMgoA39
         M5N2uVcW7V5PIKI/dy6oPaqYR5EQpeArj+QLI96Vmj3Y+pIzBRbnlbrnZji5yLweNM
         Li2OJtGqgZEBvpQERXA6A4Fq4yiVuHfSW/Q4v02k=
Date:   Fri, 12 Jun 2020 11:05:17 +0200
From:   Wolfram Sang <wsa@kernel.org>
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     Oleksij Rempel <linux@rempel-privat.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Gao Pan <b54642@freescale.com>,
        Fugang Duan <B38611@freescale.com>, linux-i2c@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] i2c: imx: Fix external abort on early interrupt
Message-ID: <20200612090517.GA3030@ninjato>
References: <1591796802-23504-1-git-send-email-krzk@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="fUYQa+Pmc3FrFX/N"
Content-Disposition: inline
In-Reply-To: <1591796802-23504-1-git-send-email-krzk@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 10, 2020 at 03:46:42PM +0200, Krzysztof Kozlowski wrote:
> If interrupt comes early (could be triggered with CONFIG_DEBUG_SHIRQ),

That code is disabled since 2011 (6d83f94db95c ("genirq: Disable the
SHIRQ_DEBUG call in request_threaded_irq for now"))? So, you had this
without fake injection, I assume?


--fUYQa+Pmc3FrFX/N
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl7jRUkACgkQFA3kzBSg
KbZdkQ/+IZPMlXrFfdz5kWsASmwsLZaJa7dd9xv/IayrAehh/ERAm+m4BbpOUOI8
IuCPYKhvaiaBMek0qNpVXffcGHJwpRPbBuQNEk7FKR75YQtm8KbwZICDMzG0J9b9
n7D7/ZTEytKy24fYLQR0cZSc5xxqlsKtC9Hy0CPStkUtqojl/JK4M1DM4IzP0KG0
VXQmewDvW4ZIEC4FDFO4boEwo6YT5fgl0qmwmbyLRKwTozizjbbLKlXBUKtBB0op
2RtikZ5Go/BOkeIo5hHhMF5zY6W8fVDVHFQx0Ieq32rxxhTzS/JGy6oiUW4OOPCJ
9P7pFzjMOVav0owX6wk/bANz+4epMut/lB64Lv0T0Q2VDdfXzVq6ROJasZIdpSTF
jktWK1hPJUJ3MEOw/5BddvFiZ/RliEOCcD4fjYT6FohTC76DdUv2/oOUYEjLxaO4
AJlqGM/7RiEtSKD1GFkfPv/b9Tz64yl8MmnKhLvK49c2VVeVcvU6V4E2NmMjpdg8
qNVc+MZBzJKPCd5YaRBMLD8/bnaI3c94UvjFAYX2kL2n3cud9+qhTFNS+LXh4/z4
bt2E55+LUNiyt4vPv8anFZn/JGnf89SE8ftrFPYxltmfEQHg8XDg1jeS3NiofhO1
2OkgvR3UcYR+O/4nSlU97W40qyYijEdZigq20Cmn4Fa6ospa92Y=
=OepP
-----END PGP SIGNATURE-----

--fUYQa+Pmc3FrFX/N--

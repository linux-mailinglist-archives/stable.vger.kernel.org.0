Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F31310EFEB
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 20:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727985AbfLBTRM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 14:17:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:49856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727586AbfLBTRM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Dec 2019 14:17:12 -0500
Received: from localhost (lfbn-1-10718-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50C7A214AF;
        Mon,  2 Dec 2019 19:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575314231;
        bh=Tbap/Zmbh8gZMiHJcbLH34iqHD0SlfP5bSkdQHyv2Pw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Dkufy4cS1HaipR+LhHipcKBL4Xu12NzG+/yYNkCVI8gfr2V1PjPUmGCblvOaQChp3
         NGrtXRe7y9k2FEFMan3af92qn2MJT+HhhtXbHNOwPFyH+qYrAXJdXDgQBw4M7zNt1d
         cpllNddpVE7MoUoKopBcs0zLjKjMqw+iRkfQ22aA=
Date:   Mon, 2 Dec 2019 20:17:09 +0100
From:   Maxime Ripard <mripard@kernel.org>
To:     Stefan Mavrodiev <stefan@olimex.com>
Cc:     Chen-Yu Tsai <wens@csie.org>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "moderated list:ARM/Allwinner sunXi SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-sunxi@googlegroups.com, stable@vger.kernel.org
Subject: Re: [PATCH v2 3/3] arm64: dts: allwinner: a64: olinuxino: Fix SDIO
 supply regulator
Message-ID: <20191202191709.nqbushoi65dhiqgj@gilmour.lan>
References: <20191129113941.20170-1-stefan@olimex.com>
 <20191129113941.20170-4-stefan@olimex.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="l3uncgqa5xbn4vfx"
Content-Disposition: inline
In-Reply-To: <20191129113941.20170-4-stefan@olimex.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--l3uncgqa5xbn4vfx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 29, 2019 at 01:39:41PM +0200, Stefan Mavrodiev wrote:
> A64-OLinuXino uses DCDC1 (VCC-IO) for MMC1 supply. In commit 916b68cfe4b5
> ("arm64: dts: a64-olinuxino: Enable RTL8723BS WiFi") ALDO2 is set, which is
> VCC-PL. Since DCDC1 is always present, the boards are working without a
> problem.
>
> This patch sets the correct regulator.
>
> Fixes: 916b68cfe4b5 ("arm64: dts: a64-olinuxino: Enable RTL8723BS WiFi")
> Cc: stable@vger.kernel.org # v4.16+
> Signed-off-by: Stefan Mavrodiev <stefan@olimex.com>

Applied, thanks!
Maxime

--l3uncgqa5xbn4vfx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXeVjNQAKCRDj7w1vZxhR
xYI5AQDZZQGUNxHfiwStWrEfc2VJtj2zpYy6AQcUhgg5psTkzQEAr0lcg82RRRqt
AQVFVWi1+hH35NAMNs6z1e4eIPP5ggU=
=yaJQ
-----END PGP SIGNATURE-----

--l3uncgqa5xbn4vfx--

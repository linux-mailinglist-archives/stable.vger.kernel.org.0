Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A942D10EFDD
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 20:13:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbfLBTNp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 14:13:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:48798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727580AbfLBTNp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Dec 2019 14:13:45 -0500
Received: from localhost (lfbn-1-10718-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D9D420848;
        Mon,  2 Dec 2019 19:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575314024;
        bh=xPa0X6R5T4e6CEa2s0SLF/tQNyowSG/AuLe3v9UhiTU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OFfA4XXSIukBhUqFK/VHx0x3IEaSdakYD9V9S4aW89Q9zq5PeKYQWEONDx6t7Ze21
         QBkk/jmZyCAKUK/lRxI6bex7+avShuMTRHoOJMBy4RO2DJIv//sUdG0ohk2zXOXLBG
         Sm3vNETJvv8pNx6Ctq25FodpLb7DUWdyauDV8N2c=
Date:   Mon, 2 Dec 2019 20:13:42 +0100
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
Subject: Re: [PATCH v2 1/3] arm64: dts: allwinner: a64: olinuxino: Fix eMMC
 supply regulator
Message-ID: <20191202191342.7ttegde7jewn4xra@gilmour.lan>
References: <20191129113941.20170-1-stefan@olimex.com>
 <20191129113941.20170-2-stefan@olimex.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="q764rlr5yjz4gv75"
Content-Disposition: inline
In-Reply-To: <20191129113941.20170-2-stefan@olimex.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--q764rlr5yjz4gv75
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 29, 2019 at 01:39:39PM +0200, Stefan Mavrodiev wrote:
> A64-OLinuXino-eMMC uses 1.8V for eMMC supply. This is done via a triple
> jumper, which sets VCC-PL to either 1.8V or 3.3V. This setting is different
> for boards with and without eMMC.
>
> This is not a big issue for DDR52 mode, however the eMMC will not work in
> HS200/HS400, since these modes explicitly requires 1.8V.
>
> Fixes: 94f68f3a4b2a ("arm64: dts: allwinner: a64: Add A64 OlinuXino board (with eMMC)")
> Cc: stable@vger.kernel.org # v5.4
> Signed-off-by: Stefan Mavrodiev <stefan@olimex.com>

Applied, thanks!
Maxime

--q764rlr5yjz4gv75
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXeViZgAKCRDj7w1vZxhR
xVnqAQCN+/fEAa8RYdLvkoYtRzpPTIeiTCvNTyfWakMZS9YKvQEAnFfgnu6qHLWp
6DXcmrsNxdL1AzYEYmpIY1KhpG4BdgQ=
=ZRr1
-----END PGP SIGNATURE-----

--q764rlr5yjz4gv75--

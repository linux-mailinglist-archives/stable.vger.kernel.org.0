Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7D012F0A9C
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 01:32:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbhAKAcU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jan 2021 19:32:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:43990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726932AbhAKAcT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 10 Jan 2021 19:32:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BAE521D40;
        Mon, 11 Jan 2021 00:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610325099;
        bh=uMU8howUW7J4Ko/B597yGylQGjetpe7UVHfGZFSLTQo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gdXPm1gR0Gi1DQ6qSUBc6wgaNm0pHnbiqZqJyGpz59l7LFQyACswBMQoi8tnvyfes
         8wY8socBhwWc1GqliTa1cGI4Qpg+pTOtlxGty5tdlqTo5b1mwmZ35lAMOu4h+siJcx
         bYG6zPcJHXLrN9+VlHRh0YDW6gqOxRkN1KomHDSO311K7FoUCHFwsRoI0lPSK+2j2h
         64gCE0+k2vy5/PpYp3hprkDpDVt5m8HaEclqP5dPV45lEj3jjkzKmC0SOwpYHn7nxI
         i/jxeEvNMnG1Li/JUygsGpYPqPogPc4+OABVei/8pfOA2ba6BfIxk7sPg3KTy+R3iv
         y+pAs4h3V7BHg==
Date:   Mon, 11 Jan 2021 08:31:35 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Soeren Moch <smoch@web.de>
Cc:     stable@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: dts: tbs2910: rename MMC node aliases
Message-ID: <20210111003134.GS28365@dragon>
References: <20201222155908.48600-1-smoch@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201222155908.48600-1-smoch@web.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 22, 2020 at 04:59:08PM +0100, Soeren Moch wrote:
> to be consistent with kernel versions up to v5.9 (mmc aliases not used here).
> usdhc1 is not wired up on this board and therefore cannot be used.
> Start mmc aliases with usdhc2.
> 
> Signed-off-by: Soeren Moch <smoch@web.de>
> Cc: stable@vger.kernel.org                # 5.10.x

Can we have a Fixes tag as well?

Shawn

> ---
> Cc: Shawn Guo <shawnguo@kernel.org>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: Fabio Estevam <festevam@gmail.com>
> Cc: linux-arm-kernel@lists.infradead.org
> ---
>  arch/arm/boot/dts/imx6q-tbs2910.dts | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/imx6q-tbs2910.dts b/arch/arm/boot/dts/imx6q-tbs2910.dts
> index cb591233035b..6a6e27b35e34 100644
> --- a/arch/arm/boot/dts/imx6q-tbs2910.dts
> +++ b/arch/arm/boot/dts/imx6q-tbs2910.dts
> @@ -16,6 +16,13 @@ chosen {
>  		stdout-path = &uart1;
>  	};
> 
> +	aliases {
> +		mmc0 = &usdhc2;
> +		mmc1 = &usdhc3;
> +		mmc2 = &usdhc4;
> +		/delete-property/ mmc3;
> +	};
> +
>  	memory@10000000 {
>  		device_type = "memory";
>  		reg = <0x10000000 0x80000000>;
> --
> 2.25.1
> 

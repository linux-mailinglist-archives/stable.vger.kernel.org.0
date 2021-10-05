Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDFA1421F49
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 09:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232167AbhJEHO0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 03:14:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:53054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230526AbhJEHO0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 03:14:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4AC6861506;
        Tue,  5 Oct 2021 07:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633417956;
        bh=Z1Kyh4CmT/HAHgyMmHMMCSHGxms9KPY2yA5BUj5ZFLg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fCnJZF3GT8TJTOOoHPseEhYX2OVuS7WYLpZ3h2dcHx7a1PhFE9e9OxNIHbpT5F8PJ
         TK/qO6FF5eFOcjAYgEhdTvpi6vIuyrpEvR8lRQhaHfNSaUCApvEsAyszRCnGJCHiLG
         LKyqaQh6eQpNMOkeA1v4n0YkfOxY37o4FlEp/paZHfEm1f91KKqZ+dzmjaFneaEwBW
         lNAE4mJKT6CTNO6+S1RxkNEbHBSUuholIp/7XMbwUUwKNNCHubH+O/NbwTKOFCzQ98
         +Jtt+S91lmXPhd77E8Fs090n3bt0b3FECB065apme/VW+lXCKEnOPNWQX7ExKQCBFU
         aAsuC9SG4KJ6g==
Date:   Tue, 5 Oct 2021 15:12:31 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Frieder Schrempf <frieder@fris.de>
Cc:     devicetree@vger.kernel.org,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, stable@vger.kernel.org,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>
Subject: Re: [PATCH 5/8] arm64: dts: imx8mm-kontron: Fix CAN SPI clock
 frequency
Message-ID: <20211005071230.GC20743@dragon>
References: <20210930155633.2745201-1-frieder@fris.de>
 <20210930155633.2745201-6-frieder@fris.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210930155633.2745201-6-frieder@fris.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 30, 2021 at 05:56:28PM +0200, Frieder Schrempf wrote:
> From: Frieder Schrempf <frieder.schrempf@kontron.de>
> 
> The MCP2515 can be used with an SPI clock of up to 10 MHz. Set the
> limit accordingly to prevent any performance issues caused by the
> really low clock speed of 100 kHz.

Could you share some testing result of this change?

> 
> Fixes: 21c4f45b335f ("arm64: dts: Add the Kontron i.MX8M Mini SoMs and baseboards")

It's really an optimization rather than fix, isn't it?

Shawn

> Cc: stable@vger.kernel.org
> Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
> ---
>  arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
> index f2c8ccefd1bf..dbf11e03ecce 100644
> --- a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
> +++ b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
> @@ -98,7 +98,7 @@ can0: can@0 {
>  		clocks = <&osc_can>;
>  		interrupt-parent = <&gpio4>;
>  		interrupts = <28 IRQ_TYPE_EDGE_FALLING>;
> -		spi-max-frequency = <100000>;
> +		spi-max-frequency = <10000000>;
>  		vdd-supply = <&reg_vdd_3v3>;
>  		xceiver-supply = <&reg_vdd_5v>;
>  	};
> -- 
> 2.33.0
> 

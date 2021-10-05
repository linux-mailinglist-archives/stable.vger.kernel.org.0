Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F19F9421F6A
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 09:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232481AbhJEH3V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 03:29:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:59266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232108AbhJEH3U (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 03:29:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75C40610E6;
        Tue,  5 Oct 2021 07:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633418850;
        bh=Dtz3i1SFKI5GY8VCxINDdZpDjS8RSAbKBaCuSTV/w+s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Dz9QQX6lZm+Mhi3j3D0tA42c7f6CEg9u71g1TixOT+kjVhBq/HTMKZfcpkd6pPH91
         EbaB8fNhSuqR7U78T39bAcieHTwB4iRwHyzT7vkbTZiP8tB/okhQXwwLeVbV+cJ68F
         1xNXrYH83x/WoYSihwW0/VsTqKpbtoeVfwUjlqtpjBeBSrJ9PHpyipH4cJ7KxQtCbk
         ZlCdZ4Dv+uNKXjNvD5ldjqfe1OY0rRcRpFC6zESdklh2T2AyHtRF6VrvGmHXitI9Y3
         lyjUeyzKFrynfIq+1hMV69qVaYdgS8ll32BGFK+3SdI0J5EuZJRnJqZEc3jX58g/Mi
         5r8o/uG3ALXpg==
Date:   Tue, 5 Oct 2021 15:27:24 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Frieder Schrempf <frieder@fris.de>
Cc:     devicetree@vger.kernel.org,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Heiko Thiery <heiko.thiery@gmail.com>, stable@vger.kernel.org,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>
Subject: Re: [PATCH 8/8] arm64: dts: imx8mm-kontron: Leave reg_vdd_arm always
 powered on
Message-ID: <20211005072723.GE20743@dragon>
References: <20210930155633.2745201-1-frieder@fris.de>
 <20210930155633.2745201-9-frieder@fris.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210930155633.2745201-9-frieder@fris.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 30, 2021 at 05:56:31PM +0200, Frieder Schrempf wrote:
> From: Frieder Schrempf <frieder.schrempf@kontron.de>
> 
> When the cpufreq driver is enabled, the buck2 regulator is kept powered on
> by the dependency between the CPU nodes with 'cpu-supply' set. Without the
> cpufreq driver the kernel will power off the regulator as it doesn't see
> any users. This is obviously not what we want, therefore keep the regulator
> powered on in any case.
> 
> Reported-by: Heiko Thiery <heiko.thiery@gmail.com>
> Fixes: 21c4f45b335f ("arm64: dts: Add the Kontron i.MX8M Mini SoMs and baseboards")
> Cc: stable@vger.kernel.org
> Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>

Already picked up the one from Heiko.

https://lore.kernel.org/all/20210915120325.20248-1-heiko.thiery@gmail.com/

Shawn

> ---
>  arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi
> index 213014f59b46..c3418d263eb4 100644
> --- a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi
> +++ b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi
> @@ -105,6 +105,7 @@ reg_vdd_arm: BUCK2 {
>  				regulator-min-microvolt = <850000>;
>  				regulator-max-microvolt = <950000>;
>  				regulator-boot-on;
> +				regulator-always-on;
>  				regulator-ramp-delay = <3125>;
>  				nxp,dvs-run-voltage = <950000>;
>  				nxp,dvs-standby-voltage = <850000>;
> -- 
> 2.33.0
> 

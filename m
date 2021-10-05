Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBCCC421F2B
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 08:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232493AbhJEG6i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 02:58:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:42266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230526AbhJEG6h (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 02:58:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9090610A2;
        Tue,  5 Oct 2021 06:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633417007;
        bh=71mlPq8y3H59x8SPscGDba3lmvBHepI0lrXnh8IQ0gE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ejJtWkmgJW82hCd31ZTppNppfTqQ3PKGjBsoQggjoEP3rT1LjMLnRQtrCWxjafETF
         rZ9VDvidU+6Hb6ZsWz2Xk5Xf/Jy706h2GdiSvqid0TfUeeAGXZrwqdSc/5JVEUzyuU
         ydIBhUybmP1NKWVV9ixTwUsOGRo4Wrf4G8KW9amQKVvg5RCFhwX6xnEMAJChG6hUkF
         YxK5bQBOL6pZAIu0StvZ09c6II4TCtn/m3Y5SxyMaBnhXgcLKUB7HPiFtUfx/38SUG
         8BAeWA+QTf7tGGwQgMH9ZgGPLlCWZji0vygZEyXaQP2AfcHoQeHfe9aPf7lZ9/9sGs
         PEvJ758WmHQrw==
Date:   Tue, 5 Oct 2021 14:56:42 +0800
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
Subject: Re: [PATCH 3/8] arm64: dts: imx8mm-kontron: Set VDD_SNVS to 800 mV
Message-ID: <20211005065641.GA20743@dragon>
References: <20210930155633.2745201-1-frieder@fris.de>
 <20210930155633.2745201-4-frieder@fris.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210930155633.2745201-4-frieder@fris.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 30, 2021 at 05:56:26PM +0200, Frieder Schrempf wrote:
> From: Frieder Schrempf <frieder.schrempf@kontron.de>
> 
> According to the datasheet VDD_SNVS should be 800 mV, so let's
> make sure that the voltage won't be different.

Could you share the datasheet?

Shawn

> 
> Fixes: 21c4f45b335f ("arm64: dts: Add the Kontron i.MX8M Mini SoMs and baseboards")
> Cc: stable@vger.kernel.org
> Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
> ---
>  arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi
> index b12fb7ce6686..213014f59b46 100644
> --- a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi
> +++ b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi
> @@ -152,8 +152,8 @@ reg_nvcc_snvs: LDO1 {
>  
>  			reg_vdd_snvs: LDO2 {
>  				regulator-name = "ldo2";
> -				regulator-min-microvolt = <850000>;
> -				regulator-max-microvolt = <900000>;
> +				regulator-min-microvolt = <800000>;
> +				regulator-max-microvolt = <800000>;
>  				regulator-boot-on;
>  				regulator-always-on;
>  			};
> -- 
> 2.33.0
> 

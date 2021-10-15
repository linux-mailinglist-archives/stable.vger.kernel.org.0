Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A97542E77B
	for <lists+stable@lfdr.de>; Fri, 15 Oct 2021 06:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233185AbhJOEHF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Oct 2021 00:07:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:59752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229445AbhJOEHD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Oct 2021 00:07:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4EA2C610D2;
        Fri, 15 Oct 2021 04:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634270697;
        bh=T1Z9HbQrrY18qJUzBqQ0IoiV6ybSBk9q37LkdOEVAus=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MXzvhER6Kr2mM3DpPB54nBFaCzil9UDbBHRkB2kejrtxoDqfZxIbk+i0+Vjzc4h8e
         D5k6bztnfatkzJj9nV1DM/47/upMR8iTcsQz6lPYsCk7lB0U0eN6KBi663xVlvHjq+
         bhWeF08FTuLMA2efmaW7VYW5Pc+WR/BQePS8wdheBukiF7c9upNQFRioRAyxTAOBFO
         RDuGG0e6EDLZKCgZivKh2F9Ac8Cs2unKc9laSl0TQskNbnTvCd4MAqaBEi2Rdb7ZC+
         pHui5UaBDwGJ1jBcscWKXpHuDMZwcR9kX8sX8SBN5V9KzDbtPclkJFEoM2FdN2IUvS
         ++29VBV8lDI0g==
Date:   Fri, 15 Oct 2021 12:04:51 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Frieder Schrempf <frieder.schrempf@kontron.de>
Cc:     Frieder Schrempf <frieder@fris.de>, devicetree@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, stable@vger.kernel.org,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>
Subject: Re: [PATCH 3/8] arm64: dts: imx8mm-kontron: Set VDD_SNVS to 800 mV
Message-ID: <20211015040450.GF22881@dragon>
References: <20210930155633.2745201-1-frieder@fris.de>
 <20210930155633.2745201-4-frieder@fris.de>
 <20211005065641.GA20743@dragon>
 <df454b06-3069-d369-e3c7-f2434d94f4af@kontron.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df454b06-3069-d369-e3c7-f2434d94f4af@kontron.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 05, 2021 at 03:14:40PM +0200, Frieder Schrempf wrote:
> On 05.10.21 08:56, Shawn Guo wrote:
> > On Thu, Sep 30, 2021 at 05:56:26PM +0200, Frieder Schrempf wrote:
> >> From: Frieder Schrempf <frieder.schrempf@kontron.de>
> >>
> >> According to the datasheet VDD_SNVS should be 800 mV, so let's
> >> make sure that the voltage won't be different.
> > 
> > Could you share the datasheet?
> 
> Sure, it's here: https://www.nxp.com/docs/en/data-sheet/IMX8MMIEC.pdf.
> See table 10 for the operating voltages.

Thanks for the link!

But datasheet specifies a voltage range. 800 mV is just the typical one.
The only problem I see is that regulator-min-microvolt should be lowered
to 800 mV.  regulator-max-microvolt looks correct to me.

Shawn

> 
> >>
> >> Fixes: 21c4f45b335f ("arm64: dts: Add the Kontron i.MX8M Mini SoMs and baseboards")
> >> Cc: stable@vger.kernel.org
> >> Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
> >> ---
> >>  arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi | 4 ++--
> >>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi
> >> index b12fb7ce6686..213014f59b46 100644
> >> --- a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi
> >> +++ b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi
> >> @@ -152,8 +152,8 @@ reg_nvcc_snvs: LDO1 {
> >>  
> >>  			reg_vdd_snvs: LDO2 {
> >>  				regulator-name = "ldo2";
> >> -				regulator-min-microvolt = <850000>;
> >> -				regulator-max-microvolt = <900000>;
> >> +				regulator-min-microvolt = <800000>;
> >> +				regulator-max-microvolt = <800000>;
> >>  				regulator-boot-on;
> >>  				regulator-always-on;
> >>  			};
> >> -- 
> >> 2.33.0
> >>

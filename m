Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA155FD460
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 07:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbiJMF6D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 01:58:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiJMF6B (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 01:58:01 -0400
Received: from mx1.tq-group.com (mx1.tq-group.com [93.104.207.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E29FB1285C7;
        Wed, 12 Oct 2022 22:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1665640680; x=1697176680;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=apJEnHLkQjzl7B1Pt8I9pkKweLKTkm4rh13qLb61/Ls=;
  b=d5W0Bnmh/dEDALcpTerpPK3S0tC9luuIXA0s8VjLsFaD9mSaCNw2ibOS
   zj0QsFwETv3Qnysn8MScDdwVr0aQgOPU4TB7BO3d1oHhc4V4Ib9WhA72Y
   ItfZGPZJ2H0mgHe3tfPkWaUfpCaCoyLHnZVisI7mmf3dkjNKkONsuWTOq
   0myDleprWevxyvhDqqGtLKWYwyqyqvSN7sBAtvkdeu25nwH/uDdcPo3Lk
   16r3YpxhFvcYQwKu5lM+upqclVLg8Fiuulj1OqDN2PYOrz857+4bWcQ4x
   FE6PsNHS6/hHXI5Uhi53Uyz2CYP3mKJnn8P9uqX/LgelqyKbPixGY6k6/
   A==;
X-IronPort-AV: E=Sophos;i="5.95,180,1661810400"; 
   d="scan'208";a="26721526"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 13 Oct 2022 07:57:58 +0200
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Thu, 13 Oct 2022 07:57:58 +0200
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Thu, 13 Oct 2022 07:57:58 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1665640678; x=1697176678;
  h=from:to:cc:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding:subject;
  bh=apJEnHLkQjzl7B1Pt8I9pkKweLKTkm4rh13qLb61/Ls=;
  b=IvAiit125OagcJRFBtuIlFxyrikB3kRQyddqC4Xm5KCkg4g4WaCXH1nR
   XFP17n+V+q9VB4J4MECfBFSkqkIR2GauEvE6xH03KutpZUJXWfOYh08Rk
   pP0wHu4JOEThvpLGuJr2tI6MGNOgcPpyKouxwe/kK0XiEYCqyFiMr8Ooj
   oSP+YE1oxt7DC1SUHEmEo/NoJnPT5mNyD6aeDKrNIptfzrsfy840xaTsZ
   Qo5zYXxrLbot5826NOpl7YImQkQKA2pXB2hWCljr6E7FGnBG/rpECxe2W
   e/CcC3+cHWvaW2oPJZgmmSbX6Zr9AxA4YxjSPRJAT0QLGJq23stjojEWW
   g==;
X-IronPort-AV: E=Sophos;i="5.95,180,1661810400"; 
   d="scan'208";a="26721525"
Subject: Re: [PATCH AUTOSEL 5.15 31/47] arm64: dts: imx8mp: Add snps,
 gfladj-refclk-lpm-sel quirk to USB nodes
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 13 Oct 2022 07:57:58 +0200
Received: from steina-w.localnet (unknown [10.123.53.21])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by vtuxmail01.tq-net.de (Postfix) with ESMTPSA id DECB2280056;
        Thu, 13 Oct 2022 07:57:57 +0200 (CEST)
From:   Alexander Stein <alexander.stein@ew.tq-group.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, shawnguo@kernel.org,
        l.stach@pengutronix.de, peng.fan@nxp.com,
        laurent.pinchart@ideasonboard.com, marex@denx.de,
        festevam@gmail.com, hongxing.zhu@nxp.com,
        paul.elder@ideasonboard.com, Markus.Niebel@ew.tq-group.com,
        aford173@gmail.com, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date:   Thu, 13 Oct 2022 07:57:55 +0200
Message-ID: <4758030.GXAFRqVoOG@steina-w>
Organization: TQ-Systems GmbH
In-Reply-To: <20221013002124.1894077-31-sashal@kernel.org>
References: <20221013002124.1894077-1-sashal@kernel.org> <20221013002124.1894077-31-sashal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am Donnerstag, 13. Oktober 2022, 02:21:06 CEST schrieb Sasha Levin:
> From: Alexander Stein <alexander.stein@ew.tq-group.com>
> 
> [ Upstream commit 5c3d5ecf48ab06c709c012bf1e8f0c91e1fcd7ad ]
> 
> With this set the SOF/ITP counter is based on ref_clk when 2.0 ports are
> suspended.
> snps,dis-u2-freeclk-exists-quirk can be removed as
> snps,gfladj-refclk-lpm-sel also clears the free running clock configuration
> bit.
> 
> Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
> Link:
> https://lore.kernel.org/r/20220915062855.751881-4-alexander.stein@ew.tq-gro
> up.com Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/arm64/boot/dts/freescale/imx8mp.dtsi | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/boot/dts/freescale/imx8mp.dtsi
> b/arch/arm64/boot/dts/freescale/imx8mp.dtsi index
> 9b07b26230a1..664177ed38d3 100644
> --- a/arch/arm64/boot/dts/freescale/imx8mp.dtsi
> +++ b/arch/arm64/boot/dts/freescale/imx8mp.dtsi
> @@ -912,7 +912,7 @@ usb_dwc3_0: usb@38100000 {
>  				interrupts = <GIC_SPI 40 
IRQ_TYPE_LEVEL_HIGH>;
>  				phys = <&usb3_phy0>, <&usb3_phy0>;
>  				phy-names = "usb2-phy", "usb3-
phy";
> -				snps,dis-u2-freeclk-exists-quirk;
> +				snps,gfladj-refclk-lpm-sel-quirk;
>  			};
> 
>  		};
> @@ -953,7 +953,7 @@ usb_dwc3_1: usb@38200000 {
>  				interrupts = <GIC_SPI 41 
IRQ_TYPE_LEVEL_HIGH>;
>  				phys = <&usb3_phy1>, <&usb3_phy1>;
>  				phy-names = "usb2-phy", "usb3-
phy";
> -				snps,dis-u2-freeclk-exists-quirk;
> +				snps,gfladj-refclk-lpm-sel-quirk;
>  			};
>  		};

Mh, does it make sense to pick this one without commit a6fc2f1b0927 ("usb: 
dwc3: core: add gfladj_refclk_lpm_sel quirk")?
snps,gfladj-refclk-lpm-sel-quirk is unknown/unused after this patch, but 
snps,dis-u2-freeclk-exists-quirk is not applied any more.
If a6fc2f1b0927 is not applicable, I would drop this one instead.

Best regards,
Alexander




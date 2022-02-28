Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80E3E4C7799
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 19:24:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240574AbiB1SZU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 13:25:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240140AbiB1SZL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 13:25:11 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 945079EBBA
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 10:05:11 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id z15so11700067pfe.7
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 10:05:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NV9ie411O40GXoKdmB6XocMILdm6e2f7gQDHPVR95BM=;
        b=gzcuQo+rhTjNEzolMnIBcji+6Lbfpi/b8/TrMXYfbkLSaqKT2CHjMocxHEp7mDdS/Z
         r/OxOYQrYpMgUhgH0Nj7oN17hW+0EfuxDXDmUjRFXEY0xDUKRVpArBELqpLHMpx8yMXg
         TW/hCd1d/M6XcZds2jTyKNd2NOHnF+I6ib59FyTeY+8htDmxWpkpE7iUIqwHaZybyYI8
         G8ke+gBEUHO9szN8n+M7nnM7LUhbcbKsXr/QD9rgTDVtMiWRK0gQ6rbZFqrXH7kKQP84
         BqzRvaMSIKUN6uweKFKmaG1z+ZVDF7HSj+ibwvrWVJNEyyg4m9HO8wHi5qv88oKQ5DLQ
         FbLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NV9ie411O40GXoKdmB6XocMILdm6e2f7gQDHPVR95BM=;
        b=RMV+8yjmGX8/KBKB7D1oALr24eP84KBVJh6jMghbPvL6olBqLv+xxE1z21cgQRf2yy
         ogvTgcIWXiCkdHpUIMVNoY+iBoePSxchbKEPCDCb79Cl+JwDW1gkdLzq0YqEgTLg/kRu
         PlVtcwwkvavrxC6vJdwEY03svVvaw1igIEJu7vtROSC896A6rjj6AuVn8J2F+bAXx2rs
         eHAkQz93cwhRP8j0dRlnvH1g2kwekMRofTHyeYAOL60vS58UMd6M+dudYvt1k0sxPNqG
         vqtjzp7MQ7+8v2Y9oDqJIx6sL9fHA0x3LNTkvFVH++ry8tW8B1RcoWBB2U/A83hQuOpQ
         n8lg==
X-Gm-Message-State: AOAM5319SuwqHMfcVWtkGH/bSfSfm8+Hy9Kb9lZIbuPrZ+fFLq7ePnft
        SldVFOM+WU/cpjnLKFE4FTAtNJYuGa51xCv/fD/nJw==
X-Google-Smtp-Source: ABdhPJwchrBRVlpMRDctD2rTS7qnH0MSv+U6mU1YnMj/jx7/PZvdDqeHAthZgQ44hTG6eqyKb5R024/0KbFCAQkjVBA=
X-Received: by 2002:a05:6a00:1307:b0:4b0:b1c:6fd9 with SMTP id
 j7-20020a056a00130700b004b00b1c6fd9mr22992507pfu.27.1646071500373; Mon, 28
 Feb 2022 10:05:00 -0800 (PST)
MIME-Version: 1.0
References: <20220228101617.12694-1-johan@kernel.org>
In-Reply-To: <20220228101617.12694-1-johan@kernel.org>
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Mon, 28 Feb 2022 10:04:48 -0800
Message-ID: <CAJ+vNU0ppYr80hV5+9tQYW1sF=szYP1N+yS5U2a71UkyoPMTXA@mail.gmail.com>
Subject: Re: [PATCH] arm64: dts: imx8mm-venice: fix spi2 pin configuration
To:     Johan Hovold <johan@kernel.org>
Cc:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Linux ARM Mailing List <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 28, 2022 at 2:18 AM Johan Hovold <johan@kernel.org> wrote:
>
> Due to what looks like a copy-paste error, the ECSPI2_MISO pad is not
> muxed for SPI mode and causes reads from a slave-device connected to the
> SPI header to always return zero.
>
> Configure the ECSPI2_MISO pad for SPI mode on the gw71xx, gw72xx and
> gw73xx families of boards that got this wrong.
>
> Fixes: 6f30b27c5ef5 ("arm64: dts: imx8mm: Add Gateworks i.MX 8M Mini Development Kits")
> Cc: stable@vger.kernel.org      # 5.12
> Cc: Tim Harvey <tharvey@gateworks.com>
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>  arch/arm64/boot/dts/freescale/imx8mm-venice-gw71xx.dtsi | 2 +-
>  arch/arm64/boot/dts/freescale/imx8mm-venice-gw72xx.dtsi | 2 +-
>  arch/arm64/boot/dts/freescale/imx8mm-venice-gw73xx.dtsi | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw71xx.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw71xx.dtsi
> index 28012279f6f6..ecf6c9a6db90 100644
> --- a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw71xx.dtsi
> +++ b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw71xx.dtsi
> @@ -166,7 +166,7 @@ pinctrl_spi2: spi2grp {
>                 fsl,pins = <
>                         MX8MM_IOMUXC_ECSPI2_SCLK_ECSPI2_SCLK    0xd6
>                         MX8MM_IOMUXC_ECSPI2_MOSI_ECSPI2_MOSI    0xd6
> -                       MX8MM_IOMUXC_ECSPI2_SCLK_ECSPI2_SCLK    0xd6
> +                       MX8MM_IOMUXC_ECSPI2_MISO_ECSPI2_MISO    0xd6
>                         MX8MM_IOMUXC_ECSPI2_SS0_GPIO5_IO13      0xd6
>                 >;
>         };
> diff --git a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw72xx.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw72xx.dtsi
> index 27afa46a253a..6e0f0a2f6970 100644
> --- a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw72xx.dtsi
> +++ b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw72xx.dtsi
> @@ -231,7 +231,7 @@ pinctrl_spi2: spi2grp {
>                 fsl,pins = <
>                         MX8MM_IOMUXC_ECSPI2_SCLK_ECSPI2_SCLK    0xd6
>                         MX8MM_IOMUXC_ECSPI2_MOSI_ECSPI2_MOSI    0xd6
> -                       MX8MM_IOMUXC_ECSPI2_SCLK_ECSPI2_SCLK    0xd6
> +                       MX8MM_IOMUXC_ECSPI2_MISO_ECSPI2_MISO    0xd6
>                         MX8MM_IOMUXC_ECSPI2_SS0_GPIO5_IO13      0xd6
>                 >;
>         };
> diff --git a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw73xx.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw73xx.dtsi
> index a59e849c7be2..6c4c9ae9715f 100644
> --- a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw73xx.dtsi
> +++ b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw73xx.dtsi
> @@ -280,7 +280,7 @@ pinctrl_spi2: spi2grp {
>                 fsl,pins = <
>                         MX8MM_IOMUXC_ECSPI2_SCLK_ECSPI2_SCLK    0xd6
>                         MX8MM_IOMUXC_ECSPI2_MOSI_ECSPI2_MOSI    0xd6
> -                       MX8MM_IOMUXC_ECSPI2_SCLK_ECSPI2_SCLK    0xd6
> +                       MX8MM_IOMUXC_ECSPI2_MISO_ECSPI2_MISO    0xd6
>                         MX8MM_IOMUXC_ECSPI2_SS0_GPIO5_IO13      0xd6
>                 >;
>         };
> --
> 2.34.1
>

Johan,

Thanks for catching this!

Acked-by: Tim Harvey <tharvey@gateworks.com>

Best Regards,

Tim

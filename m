Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C41E13187DF
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 11:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbhBKKQc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 05:16:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbhBKKQK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Feb 2021 05:16:10 -0500
Received: from mail-out.m-online.net (mail-out.m-online.net [IPv6:2001:a60:0:28:0:1:25:1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88D7BC061756;
        Thu, 11 Feb 2021 02:15:12 -0800 (PST)
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4DbsvM2WyGz1rxcC;
        Thu, 11 Feb 2021 11:15:11 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4DbsvM1JG1z1sP75;
        Thu, 11 Feb 2021 11:15:11 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id ECRdps7T0nDa; Thu, 11 Feb 2021 11:15:09 +0100 (CET)
X-Auth-Info: FQL4N4HFTWrrQ9opqhHTxcbEHdtA0CXlQt53FHfqX94=
Received: from [10.88.0.186] (dslb-002-207-026-175.002.207.pools.vodafone-ip.de [2.207.26.175])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Thu, 11 Feb 2021 11:15:09 +0100 (CET)
Subject: Re: [PATCH] pinctrl: imx: imx8mm: fix pad offset of SD1_DATA0 pin
To:     Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Cc:     Marek Vasut <marex@denx.de>, stable@vger.kernel.org
References: <20210211095413.1043102-1-ch@denx.de>
From:   Claudius Heine <ch@denx.de>
Organization: Denx Software Engineering
Message-ID: <8c08b85e-fa1e-3dd7-6d86-6ec9b57a3670@denx.de>
Date:   Thu, 11 Feb 2021 11:15:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210211095413.1043102-1-ch@denx.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

can you please add:

Fixes: c1c9d41319c3 ("dt-bindings: imx: Add pinctrl binding doc for imx8mm")

to the commit message.

regards,
Claudius

On 2021-02-11 10:54, Claudius Heine wrote:
> There is a 0 missing in the pad register offset. This patch adds it.
> 
> Signed-off-by: Claudius Heine <ch@denx.de>
> ---
>   arch/arm64/boot/dts/freescale/imx8mm-pinfunc.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/boot/dts/freescale/imx8mm-pinfunc.h b/arch/arm64/boot/dts/freescale/imx8mm-pinfunc.h
> index 5ccc4cc91959d..a003e6af33533 100644
> --- a/arch/arm64/boot/dts/freescale/imx8mm-pinfunc.h
> +++ b/arch/arm64/boot/dts/freescale/imx8mm-pinfunc.h
> @@ -124,7 +124,7 @@
>   #define MX8MM_IOMUXC_SD1_CMD_USDHC1_CMD                                     0x0A4 0x30C 0x000 0x0 0x0
>   #define MX8MM_IOMUXC_SD1_CMD_GPIO2_IO1                                      0x0A4 0x30C 0x000 0x5 0x0
>   #define MX8MM_IOMUXC_SD1_DATA0_USDHC1_DATA0                                 0x0A8 0x310 0x000 0x0 0x0
> -#define MX8MM_IOMUXC_SD1_DATA0_GPIO2_IO2                                    0x0A8 0x31  0x000 0x5 0x0
> +#define MX8MM_IOMUXC_SD1_DATA0_GPIO2_IO2                                    0x0A8 0x310 0x000 0x5 0x0
>   #define MX8MM_IOMUXC_SD1_DATA1_USDHC1_DATA1                                 0x0AC 0x314 0x000 0x0 0x0
>   #define MX8MM_IOMUXC_SD1_DATA1_GPIO2_IO3                                    0x0AC 0x314 0x000 0x5 0x0
>   #define MX8MM_IOMUXC_SD1_DATA2_USDHC1_DATA2                                 0x0B0 0x318 0x000 0x0 0x0
>

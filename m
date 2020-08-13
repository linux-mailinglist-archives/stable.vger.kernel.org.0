Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 840E0243B11
	for <lists+stable@lfdr.de>; Thu, 13 Aug 2020 15:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726499AbgHMN5K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Aug 2020 09:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbgHMN5J (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Aug 2020 09:57:09 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 459FFC061757;
        Thu, 13 Aug 2020 06:57:09 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id 184so5148260wmb.0;
        Thu, 13 Aug 2020 06:57:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZL42NDAwRyqFSgHd9+LPNZsn853QbpqMscEZvhiYWzM=;
        b=DZc9ySxOXmzqhLq8wmbQNIP8qC3GDOlMAZXwH7T9qCDObVYdxITsnlnU7bMMNL0I2v
         8lwS7+qRhmzNhfUwwC0kNFVA8VZtzhOKjDROTB3vtPBcNcTcYjxuoURPglFJn45b2mgn
         dnUGwPgc6LU4AEVPxf/jffEers4VwtF2ItE5gO9UUBy6QeE3kRF9mgP8QaLA6zi5aNj8
         qbn1Q9yNmgEcfilN2hl4qfiHdQKqYejDnn/EhxGdOJL6+bOTWQiKbknzYBcjQnLzS6Vp
         Q1q+E+nufJFqn8GO5egocKKELypeNx1wr8X2QMpEra5OR1Ndc0rUl/zoTuqIXLLdF5fN
         V51g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZL42NDAwRyqFSgHd9+LPNZsn853QbpqMscEZvhiYWzM=;
        b=gSrlB0FcPa1fsKpSv/CD+cuX/ebAK6DdP946YBlkY0WpjxML6rDS3UKFBKhvSsC98R
         cSebHRYpjjFbSNOnakJ54Xl2NUz74ZnHFYEEv4dl/sLHDh4uMP5UyunLAW4V1Fm/zENb
         gd+u/xg2h6pBSdh/dDR2UctDnv415FCAri9k1lKfFmzx/iG8uGYdh3B6GIZMWi+wN87w
         VQQ3NtF1C647zoChBiRuLK3XtbL9gCyzLgoIurS4z2pGTw9THuK9giSYqULXCjvrAHzB
         +dTAJ3G0YYgqNhYfnJC0UZwQ8FzBohS3WlLULSwSgtl8gBbCWHSOxH8PyXBMurKVGvzj
         VO5A==
X-Gm-Message-State: AOAM5335jSLV/EhsHbyoYcdhAMjHA4qU4tT/hcRZUoyG/ELD2xQHY0F6
        lDK9QYrIh6EKRquhFp1mSg2apLn2QRs=
X-Google-Smtp-Source: ABdhPJxZvSJM5CEE+rwyY2plMtVpFbesLgpk5SnfITkTmQSlBIrtVpTBoa601/n+g2520vvERC4vGw==
X-Received: by 2002:a1c:1b93:: with SMTP id b141mr4598606wmb.150.1597327027636;
        Thu, 13 Aug 2020 06:57:07 -0700 (PDT)
Received: from ziggy.stardust ([213.195.117.232])
        by smtp.gmail.com with ESMTPSA id n11sm5016409wmi.15.2020.08.13.06.57.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Aug 2020 06:57:06 -0700 (PDT)
Subject: Re: [RESEND,v4,3/3] mmc: mediatek: add optional module reset property
To:     Wenbin Mei <wenbin.mei@mediatek.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Chaotian Jing <chaotian.jing@mediatek.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        srv_heupstream@mediatek.com, stable@vger.kernel.org
References: <20200813093811.28606-1-wenbin.mei@mediatek.com>
 <20200813093811.28606-4-wenbin.mei@mediatek.com>
From:   Matthias Brugger <matthias.bgg@gmail.com>
Message-ID: <7337a174-169d-2dd1-ed91-f05291d4f3a6@gmail.com>
Date:   Thu, 13 Aug 2020 15:57:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200813093811.28606-4-wenbin.mei@mediatek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 13/08/2020 11:38, Wenbin Mei wrote:
> This patch fixs eMMC-Access on mt7622/Bpi-64.
> Before we got these Errors on mounting eMMC ion R64:
> [   48.664925] blk_update_request: I/O error, dev mmcblk0, sector 204800 op 0x1:(WRITE)
> flags 0x800 phys_seg 1 prio class 0
> [   48.676019] Buffer I/O error on dev mmcblk0p1, logical block 0, lost sync page write
> 
> This patch adds a optional reset management for msdc.
> Sometimes the bootloader does not bring msdc register
> to default state, so need reset the msdc controller.
> 
> Cc: <stable@vger.kernel.org> # v5.4+
> Fixes: 966580ad236e ("mmc: mediatek: add support for MT7622 SoC")
> Signed-off-by: Wenbin Mei <wenbin.mei@mediatek.com>
> Tested-by: Frank Wunderlich <frank-w@public-files.de>

I think you missed to add Philipp Zabels Reviewed-by tag.

Regards,
Matthias


> ---
>   drivers/mmc/host/mtk-sd.c | 13 +++++++++++++
>   1 file changed, 13 insertions(+)
> 
> diff --git a/drivers/mmc/host/mtk-sd.c b/drivers/mmc/host/mtk-sd.c
> index 39e7fc54c438..fc97d5bf3a20 100644
> --- a/drivers/mmc/host/mtk-sd.c
> +++ b/drivers/mmc/host/mtk-sd.c
> @@ -22,6 +22,7 @@
>   #include <linux/slab.h>
>   #include <linux/spinlock.h>
>   #include <linux/interrupt.h>
> +#include <linux/reset.h>
>   
>   #include <linux/mmc/card.h>
>   #include <linux/mmc/core.h>
> @@ -434,6 +435,7 @@ struct msdc_host {
>   	struct msdc_save_para save_para; /* used when gate HCLK */
>   	struct msdc_tune_para def_tune_para; /* default tune setting */
>   	struct msdc_tune_para saved_tune_para; /* tune result of CMD21/CMD19 */
> +	struct reset_control *reset;
>   };
>   
>   static const struct mtk_mmc_compatible mt8135_compat = {
> @@ -1516,6 +1518,12 @@ static void msdc_init_hw(struct msdc_host *host)
>   	u32 val;
>   	u32 tune_reg = host->dev_comp->pad_tune_reg;
>   
> +	if (host->reset) {
> +		reset_control_assert(host->reset);
> +		usleep_range(10, 50);
> +		reset_control_deassert(host->reset);
> +	}
> +
>   	/* Configure to MMC/SD mode, clock free running */
>   	sdr_set_bits(host->base + MSDC_CFG, MSDC_CFG_MODE | MSDC_CFG_CKPDN);
>   
> @@ -2273,6 +2281,11 @@ static int msdc_drv_probe(struct platform_device *pdev)
>   	if (IS_ERR(host->src_clk_cg))
>   		host->src_clk_cg = NULL;
>   
> +	host->reset = devm_reset_control_get_optional_exclusive(&pdev->dev,
> +								"hrst");
> +	if (IS_ERR(host->reset))
> +		return PTR_ERR(host->reset);
> +
>   	host->irq = platform_get_irq(pdev, 0);
>   	if (host->irq < 0) {
>   		ret = -EINVAL;
> 

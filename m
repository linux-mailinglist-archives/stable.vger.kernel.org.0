Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53A11242A48
	for <lists+stable@lfdr.de>; Wed, 12 Aug 2020 15:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728018AbgHLNZr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Aug 2020 09:25:47 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:54297 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728056AbgHLNZq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Aug 2020 09:25:46 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id A6F7E5803D8;
        Wed, 12 Aug 2020 09:25:44 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 12 Aug 2020 09:25:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=ogsRn8UJvYnJnHmnmoJD8EeRCxv
        OuB0FI3xBqc0qcuQ=; b=lIPY4fVS/yyIBCu1HgDe/hcTkqorszv3Knz35oiXGxo
        25RZMhsPABOSsbX5pqdYE7aD/GPKLPdNTxSqyNvdDo9EEEbwRTDiuckF00b9FEXL
        PeLn/goTNMAHalcs/sK07UwI2HAcYuOn1xMso0zGO2ln5TLDAonjPwJeEd6ozHs1
        mdUb3o/rg98N+6CK+/x1+5s5bT81wkZ/tR+oxA7TEezvyHXcUzidJUck18HaX13/
        h/YcciJ92M359yzD5dqDq2t7+Ymn7fzfyx4yFfTH6HTXecZEtydoiDYROW3TOUaI
        qFS/vw7gw248kdqHLwq5oqjRd1dI2BcTFMsFDK0LI7Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ogsRn8
        UJvYnJnHmnmoJD8EeRCxvOuB0FI3xBqc0qcuQ=; b=j6q48OfkZkL6IhRSVkrHag
        3QhD/klT3dNA5dOCQ6K6Dw+8cNat4Zorh/qx+KOQC6dHElclKdVrD+TCLpivJevO
        Obq6M0lG1E37fC814+uhcOWEQb2UyW4/vzUX4t8qT4CjmYRBJUSplSYookVg/WUD
        6yiCdPsUORGpkNjZl773Pf1qSGEunmVf9zIt8LzJUUfTHoYztR/wuttth1VvdFix
        NOFgCfDDfIw4DY9AhTWGDRjlRs7rQhTMZcGkclPmanxYH+BiOg2MicJspeRR26e+
        R9pmxkLrx8SWNtOcuxs/bgMBPuY/PDsYFgY2KFZROy5ddQaPtNN+K55DhKRsrPyw
        ==
X-ME-Sender: <xms:2O0zX5T5Qj95O1-mTPmVA_mMJte538fKlYq_YAkw-8B3nNGF1rNeBg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrledvgdeifecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueelledthe
    ekleethfeludduvdfhffeuvdffudevgeehkeegieffveehgeeftefgnecuffhomhgrihhn
    pehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsth
    gvrhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghh
    rdgtohhm
X-ME-Proxy: <xmx:2O0zXyxYJdCmoSSma5ECQPwlNv1CvWD6_PNcNGK6vxqeJUkh0lcx5g>
    <xmx:2O0zX-1qDpX9rRtegMpKmfcTRHbdD7_oC2X5UB3wbEXZVpmm6IsxPg>
    <xmx:2O0zXxDhk8h2P_vhj0t36IKfEcnaHsbKL-pZhpw7yxGBmY1sosxbnQ>
    <xmx:2O0zX9Nloy36PNgGgACebPlvIfM1zIlboHBNMPEWroLg42gjgO89EA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0A9F0328005D;
        Wed, 12 Aug 2020 09:25:44 -0400 (EDT)
Date:   Wed, 12 Aug 2020 15:25:55 +0200
From:   Greg KH <greg@kroah.com>
To:     Wenbin Mei <wenbin.mei@mediatek.com>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Chaotian Jing <chaotian.jing@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, srv_heupstream@mediatek.com
Subject: Re: [v2,3/3] mmc: mediatek: add optional module reset property
Message-ID: <20200812132555.GD2489711@kroah.com>
References: <20200812130129.13519-1-wenbin.mei@mediatek.com>
 <20200812130129.13519-4-wenbin.mei@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200812130129.13519-4-wenbin.mei@mediatek.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 12, 2020 at 09:01:29PM +0800, Wenbin Mei wrote:
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
> Fixes: 966580ad236e ("mmc: mediatek: add support for MT7622 SoC")
> Signed-off-by: Wenbin Mei <wenbin.mei@mediatek.com>
> Tested-by: Frank Wunderlich <frank-w@public-files.de>
> ---
>  drivers/mmc/host/mtk-sd.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/drivers/mmc/host/mtk-sd.c b/drivers/mmc/host/mtk-sd.c
> index 39e7fc54c438..2b243c03c9b2 100644
> --- a/drivers/mmc/host/mtk-sd.c
> +++ b/drivers/mmc/host/mtk-sd.c
> @@ -22,6 +22,7 @@
>  #include <linux/slab.h>
>  #include <linux/spinlock.h>
>  #include <linux/interrupt.h>
> +#include <linux/reset.h>
>  
>  #include <linux/mmc/card.h>
>  #include <linux/mmc/core.h>
> @@ -434,6 +435,7 @@ struct msdc_host {
>  	struct msdc_save_para save_para; /* used when gate HCLK */
>  	struct msdc_tune_para def_tune_para; /* default tune setting */
>  	struct msdc_tune_para saved_tune_para; /* tune result of CMD21/CMD19 */
> +	struct reset_control *reset;
>  };
>  
>  static const struct mtk_mmc_compatible mt8135_compat = {
> @@ -1516,6 +1518,12 @@ static void msdc_init_hw(struct msdc_host *host)
>  	u32 val;
>  	u32 tune_reg = host->dev_comp->pad_tune_reg;
>  
> +	if (!IS_ERR(host->reset)) {
> +		reset_control_assert(host->reset);
> +		usleep_range(10, 50);
> +		reset_control_deassert(host->reset);
> +	}
> +
>  	/* Configure to MMC/SD mode, clock free running */
>  	sdr_set_bits(host->base + MSDC_CFG, MSDC_CFG_MODE | MSDC_CFG_CKPDN);
>  
> @@ -2273,6 +2281,11 @@ static int msdc_drv_probe(struct platform_device *pdev)
>  	if (IS_ERR(host->src_clk_cg))
>  		host->src_clk_cg = NULL;
>  
> +	host->reset = devm_reset_control_get_optional_exclusive(&pdev->dev,
> +								"hrst");
> +	if (PTR_ERR(host->reset) == -EPROBE_DEFER)
> +		return PTR_ERR(host->reset);
> +
>  	host->irq = platform_get_irq(pdev, 0);
>  	if (host->irq < 0) {
>  		ret = -EINVAL;
> -- 
> 2.18.0

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>

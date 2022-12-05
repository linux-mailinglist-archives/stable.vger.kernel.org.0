Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ACA26427F8
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 13:02:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbiLEMCB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 07:02:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231364AbiLEMB7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 07:01:59 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F41E0E037
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 04:01:57 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id w4-20020a17090ac98400b002186f5d7a4cso14629134pjt.0
        for <stable@vger.kernel.org>; Mon, 05 Dec 2022 04:01:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1ZssqNs7pInPJStfO2e2atX8UAeVUe46DyiwPRJ0RFE=;
        b=gTBYAJ1Ma45a7BHMHwGS1ZHQV1LzleQ4PEZfCy/Ms1jqJq/R7XCBojvZSjVwDytGBl
         tN14rL/HENx9Q5LlPX4WuMwJJWzclkPHBO9+LZKJTz/HIKA4jprkU1CfYiI1uAJTkXd7
         bAgZYDgbFWJKn4v/rY41b572E1K6UC569OXTBdMo7U+3FZQDQEdsTjILrOy+rVYjyOs/
         YCycs2rfLeKfHd6aBIwTaX0NPMV979GVAoutZb5kZ50M/ShuegX+x0jDvwsyTBcUTBRO
         ODLrgTt2ljReb36H/LfPWCcaIYRTLWo+a1qfjZdYigWKef8l/KWzX9x0AUIGEgfzvD5G
         OIuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1ZssqNs7pInPJStfO2e2atX8UAeVUe46DyiwPRJ0RFE=;
        b=77/oJlsF+FdFH/gxKJPPjPUjFIqXuMovI5EwVkALhR6wWBr8/V0Jng1aTHlIBUB3fh
         qSNvMZ+kvC7FfX46T3Y9qk0akesdS7F3LyvL1krIsFTp7zsjHrSPB9StANQxLcGPTAy3
         5vhdmemg5e6A5782oI0NkceuWaQBCP2wr8WsarFk/W3SiDfA7tIS1teW9fdvOkUn3WES
         bppBOLRZke8RnLmgRQyMfyjvnxMWlsu+yqQmtra1pDHs4QEOQDXfi7BTE4d/ok0deFy7
         VrSvLQNMs9RyZ95VGENzx5UN6B00cvQV6ZeU12sHfPpodlzGVxF0M9KqzAYh7r+D9ZCd
         uaRg==
X-Gm-Message-State: ANoB5plI5ZGw2t833ClsZdz2mTAyVfrxkdGtQ7kaDBFby8dqEj6lR0a2
        zxLvv6VYjeuMn2umq04RoBdp
X-Google-Smtp-Source: AA0mqf4DBEnBQ8pyT7ohyPkzU+t1mQ/uJBWCKhtQbdoYDM2WCK+EWk0MTEIdyx8km5XU4ssgP5EsjQ==
X-Received: by 2002:a17:902:d0c9:b0:189:9cfd:be76 with SMTP id n9-20020a170902d0c900b001899cfdbe76mr30410742pln.21.1670241717355;
        Mon, 05 Dec 2022 04:01:57 -0800 (PST)
Received: from thinkpad ([59.92.98.136])
        by smtp.gmail.com with ESMTPSA id p8-20020aa79e88000000b005743b5ebd7csm3318672pfq.92.2022.12.05.04.01.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 04:01:55 -0800 (PST)
Date:   Mon, 5 Dec 2022 17:31:48 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Johan Hovold <johan+linaro@kernel.org>
Cc:     Bjorn Andersson <andersson@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Andy Gross <agross@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/2] arm64: dts: qcom: sc8280xp: fix UFS DMA coherency
Message-ID: <20221205120148.GB20192@thinkpad>
References: <20221205100837.29212-1-johan+linaro@kernel.org>
 <20221205100837.29212-3-johan+linaro@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221205100837.29212-3-johan+linaro@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 05, 2022 at 11:08:37AM +0100, Johan Hovold wrote:
> The SC8280XP UFS controllers are cache coherent and must be marked as
> such in the devicetree to avoid potential data corruption.
> 
> Fixes: 152d1faf1e2f ("arm64: dts: qcom: add SC8280XP platform")
> Cc: stable@vger.kernel.org      # 6.0
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

Thanks,
Mani

> ---
>  arch/arm64/boot/dts/qcom/sc8280xp.dtsi | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
> index c4947c563099..23d1f51527aa 100644
> --- a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
> @@ -1430,6 +1430,7 @@ ufs_mem_hc: ufs@1d84000 {
>  			required-opps = <&rpmhpd_opp_nom>;
>  
>  			iommus = <&apps_smmu 0xe0 0x0>;
> +			dma-coherent;
>  
>  			clocks = <&gcc GCC_UFS_PHY_AXI_CLK>,
>  				 <&gcc GCC_AGGRE_UFS_PHY_AXI_CLK>,
> @@ -1491,6 +1492,7 @@ ufs_card_hc: ufs@1da4000 {
>  			power-domains = <&gcc UFS_CARD_GDSC>;
>  
>  			iommus = <&apps_smmu 0x4a0 0x0>;
> +			dma-coherent;
>  
>  			clocks = <&gcc GCC_UFS_CARD_AXI_CLK>,
>  				 <&gcc GCC_AGGRE_UFS_CARD_AXI_CLK>,
> -- 
> 2.37.4
> 

-- 
மணிவண்ணன் சதாசிவம்

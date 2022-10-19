Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD73605268
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 23:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbiJSV7u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 17:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiJSV7s (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 17:59:48 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6476580E83;
        Wed, 19 Oct 2022 14:59:46 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id 8so11687611qka.1;
        Wed, 19 Oct 2022 14:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S9HkPFgZD/C2W2q2J74fWT1vMIg6k3iAnDkNlkeaCaI=;
        b=d0/Jg79vTpn0Od8mLqQ1vDbdKv5Uq65BUw4uyVcnj01ko3ChA7seFgaLFijzP2eAYS
         vvYlvSMlFs3sC210alNTmYCU2y9CrATSQmsW6i04t9Z4J1hxfECsEQJdAQBR2DOA80Hx
         BeeZiK0ciO5lyIBBxkB4vKxdBwhyYpvE6nfcpwkZyeaRH9EGsZpk4WbzhYV29QB7ZlOL
         2POFDDz+blYRx4V5kqshhg2Cx3hFgDxx7j1UDYAFFFPLVJfrKFxKtGMKIyHDnCP7JnUg
         OHX+iwQtx8qFiyvjK9VdlFJoKmGLMKWlqtl38/i3JDXuBA7LU187DGLaXWAkl1HxRbEN
         ulcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S9HkPFgZD/C2W2q2J74fWT1vMIg6k3iAnDkNlkeaCaI=;
        b=jqU0N/32Vk0/VbIPJgGEN/ybAEmCLsQ1+SntV1sGIko5EhIxAUUjw//6pzsiQGm9s3
         176CcE2HVfQp+MIGyvxUb8N4Sht88t4RzrKmNeJWEIzRle8HaxIOSOGrS4fP0iR/gH5G
         MMTS0hVBF8szVqxMXEKed4ZvQhE8gH+h/Tw5xccz9ikrXl+D0LbPNbyKv/uHZYPobcgJ
         sA6ofn8aN+fBLIET9pM7FndkbqFlD4YQ281SZOziTeoDlV598kW2CvYPR3RkS7SWxOZj
         rPKYTivM4w2u8Kg8inrV7ZGq0x0TVq1jIqetCm+FHCYRHXqgU+C/suO7KiaoDFM4WRCt
         n9kw==
X-Gm-Message-State: ACrzQf00uqPFEYRITfMvnQnXjH2ZXA+IXpAF4e8aGkLJzoRayM7WBrcY
        H2mwvz22Q9TVj130ZsMU7gq/ZtQ8KhUqjA==
X-Google-Smtp-Source: AMsMyM4jByfHrPBUyeIqq0Qdns+pbJVRQWlZYTS7DpZ3AEO71aKNRFhor87zBQBcuFuYvQdFACRdvA==
X-Received: by 2002:a37:4454:0:b0:6e7:9bd0:bf53 with SMTP id r81-20020a374454000000b006e79bd0bf53mr7260058qka.616.1666216785297;
        Wed, 19 Oct 2022 14:59:45 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id t14-20020a05620a450e00b006ce580c2663sm5896681qkp.35.2022.10.19.14.59.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Oct 2022 14:59:44 -0700 (PDT)
Message-ID: <14efb3e6-96cf-f42e-16aa-c45001ec632e@gmail.com>
Date:   Wed, 19 Oct 2022 14:59:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v2 2/7] mmc: sdhci-of-arasan: Fix SDHCI_RESET_ALL for
 CQHCI
Content-Language: en-US
To:     Brian Norris <briannorris@chromium.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Shawn Lin <shawn.lin@rock-chips.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        Haibo Chen <haibo.chen@nxp.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Faiz Abbas <faiz_abbas@ti.com>, linux-mmc@vger.kernel.org,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Al Cooper <alcooperx@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, stable@vger.kernel.org
References: <20221019215440.277643-1-briannorris@chromium.org>
 <20221019145246.v2.2.I29f6a2189e84e35ad89c1833793dca9e36c64297@changeid>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221019145246.v2.2.I29f6a2189e84e35ad89c1833793dca9e36c64297@changeid>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/19/22 14:54, Brian Norris wrote:
> SDHCI_RESET_ALL resets will reset the hardware CQE state, but we aren't
> tracking that properly in software. When out of sync, we may trigger
> various timeouts.
> 
> It's not typical to perform resets while CQE is enabled, but one
> particular case I hit commonly enough: mmc_suspend() -> mmc_power_off().
> Typically we will eventually deactivate CQE (cqhci_suspend() ->
> cqhci_deactivate()), but that's not guaranteed -- in particular, if
> we perform a partial (e.g., interrupted) system suspend.
> 
> The same bug was already found and fixed for two other drivers, in v5.7
> and v5.9:
> 
> 5cf583f1fb9c mmc: sdhci-msm: Deactivate CQE during SDHC reset
> df57d73276b8 mmc: sdhci-pci: Fix SDHCI_RESET_ALL for CQHCI for Intel GLK-based controllers
> 
> The latter is especially prescient, saying "other drivers using CQHCI
> might benefit from a similar change, if they also have CQHCI reset by
> SDHCI_RESET_ALL."
> 
> So like these other patches, deactivate CQHCI when resetting the
> controller.
> 
> Fixes: 84362d79f436 ("mmc: sdhci-of-arasan: Add CQHCI support for arasan,sdhci-5.1")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> ---
> 
> Changes in v2:
>   - Rely on cqhci_deactivate() to safely handle (ignore)
>     not-yet-initialized CQE support
> 
>   drivers/mmc/host/sdhci-of-arasan.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/mmc/host/sdhci-of-arasan.c b/drivers/mmc/host/sdhci-of-arasan.c
> index 3997cad1f793..b30f0d6baf5b 100644
> --- a/drivers/mmc/host/sdhci-of-arasan.c
> +++ b/drivers/mmc/host/sdhci-of-arasan.c
> @@ -366,6 +366,9 @@ static void sdhci_arasan_reset(struct sdhci_host *host, u8 mask)
>   	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
>   	struct sdhci_arasan_data *sdhci_arasan = sdhci_pltfm_priv(pltfm_host);
>   
> +	if ((host->mmc->caps2 & MMC_CAP2_CQE) && (mask & SDHCI_RESET_ALL))
> +		cqhci_deactivate(host->mmc);
> +
>   	sdhci_reset(host, mask);

Cannot this be absorbed by sdhci_reset() that all of these drivers 
appear to be utilizing since you have access to the host and the mask to 
make that decision?
-- 
Florian


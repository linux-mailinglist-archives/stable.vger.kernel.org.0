Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99D854BBA11
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 14:24:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233039AbiBRNZG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 08:25:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbiBRNZF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 08:25:05 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2EB8284211
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 05:24:48 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id i14so14559639wrc.10
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 05:24:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ujmj8PwbJSvu47uw+CyCbxAA/eAxR/7pr/uKWTwQSVI=;
        b=d/5iEdmNQi1OPG/+LIV6gWpQUkUjCSHGIgH1D0FcX7ZyEgs8jS7MoQa4IJgJ2B6eqL
         FM4kzf/QUxUrCwUX2eIFNVmfzlNT63GrIWDj9FwpDaARAILH0RZ1/01qjCG0zSPh3dMJ
         HwvWOd6S8DF2OOneBoSwvAs0UzTJqknCOwwyfC3Om1DfojnRR+YPwbLY4hRuChuD+GNI
         TFnxA8s6wH7tGfns7Ivf21N8LvzoaL1LzjpjnDvBoGnfvN4KW+wm2FHcmLsKNwNcGnrB
         rOOOIDwBR598nXeua7jBinj0xTnuNLzO/uTX1BAaIh+fIw844Mqko7SZF1pi/5Zii1xs
         S8LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ujmj8PwbJSvu47uw+CyCbxAA/eAxR/7pr/uKWTwQSVI=;
        b=2HuWEYrAzdpS8dn4b4iiRAQosDMslzRN8qYxGp4mdRyOB/PP9gilY6cK80Ym9IWs4V
         ZGPREMcTBt6t0p0c/M8HzqLN3tMjFP05jB1l1q7fTvE2yXJ2hZ0UqNrLnHucxFVRObZP
         5EDfTSqb2fD/25ZzO1+xfDK8bZTcyN+QL0d/uB0ZDJs/tVPevIMMQ2InhUYX8+3v/RJ7
         I1VCkiTSVnv2kbYIrKyBz8ET0NME6dS8mLoC5r1sL5P4LWyFCzCs3qpn3U7AYzrEjHbb
         DUZwZjV/OxrPDUhwd8s2FncxH5xPv1KOqPJBtRfw3mFOXi5L3sH7eQsx66eF6As8W36B
         m66Q==
X-Gm-Message-State: AOAM531rCUPVtNq5IlxAPKHq+L/DdsTEi6S/zB6X1hjnVTwmeDMQVf+f
        saqvYiXmeBgsH1YkjY1wJY2udg==
X-Google-Smtp-Source: ABdhPJy2nDo7yTxFYdHgagsn3pqhYbisII2MeTUOZhN6jb5RjapXtp3DM5vozRRBVGB3r4CtEsesrg==
X-Received: by 2002:a05:6000:1e04:b0:1e4:9b64:8cab with SMTP id bj4-20020a0560001e0400b001e49b648cabmr6038845wrb.608.1645190687489;
        Fri, 18 Feb 2022 05:24:47 -0800 (PST)
Received: from [192.168.86.34] (cpc90716-aztw32-2-0-cust825.18-1.cable.virginm.net. [86.26.103.58])
        by smtp.googlemail.com with ESMTPSA id x18sm41464215wrw.17.2022.02.18.05.24.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Feb 2022 05:24:46 -0800 (PST)
Message-ID: <6f3ff8f3-82fb-1bb1-d854-bb48f1ea9b1d@linaro.org>
Date:   Fri, 18 Feb 2022 13:24:45 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 3/4] nvmem: core: Fix a conflict between MTD and NVMEM
 on wp-gpios property
Content-Language: en-US
To:     Christophe Kerello <christophe.kerello@foss.st.com>,
        miquel.raynal@bootlin.com, richard@nod.at, vigneshr@ti.com,
        robh+dt@kernel.org, p.yadav@ti.com
Cc:     linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        devicetree@vger.kernel.org, chenshumin86@sina.com,
        stable@vger.kernel.org
References: <20220217144755.270679-1-christophe.kerello@foss.st.com>
 <20220217144755.270679-4-christophe.kerello@foss.st.com>
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
In-Reply-To: <20220217144755.270679-4-christophe.kerello@foss.st.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 17/02/2022 14:47, Christophe Kerello wrote:
> Wp-gpios property can be used on NVMEM nodes and the same property can
> be also used on MTD NAND nodes. In case of the wp-gpios property is
> defined at NAND level node, the GPIO management is done at NAND driver
> level. Write protect is disabled when the driver is probed or resumed
> and is enabled when the driver is released or suspended.
> 
> When no partitions are defined in the NAND DT node, then the NAND DT node
> will be passed to NVMEM framework. If wp-gpios property is defined in
> this node, the GPIO resource is taken twice and the NAND controller
> driver fails to probe.
> 
> It would be possible to set config->wp_gpio at MTD level before calling
> nvmem_register function but NVMEM framework will toggle this GPIO on
> each write when this GPIO should only be controlled at NAND level driver
> to ensure that the Write Protect has not been enabled.
> 
> A way to fix this conflict is to add a new boolean flag in nvmem_config
> named ignore_wp. In case ignore_wp is set, the GPIO resource will
> be managed by the provider.
> 
> Fixes: 2a127da461a9 ("nvmem: add support for the write-protect pin")
> Signed-off-by: Christophe Kerello <christophe.kerello@foss.st.com>
> Cc: stable@vger.kernel.org
> ---
> Changes in v3:
>   - add a fixes tag.
>   - rename skip_wp_gpio by ignore_wp in nvmen_config.

Applied thanks,

--srini
> 
> Changes in v2:
>   - rework the proposal done to fix a conflict between MTD and NVMEM on
>     wp-gpios property.
> 
>   drivers/nvmem/core.c           | 2 +-
>   include/linux/nvmem-provider.h | 4 +++-
>   2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
> index 23a38dcf0fc4..9fd1602b539d 100644
> --- a/drivers/nvmem/core.c
> +++ b/drivers/nvmem/core.c
> @@ -771,7 +771,7 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
>   
>   	if (config->wp_gpio)
>   		nvmem->wp_gpio = config->wp_gpio;
> -	else
> +	else if (!config->ignore_wp)
>   		nvmem->wp_gpio = gpiod_get_optional(config->dev, "wp",
>   						    GPIOD_OUT_HIGH);
>   	if (IS_ERR(nvmem->wp_gpio)) {
> diff --git a/include/linux/nvmem-provider.h b/include/linux/nvmem-provider.h
> index 98efb7b5660d..c9a3ac9efeaa 100644
> --- a/include/linux/nvmem-provider.h
> +++ b/include/linux/nvmem-provider.h
> @@ -70,7 +70,8 @@ struct nvmem_keepout {
>    * @word_size:	Minimum read/write access granularity.
>    * @stride:	Minimum read/write access stride.
>    * @priv:	User context passed to read/write callbacks.
> - * @wp-gpio:   Write protect pin
> + * @wp-gpio:	Write protect pin
> + * @ignore_wp:  Write Protect pin is managed by the provider.
>    *
>    * Note: A default "nvmem<id>" name will be assigned to the device if
>    * no name is specified in its configuration. In such case "<id>" is
> @@ -92,6 +93,7 @@ struct nvmem_config {
>   	enum nvmem_type		type;
>   	bool			read_only;
>   	bool			root_only;
> +	bool			ignore_wp;
>   	struct device_node	*of_node;
>   	bool			no_of_node;
>   	nvmem_reg_read_t	reg_read;

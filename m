Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 083A74BBA16
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 14:25:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235769AbiBRNZW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 08:25:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235764AbiBRNZV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 08:25:21 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 294D1284220
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 05:25:04 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id m126-20020a1ca384000000b0037bb8e379feso8623724wme.5
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 05:25:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=yrkYgpVIUXGnXP2wkyWmIbd2RYDJqfqs2Rsp+OtCt5o=;
        b=uAAaFw6RHpsnW5DW+gQVrVkaLEzP2Xzhuy4W0EJdVj+v9QPUI1dBLADu063fihlOEu
         SMmDL+vn0fseuUyOwz4U6ojcjnvO2AmogeBd02BQNAwHSuD2pcrlE/kh8xiGBAW74gk0
         VLtxRzwtsIGpUyxapMkGGRS/4St+WSxs5Ah+5sMiXD+P009Tfy8QTxz2pi2Qkhqe+hxF
         hv6LJMEvU1UKM3Gp4pilsMA012MvSbmPZjV8RfRX3qiQ03dZkCCo0OPtymcMqivDiXaK
         6WxgiHHGOQyo+j/OrC3DkLrUyDsYAju7NmHIHfHQEd1nUXxkf4Wm83SB5/0gRlrqW/3l
         OVCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=yrkYgpVIUXGnXP2wkyWmIbd2RYDJqfqs2Rsp+OtCt5o=;
        b=ChwlXv3rcL2Om8vKBLKjpTYfFeT9XQ/6gZmA2ZjYTRcxmFD1+UwoivzivYV3ycQeuG
         z23qa4xILSXLHgY41SaxJNXaHogEWLnd7Qte3NW+OeCZJcaDSFg+Zt4d+tJ4Ufs1bTV7
         I9dpSStptkuEYCnwoGn7WZ8EyMbbN7vMub/mPxKBf9RwjloefYvOJyzEl9lJ+ir/lq10
         goYsS4sZ8bt0ijktQ2s5zYKBibH051LkqNttPqCihtfb5rEteYVSvADfZcrBNaxraWR3
         M63DoSw/NS+eGo0BdIEpSPAHkT7Jgp/sUeJDWNwAd3uTkq0yAjvf59pghwy1a1wpQmWx
         NFTQ==
X-Gm-Message-State: AOAM531DqRKa7g0ZHtmLgk9QjlHI/YH+9WnhyqFbaPUz2xK7INRqei8q
        ItCBg7Wsht+ct/v5X4kcQF+tkg==
X-Google-Smtp-Source: ABdhPJyVAYzbgy/AAZpsXhPLMR1fBjvqb4Dg1MygToTm7RwGLTNkBP3nvxFtcdd/zIFp23yEwgJAXg==
X-Received: by 2002:a05:600c:19ce:b0:37c:6fe:68b6 with SMTP id u14-20020a05600c19ce00b0037c06fe68b6mr10451900wmq.90.1645190702754;
        Fri, 18 Feb 2022 05:25:02 -0800 (PST)
Received: from [192.168.86.34] (cpc90716-aztw32-2-0-cust825.18-1.cable.virginm.net. [86.26.103.58])
        by smtp.googlemail.com with ESMTPSA id r2sm6039032wmq.24.2022.02.18.05.25.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Feb 2022 05:25:02 -0800 (PST)
Message-ID: <e451d814-2d10-6cb6-3402-6d1580ddbce2@linaro.org>
Date:   Fri, 18 Feb 2022 13:25:00 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 4/4] mtd: core: Fix a conflict between MTD and NVMEM on
 wp-gpios property
Content-Language: en-US
To:     Christophe Kerello <christophe.kerello@foss.st.com>,
        miquel.raynal@bootlin.com, richard@nod.at, vigneshr@ti.com,
        robh+dt@kernel.org, p.yadav@ti.com
Cc:     linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        devicetree@vger.kernel.org, chenshumin86@sina.com,
        stable@vger.kernel.org
References: <20220217144755.270679-1-christophe.kerello@foss.st.com>
 <20220217144755.270679-5-christophe.kerello@foss.st.com>
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
In-Reply-To: <20220217144755.270679-5-christophe.kerello@foss.st.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
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
> A new Boolean flag named ignore_wp has been added in nvmem_config.
> In case ignore_wp is set, it means that the GPIO is handled by the
> provider. Lets set this flag in MTD layer to avoid the conflict on
> wp_gpios property.
> 
> Fixes: 2a127da461a9 ("nvmem: add support for the write-protect pin")
> Signed-off-by: Christophe Kerello <christophe.kerello@foss.st.com>
> Cc: stable@vger.kernel.org


Applied thanks,

--srini

> ---
> Changes in v3:
>   - add a fixes tag
>   - rename skip_wp_gpio by ignore_wp in nvmen_config.
> 
>   drivers/mtd/mtdcore.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
> index 70f492dce158..eef87b28d6c8 100644
> --- a/drivers/mtd/mtdcore.c
> +++ b/drivers/mtd/mtdcore.c
> @@ -546,6 +546,7 @@ static int mtd_nvmem_add(struct mtd_info *mtd)
>   	config.stride = 1;
>   	config.read_only = true;
>   	config.root_only = true;
> +	config.ignore_wp = true;
>   	config.no_of_node = !of_device_is_compatible(node, "nvmem-cells");
>   	config.priv = mtd;
>   
> @@ -833,6 +834,7 @@ static struct nvmem_device *mtd_otp_nvmem_register(struct mtd_info *mtd,
>   	config.owner = THIS_MODULE;
>   	config.type = NVMEM_TYPE_OTP;
>   	config.root_only = true;
> +	config.ignore_wp = true;
>   	config.reg_read = reg_read;
>   	config.size = size;
>   	config.of_node = np;

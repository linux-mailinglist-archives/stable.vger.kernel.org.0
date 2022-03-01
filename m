Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EBF94C917F
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 18:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236259AbiCAR3K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 12:29:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234411AbiCAR3J (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 12:29:09 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DA14BF6D
        for <stable@vger.kernel.org>; Tue,  1 Mar 2022 09:28:27 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id y5so7931839wmi.0
        for <stable@vger.kernel.org>; Tue, 01 Mar 2022 09:28:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Y86hBfPWj9E4aTo+XMBrAu6Y5p4SQMawkPD4Q/SuKPY=;
        b=ifR445Ptk0kZIwyK/iR5LauUeexT4h+Xm5fWIS9UfHsJTwIXI+TBUH0b1B1nklV58Q
         e3posB9tDmWAuXNqOByYa8OEIeuEgFpyIkDoWKkxe1RAiCnFE6ZEzQVCpMvS62fGzNFV
         nWcw5JV2lmoD9jxvmDMFuNVsgy/NwYWUQ6a0I1zB2e5jSr3/JFEIp9xW/NRIDhtT+/y6
         uvAB7/5ZICC2qcmaHb2EAlpVYU+L8My5syB7aELi6iajmzjea09g2vNncJq3GY6hv/nP
         g2d17hu4ZYUIRYCXpyuRUhAY/Kr9r3k7MyrtDEVfLOZZZFWPJ239r6w7DpTzLNolCHHw
         A62A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Y86hBfPWj9E4aTo+XMBrAu6Y5p4SQMawkPD4Q/SuKPY=;
        b=zqpRKSR68jGC2BeqoaUgAhYO2AdwxxJdzYkFU5AcolP8S7wPXwpOWtbTQHE02nyVGL
         AxmOl4fBSu2fFa8Zs4dZSmU0uFcHunRmiPJqByOpMTr3swO/9JBU4Blxk7dNSvr4HHgk
         pE5Tjf5N8t1mTZrJ7FA1m440GKsfGUql2Yc/ZObWZtuWse6196lQ88UHFyqHhNaAfo4Z
         DjJN+FJ9tOOkJ8oQ1XDv5gnSVncKbm/OIsPNR1N2WFgOZgjnenz0JsS0ehj50kHq34H3
         UDKCeBr68hUIGECXYa83JZUZgmm//GraUX3WN/paqWpZ5USCKK133H3iLw+Y+IAy9kOP
         7IAw==
X-Gm-Message-State: AOAM530i2/cWPsl631L7eGoytNPhXw4jImH7tPl1kKMgBjmPqNnAseWc
        CtflCTepZaQWxWQrXvwTZs4Kkg==
X-Google-Smtp-Source: ABdhPJyP4zzjkBPeDrhk1IU4HHA4Z4mVRSeyWw7DiZ4BmjKx+FbF6/CkwhxttMvqrC0XO+mqNoqKvQ==
X-Received: by 2002:a05:600c:a4b:b0:37b:ea2b:5583 with SMTP id c11-20020a05600c0a4b00b0037bea2b5583mr18173339wmq.139.1646155705687;
        Tue, 01 Mar 2022 09:28:25 -0800 (PST)
Received: from [192.168.86.34] (cpc90716-aztw32-2-0-cust825.18-1.cable.virginm.net. [86.26.103.58])
        by smtp.googlemail.com with ESMTPSA id c4-20020adfed84000000b001e5b8d5b8dasm20457807wro.36.2022.03.01.09.28.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Mar 2022 09:28:24 -0800 (PST)
Message-ID: <5f481315-021c-39d6-8c6c-91918851ab13@linaro.org>
Date:   Tue, 1 Mar 2022 17:28:22 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 10/11] slimbus: qcom-ngd: Fix kfree() of static memory
 on setting driver_override
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Abel Vesa <abel.vesa@nxp.com>, Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Andy Gross <agross@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        linux-clk@vger.kernel.org, NXP Linux Team <linux-imx@nxp.com>,
        linux-arm-kernel@lists.infradead.org, linux-hyperv@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-spi@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Rasmus Villemoes <linux@rasmusvillemoes.dk>, stable@vger.kernel.org
References: <20220227135214.145599-1-krzysztof.kozlowski@canonical.com>
 <20220227135329.145862-4-krzysztof.kozlowski@canonical.com>
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
In-Reply-To: <20220227135329.145862-4-krzysztof.kozlowski@canonical.com>
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



On 27/02/2022 13:53, Krzysztof Kozlowski wrote:
> The driver_override field from platform driver should not be initialized
> from static memory (string literal) because the core later kfree() it,
> for example when driver_override is set via sysfs.
> 
> Use dedicated helper to set driver_override properly.
> 
> Fixes: 917809e2280b ("slimbus: ngd: Add qcom SLIMBus NGD driver")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

LGTM,

Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

> ---
>   drivers/slimbus/qcom-ngd-ctrl.c | 13 ++++++++++++-
>   1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/slimbus/qcom-ngd-ctrl.c b/drivers/slimbus/qcom-ngd-ctrl.c
> index 7040293c2ee8..e5d9fdb81eb0 100644
> --- a/drivers/slimbus/qcom-ngd-ctrl.c
> +++ b/drivers/slimbus/qcom-ngd-ctrl.c
> @@ -1434,6 +1434,7 @@ static int of_qcom_slim_ngd_register(struct device *parent,
>   	const struct of_device_id *match;
>   	struct device_node *node;
>   	u32 id;
> +	int ret;
>   
>   	match = of_match_node(qcom_slim_ngd_dt_match, parent->of_node);
>   	data = match->data;
> @@ -1455,7 +1456,17 @@ static int of_qcom_slim_ngd_register(struct device *parent,
>   		}
>   		ngd->id = id;
>   		ngd->pdev->dev.parent = parent;
> -		ngd->pdev->driver_override = QCOM_SLIM_NGD_DRV_NAME;
> +
> +		ret = driver_set_override(&ngd->pdev->dev,
> +					  &ngd->pdev->driver_override,
> +					  QCOM_SLIM_NGD_DRV_NAME,
> +					  strlen(QCOM_SLIM_NGD_DRV_NAME));
> +		if (ret) {
> +			platform_device_put(ngd->pdev);
> +			kfree(ngd);
> +			of_node_put(node);
> +			return ret;
> +		}
>   		ngd->pdev->dev.of_node = node;
>   		ctrl->ngd = ngd;
>   

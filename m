Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38D71688D80
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 03:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232053AbjBCCz3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 21:55:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231903AbjBCCz2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 21:55:28 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D4E3EFC0
        for <stable@vger.kernel.org>; Thu,  2 Feb 2023 18:55:25 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id bk15so11696276ejb.9
        for <stable@vger.kernel.org>; Thu, 02 Feb 2023 18:55:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+8fV2+ZPkANwP3GYe/Ty74BkbitDSVqkcbED+KFF8RI=;
        b=SuOYKs/V4dup+nwSgj1aKqbo/id0uNiEV+J1Dq4sj0MocvwJ7rRoeGdjo+W51dDxrC
         Mql3M3KmxEDh+nF+JnqGkAYHaM6Fo7W6TUnad9uX31PoVpjbdtbc5fIo0ohNY0O9e4hC
         RnH4xyMDVujxrjQL/B3GYkw5+8HuETsjuCKXzkbcW/wuKmMDEp04F3Z4nI1Vd9PIh7bI
         MorDwIOvCN8hbyUZrf6MOXXhv0T8LP7FYpLDS5e6+Mdc65nGz7dZNOcv4c6aOup4wz5O
         ctm/3v+UIsdZ96lFldhyhRb+nbv/1YtxrTUonb9s8V3/wT09uFUjpI8kcT+JbV3UP311
         xNPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+8fV2+ZPkANwP3GYe/Ty74BkbitDSVqkcbED+KFF8RI=;
        b=IIP2ABjmhcxm6cK4rRr82KYQKf0PPP3hC3hbcU7Q4s4eoa4OpFWu8NoWE5vR6mZRjG
         fJFUOjwqHupoEIOXLP3w6YFVnfE48pqyBan37UMfXeUke+Oa95rSW1w4E3wSKI7NCsJ5
         1jExPOTDHVTS86bQzPbIN3sQ/Erj2AD1jSLXe7vuLPKl7qmaKvqW5qB4x+hnAxpR691h
         /qkP2EESG3vUqN18daRVeDPW24cDzy9o8jDz1WhktdwRWu97ln2eBBh+bv9c+d3ghMYA
         ErmhriG/sMwKhmdujOaHTa0TNiBWIyD5djZr1XNl5Igs7wAZWnEG3X2Y2zABtC76sfBO
         9IDQ==
X-Gm-Message-State: AO0yUKW139P4vejudFyJa2jgoYbwc/dM2Fr8TZE1SDmgce9pWRWqqTVQ
        DDbkMKjFMZAxIJWlVmQLy2XejQ==
X-Google-Smtp-Source: AK7set+zJtS9I4La2y0p/l/DLAEW/qAm+KmlcWUJ6l6jjpa9fxDitxVITWoaaIQYBQGwVlnWftYw/w==
X-Received: by 2002:a17:906:c089:b0:88f:895f:1ba4 with SMTP id f9-20020a170906c08900b0088f895f1ba4mr3226041ejz.57.1675392923840;
        Thu, 02 Feb 2023 18:55:23 -0800 (PST)
Received: from [192.168.1.101] (abyl20.neoplus.adsl.tpnet.pl. [83.9.31.20])
        by smtp.gmail.com with ESMTPSA id gw16-20020a170906f15000b0088e5f3e1faesm675364ejb.36.2023.02.02.18.55.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Feb 2023 18:55:23 -0800 (PST)
Message-ID: <26f87cbe-58f8-e74a-3dd3-2f27cb092791@linaro.org>
Date:   Fri, 3 Feb 2023 03:55:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: [PATCH 10/23] interconnect: qcom: rpmh: fix registration race
Content-Language: en-US
To:     Johan Hovold <johan+linaro@kernel.org>,
        Georgi Djakov <djakov@kernel.org>
Cc:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        =?UTF-8?B?QXJ0dXIgxZp3aWdvxYQ=?= <a.swigon@samsung.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20230201101559.15529-1-johan+linaro@kernel.org>
 <20230201101559.15529-11-johan+linaro@kernel.org>
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <20230201101559.15529-11-johan+linaro@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 1.02.2023 11:15, Johan Hovold wrote:
> The current interconnect provider registration interface is inherently
> racy as nodes are not added until the after adding the provider. This
> can specifically cause racing DT lookups to fail.
> 
> Switch to using the new API where the provider is not registered until
> after it has been fully initialised.
> 
> Fixes: 976daac4a1c5 ("interconnect: qcom: Consolidate interconnect RPMh support")
> Cc: stable@vger.kernel.org      # 5.7
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> ---
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>

Konrad
>  drivers/interconnect/qcom/icc-rpmh.c | 25 +++++++++++++++----------
>  1 file changed, 15 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/interconnect/qcom/icc-rpmh.c b/drivers/interconnect/qcom/icc-rpmh.c
> index 5168bbf3d92f..fdb5e58e408b 100644
> --- a/drivers/interconnect/qcom/icc-rpmh.c
> +++ b/drivers/interconnect/qcom/icc-rpmh.c
> @@ -192,9 +192,10 @@ int qcom_icc_rpmh_probe(struct platform_device *pdev)
>  	provider->pre_aggregate = qcom_icc_pre_aggregate;
>  	provider->aggregate = qcom_icc_aggregate;
>  	provider->xlate_extended = qcom_icc_xlate_extended;
> -	INIT_LIST_HEAD(&provider->nodes);
>  	provider->data = data;
>  
> +	icc_provider_init(provider);
> +
>  	qp->dev = dev;
>  	qp->bcms = desc->bcms;
>  	qp->num_bcms = desc->num_bcms;
> @@ -203,10 +204,6 @@ int qcom_icc_rpmh_probe(struct platform_device *pdev)
>  	if (IS_ERR(qp->voter))
>  		return PTR_ERR(qp->voter);
>  
> -	ret = icc_provider_add(provider);
> -	if (ret)
> -		return ret;
> -
>  	for (i = 0; i < qp->num_bcms; i++)
>  		qcom_icc_bcm_init(qp->bcms[i], dev);
>  
> @@ -218,7 +215,7 @@ int qcom_icc_rpmh_probe(struct platform_device *pdev)
>  		node = icc_node_create(qn->id);
>  		if (IS_ERR(node)) {
>  			ret = PTR_ERR(node);
> -			goto err;
> +			goto err_remove_nodes;
>  		}
>  
>  		node->name = qn->name;
> @@ -232,19 +229,27 @@ int qcom_icc_rpmh_probe(struct platform_device *pdev)
>  	}
>  
>  	data->num_nodes = num_nodes;
> +
> +	ret = icc_provider_register(provider);
> +	if (ret)
> +		goto err_remove_nodes;
> +
>  	platform_set_drvdata(pdev, qp);
>  
>  	/* Populate child NoC devices if any */
>  	if (of_get_child_count(dev->of_node) > 0) {
>  		ret = of_platform_populate(dev->of_node, NULL, NULL, dev);
>  		if (ret)
> -			goto err;
> +			goto err_deregister_provider;
>  	}
>  
>  	return 0;
> -err:
> +
> +err_deregister_provider:
> +	icc_provider_deregister(provider);
> +err_remove_nodes:
>  	icc_nodes_remove(provider);
> -	icc_provider_del(provider);
> +
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(qcom_icc_rpmh_probe);
> @@ -253,8 +258,8 @@ int qcom_icc_rpmh_remove(struct platform_device *pdev)
>  {
>  	struct qcom_icc_provider *qp = platform_get_drvdata(pdev);
>  
> +	icc_provider_deregister(&qp->provider);
>  	icc_nodes_remove(&qp->provider);
> -	icc_provider_del(&qp->provider);
>  
>  	return 0;
>  }

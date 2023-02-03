Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4E18688D89
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 03:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231841AbjBCC5O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 21:57:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231967AbjBCC5M (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 21:57:12 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B9628B300
        for <stable@vger.kernel.org>; Thu,  2 Feb 2023 18:56:39 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id bk15so11700644ejb.9
        for <stable@vger.kernel.org>; Thu, 02 Feb 2023 18:56:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eCwiZoioRysEx+QIWwTxm0nALXffiaf6KDERGD0e8Es=;
        b=HGdKhb1ws04Wg3yG7QMp5xKjRoqGu8TEdMYoMZRZ/z6UNpOfIqv3poIpQkJOrN6kTs
         tzPyJMPtnqOqfYhDEHfDTY3yVdvd/mHqcnYpiXxAD6kQb5sHArk3pS/HOKSLJNMjk1No
         87/Mz14YITO01vj8awf6x7aU9/WXQSS+dHf58tW9iG6ww9Fg1Z8pz9nyBbLfOOY7VH8P
         3kTOylzN97Tnz7Oa6Xe3v8dGvVkK15pExPiGODwBGz32dsenR1D59py4s+665mIOwuwm
         tQfmXeQ7gk4frKnN92iz+AD31EdzmKl+wudhAPZImQFbSnVoe4TTaN8+PUVf2oghhDsO
         s6+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eCwiZoioRysEx+QIWwTxm0nALXffiaf6KDERGD0e8Es=;
        b=a0crmL6QWJTMPjrfjyF+zxsfFhAE/RCB9ZdefgEdaVreGNVxCUkGmC5bEmVX8ZWwKc
         LmPnR8Sca4K6n3RjzKLOKUbbbP8ZWdrwNXrpym7o1Tv4PuicNiE5ywd9c/3Ze5/OHK8j
         dSIN2czQLlr8QD0FFaSJfGTgamQ+rvvdxJYSgHI1pi1SjyRNn81P3zTpT5oD6ImdnFoc
         9GdQKHH2DeiUfYROnArKEnFNTB4/M5QV293HZkEg7VROxK54GSb8bJ17dyPiVqtOCRz+
         atL+RWK1V8+XXRCMP+pIGZsZ8mkAiobe+jRM57Q0byj+D/Lh9ED21yq6jV6yugcBvEiB
         a7qg==
X-Gm-Message-State: AO0yUKVLpBdU/8eAz6vqr7JZoTC29xH55SLGsvFlmPmOJrKI59Bat/06
        GhylgYwEEMQy7I6IPCJQDthL3A==
X-Google-Smtp-Source: AK7set/R/uYizy+fsGZr99X4Hwk76gtMulPD9wn4e3FKhc8+Gn/UPOPNIDkYa7emz/ypwBYdolD//Q==
X-Received: by 2002:a17:907:9917:b0:88d:6de1:96bf with SMTP id ka23-20020a170907991700b0088d6de196bfmr9276210ejc.12.1675392987561;
        Thu, 02 Feb 2023 18:56:27 -0800 (PST)
Received: from [192.168.1.101] (abyl20.neoplus.adsl.tpnet.pl. [83.9.31.20])
        by smtp.gmail.com with ESMTPSA id f17-20020a170906049100b00871f66bf354sm645476eja.204.2023.02.02.18.56.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Feb 2023 18:56:27 -0800 (PST)
Message-ID: <07b3338d-1d3d-ac06-07f3-337d3df9dde8@linaro.org>
Date:   Fri, 3 Feb 2023 03:56:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: [PATCH 11/23] interconnect: qcom: msm8974: fix registration race
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
        stable@vger.kernel.org, Brian Masney <bmasney@redhat.com>
References: <20230201101559.15529-1-johan+linaro@kernel.org>
 <20230201101559.15529-12-johan+linaro@kernel.org>
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <20230201101559.15529-12-johan+linaro@kernel.org>
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
> Fixes: 4e60a9568dc6 ("interconnect: qcom: add msm8974 driver")
> Cc: stable@vger.kernel.org      # 5.5
> Cc: Brian Masney <bmasney@redhat.com>
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> ---
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>

Konrad
>  drivers/interconnect/qcom/msm8974.c | 20 ++++++++------------
>  1 file changed, 8 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/interconnect/qcom/msm8974.c b/drivers/interconnect/qcom/msm8974.c
> index 5ea192f1141d..1828deaca443 100644
> --- a/drivers/interconnect/qcom/msm8974.c
> +++ b/drivers/interconnect/qcom/msm8974.c
> @@ -692,7 +692,6 @@ static int msm8974_icc_probe(struct platform_device *pdev)
>  		return ret;
>  
>  	provider = &qp->provider;
> -	INIT_LIST_HEAD(&provider->nodes);
>  	provider->dev = dev;
>  	provider->set = msm8974_icc_set;
>  	provider->aggregate = icc_std_aggregate;
> @@ -700,11 +699,7 @@ static int msm8974_icc_probe(struct platform_device *pdev)
>  	provider->data = data;
>  	provider->get_bw = msm8974_get_bw;
>  
> -	ret = icc_provider_add(provider);
> -	if (ret) {
> -		dev_err(dev, "error adding interconnect provider: %d\n", ret);
> -		goto err_disable_clks;
> -	}
> +	icc_provider_init(provider);
>  
>  	for (i = 0; i < num_nodes; i++) {
>  		size_t j;
> @@ -712,7 +707,7 @@ static int msm8974_icc_probe(struct platform_device *pdev)
>  		node = icc_node_create(qnodes[i]->id);
>  		if (IS_ERR(node)) {
>  			ret = PTR_ERR(node);
> -			goto err_del_icc;
> +			goto err_remove_nodes;
>  		}
>  
>  		node->name = qnodes[i]->name;
> @@ -729,15 +724,16 @@ static int msm8974_icc_probe(struct platform_device *pdev)
>  	}
>  	data->num_nodes = num_nodes;
>  
> +	ret = icc_provider_register(provider);
> +	if (ret)
> +		goto err_remove_nodes;
> +
>  	platform_set_drvdata(pdev, qp);
>  
>  	return 0;
>  
> -err_del_icc:
> +err_remove_nodes:
>  	icc_nodes_remove(provider);
> -	icc_provider_del(provider);
> -
> -err_disable_clks:
>  	clk_bulk_disable_unprepare(qp->num_clks, qp->bus_clks);
>  
>  	return ret;
> @@ -747,9 +743,9 @@ static int msm8974_icc_remove(struct platform_device *pdev)
>  {
>  	struct msm8974_icc_provider *qp = platform_get_drvdata(pdev);
>  
> +	icc_provider_deregister(&qp->provider);
>  	icc_nodes_remove(&qp->provider);
>  	clk_bulk_disable_unprepare(qp->num_clks, qp->bus_clks);
> -	icc_provider_del(&qp->provider);
>  
>  	return 0;
>  }

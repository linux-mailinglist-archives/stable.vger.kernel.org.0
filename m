Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2E81688D43
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 03:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231964AbjBCCtQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 21:49:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231904AbjBCCtI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 21:49:08 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49658820FC
        for <stable@vger.kernel.org>; Thu,  2 Feb 2023 18:48:52 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id hx15so11635508ejc.11
        for <stable@vger.kernel.org>; Thu, 02 Feb 2023 18:48:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ssp0tYsGiD2wY3B3DGIo6QkUzze0YWa6hi7rXepDkb4=;
        b=spkM/U5VoThD/brvY9ju/nMSYtv5QRq/KCCflZYFuQNLBWe3jtI+hjcvxUwoQCByE1
         VR5eZmIYxtNYeGPKFulbHvnGN/0JFucqiP4uyABqW0n9PZ+tIQzft24GfjPyiL2koXeD
         U3e9asI4QaAxfFUFXZeN+FgAoK+bvOPBr1Y4JawYJMXKz7/Ip8vFaJob05v7w1a9m1JK
         KI9yaWTYSnByYpxu2QVQAeEFQxiDWcrCONp+t+HOlVbAtNA36e5fxxTKcWB2Oo0YEBWa
         V1V3aBMM31BcieD3rdbCToqUWX201WMWj2RlAcoqEaJ72XWJ5pKcltCjtgySFqKOIjbv
         n+rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ssp0tYsGiD2wY3B3DGIo6QkUzze0YWa6hi7rXepDkb4=;
        b=Ff9HuwHNaWesVMmsM4VK9xbnmcbXcfr/s2Lm3z+qd7CLNI7pnet9sNBbkGOgSTfqHG
         BsK4LlQaCipjnBBlpR9SDiSETzqZcer177eWYnaxMe0OSdHZkstSR27ERuk3Yg445QEP
         UHQhZOndJ0W+8ihJBTlETdgrmi2cfgFs0lzx4QEqlJrao3x6mBRhIS/u+fi33TUdeh44
         kNJ0OcaI6mEsBTQvokNeQNVfazlAZWJEViLvHmzmixH5IFz+pUTNyLk7p1CfwgF/zKUr
         Djx/ZCtV6GcXYHlF/wiVP6+J9s5tQp9GfRjgioGB3ySFe/z095998x7jzeiX2fKjBUUr
         U0Tw==
X-Gm-Message-State: AO0yUKVj1WJGCPJBAVSTw6B8cawwIMWW0b30uLUxB/Au0bP6csZ8GPoZ
        EZFSoI+PBqE0RPdq651LpIHBag==
X-Google-Smtp-Source: AK7set+whWb0bDbuWGa8nmgHnP15jP1PhF9qSUmyaBXg2Yk7Dw+pIOxVTOaw5W3axnbzV5RnBpnLQw==
X-Received: by 2002:a17:906:c411:b0:889:14ec:21ae with SMTP id u17-20020a170906c41100b0088914ec21aemr8874834ejz.32.1675392530811;
        Thu, 02 Feb 2023 18:48:50 -0800 (PST)
Received: from [192.168.1.101] (abyl20.neoplus.adsl.tpnet.pl. [83.9.31.20])
        by smtp.gmail.com with ESMTPSA id s13-20020a170906c30d00b0088842b00241sm657296ejz.114.2023.02.02.18.48.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Feb 2023 18:48:50 -0800 (PST)
Message-ID: <b57730e5-e12a-e06e-a82b-9eddc5bdd8c7@linaro.org>
Date:   Fri, 3 Feb 2023 03:48:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: [PATCH 03/23] interconnect: fix provider registration API
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
 <20230201101559.15529-4-johan+linaro@kernel.org>
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <20230201101559.15529-4-johan+linaro@kernel.org>
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
> The current interconnect provider interface is inherently racy as
> providers are expected to be added before being fully initialised.
> 
> Specifically, nodes are currently not added and the provider data is not
> initialised until after registering the provider which can cause racing
> DT lookups to fail.
> 
> Add a new provider API which will be used to fix up the interconnect
> drivers.
> 
> The old API is reimplemented using the new interface and will be removed
> once all drivers have been fixed.
> 
> Fixes: 11f1ceca7031 ("interconnect: Add generic on-chip interconnect API")
> Fixes: 87e3031b6fbd ("interconnect: Allow endpoints translation via DT")
> Cc: stable@vger.kernel.org      # 5.1
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> ---
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>

Konrad
>  drivers/interconnect/core.c           | 52 +++++++++++++++++++--------
>  include/linux/interconnect-provider.h | 12 +++++++
>  2 files changed, 50 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/interconnect/core.c b/drivers/interconnect/core.c
> index 43c5c8503ee8..93d27ff8eef6 100644
> --- a/drivers/interconnect/core.c
> +++ b/drivers/interconnect/core.c
> @@ -1030,44 +1030,68 @@ int icc_nodes_remove(struct icc_provider *provider)
>  EXPORT_SYMBOL_GPL(icc_nodes_remove);
>  
>  /**
> - * icc_provider_add() - add a new interconnect provider
> - * @provider: the interconnect provider that will be added into topology
> + * icc_provider_init() - initialize a new interconnect provider
> + * @provider: the interconnect provider to initialize
> + *
> + * Must be called before adding nodes to the provider.
> + */
> +void icc_provider_init(struct icc_provider *provider)
> +{
> +	WARN_ON(!provider->set);
> +
> +	INIT_LIST_HEAD(&provider->nodes);
> +}
> +EXPORT_SYMBOL_GPL(icc_provider_init);
> +
> +/**
> + * icc_provider_register() - register a new interconnect provider
> + * @provider: the interconnect provider to register
>   *
>   * Return: 0 on success, or an error code otherwise
>   */
> -int icc_provider_add(struct icc_provider *provider)
> +int icc_provider_register(struct icc_provider *provider)
>  {
> -	if (WARN_ON(!provider->set))
> -		return -EINVAL;
>  	if (WARN_ON(!provider->xlate && !provider->xlate_extended))
>  		return -EINVAL;
>  
>  	mutex_lock(&icc_lock);
> -
> -	INIT_LIST_HEAD(&provider->nodes);
>  	list_add_tail(&provider->provider_list, &icc_providers);
> -
>  	mutex_unlock(&icc_lock);
>  
> -	dev_dbg(provider->dev, "interconnect provider added to topology\n");
> +	dev_dbg(provider->dev, "interconnect provider registered\n");
>  
>  	return 0;
>  }
> -EXPORT_SYMBOL_GPL(icc_provider_add);
> +EXPORT_SYMBOL_GPL(icc_provider_register);
>  
>  /**
> - * icc_provider_del() - delete previously added interconnect provider
> - * @provider: the interconnect provider that will be removed from topology
> + * icc_provider_deregister() - deregister an interconnect provider
> + * @provider: the interconnect provider to deregister
>   */
> -void icc_provider_del(struct icc_provider *provider)
> +void icc_provider_deregister(struct icc_provider *provider)
>  {
>  	mutex_lock(&icc_lock);
>  	WARN_ON(provider->users);
> -	WARN_ON(!list_empty(&provider->nodes));
>  
>  	list_del(&provider->provider_list);
>  	mutex_unlock(&icc_lock);
>  }
> +EXPORT_SYMBOL_GPL(icc_provider_deregister);
> +
> +int icc_provider_add(struct icc_provider *provider)
> +{
> +	icc_provider_init(provider);
> +
> +	return icc_provider_register(provider);
> +}
> +EXPORT_SYMBOL_GPL(icc_provider_add);
> +
> +void icc_provider_del(struct icc_provider *provider)
> +{
> +	WARN_ON(!list_empty(&provider->nodes));
> +
> +	icc_provider_deregister(provider);
> +}
>  EXPORT_SYMBOL_GPL(icc_provider_del);
>  
>  static const struct of_device_id __maybe_unused ignore_list[] = {
> diff --git a/include/linux/interconnect-provider.h b/include/linux/interconnect-provider.h
> index cd5c5a27557f..d12cd18aab3f 100644
> --- a/include/linux/interconnect-provider.h
> +++ b/include/linux/interconnect-provider.h
> @@ -122,6 +122,9 @@ int icc_link_destroy(struct icc_node *src, struct icc_node *dst);
>  void icc_node_add(struct icc_node *node, struct icc_provider *provider);
>  void icc_node_del(struct icc_node *node);
>  int icc_nodes_remove(struct icc_provider *provider);
> +void icc_provider_init(struct icc_provider *provider);
> +int icc_provider_register(struct icc_provider *provider);
> +void icc_provider_deregister(struct icc_provider *provider);
>  int icc_provider_add(struct icc_provider *provider);
>  void icc_provider_del(struct icc_provider *provider);
>  struct icc_node_data *of_icc_get_from_provider(struct of_phandle_args *spec);
> @@ -167,6 +170,15 @@ static inline int icc_nodes_remove(struct icc_provider *provider)
>  	return -ENOTSUPP;
>  }
>  
> +static inline void icc_provider_init(struct icc_provider *provider) { }
> +
> +static inline int icc_provider_register(struct icc_provider *provider)
> +{
> +	return -ENOTSUPP;
> +}
> +
> +static inline void icc_provider_deregister(struct icc_provider *provider) { }
> +
>  static inline int icc_provider_add(struct icc_provider *provider)
>  {
>  	return -ENOTSUPP;

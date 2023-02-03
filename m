Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C115E688D54
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 03:51:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232048AbjBCCv6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 21:51:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231889AbjBCCvv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 21:51:51 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 857C634008
        for <stable@vger.kernel.org>; Thu,  2 Feb 2023 18:51:48 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id ml19so11887229ejb.0
        for <stable@vger.kernel.org>; Thu, 02 Feb 2023 18:51:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9sK1kiPANM5sDtBtHkvFlyTj/KkhjaOrGhiblZmL0M0=;
        b=BN0XufmHv1hppdkISK+rHRkSjyopgNv//ikIOSw9x6dd/6TnDBk2a/hxJkpK4y7Ikk
         IVOvhDsrwfGccWQh3cnj5gCpDztzOXR1IfdMwGZUlYlUTV6NMHgdYCLNRu+fY9dgIye+
         K47eMPtGoNdLMSgBv+MwyCcDg3ouGyeM/Ek6eRCj9nN2s9hL40hsGVyCiyImnaYmG8i6
         ASI09fL39RqHHLVYwvm31mjIJDJAflckl53+/q9YMnhYI4GoQwb1j5XcOZLYb2u7hR7g
         3M06fHsxioZTOyHF8FnQexA5yOqHQXJVVXnZNRQwputCIEMF47wd2fcLKLk2J2ZZn8th
         +GwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9sK1kiPANM5sDtBtHkvFlyTj/KkhjaOrGhiblZmL0M0=;
        b=1lm1sWG4bolPZUL7xvt9Gk9rHXl2OQAAVK0mZR9xqa/4b/3N/dmIi86LpAUs+aQ0lS
         HkoNmWDIgu8khGLOZjqmj/kAEeaBuEn4DLqHe9BaA0oYGpmjlJwmmcVkHuuEnZrFkZl9
         5TYODCyTHf7RB/XG4aQCOTtjVexS4nh0C5yv2BKhjg0UYwhT4MiMjeep8ggq36nSdD8l
         VF1BY8fqK5Ju5JLwcROMd8OS6BpVACem0MTQHTK9uh1g0DdfOdrjS1gX8tF9xcPvF+kp
         lKEJxGhjGMnJ00iHEhbwnrrXE5i0PjodQayLHvb+91lSRdK7XZbGNsfbyiAxhDgEmKoE
         vCMQ==
X-Gm-Message-State: AO0yUKVMWg9PJ8YB+qolhzJoCx1ivTnoQmlnPKLoK4EdN70RXAxiSyVi
        uLXk2ROhiHeVDrYGWeHmTvTyAQ==
X-Google-Smtp-Source: AK7set8mfugHn5qx02IsNAufb5ixSu47oCE4xj/+YoDcvfh4WICLCamx8dHktQnZIkraLPF4o+xIWQ==
X-Received: by 2002:a17:907:c312:b0:88d:ba89:184a with SMTP id tl18-20020a170907c31200b0088dba89184amr3736949ejc.27.1675392707026;
        Thu, 02 Feb 2023 18:51:47 -0800 (PST)
Received: from [192.168.1.101] (abyl20.neoplus.adsl.tpnet.pl. [83.9.31.20])
        by smtp.gmail.com with ESMTPSA id g4-20020a170906348400b007add62dafbasm653528ejb.157.2023.02.02.18.51.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Feb 2023 18:51:46 -0800 (PST)
Message-ID: <90d2631d-c9e9-1c9b-c7de-6ec84d60096b@linaro.org>
Date:   Fri, 3 Feb 2023 03:51:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: [PATCH 05/23] interconnect: qcom: osm-l3: fix registration race
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
 <20230201101559.15529-6-johan+linaro@kernel.org>
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <20230201101559.15529-6-johan+linaro@kernel.org>
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
> can specifically cause racing DT lookups to fail:
> 
> 	of_icc_xlate_onecell: invalid index 0
> 	cpu cpu0: error -EINVAL: error finding src node
> 	cpu cpu0: dev_pm_opp_of_find_icc_paths: Unable to get path0: -22
> 	qcom-cpufreq-hw: probe of 18591000.cpufreq failed with error -22
> 
> Switch to using the new API where the provider is not registered until
> after it has been fully initialised.
> 
> Fixes: 5bc9900addaf ("interconnect: qcom: Add OSM L3 interconnect provider support")
> Cc: stable@vger.kernel.org      # 5.7
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> ---
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>

Konrad
>  drivers/interconnect/qcom/osm-l3.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/interconnect/qcom/osm-l3.c b/drivers/interconnect/qcom/osm-l3.c
> index 5fa171087425..3a1cbfe3e481 100644
> --- a/drivers/interconnect/qcom/osm-l3.c
> +++ b/drivers/interconnect/qcom/osm-l3.c
> @@ -158,8 +158,8 @@ static int qcom_osm_l3_remove(struct platform_device *pdev)
>  {
>  	struct qcom_osm_l3_icc_provider *qp = platform_get_drvdata(pdev);
>  
> +	icc_provider_deregister(&qp->provider);
>  	icc_nodes_remove(&qp->provider);
> -	icc_provider_del(&qp->provider);
>  
>  	return 0;
>  }
> @@ -245,14 +245,9 @@ static int qcom_osm_l3_probe(struct platform_device *pdev)
>  	provider->set = qcom_osm_l3_set;
>  	provider->aggregate = icc_std_aggregate;
>  	provider->xlate = of_icc_xlate_onecell;
> -	INIT_LIST_HEAD(&provider->nodes);
>  	provider->data = data;
>  
> -	ret = icc_provider_add(provider);
> -	if (ret) {
> -		dev_err(&pdev->dev, "error adding interconnect provider\n");
> -		return ret;
> -	}
> +	icc_provider_init(provider);
>  
>  	for (i = 0; i < num_nodes; i++) {
>  		size_t j;
> @@ -275,12 +270,15 @@ static int qcom_osm_l3_probe(struct platform_device *pdev)
>  	}
>  	data->num_nodes = num_nodes;
>  
> +	ret = icc_provider_register(provider);
> +	if (ret)
> +		goto err;
> +
>  	platform_set_drvdata(pdev, qp);
>  
>  	return 0;
>  err:
>  	icc_nodes_remove(provider);
> -	icc_provider_del(provider);
>  
>  	return ret;
>  }

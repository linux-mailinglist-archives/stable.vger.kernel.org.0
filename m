Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8EC1688D77
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 03:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232110AbjBCCy7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 21:54:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbjBCCy6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 21:54:58 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDFD48A7E2
        for <stable@vger.kernel.org>; Thu,  2 Feb 2023 18:54:37 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id p26so11632110ejx.13
        for <stable@vger.kernel.org>; Thu, 02 Feb 2023 18:54:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Mstc3lGV61M7IlWy9Tj/AynBNvHW1063jMNmi6YxKdM=;
        b=EwSK1PKItdH+q6dSJObpy51LA1YXHFfVx8e4Oi6pmtI19f2iZcR7itHWWLNE47WdYu
         YJpnqX0mEaPxrQTfbpcaWnWCYRZmfAMHPSNkSQRGSKdlWVYs59DC+dbZuBYArkGydu95
         8upRgKGUJbkXoq7mzYRq6HlOj7ARJbeAjxqbILH8A+7JzwijtFc9htOb0rLc8gAL8ANa
         nn8hQJy8eEcX4mA4Nnaqhf6g3jtsY0MeHgIRXKoqwyPNFW082XgDZg8V5R5L94OLTCTj
         cx0m5UUBOB7MUVeiSHm5A3Bn0CyGRhD75wSyd+8TUqCxfrhOQtD/G7bFKJRWfPtnbldX
         M4lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Mstc3lGV61M7IlWy9Tj/AynBNvHW1063jMNmi6YxKdM=;
        b=U9BoIEQSLeCNzJqNd8T6mDc3vl2dVtwMpCtW7+D7cBC6LCagy5elyNyiFsCE1zJ0Fb
         I3zr6YBLtFY4KTVqVUc2sQb+5S8anltwsi2Rgb3HXi5UklpUZwBz9BmTlGzQyFfQLJdE
         0Z6NwINAsQUBRexRKs3KV2Eb/Z40z1Y+0K1gti/laE4KXYmDsJomNx6EkX8ZWFDZyz52
         gVmnNRJ/n7KUUUdKJVeZ4ti/qvzoFaSJGN4/emeajIe6iLXiIQYvcfYmtsUbE0b2ukqG
         5gqDMTPh7f6/++G/bR6ePkJoWUZlKLaWBZiwiBrUZwno/PU+sKbX3KRcklsUt9C2qTdS
         vBAw==
X-Gm-Message-State: AO0yUKULCdGCp5XyhgDVaw9G0eJ4fQDMp+yR5HK3sgVlhQbpvLKMqayQ
        N4yVN9Q1w5DSojCeBKtXHVF1yQ==
X-Google-Smtp-Source: AK7set9Fvqh4uyhksVh4KGxRmNAduUsq4iHnfJ/wNYurtkD/LQNUMA5P+dGxpteJuOXUnkLvgxMHag==
X-Received: by 2002:a17:907:1707:b0:884:3174:119d with SMTP id le7-20020a170907170700b008843174119dmr9499413ejc.14.1675392876041;
        Thu, 02 Feb 2023 18:54:36 -0800 (PST)
Received: from [192.168.1.101] (abyl20.neoplus.adsl.tpnet.pl. [83.9.31.20])
        by smtp.gmail.com with ESMTPSA id ek26-20020a056402371a00b00495c3573b36sm489953edb.32.2023.02.02.18.54.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Feb 2023 18:54:35 -0800 (PST)
Message-ID: <4969bf69-ca1f-a6e2-48cd-2cb27ee5a25e@linaro.org>
Date:   Fri, 3 Feb 2023 03:54:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: [PATCH 09/23] interconnect: qcom: rpmh: fix probe child-node
 error handling
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
        stable@vger.kernel.org, Luca Weiss <luca.weiss@fairphone.com>
References: <20230201101559.15529-1-johan+linaro@kernel.org>
 <20230201101559.15529-10-johan+linaro@kernel.org>
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <20230201101559.15529-10-johan+linaro@kernel.org>
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
> Make sure to clean up and release resources properly also in case probe
> fails when populating child devices.
> 
> Fixes: 57eb14779dfd ("interconnect: qcom: icc-rpmh: Support child NoC device probe")
> Cc: stable@vger.kernel.org      # 6.0
> Cc: Luca Weiss <luca.weiss@fairphone.com>
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> ---
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>

Konrad
>  drivers/interconnect/qcom/icc-rpmh.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/interconnect/qcom/icc-rpmh.c b/drivers/interconnect/qcom/icc-rpmh.c
> index fd17291c61eb..5168bbf3d92f 100644
> --- a/drivers/interconnect/qcom/icc-rpmh.c
> +++ b/drivers/interconnect/qcom/icc-rpmh.c
> @@ -235,8 +235,11 @@ int qcom_icc_rpmh_probe(struct platform_device *pdev)
>  	platform_set_drvdata(pdev, qp);
>  
>  	/* Populate child NoC devices if any */
> -	if (of_get_child_count(dev->of_node) > 0)
> -		return of_platform_populate(dev->of_node, NULL, NULL, dev);
> +	if (of_get_child_count(dev->of_node) > 0) {
> +		ret = of_platform_populate(dev->of_node, NULL, NULL, dev);
> +		if (ret)
> +			goto err;
> +	}
>  
>  	return 0;
>  err:

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9A93672178
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 16:37:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjARPhh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 10:37:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230420AbjARPhg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 10:37:36 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C165F4FC08
        for <stable@vger.kernel.org>; Wed, 18 Jan 2023 07:37:33 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id o17-20020a05600c511100b003db021ef437so1811210wms.4
        for <stable@vger.kernel.org>; Wed, 18 Jan 2023 07:37:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9MUTzLHzBmFsx6voDKaBAKveK68NwSUI+xI02exchoI=;
        b=vL8HdVo204ElRdFkg75ULWXDUJz5E8sZk8BZrq3OHoFsHZW3i4ljANsFIYNT0ZFDPr
         Ok0kHbRrWX9mBxnodxf0d2zz/uQUt9tNhkBYSy4ZM7flZv4bmd+L93CPToC4VqNVlLPG
         Qnd8yk9UoKu59jSlDDL9iGIPUnW42P7AtV6czYp/Hmn33GCyCBg5c2pSaxgHKF/XULUu
         7ECJ/9t0YNUYrtF3ifFGuVd3b5OAneNKwkg8hvHRAgNWX9qUbpsqt1D7P/NTh8C6pVUE
         x1Y5W8RdFp+umRxNQ8+8oWnHGbv8ReLMF/KKYdqgxLHW9atxA5sGaf3Ie5XrrdWdz1UF
         Ng5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9MUTzLHzBmFsx6voDKaBAKveK68NwSUI+xI02exchoI=;
        b=oHoCfLVRM8S1nd5Bbt9e2EQjw7fG1qqBR6D24L5jPxn3vRrZcUoZw7LBO3+CIWJff+
         tZLd9TYNdAZwFrXsngV4CawOW5C/f46sBBjqM+46VfohbJ8AvujQZAs4YXraEOODjy0H
         KeeDTLAo+H1TEjk2P8Ft0jZ7SX3m74x8fkBv9fT59GBrhpog2iUQzUbsFtpoKE0mBe+R
         FHFdHy59ktCM3EngyT7NQyCeJHDBI3MdsTSR4hvQ88NW8i7DcJHbBMly5VZg++gnFR4v
         3QmqcpzQ7v+NSlMNq0FvMuC/MGGSaR9zjV8xRRoJd/4qbnRJbagseJkZ18NwQ+7G8b1h
         zsIg==
X-Gm-Message-State: AFqh2kq46vNHu3zY6t2+EzVsXZop4aOAMPxyVi9aJpZ6FQiE1m/NaA4l
        ZB8DHmKEm3qUOcn46SJ/PIma6w==
X-Google-Smtp-Source: AMrXdXuDqlWhXHYAvFp3Xph5TSdx8V0BuxL3WrSKE2aqK4/6KM0lTlBDNXeOeWuW16esJh9MGXJQjg==
X-Received: by 2002:a05:600c:1c96:b0:3d9:e9a2:eea3 with SMTP id k22-20020a05600c1c9600b003d9e9a2eea3mr6977425wms.37.1674056252297;
        Wed, 18 Jan 2023 07:37:32 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id o2-20020a05600c4fc200b003cf894dbc4fsm2349091wmq.25.2023.01.18.07.37.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Jan 2023 07:37:31 -0800 (PST)
Message-ID: <d3cd9b7a-6286-a140-d205-6d4b6ca8092d@linaro.org>
Date:   Wed, 18 Jan 2023 16:37:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: [PATCH v6 17/17] soc: qcom: llcc: Do not create EDAC platform
 device on SDM845
Content-Language: en-US
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        andersson@kernel.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, bp@alien8.de,
        tony.luck@intel.com
Cc:     quic_saipraka@quicinc.com, konrad.dybcio@linaro.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        james.morse@arm.com, mchehab@kernel.org, rric@kernel.org,
        linux-edac@vger.kernel.org, quic_ppareek@quicinc.com,
        luca.weiss@fairphone.com, ahalaney@redhat.com, steev@kali.org,
        stable@vger.kernel.org
References: <20230118150904.26913-1-manivannan.sadhasivam@linaro.org>
 <20230118150904.26913-18-manivannan.sadhasivam@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230118150904.26913-18-manivannan.sadhasivam@linaro.org>
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

On 18/01/2023 16:09, Manivannan Sadhasivam wrote:
> The platforms based on SDM845 SoC locks the access to EDAC registers in the
> bootloader. So probing the EDAC driver will result in a crash. Hence,
> disable the creation of EDAC platform device on all SDM845 devices.
> 
> The issue has been observed on Lenovo Yoga C630 and DB845c.
> 
> Cc: <stable@vger.kernel.org> # 5.10
> Reported-by: Steev Klimaszewski <steev@kali.org>
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
>  drivers/soc/qcom/llcc-qcom.c | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/soc/qcom/llcc-qcom.c b/drivers/soc/qcom/llcc-qcom.c
> index 7b7c5a38bac6..8d840702df50 100644
> --- a/drivers/soc/qcom/llcc-qcom.c
> +++ b/drivers/soc/qcom/llcc-qcom.c
> @@ -1012,11 +1012,18 @@ static int qcom_llcc_probe(struct platform_device *pdev)
>  
>  	drv_data->ecc_irq = platform_get_irq_optional(pdev, 0);
>  
> -	llcc_edac = platform_device_register_data(&pdev->dev,
> -					"qcom_llcc_edac", -1, drv_data,
> -					sizeof(*drv_data));
> -	if (IS_ERR(llcc_edac))
> -		dev_err(dev, "Failed to register llcc edac driver\n");
> +	/*
> +	 * The platforms based on SDM845 SoC locks the access to EDAC registers
> +	 * in bootloader. So probing the EDAC driver will result in a crash.
> +	 * Hence, disable the creation of EDAC platform device on SDM845.
> +	 */
> +	if (!of_device_is_compatible(dev->of_node, "qcom,sdm845-llcc")) {

Don't spread of_device_is_compatible() in driver code. You have driver
data for this.

Best regards,
Krzysztof


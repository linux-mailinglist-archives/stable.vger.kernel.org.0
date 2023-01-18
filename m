Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F16606722A3
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 17:11:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbjARQLF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 11:11:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbjARQJ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 11:09:29 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF5115AA67
        for <stable@vger.kernel.org>; Wed, 18 Jan 2023 08:05:32 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id m15so3859977wms.4
        for <stable@vger.kernel.org>; Wed, 18 Jan 2023 08:05:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TlpQr2e80moEUIK/fMAJf4D8UDlmnyfV6FvXUUoII8s=;
        b=mAn2qWHxBDlWnGsHCmRMSyJ9Cgjy9na703v331EgvwSvckiTgKNXhK2mX4qGvSWTVz
         gATsRKUL7LVhq+cXTmWVBfk12Acu4cFcSBiT8UeZT/RxmT11SXZR3oVqpZT5DKM2MmbE
         Qy7SysHmo/OSIlAlNERV5D7Vyx03l1TlfC+3ECIDmkS6CW4CRddQ1LhNX1In38bJCTkh
         SqEsju9kFCKQDq8rKxhzVpJX/MokdM1Ul7dfDyvb2mS1fs3R3eJKqQNzVCgcf4cW0a1l
         orFrXiqmwDUcyaJZlzyXd/ywlj4lbwOZFNuAoA9yJEHyf+xn2YMMSmS+eQo+oIZZ5qNS
         OquA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TlpQr2e80moEUIK/fMAJf4D8UDlmnyfV6FvXUUoII8s=;
        b=eGJrnQ4evT5ntsZD0x8smw+gCJBCY2sKrWAf6FmLpa+OYzM1/OaCbVGnmaBXmWZjW6
         XQDQv5dT4beEzFUAFBHOu2dUBcVsk/T8kKFw7jmye+Y7du9RCi3qiyBfIeElTOchvEtn
         lO90rAJH2gXyrNQOcp/JORkriFgDiplTVe/HWUviuigqBqde/vBT2sdMSCgW2Huipm+h
         lfWebxU728wHevPWPdumqK5DAN4rIUeyl2+n8DzrH9Acr/p7CWfvkSBwbJtHIaomUN3u
         jNPk+Ey7zHR+shkW9n5GQMJosU6eoVMymTyYiPEt0nTGwvpb4DKWqwiwuiAxE494zLPg
         Ai1g==
X-Gm-Message-State: AFqh2krfByZVYNt0lQSn8HsECG0Wdi0IcvzJuB7G6jdvv1tHwcmBo4Df
        5mKOnKSezgYW8vt3j366MeDL4A==
X-Google-Smtp-Source: AMrXdXtMo9VtxxVGHKA5Vmrw+4k/bxklMtWbXdVXPAQVenIjLidMhYpXoOxBSsvoBf5gIN6j4+Cpbg==
X-Received: by 2002:a05:600c:2056:b0:3db:ce8:6662 with SMTP id p22-20020a05600c205600b003db0ce86662mr5147700wmg.31.1674057931048;
        Wed, 18 Jan 2023 08:05:31 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id f20-20020a7bcd14000000b003da28dfdedcsm2899480wmj.5.2023.01.18.08.05.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Jan 2023 08:05:30 -0800 (PST)
Message-ID: <3ca41414-df2e-4ba0-9dc7-cacea2413fe6@linaro.org>
Date:   Wed, 18 Jan 2023 17:05:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: [PATCH v6 17/17] soc: qcom: llcc: Do not create EDAC platform
 device on SDM845
Content-Language: en-US
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     andersson@kernel.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, bp@alien8.de,
        tony.luck@intel.com, quic_saipraka@quicinc.com,
        konrad.dybcio@linaro.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, james.morse@arm.com,
        mchehab@kernel.org, rric@kernel.org, linux-edac@vger.kernel.org,
        quic_ppareek@quicinc.com, luca.weiss@fairphone.com,
        ahalaney@redhat.com, steev@kali.org, stable@vger.kernel.org
References: <20230118150904.26913-1-manivannan.sadhasivam@linaro.org>
 <20230118150904.26913-18-manivannan.sadhasivam@linaro.org>
 <d3cd9b7a-6286-a140-d205-6d4b6ca8092d@linaro.org>
 <20230118155919.GD4690@thinkpad>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230118155919.GD4690@thinkpad>
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

On 18/01/2023 16:59, Manivannan Sadhasivam wrote:
> On Wed, Jan 18, 2023 at 04:37:29PM +0100, Krzysztof Kozlowski wrote:
>> On 18/01/2023 16:09, Manivannan Sadhasivam wrote:
>>> The platforms based on SDM845 SoC locks the access to EDAC registers in the
>>> bootloader. So probing the EDAC driver will result in a crash. Hence,
>>> disable the creation of EDAC platform device on all SDM845 devices.
>>>
>>> The issue has been observed on Lenovo Yoga C630 and DB845c.
>>>
>>> Cc: <stable@vger.kernel.org> # 5.10
>>> Reported-by: Steev Klimaszewski <steev@kali.org>
>>> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
>>> ---
>>>  drivers/soc/qcom/llcc-qcom.c | 17 ++++++++++++-----
>>>  1 file changed, 12 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/drivers/soc/qcom/llcc-qcom.c b/drivers/soc/qcom/llcc-qcom.c
>>> index 7b7c5a38bac6..8d840702df50 100644
>>> --- a/drivers/soc/qcom/llcc-qcom.c
>>> +++ b/drivers/soc/qcom/llcc-qcom.c
>>> @@ -1012,11 +1012,18 @@ static int qcom_llcc_probe(struct platform_device *pdev)
>>>  
>>>  	drv_data->ecc_irq = platform_get_irq_optional(pdev, 0);
>>>  
>>> -	llcc_edac = platform_device_register_data(&pdev->dev,
>>> -					"qcom_llcc_edac", -1, drv_data,
>>> -					sizeof(*drv_data));
>>> -	if (IS_ERR(llcc_edac))
>>> -		dev_err(dev, "Failed to register llcc edac driver\n");
>>> +	/*
>>> +	 * The platforms based on SDM845 SoC locks the access to EDAC registers
>>> +	 * in bootloader. So probing the EDAC driver will result in a crash.
>>> +	 * Hence, disable the creation of EDAC platform device on SDM845.
>>> +	 */
>>> +	if (!of_device_is_compatible(dev->of_node, "qcom,sdm845-llcc")) {
>>
>> Don't spread of_device_is_compatible() in driver code. You have driver
>> data for this.
>>
> 
> Yeah, but there is no ID to in the driver data to identify an SoC. 

What do you mean there is no? You use exactly the same compatible as the
one in driver data.


> I could add
> one but is that really worth doing so? Is using of_device_is_compatible() in
> drivers discouraged nowadays?

Because it spreads variant matching all over. It does not scale. drv
data fields are the way or better quirks/flags.

Best regards,
Krzysztof


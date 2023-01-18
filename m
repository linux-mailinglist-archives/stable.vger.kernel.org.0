Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33EB8672472
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 18:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbjARRHB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 12:07:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbjARRG7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 12:06:59 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 419F346142
        for <stable@vger.kernel.org>; Wed, 18 Jan 2023 09:06:54 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id bk16so34604198wrb.11
        for <stable@vger.kernel.org>; Wed, 18 Jan 2023 09:06:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VWQ584Y2nMdX85zP2zBoUd1q5AWvsub5/EGESd2pImA=;
        b=nUdxqOrzGd38yu2vPUk7VSI0BgJXhO3l0fnqMHCB8GWyTziBjYokyUPf3Bbjv9CPbQ
         rU7uwbqxYQdTJCN3A8viBxq7Erjj5/JafRMQqBpvOALxf6wS7XGIDjDN8DR1/T4YOnlm
         /7sxj/OlcgRgIO2hC5cpZSFW3dHFy/HfifJW5v2HngVr2oQGDwYGdUs5qkfJa5DWMSwb
         Dk5xC1xoxbLs4nk2L6YAPBKwYTx4DPiw+f7ZVRRTNVfyQBJ5ILQEedHFE/g+9YI+wP9I
         hE5oOAHeEYZarW27Fzff6320VNDfHCedb2k5G+ZeY0JhWMgFXdUl6ZSAUBz4UVD58vr+
         mEPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VWQ584Y2nMdX85zP2zBoUd1q5AWvsub5/EGESd2pImA=;
        b=2IGciqJCUOa+kDg5X0uN2iUE0O8mzHhv6xCP972PbDGvetJ6b+t4dxBFLlzqG/dWW5
         idfVwJDMnFh182YMi1vjPwNJYVYpR26ufUsGGMbWVCpJhk2p0oJZcvj0b8UpFCY6/dOr
         7jwCC2agGYJNZg6UuF7hHzGkURc6XY69Tjp04bA3dPsLgCMUgL5zCco14AhJ3oqpaYyv
         Q2zlbuK2mR6cW9jEsnllTXimq8OIcalAOH807Dw4L3RFMJvaq5kWV6mQRWpGlXrgB7n9
         WYtrEJ8PxKxWjfmk6TpnWUVJbYbkqn93JOeyEW3obYJ8zq0IkmyCSQYtX5AK106av4dV
         CCKw==
X-Gm-Message-State: AFqh2ko3+6xpw/jIbBq+D3bwArzEnI2UTQH5/szp4TBxg8iptqifjflO
        5yof8sFcJTIWYg6dZ7JtdkLK7w==
X-Google-Smtp-Source: AMrXdXtjSaoQnGJL2cmOmv2BcbWJCZQKa03nVTS+9kuhJZfyeGFyGYalXJkIr65AlcO8+X1nnDSepw==
X-Received: by 2002:a5d:684d:0:b0:263:9208:2dd with SMTP id o13-20020a5d684d000000b00263920802ddmr14442437wrw.18.1674061613357;
        Wed, 18 Jan 2023 09:06:53 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id t17-20020a05600001d100b00241d21d4652sm31405992wrx.21.2023.01.18.09.06.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Jan 2023 09:06:52 -0800 (PST)
Message-ID: <978b0335-ae9d-7d7a-ad70-6861d6dfcc43@linaro.org>
Date:   Wed, 18 Jan 2023 18:06:50 +0100
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
 <3ca41414-df2e-4ba0-9dc7-cacea2413fe6@linaro.org>
 <20230118162657.GE4690@thinkpad>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230118162657.GE4690@thinkpad>
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

On 18/01/2023 17:26, Manivannan Sadhasivam wrote:
> On Wed, Jan 18, 2023 at 05:05:28PM +0100, Krzysztof Kozlowski wrote:
>> On 18/01/2023 16:59, Manivannan Sadhasivam wrote:
>>> On Wed, Jan 18, 2023 at 04:37:29PM +0100, Krzysztof Kozlowski wrote:
>>>> On 18/01/2023 16:09, Manivannan Sadhasivam wrote:
>>>>> The platforms based on SDM845 SoC locks the access to EDAC registers in the
>>>>> bootloader. So probing the EDAC driver will result in a crash. Hence,
>>>>> disable the creation of EDAC platform device on all SDM845 devices.
>>>>>
>>>>> The issue has been observed on Lenovo Yoga C630 and DB845c.
>>>>>
>>>>> Cc: <stable@vger.kernel.org> # 5.10
>>>>> Reported-by: Steev Klimaszewski <steev@kali.org>
>>>>> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
>>>>> ---
>>>>>  drivers/soc/qcom/llcc-qcom.c | 17 ++++++++++++-----
>>>>>  1 file changed, 12 insertions(+), 5 deletions(-)
>>>>>
>>>>> diff --git a/drivers/soc/qcom/llcc-qcom.c b/drivers/soc/qcom/llcc-qcom.c
>>>>> index 7b7c5a38bac6..8d840702df50 100644
>>>>> --- a/drivers/soc/qcom/llcc-qcom.c
>>>>> +++ b/drivers/soc/qcom/llcc-qcom.c
>>>>> @@ -1012,11 +1012,18 @@ static int qcom_llcc_probe(struct platform_device *pdev)
>>>>>  
>>>>>  	drv_data->ecc_irq = platform_get_irq_optional(pdev, 0);
>>>>>  
>>>>> -	llcc_edac = platform_device_register_data(&pdev->dev,
>>>>> -					"qcom_llcc_edac", -1, drv_data,
>>>>> -					sizeof(*drv_data));
>>>>> -	if (IS_ERR(llcc_edac))
>>>>> -		dev_err(dev, "Failed to register llcc edac driver\n");
>>>>> +	/*
>>>>> +	 * The platforms based on SDM845 SoC locks the access to EDAC registers
>>>>> +	 * in bootloader. So probing the EDAC driver will result in a crash.
>>>>> +	 * Hence, disable the creation of EDAC platform device on SDM845.
>>>>> +	 */
>>>>> +	if (!of_device_is_compatible(dev->of_node, "qcom,sdm845-llcc")) {
>>>>
>>>> Don't spread of_device_is_compatible() in driver code. You have driver
>>>> data for this.
>>>>
>>>
>>> Yeah, but there is no ID to in the driver data to identify an SoC. 
>>
>> What do you mean there is no? You use exactly the same compatible as the
>> one in driver data.
>>
> 
> Right, but I was saying that there is no unique field to identify an SoC.
> 
>>
>>> I could add
>>> one but is that really worth doing so? Is using of_device_is_compatible() in
>>> drivers discouraged nowadays?
>>
>> Because it spreads variant matching all over. It does not scale. drv
>> data fields are the way or better quirks/flags.
>>
> 
> The driver quirk/flags are usually beneficial if it applies to multiple
> platforms, otherwise they are a bit overkill IMO just like in this case.
> 
> One can argue that this matching could spread to other SoCs in the future, but
> I don't think that could happen for this case.

That's the argument for every flag/quirk/field. Driver already uses it -
see need_llcc_cfg being set for only one (!!!) variant. Now you add
orthogonal field just as of_device_is_compatible(). No, that's why we
have driver data and as I said - it is already used.

Best regards,
Krzysztof


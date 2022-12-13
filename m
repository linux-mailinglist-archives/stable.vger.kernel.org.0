Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3939C64BC2D
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 19:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236624AbiLMSh3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 13:37:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236747AbiLMShL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 13:37:11 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 485A12528A
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 10:37:10 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id 1so6403446lfz.4
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 10:37:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=L303KNiiCGa2s8e57cnLjfvhyKQwQ4Pq4U8Wh9sxeAM=;
        b=mbZMTgzMhOaneVV7iiak9c6D7suF3fdKwaHLlfn1P9N9puXV3Yg4bIzEbYppr/Bm4d
         STzIGbHWYqW5og/Be1fNLf2MleWqkisHbGGja5Mv3HZr4+Kh0vE6Fo4YCYjq2wmvQotj
         X+6PECu5ZAvQxSfwCcSOuQJtTC6h7scxjmqwar0NIjVTNKmhbS9eRNz/GVuuS4vYaXP4
         sN9sFgz32ThTb5i7YdglhOPxTN0nCc8ZIdMCEoPhdnQ6dK3IAv2jr7xUUHWqr+uv1qch
         rg6XCdIQOBFDYc4UbjHWqVRsHBFZ/E/ECaFfOpcjwY4117PO50C4VP5X+KGT9Rr5zrjo
         bEww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L303KNiiCGa2s8e57cnLjfvhyKQwQ4Pq4U8Wh9sxeAM=;
        b=73pxQAyQ2EkO22wWWk0hi6hggaUIFGqgL22UAXQH1/etInTP7TXwKrKzyMrweNnUxZ
         G/b7dmM9jzTlg8j1aI88fZ0vPW7SaDX4Da5+TDjq6SQkWHADUQviGL3UWHuGgWQuRmpe
         H9k2FWlDzCpxJW1cg6yJqzt3YOkWPGQzPCsKtJf7qCislueNfcrDUKfm+z25RxfG3cB4
         xs1yd1cIuZCGBVkm0+IUde2fwdHMW29rICAb5K8Hq509SKSiuoFMvDVLSZGQ91YLvHnT
         ErNj99560xB6sZHqMfewCq32o1dihBfVJNvk7tZPmaR5hkeEc4FgxDgJUIRnSxcXPFfd
         KXpg==
X-Gm-Message-State: ANoB5pmssPlSFVcpNln2T1PKzTePgQyOz7JtSY+v1BplJjT74+IKQDRH
        2m/VZ4SjaS7lhNvu0TUBhVquIA==
X-Google-Smtp-Source: AA0mqf4HHK1bQqbvgigc8VPooEu6/F0b93bT0pGHF/bl+4o9upH1psW6sAy5NOU48fyzZEY+Goz+bQ==
X-Received: by 2002:ac2:5314:0:b0:4b5:a4f1:fbbe with SMTP id c20-20020ac25314000000b004b5a4f1fbbemr7593894lfh.67.1670956628642;
        Tue, 13 Dec 2022 10:37:08 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id f11-20020a056512360b00b004b55da01d3csm463102lfs.191.2022.12.13.10.37.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Dec 2022 10:37:08 -0800 (PST)
Message-ID: <75ae9a48-6ddd-2e85-a7e2-7b0e6baf0ccf@linaro.org>
Date:   Tue, 13 Dec 2022 19:37:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 03/13] arm64: dts: qcom: sdm845: Fix the base addresses
 of LLCC banks
Content-Language: en-US
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     andersson@kernel.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, bp@alien8.de,
        tony.luck@intel.com, quic_saipraka@quicinc.com,
        konrad.dybcio@linaro.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, james.morse@arm.com,
        mchehab@kernel.org, rric@kernel.org, linux-edac@vger.kernel.org,
        quic_ppareek@quicinc.com, luca.weiss@fairphone.com,
        stable@vger.kernel.org
References: <20221212123311.146261-1-manivannan.sadhasivam@linaro.org>
 <20221212123311.146261-4-manivannan.sadhasivam@linaro.org>
 <038e6569-9f8f-3b59-0243-af6dcf0c2d80@linaro.org>
 <20221213171356.GD4862@thinkpad>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221213171356.GD4862@thinkpad>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 13/12/2022 18:13, Manivannan Sadhasivam wrote:
> On Tue, Dec 13, 2022 at 05:27:45PM +0100, Krzysztof Kozlowski wrote:
>> On 12/12/2022 13:33, Manivannan Sadhasivam wrote:
>>> The LLCC block has several banks each with a different base address
>>> and holes in between. So it is not a correct approach to cover these
>>> banks with a single offset/size. Instead, the individual bank's base
>>> address needs to be specified in devicetree with the exact size.
>>>
>>> Also, let's get rid of reg-names property as it is not needed anymore.
>>> The driver is expected to parse the reg field based on index to get the
>>> addresses of each LLCC banks.
>>>
>>> Cc: <stable@vger.kernel.org> # 5.4
>>
>> No, you cannot backport it. You will break users.
>>
> 
> If the driver change gets backported, it will break users, isn't it?

Whether driver change gets backported or not - all out of tree kernel
users, other systems, firmwares/bootloaders are broken and backporting
driver piece will not fix it.

By this backport you mean that the change can go alone to v5.4 kernel
(you did not write here dependency on other backport) and I wonder if
v5.4 kernel works with this patch...

> 
>>> Fixes: ba0411ddd133 ("arm64: dts: sdm845: Add device node for Last level cache controller")
>>> Reported-by: Parikshit Pareek <quic_ppareek@quicinc.com>
>>> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
>>> ---
>>>  arch/arm64/boot/dts/qcom/sdm845.dtsi | 5 +++--
>>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
>>> index 65032b94b46d..683b861e060d 100644
>>> --- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
>>> +++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
>>> @@ -2132,8 +2132,9 @@ uart15: serial@a9c000 {
>>>  
>>>  		llcc: system-cache-controller@1100000 {
>>>  			compatible = "qcom,sdm845-llcc";
>>> -			reg = <0 0x01100000 0 0x31000>, <0 0x01300000 0 0x50000>;
>>> -			reg-names = "llcc_base", "llcc_broadcast_base";
>>
>> Once property was made required, you cannot remove it. What if other
>> bindings user depends on it?
>>
>> Please instead keep/update the reg-names and/or mark it as deprecated.
>> It must stay in DTS for some time.
>>
> 
> Fair enough. I will mark it as deprecated in binding and will keep it in dts.

Best regards,
Krzysztof


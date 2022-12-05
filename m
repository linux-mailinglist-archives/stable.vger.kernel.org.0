Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3699F6423B7
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 08:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231571AbiLEHnT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 02:43:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231664AbiLEHnR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 02:43:17 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A1B13F0E
        for <stable@vger.kernel.org>; Sun,  4 Dec 2022 23:43:16 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id p8so17182089lfu.11
        for <stable@vger.kernel.org>; Sun, 04 Dec 2022 23:43:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GpteDm2gH43vBJ7G+qua6WC1qNYCXfWUrpUXxzjeBNg=;
        b=xE5FemEfKgYyDTEC250D2ecul4cDVfmaEB1eU2Q42NCeCaX1V3knt6xZARfW/vgPun
         hwFNa/trR65569K2MYODGH9obwN73UGP7VpBjJbXXAiMbBr3Yc8WtNVxFGeDGXqAs+Yx
         /E2Z1D5BjtG9V1+nfuOz3vVmfUuo83jWnBb5lX7Nj0KqNeVjt6I75J321+ONRWHIAdvE
         Lq9d1AebttMDENHkidREe34zACLiL8mdMujcZq5VALj6zFFza5nGWRfceDfbu15yn6Lc
         EUqfO4wVmKBuLb8pmQ5avYEQyZXYEVx7E55C2Cm9hzdkX9PJswMOdiuTfhpitfH46Kvq
         rEeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GpteDm2gH43vBJ7G+qua6WC1qNYCXfWUrpUXxzjeBNg=;
        b=R+ZwIsWpUPJnQy8kcz6mEhbOgJD3UmXxfuOaCkV3N79oeM7ACN7ISVPtHzF2n4VFjG
         qfZ38najBGN8XQWbJL9gO5kM8gKaAlpccHq+OhJRfcdO8cinLwq+hxF5k18pUJjHkbB+
         eYBfSYXUqp5PZuFqx0JUU5h2HRrXv/oKakGUHlyNtLIrKwqJLPPMWIiFNUnXeC6fTNrJ
         O9qKQV7LK8MOj/YIM4KPvkHeVahflL3ZYr3uGCAnXcFfLOhk1fM9eti8zAiiGVYOcmDz
         E5aaBIchEiV8uXWL9NS+3fKC1LyGDVmPPrTYLwg8cVdtQqqJQNdyoDOUxAbmJlTsCNaS
         v5Uw==
X-Gm-Message-State: ANoB5pkjkSUSedaXocZg4EbwrlAO5gr58Lcksf+Vatp5/hdZe72yoAYo
        G3dngHKrQRQteYYJzz/i8RXJIA==
X-Google-Smtp-Source: AA0mqf5Eim82q68xWNSwtZu3R6hlStfNNujvcHjYSVdIWSOfJzwTh6H7FO/Ty8/sysYrVtHlxaOFCw==
X-Received: by 2002:ac2:52b6:0:b0:4a8:df88:f4d2 with SMTP id r22-20020ac252b6000000b004a8df88f4d2mr25933550lfm.463.1670226194678;
        Sun, 04 Dec 2022 23:43:14 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id m4-20020a056512114400b00492e3c8a986sm2015761lfg.264.2022.12.04.23.43.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Dec 2022 23:43:14 -0800 (PST)
Message-ID: <d79fb2b2-6a79-8be2-e3ae-e24a7212fbaa@linaro.org>
Date:   Mon, 5 Dec 2022 08:43:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH] ARM: dts: qcom: apq8084-ifc6540: fix overriding SDHCI
Content-Language: en-US
To:     Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20221204084614.12193-1-krzysztof.kozlowski@linaro.org>
 <CAA8EJppUkXMt7nvzkWoLGqyvLSjX2Kn0D2C1AH2VJ9jBdyWKSQ@mail.gmail.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <CAA8EJppUkXMt7nvzkWoLGqyvLSjX2Kn0D2C1AH2VJ9jBdyWKSQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 04/12/2022 12:11, Dmitry Baryshkov wrote:
> On Sun, 4 Dec 2022 at 10:46, Krzysztof Kozlowski
> <krzysztof.kozlowski@linaro.org> wrote:
>>
>> While changing node names of APQ8084 SDHCI, the ones in IFC6540 board
>> were not updated leading to disabled and misconfigured SDHCI.
>>
>> Cc: <stable@vger.kernel.org>
>> Fixes: 2477d81901a2 ("ARM: dts: qcom: Fix sdhci node names - use 'mmc@'")
>> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> 
> Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> 
> Minor nit below.
> 
>> ---
>>  arch/arm/boot/dts/qcom-apq8084-ifc6540.dts | 20 ++++++++++----------
>>  arch/arm/boot/dts/qcom-apq8084.dtsi        |  4 ++--
>>  2 files changed, 12 insertions(+), 12 deletions(-)
>>
>> diff --git a/arch/arm/boot/dts/qcom-apq8084-ifc6540.dts b/arch/arm/boot/dts/qcom-apq8084-ifc6540.dts
>> index 44cd72f1b1be..116e59a3b76d 100644
>> --- a/arch/arm/boot/dts/qcom-apq8084-ifc6540.dts
>> +++ b/arch/arm/boot/dts/qcom-apq8084-ifc6540.dts
>> @@ -19,16 +19,16 @@ soc {
>>                 serial@f995e000 {
>>                         status = "okay";
>>                 };
>> +       };
>> +};
>>
>> -               sdhci@f9824900 {
>> -                       bus-width = <8>;
>> -                       non-removable;
>> -                       status = "okay";
>> -               };
>> +&sdhc_1 {
>> +       bus-width = <8>;
>> +       non-removable;
>> +       status = "okay";
>> +};
>>
>> -               sdhci@f98a4900 {
>> -                       cd-gpios = <&tlmm 122 GPIO_ACTIVE_LOW>;
>> -                       bus-width = <4>;
>> -               };
>> -       };
>> +&sdhc_2 {
>> +       cd-gpios = <&tlmm 122 GPIO_ACTIVE_LOW>;
>> +       bus-width = <4>;
> 
> Technically this will still be disabled, as there is no 'status = "okay";' here.
> 

Yes, but I think this is separate issue, not related to node renaming.
The initial patch which added these said:
"required for enabling the serial port and eMMC."
so I assume SD card controller was meant to stay disabled.

Best regards,
Krzysztof


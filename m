Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 714DE64B992
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 17:24:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235748AbiLMQYx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 11:24:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235754AbiLMQYv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 11:24:51 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B11701116
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 08:24:48 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id s10so3841380ljg.1
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 08:24:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=O9lhRP4vwAQazbZFW3dbqSAS6PGTLh/z2McBocENAxg=;
        b=StN78XuDZ9jj1i9eK3S9SBvR9+DQ2yT1cAXKfaF3wiZNHteupurkIEjCDfQsie+nOx
         m+lzMiRaA/KoTZ1zKakBMxCP9UljE6gxK6H4eZk5cmjUUK2TWeNBvZohW2Y8kkiJ2u0F
         hryC9P2VnwBNClgSjD5K/iOX0ZoVOpf0JqyTSZZfNGk3P7wAA/amsjAQ7j+2ahGmK5UB
         hD7RPxot2KvtUiRqxA33D2cIJR4g1JipBaZHxMN6AEswJm1bSmE8Gp56B0eRNnhyTaL0
         XUitJBPuY/TKmJtMKZudqrFB8atIlThip42tfXdK7jPdrk0JJ6Khq24QUgG7yyV2Gz55
         lwPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O9lhRP4vwAQazbZFW3dbqSAS6PGTLh/z2McBocENAxg=;
        b=kOrdpTPsRavhd4UGpl9qclWShNymCQs1RleB/9dasd4JbNDZbcDrGIJQwQOPXkUsS4
         lvwCuhdAHbcJv7dEZs207WFBaMNADBdm/BKjK/J1RRY9jQ9SBjWr6CoVVtArUxwbKEP1
         5sFC54oEucPzQBnbXJ6oJoNDiIIFZD2F88l/KUkAQ6E9tpcIm2kNjCUifr09jtuATr8H
         L8fpcsec+l30eyoqll7K6aycY4MOtsqYw1YhcJXeCFwgDZwVzDZNubCgey5KAC2q3v7m
         mp19YvS36m9WfOl7LfBTfkFs+nlsTd07IOLS8yRzHg2B8pXf6DBFwR1ef8Iin265sXiK
         vPsQ==
X-Gm-Message-State: ANoB5pl9tjx7WfvKiCilor6de39Z/4i6KlzfS3HkY52X4IolFv4QwbD+
        H7HfxOAJMKF7xYuKa1bVJ9IHJo5QGYeabC7h
X-Google-Smtp-Source: AA0mqf4bRoay6xz9loy59VEgInoVuNzqbHi1bApLvPMco1RzkoH6wFH02p9JxKHi+zAXV8Yy5LPjyw==
X-Received: by 2002:a05:651c:234:b0:279:e86c:7101 with SMTP id z20-20020a05651c023400b00279e86c7101mr5275011ljn.8.1670948687046;
        Tue, 13 Dec 2022 08:24:47 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id f9-20020a05651c03c900b0027b65f34947sm144620ljp.1.2022.12.13.08.24.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Dec 2022 08:24:46 -0800 (PST)
Message-ID: <aa692a69-fc8d-472e-e5ae-276c3d6d7d78@linaro.org>
Date:   Tue, 13 Dec 2022 17:24:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 02/13] dt-bindings: arm: msm: Fix register regions used
 for LLCC banks
Content-Language: en-US
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        andersson@kernel.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, bp@alien8.de,
        tony.luck@intel.com
Cc:     quic_saipraka@quicinc.com, konrad.dybcio@linaro.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        james.morse@arm.com, mchehab@kernel.org, rric@kernel.org,
        linux-edac@vger.kernel.org, quic_ppareek@quicinc.com,
        luca.weiss@fairphone.com, stable@vger.kernel.org
References: <20221212123311.146261-1-manivannan.sadhasivam@linaro.org>
 <20221212123311.146261-3-manivannan.sadhasivam@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221212123311.146261-3-manivannan.sadhasivam@linaro.org>
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

On 12/12/2022 13:33, Manivannan Sadhasivam wrote:
> Register regions of the LLCC banks are located at separate addresses.
> Currently, the binding just lists the LLCC0 base address and specifies
> the size to cover all banks. This is not the correct approach since,
> there are holes and other registers located in between.
> 
> So let's specify the base address of each LLCC bank and get rid of
> reg-names property as it is not needed anymore. It should be noted that
> the bank count differs for each SoC, so that also needs to be taken into
> account in the binding.
> 
> Cc: <stable@vger.kernel.org> # 4.19
> Fixes: 7e5700ae64f6 ("dt-bindings: Documentation for qcom, llcc")
> Reported-by: Parikshit Pareek <quic_ppareek@quicinc.com>
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
>  .../bindings/arm/msm/qcom,llcc.yaml           | 97 ++++++++++++++++---
>  1 file changed, 83 insertions(+), 14 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/arm/msm/qcom,llcc.yaml b/Documentation/devicetree/bindings/arm/msm/qcom,llcc.yaml
> index d1df49ffcc1b..260bc87629a7 100644
> --- a/Documentation/devicetree/bindings/arm/msm/qcom,llcc.yaml
> +++ b/Documentation/devicetree/bindings/arm/msm/qcom,llcc.yaml
> @@ -33,14 +33,8 @@ properties:
>        - qcom,sm8550-llcc
>  
>    reg:
> -    items:
> -      - description: LLCC base register region
> -      - description: LLCC broadcast base register region
> -
> -  reg-names:
> -    items:
> -      - const: llcc_base
> -      - const: llcc_broadcast_base
> +    minItems: 2
> +    maxItems: 9
>  
>    interrupts:
>      maxItems: 1
> @@ -48,7 +42,76 @@ properties:
>  required:
>    - compatible
>    - reg
> -  - reg-names
> +
> +allOf:
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            enum:
> +              - qcom,sc7180-llcc
> +              - qcom,sm6350-llcc
> +    then:
> +      properties:
> +        reg:
> +          items:
> +            - description: LLCC0 base register region
> +            - description: LLCC broadcast base register region
> +
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            enum:
> +              - qcom,sc7280-llcc
> +    then:
> +      properties:
> +        reg:
> +          items:
> +            - description: LLCC0 base register region
> +            - description: LLCC1 base register region
> +            - description: LLCC broadcast base register region

This will break all existing users (all systems, bootloaders/firmwares),
so you need to explain that in commit msg - why breaking is allowed, who
is or is not going to be affected etc. Otherwise judging purely by
bindings this is an ABI break.

Reason "This is not the correct approach since, there are holes and
other registers located in between." is not enough, because this
suggests previous approach was just not the best and you have something
better. Better is not a reason for ABI break.

> +
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            enum:
> +              - qcom,sc8180x-llcc
> +              - qcom,sc8280xp-llcc
> +    then:
> +      properties:
> +        reg:
> +          items:
> +            - description: LLCC0 base register region
> +            - description: LLCC1 base register region
> +            - description: LLCC2 base register region
> +            - description: LLCC3 base register region
> +            - description: LLCC4 base register region
> +            - description: LLCC5 base register region
> +            - description: LLCC6 base register region
> +            - description: LLCC7 base register region
> +            - description: LLCC broadcast base register region
> +
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            enum:
> +              - qcom,sdm845-llcc
> +              - qcom,sm8150-llcc
> +              - qcom,sm8250-llcc
> +              - qcom,sm8350-llcc
> +              - qcom,sm8450-llcc
> +    then:
> +      properties:
> +        reg:
> +          items:
> +            - description: LLCC0 base register region
> +            - description: LLCC1 base register region
> +            - description: LLCC2 base register region
> +            - description: LLCC3 base register region
> +            - description: LLCC broadcast base register region
>  
>  additionalProperties: false
>  
> @@ -56,9 +119,15 @@ examples:
>    - |
>      #include <dt-bindings/interrupt-controller/arm-gic.h>
>  
> -    system-cache-controller@1100000 {
> -      compatible = "qcom,sdm845-llcc";
> -      reg = <0x1100000 0x200000>, <0x1300000 0x50000> ;
> -      reg-names = "llcc_base", "llcc_broadcast_base";
> -      interrupts = <GIC_SPI 582 IRQ_TYPE_LEVEL_HIGH>;
> +    soc {
> +        #address-cells = <2>;
> +        #size-cells = <2>;
> +
> +        system-cache-controller@1100000 {
> +          compatible = "qcom,sdm845-llcc";

Inconsistent indentation for DTS example. Use 4 spaces for it.

> +          reg = <0 0x01100000 0 0x50000>, <0 0x01180000 0 0x50000>,
> +                <0 0x01200000 0 0x50000>, <0 0x01280000 0 0x50000>,
> +                <0 0x01300000 0 0x50000>;
> +          interrupts = <GIC_SPI 582 IRQ_TYPE_LEVEL_HIGH>;
> +        };
>      };

Best regards,
Krzysztof


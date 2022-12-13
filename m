Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F19564B9A7
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 17:27:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235911AbiLMQ1x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 11:27:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235834AbiLMQ1u (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 11:27:50 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F1BB1C2
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 08:27:48 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id g7so5785610lfv.5
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 08:27:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=woXdvljG6W0F2gMdHz14LCFXupXMTFMtu7l19E30UtY=;
        b=BaWb9PsabBqnOupjXMc2VrCXHLEnp+1e+S929J/8E69pNQs2LXdoOqTrQL63P8Q5M7
         n9/1V0N9OK9CG1HMWLBYoBzURHVQcgjUnQ56Tx5K/xp8xy9a+rbjJWoBL+kJe3Sn03US
         5PMLCg8VN/q6wGXX5S50035VVKWen9XSCXSGz2+B4EBXgJ4leFdwIBMjbh8fLDqFpWL7
         w0GCKxqCm9n+ToOSUI0x9go8ujSoeRh8/hIA6lxhInlCizwCILF0TA97OPw/94Kgy3Js
         euh1B4cYer1LZif8z2cYXc6YksR2OVKNu2r9LQTcgRL7R79SCQWdF2LXyP2Kqdfbd3mF
         TnjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=woXdvljG6W0F2gMdHz14LCFXupXMTFMtu7l19E30UtY=;
        b=1AAIipfZd7MZDSqefmnrP7G8xEHM9KuXQ/LqhqtI+4g/crHbQ7Ic/rQO6k2ePsJsZq
         qekCkqyZ/N+ItFzgqXZU3fXkFvYu5EG/XnIav9QZ+O5FtEkMcADEHPKsEpQx0fqJ1/AL
         zZcT5/NbAOo2rk+KE34gBfexGuhC2QoAltJIkTlG8GhHABIyLQlLI6ZnNFft9FXceaG6
         b5R1X6iI/pICmvR715c0WcnPKq/xl6gx41acLJ/6Wv1EUjnDNeIh3gBor0N+bScUfJ8y
         9ThLwbae9wawBB6dS6c5EHsp3Zh/+kjHB4V/CE+qjczWc8yTQHNVa1aM5RnA1YH4QL+/
         G2Rw==
X-Gm-Message-State: ANoB5plML5PJ9g5Rtjih45FS/vusZEsWGempuS/WiM2Ex/vP+DwZbKLu
        3mBv9B/qLfMK1oZ0gNkcYNRYWg==
X-Google-Smtp-Source: AA0mqf64+qMEMjCRqk36Gl1uFOD29pICo0ApyZTFGy98SpUz/pCa7KHd+BZ3IldCgQzKolzJ3OevcQ==
X-Received: by 2002:ac2:4119:0:b0:4b5:7f15:aa21 with SMTP id b25-20020ac24119000000b004b57f15aa21mr6878876lfi.52.1670948867094;
        Tue, 13 Dec 2022 08:27:47 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id q2-20020ac25142000000b0049482adb3basm427868lfd.63.2022.12.13.08.27.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Dec 2022 08:27:46 -0800 (PST)
Message-ID: <038e6569-9f8f-3b59-0243-af6dcf0c2d80@linaro.org>
Date:   Tue, 13 Dec 2022 17:27:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 03/13] arm64: dts: qcom: sdm845: Fix the base addresses
 of LLCC banks
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
 <20221212123311.146261-4-manivannan.sadhasivam@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221212123311.146261-4-manivannan.sadhasivam@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/12/2022 13:33, Manivannan Sadhasivam wrote:
> The LLCC block has several banks each with a different base address
> and holes in between. So it is not a correct approach to cover these
> banks with a single offset/size. Instead, the individual bank's base
> address needs to be specified in devicetree with the exact size.
> 
> Also, let's get rid of reg-names property as it is not needed anymore.
> The driver is expected to parse the reg field based on index to get the
> addresses of each LLCC banks.
> 
> Cc: <stable@vger.kernel.org> # 5.4

No, you cannot backport it. You will break users.

> Fixes: ba0411ddd133 ("arm64: dts: sdm845: Add device node for Last level cache controller")
> Reported-by: Parikshit Pareek <quic_ppareek@quicinc.com>
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
>  arch/arm64/boot/dts/qcom/sdm845.dtsi | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
> index 65032b94b46d..683b861e060d 100644
> --- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
> @@ -2132,8 +2132,9 @@ uart15: serial@a9c000 {
>  
>  		llcc: system-cache-controller@1100000 {
>  			compatible = "qcom,sdm845-llcc";
> -			reg = <0 0x01100000 0 0x31000>, <0 0x01300000 0 0x50000>;
> -			reg-names = "llcc_base", "llcc_broadcast_base";

Once property was made required, you cannot remove it. What if other
bindings user depends on it?

Please instead keep/update the reg-names and/or mark it as deprecated.
It must stay in DTS for some time.

Best regards,
Krzysztof


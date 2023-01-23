Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C677677C5C
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 14:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231673AbjAWNVb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 08:21:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231543AbjAWNVa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 08:21:30 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA3DA244B4
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 05:21:27 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id vw16so30356213ejc.12
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 05:21:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YsXGq+84b3tFva8sx/OXAy3zCE5skYa0ofpr2MBER4c=;
        b=eRDEYhOIGJ103mS6oZnJoO+6Moo0rdjkBf0TOJ5mG0TBUOIxJc/CtJMsqHf7Tn6UuH
         sULITttpVPB4z/TZl9rXOV5TH2C9xOTHn1+1l7IajvYiAjGBhQeFPicvAMZsDe+v2ZXy
         ze6kRY+UwbVsCacMyfFQoCs85JCLULvRBsssHbCUgu8nvfAGuHN9ADc+nAGR6+7b351U
         lVusB2tp+v8OXfrGP2lIQY1AAFlwYo6vmzoVGHg/xOX3cuuZh1rmgGhSYe/yOAXJhqes
         jLuwg5Gqcwr/EmudOw+AaKZtN/saCTd/WXyVp5aVGTbflmbm2O9J+vZQomtTg4YRRlCk
         ObVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YsXGq+84b3tFva8sx/OXAy3zCE5skYa0ofpr2MBER4c=;
        b=RqSEkg29eNlYnUWgUtA0Jr0NRB3CwTIAMY8CskC3u3Jh9uA9/efd+Y2nsVnUJR+RFQ
         mvBbbVhSM+e7uVZyPwQw+aftYKtgzK99NTro0ejrsTQFNvdq0y/T110Ja8ldNg7avMw8
         eMIksK+epoNL7cQMAITNFsDGd3q5HQsy9q2402EsAu9QDmDHuNf1JNbapIr2vlaNAVxf
         +dJGDCsVQtzuabHFwBwTji6Ev9bPqZJCDcSHJ+DVNGAVmPSrBHlu9laaICvofRiUE84X
         ilafB/JpPl9ud/2mPI+SGQaiiuy+Gc5r8QGI83I24tc9PqSE6dBmo1yscIbwrfBfB3St
         M+BQ==
X-Gm-Message-State: AFqh2krPEaV+eAaptcm2yJLeUok3GCf5dD2I2QAeK3+vKz1gNYaD58Wy
        QeDLxPJVO2cPfLgkunOcIMhSpw==
X-Google-Smtp-Source: AMrXdXvoSP7NORFjK/VvrRxhcuHbYeJ42QdKshHQmbhms89pHQrdDseSM67icmPAtdDWwLKfJneaAw==
X-Received: by 2002:a17:907:cc03:b0:7c4:f8fb:6a27 with SMTP id uo3-20020a170907cc0300b007c4f8fb6a27mr34065026ejc.0.1674480086417;
        Mon, 23 Jan 2023 05:21:26 -0800 (PST)
Received: from [192.168.1.101] (abxi24.neoplus.adsl.tpnet.pl. [83.9.2.24])
        by smtp.gmail.com with ESMTPSA id p8-20020a17090653c800b00872c0bccab2sm9742043ejo.35.2023.01.23.05.21.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jan 2023 05:21:26 -0800 (PST)
Message-ID: <8d07ba5e-6354-c2ba-bd09-5f8169732b55@linaro.org>
Date:   Mon, 23 Jan 2023 14:21:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: [PATCH 3/3] ARM: dts: qcom: sdx65: Add Qcom SMMU-500 as the
 fallback for IOMMU node
Content-Language: en-US
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        andersson@kernel.org, will@kernel.org, joro@8bytes.org,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org
Cc:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
        dmitry.baryshkov@linaro.org, stable@vger.kernel.org
References: <20230123131931.263024-1-manivannan.sadhasivam@linaro.org>
 <20230123131931.263024-4-manivannan.sadhasivam@linaro.org>
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <20230123131931.263024-4-manivannan.sadhasivam@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 23.01.2023 14:19, Manivannan Sadhasivam wrote:
> SDX65 uses the Qcom version of the SMMU-500 IP. So use "qcom,smmu-500"
> compatible as the fallback to the SoC specific compatible.
> 
> Cc: <stable@vger.kernel.org> # 5.19
> Fixes: 98187f7b74bf ("ARM: dts: qcom: sdx65: Enable ARM SMMU")
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>

Konrad
>  arch/arm/boot/dts/qcom-sdx65.dtsi | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/qcom-sdx65.dtsi b/arch/arm/boot/dts/qcom-sdx65.dtsi
> index b073e0c63df4..408c4b87d44b 100644
> --- a/arch/arm/boot/dts/qcom-sdx65.dtsi
> +++ b/arch/arm/boot/dts/qcom-sdx65.dtsi
> @@ -455,7 +455,7 @@ pil-reloc@94c {
>  		};
>  
>  		apps_smmu: iommu@15000000 {
> -			compatible = "qcom,sdx65-smmu-500", "arm,mmu-500";
> +			compatible = "qcom,sdx65-smmu-500", "qcom,smmu-500", "arm,mmu-500";
>  			reg = <0x15000000 0x40000>;
>  			#iommu-cells = <2>;
>  			#global-interrupts = <1>;

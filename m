Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E71264B9B8
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 17:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235884AbiLMQaQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 11:30:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235505AbiLMQaO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 11:30:14 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 313A71FCFD
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 08:30:13 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id x28so5791015lfn.6
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 08:30:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/3SSmm/UrY9ov0YZBX9cLDjY5MgUVcBzj1GBqULYveA=;
        b=gepmD4P5WmaNihLk4FLDqomNV87KQP+3LlASTHvoA2eFcfvo/ed0fb9i5qx4ghQcw9
         E0c3CeC5AY7ZgILK4aKW6BbihZcSppuu7JLcTFjHRLLuJgSLn8oTe+ZLuYhSYEcdgHtO
         DTVxEsZHkOU3JArxgshFX9BTcMshDrAl061n7BE2Ex8STa2wVEiv3EnbJDimGGqaXBQF
         CTuGIGsFM4E2Cc/v0YHb7QxRfuzToRaXvOY13jSk8b97UkawHuW57qtv9mJNi6NoWWbY
         OfA9ZS1izz3BwPd6GzJMP8JI/4N8HS1xsabtJrktbx6WW0wfpPw/0YDSCd0ITpehnWFG
         kjtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/3SSmm/UrY9ov0YZBX9cLDjY5MgUVcBzj1GBqULYveA=;
        b=YXZxnez2LIJ5faOVnaByBHwOGEBuc0CuPiZUOBRtk7Rm/9AQaVJv6WnQt4tnwUpb9e
         mdDcO72DKc8cn8zr3l9SRF6MqqMLyP3sDjA3Yvg5IZJ0fqNZ2Fk8SfGC3cZoefXEKHb7
         xPNtfOGgEbXTHRbzpyki9gwXzYa4iZG4An9YVfU7zl1vLwMUBATrrvs9MD4aNOClA6WX
         VgfnCMwSKpFovFbjEa3AOfnTga1+YFt6GJ798ebRboY8FSk/VzmSr1VYuDrFypppY05O
         r7bka7HrlF/Gv3fC+vc41RxWGJ6ZVPp2+pGodyIZq5iomN4HfMIxH+61SFPEOOWWptXj
         zyiQ==
X-Gm-Message-State: ANoB5pkOtsJ04n2mhNNrhauyEIxOrphplNKvyaC/UgpoyFmuLR0uKvgr
        lUTC9J3Mu8Vz6hwuxbDwqHG13xcFCxOnFUXW
X-Google-Smtp-Source: AA0mqf5QSLmfigRkLLT+tYJeVGs57UO57i8jBpV/wkL/rUs/C66Kzm9lt9pLeU8yVNXpkoSHB6LQfA==
X-Received: by 2002:ac2:5bc9:0:b0:4b5:76a2:8ad4 with SMTP id u9-20020ac25bc9000000b004b576a28ad4mr5922231lfn.0.1670949011589;
        Tue, 13 Dec 2022 08:30:11 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id t27-20020ac24c1b000000b004a0589786ddsm430835lfq.69.2022.12.13.08.30.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Dec 2022 08:30:11 -0800 (PST)
Message-ID: <e57ffec7-6757-5cd8-7764-28f6edb95985@linaro.org>
Date:   Tue, 13 Dec 2022 17:30:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 04/13] arm64: dts: qcom: sc7180: Remove reg-names
 property from LLCC node
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
 <20221212123311.146261-5-manivannan.sadhasivam@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221212123311.146261-5-manivannan.sadhasivam@linaro.org>
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
> On SC7180, there is only one LLCC bank available. So only change needed is
> to remove the reg-names property from LLCC node to conform to the binding.
> 
> The driver is expected to parse the reg field based on index to get the
> addresses of each LLCC banks.
> 
> Cc: <stable@vger.kernel.org> # 5.6

Oh, no, there is no single bug here. Binding from v5.6+ (which cannot be
changed) required/defined such reg-names. This is neither a bug nor
possible to backport.

> Fixes: c831fa299996 ("arm64: dts: qcom: sc7180: Add Last level cache controller node")

Drop.

> Reported-by: Parikshit Pareek <quic_ppareek@quicinc.com>
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
>  arch/arm64/boot/dts/qcom/sc7180.dtsi | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sc7180.dtsi b/arch/arm64/boot/dts/qcom/sc7180.dtsi
> index f71cf21a8dd8..b0d524bbf051 100644
> --- a/arch/arm64/boot/dts/qcom/sc7180.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sc7180.dtsi
> @@ -2759,7 +2759,6 @@ dc_noc: interconnect@9160000 {
>  		system-cache-controller@9200000 {
>  			compatible = "qcom,sc7180-llcc";
>  			reg = <0 0x09200000 0 0x50000>, <0 0x09600000 0 0x50000>;
> -			reg-names = "llcc_base", "llcc_broadcast_base";

That's an ABI break...

>  			interrupts = <GIC_SPI 582 IRQ_TYPE_LEVEL_HIGH>;
>  		};
>  

Best regards,
Krzysztof


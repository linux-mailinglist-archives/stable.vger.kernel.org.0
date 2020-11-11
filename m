Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8989C2AF280
	for <lists+stable@lfdr.de>; Wed, 11 Nov 2020 14:48:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbgKKNsJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Nov 2020 08:48:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726854AbgKKNrd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Nov 2020 08:47:33 -0500
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D071C0613D1;
        Wed, 11 Nov 2020 05:47:31 -0800 (PST)
Received: by mail-lf1-x143.google.com with SMTP id v144so3157593lfa.13;
        Wed, 11 Nov 2020 05:47:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YBHMNmAOhYdHvBHjnStemujfpU3IXRUzuSHXrC3Zax0=;
        b=ZZQkLQM8NNjkbIRP3s5mXJa/90H1xB+lYkX/FspeQruHDmbVRV32zpRoG5PJB4T5Ji
         Mb9l+3zYUIWpTm4DQfWkVsVvA8qHcYG3L8t0x88ydanm8ljeX+69uR4szGvVc+fLJBuu
         dZ0yDkM4q3jgjaStXdPuQIq5unESa/+e8OevoKIA4MCsc4MpPFaxDg94R5y2lABk/dFe
         pw3JWoTP9f9xXO8JW3le5NeP6K5dvvmdPh6x77yoTaqVxQ053ldLOoQlvlH/PGi16xgn
         RGlEtHpgKrbgCjfvzmc/cQDOXsoEHTAlSCU9rF2ubcvUKJZgZYcL06GDY3yG0qC+KQyY
         BqAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YBHMNmAOhYdHvBHjnStemujfpU3IXRUzuSHXrC3Zax0=;
        b=MKSUhNBpCUDgOFYRFN3S5dG7LyXZznQZ29tlha3/iSC5TyFPHyvTE1unCxRA575KZ/
         o4rWDzeEi2FLDQHJtry7tLyJL95pFAlEy/0/IKpNM81Ucj7Z0fDfIcqhIRdrWsEgwFRn
         SGcYKPT/EAmUBucZpTHPqqlCIIAQL7KKTlGJn2IIfVdxbb6FV/wTwP+99snLLccNKmBV
         EHm2745m7txfNOc0dzmt9m2dbQqD+QdtDsqU0leQoBrCpharC224Rpc2XRqTajvUVCBH
         RuSjnW8w1a9lYXflQ/KamHN7Z8C9jBl5b10ObfQA/KbM0Iixl9xHBqpG7uuVb9BzjjmV
         LAqw==
X-Gm-Message-State: AOAM531NLWLUpKrzAioB6ulEbtXHLATMFF30Q08Hd4C/IYBrGwG1uS5H
        Y4+Hs/doHyxGsx4lkQNHVlEioZcBtis=
X-Google-Smtp-Source: ABdhPJz1/b/zPAQ3KPPZ/x+HTmaWiJjAvrsEWiPZes7SQg69AfTivBIpYr5HUtTo/l2OpD232Rt3gg==
X-Received: by 2002:ac2:57c7:: with SMTP id k7mr10005249lfo.20.1605102449554;
        Wed, 11 Nov 2020 05:47:29 -0800 (PST)
Received: from [192.168.2.145] (109-252-193-159.dynamic.spd-mgts.ru. [109.252.193.159])
        by smtp.googlemail.com with ESMTPSA id 16sm223765lfk.186.2020.11.11.05.47.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2020 05:47:28 -0800 (PST)
Subject: Re: [PATCH] ARM: tegra: Populate OPP table for Tegra20 Ventana
To:     Jon Hunter <jonathanh@nvidia.com>,
        Rob Herring <robh+dt@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>
Cc:     devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20201111103847.152721-1-jonathanh@nvidia.com>
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <7e40cd3e-7c34-c9a9-bf00-ba7d507a2d6b@gmail.com>
Date:   Wed, 11 Nov 2020 16:47:27 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.2
MIME-Version: 1.0
In-Reply-To: <20201111103847.152721-1-jonathanh@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

11.11.2020 13:38, Jon Hunter пишет:
> Commit 9ce274630495 ("cpufreq: tegra20: Use generic cpufreq-dt driver
> (Tegra30 supported now)") update the Tegra20 CPUFREQ driver to use the
> generic CPUFREQ device-tree driver. Since this change CPUFREQ support
> on the Tegra20 Ventana platform has been broken because the necessary
> device-tree nodes with the operating point information are not populated
> for this platform. Fix this by updating device-tree for Venata to
> include the operating point informration for Tegra20.
> 
> Fixes: 9ce274630495 ("cpufreq: tegra20: Use generic cpufreq-dt driver (Tegra30 supported now)")
> Cc: stable@vger.kernel.org
> 
> Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
> ---
>  arch/arm/boot/dts/tegra20-ventana.dts | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/tegra20-ventana.dts b/arch/arm/boot/dts/tegra20-ventana.dts
> index b158771ac0b7..055334ae3d28 100644
> --- a/arch/arm/boot/dts/tegra20-ventana.dts
> +++ b/arch/arm/boot/dts/tegra20-ventana.dts
> @@ -3,6 +3,7 @@
>  
>  #include <dt-bindings/input/input.h>
>  #include "tegra20.dtsi"
> +#include "tegra20-cpu-opp.dtsi"
>  
>  / {
>  	model = "NVIDIA Tegra20 Ventana evaluation board";
> @@ -592,6 +593,16 @@ clk32k_in: clock@0 {
>  		#clock-cells = <0>;
>  	};
>  
> +	cpus {
> +		cpu0: cpu@0 {
> +			operating-points-v2 = <&cpu0_opp_table>;
> +		};
> +
> +		cpu@1 {
> +			operating-points-v2 = <&cpu0_opp_table>;
> +		};
> +	};
> +
>  	gpio-keys {
>  		compatible = "gpio-keys";
>  
> 

This could be wrong to do because CPU voltage is fixed to 1000mV in
Ventana's DT, are you sure that higher clock rates don't require higher
voltages? What is the CPU process ID and SoC speedo ID on Ventana?

You could easily hook up CPU voltage scaling, please see acer-500 DT and
patch [1] for examples of how to set up regulators in DT. But then it
shouldn't be a stable patch.

[1]
https://patchwork.ozlabs.org/project/linux-tegra/patch/20201104234427.26477-27-digetx@gmail.com/

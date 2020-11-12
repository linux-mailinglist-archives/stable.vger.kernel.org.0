Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 387422B0323
	for <lists+stable@lfdr.de>; Thu, 12 Nov 2020 11:51:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbgKLKv0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Nov 2020 05:51:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726776AbgKLKvZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Nov 2020 05:51:25 -0500
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F3A1C0613D1;
        Thu, 12 Nov 2020 02:51:25 -0800 (PST)
Received: by mail-lj1-x243.google.com with SMTP id l10so5557701lji.4;
        Thu, 12 Nov 2020 02:51:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ko0Hen9xgaMvsVz22vy0N1Bw1MmjjCfm//RLZdh5Ix8=;
        b=LPh4+MZNokEWonIni3ZCTu6odNHux9zEsd4ClN9OceJOADqpT2H0Xz7Rp+iD7yOivi
         3MKl/vtsXpB9dqAR8HFyp11eNrmPkJ6CNfjRC4ftuMgL/czjicmgi0SGguihWckbiO09
         1SOkAYTFUbWiajY2p1UjfWC3vg0VvvSQuYvERAdh9DqFR96PU9L+yElqLUJPTm/GVjDW
         I6V9XIQYZHORg9datYkQ8BNKweLUxWH3gjbLmBVYDIXjCEzXD09TwKXIqumrWbvkd98W
         z4yvE4J5SHGxs9sBaG+GfK5fcQDxSzBsqvUlrt9AypnTC0GECcfPHQrf2EjldFc56VZw
         abMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ko0Hen9xgaMvsVz22vy0N1Bw1MmjjCfm//RLZdh5Ix8=;
        b=rnTWHeGy6/kyjW324nMLvPuV7bm4nlfDuciroDuKcaO4Ie3kkXUNTxbOCaYTRfI+GQ
         3lc+hDxIOMcrnUK19Vi0PvltLi7/dEpQFsfJuW3o9HaukvYmkYVEreq5fm0ShKxb6ZL0
         UHRN1FH4XnOuYokCwerRNJLbuAbE5bjRDipWDZ3ffIpy5pXl74GNwNKDCdUZOeGFh9RU
         oWFxMpj726R6nKihQFh0wxKeUtRakV5lYOap8ovnnFw4YDP9j43vsaIdKPH6C/3YKAIF
         /0jseCMr+96yjO5CCaHGRCOVtNMQlBgcXR3ZmalQbdMp6y4ta6oSo4M19GkKqFmsZ8sP
         z3Nw==
X-Gm-Message-State: AOAM533g/cfrTnQ2QFezF2lTUJgg1aj5jqZfxC5psfoLH0BUEQ15Vujp
        lMKjUhuHQJoMGC9TFMIaCzQqH4p9Ji8=
X-Google-Smtp-Source: ABdhPJx5jh8tGHEuJkyGBvzo+p6Dj1SKhoFVTyWjBdyt/XAQJ8z7s9E0l5okKEl+Ehy5UU5etZocEw==
X-Received: by 2002:a2e:7a18:: with SMTP id v24mr6174698ljc.224.1605178283664;
        Thu, 12 Nov 2020 02:51:23 -0800 (PST)
Received: from [192.168.2.145] (109-252-193-159.dynamic.spd-mgts.ru. [109.252.193.159])
        by smtp.googlemail.com with ESMTPSA id b13sm504831ljf.107.2020.11.12.02.51.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Nov 2020 02:51:22 -0800 (PST)
Subject: Re: [PATCH] ARM: tegra: Populate OPP table for Tegra20 Ventana
To:     Jon Hunter <jonathanh@nvidia.com>,
        Rob Herring <robh+dt@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>
Cc:     devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20201111103847.152721-1-jonathanh@nvidia.com>
 <7e40cd3e-7c34-c9a9-bf00-ba7d507a2d6b@gmail.com>
 <5409bbb4-d3f9-ccc9-ac3e-6344975bd58e@nvidia.com>
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <acadbf40-5dea-eee1-b05e-ad788df56bf7@gmail.com>
Date:   Thu, 12 Nov 2020 13:51:21 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.2
MIME-Version: 1.0
In-Reply-To: <5409bbb4-d3f9-ccc9-ac3e-6344975bd58e@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

11.11.2020 23:31, Jon Hunter пишет:
> 
> On 11/11/2020 13:47, Dmitry Osipenko wrote:
>> 11.11.2020 13:38, Jon Hunter пишет:
>>> Commit 9ce274630495 ("cpufreq: tegra20: Use generic cpufreq-dt driver
>>> (Tegra30 supported now)") update the Tegra20 CPUFREQ driver to use the
>>> generic CPUFREQ device-tree driver. Since this change CPUFREQ support
>>> on the Tegra20 Ventana platform has been broken because the necessary
>>> device-tree nodes with the operating point information are not populated
>>> for this platform. Fix this by updating device-tree for Venata to
>>> include the operating point informration for Tegra20.
>>>
>>> Fixes: 9ce274630495 ("cpufreq: tegra20: Use generic cpufreq-dt driver (Tegra30 supported now)")
>>> Cc: stable@vger.kernel.org
>>>
>>> Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
>>> ---
>>>  arch/arm/boot/dts/tegra20-ventana.dts | 11 +++++++++++
>>>  1 file changed, 11 insertions(+)
>>>
>>> diff --git a/arch/arm/boot/dts/tegra20-ventana.dts b/arch/arm/boot/dts/tegra20-ventana.dts
>>> index b158771ac0b7..055334ae3d28 100644
>>> --- a/arch/arm/boot/dts/tegra20-ventana.dts
>>> +++ b/arch/arm/boot/dts/tegra20-ventana.dts
>>> @@ -3,6 +3,7 @@
>>>  
>>>  #include <dt-bindings/input/input.h>
>>>  #include "tegra20.dtsi"
>>> +#include "tegra20-cpu-opp.dtsi"
>>>  
>>>  / {
>>>  	model = "NVIDIA Tegra20 Ventana evaluation board";
>>> @@ -592,6 +593,16 @@ clk32k_in: clock@0 {
>>>  		#clock-cells = <0>;
>>>  	};
>>>  
>>> +	cpus {
>>> +		cpu0: cpu@0 {
>>> +			operating-points-v2 = <&cpu0_opp_table>;
>>> +		};
>>> +
>>> +		cpu@1 {
>>> +			operating-points-v2 = <&cpu0_opp_table>;
>>> +		};
>>> +	};
>>> +
>>>  	gpio-keys {
>>>  		compatible = "gpio-keys";
>>>  
>>>
>>
>> This could be wrong to do because CPU voltage is fixed to 1000mV in
>> Ventana's DT, are you sure that higher clock rates don't require higher
>> voltages? What is the CPU process ID and SoC speedo ID on Ventana?
> 
> I see this in the bootlog ...
> 
> [    2.797684] tegra20-cpufreq tegra20-cpufreq: hardware version 0x2 0x2
> 
>> You could easily hook up CPU voltage scaling, please see acer-500 DT and
>> patch [1] for examples of how to set up regulators in DT. But then it
>> shouldn't be a stable patch.
> 
> According to the Ventana design guide the CPU voltage range is 0.8-1.0V
> and so it appears to be set to the max. The CPUFREQ test is reporting
> the following ...
> 
> cpu: cpufreq: - CPU#0:
> cpu: cpufreq:   - supported governors:
> cpu: cpufreq:     - ondemand *
> cpu: cpufreq:     - performance
> cpu: cpufreq:     - schedutil
> cpu: cpufreq:   - supported rates:
> cpu: cpufreq:     -  216000
> cpu: cpufreq:     -  312000
> cpu: cpufreq:     -  456000
> cpu: cpufreq:     -  608000
> cpu: cpufreq:     -  760000
> cpu: cpufreq:     -  816000
> cpu: cpufreq:     -  912000
> cpu: cpufreq:     - 1000000 *
> cpu: cpufreq: - CPU#1:
> cpu: cpufreq:   - supported governors:
> cpu: cpufreq:     - ondemand *
> cpu: cpufreq:     - performance
> cpu: cpufreq:     - schedutil
> cpu: cpufreq:   - supported rates:
> cpu: cpufreq:     -  216000
> cpu: cpufreq:     -  312000
> cpu: cpufreq:     -  456000
> cpu: cpufreq:     -  608000
> cpu: cpufreq:     -  760000
> cpu: cpufreq:     -  816000
> cpu: cpufreq:     -  912000
> cpu: cpufreq:     - 1000000 *

If you don't see a message in KMSG saying "bringing vdd_cpu to
1000000uV", then should be good.

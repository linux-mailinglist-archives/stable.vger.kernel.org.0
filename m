Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42E302B04B7
	for <lists+stable@lfdr.de>; Thu, 12 Nov 2020 13:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727789AbgKLMLd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Nov 2020 07:11:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726969AbgKLMLd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Nov 2020 07:11:33 -0500
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01916C0613D1;
        Thu, 12 Nov 2020 04:11:33 -0800 (PST)
Received: by mail-lf1-x142.google.com with SMTP id l2so8086143lfk.0;
        Thu, 12 Nov 2020 04:11:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qDQm3rNb54SkhUlNL8RpgRXOxU1huiUJ9bj0ejS8kCk=;
        b=AkrS6kZLgOxeYWXwGqpnfRdxsFJC8kUVrNHqC+x66hKRlbQKyI02IkvnEQXgS+Mpqv
         wfUomJ2OUUNHkIOUnFqPihpisPDQBLBk8peJrFHfZlz59JxQ69BJ7N4Uf77rkP5Xf82t
         qsFNugShHOgnDKzU1zIymdgWbVHdOhoRwVt5aKbx7AxfBiAWNqtDaBdlNFKl5bo/Efot
         z8wGvsipy2d3YYrx09ALDYA55yCpyVnehUR5SnF+mvX3oXH6JhznejwjEz4jNHJoqQEe
         9am6xJ4Cj4V0a2eXaE68zLYHUIwOKgKVofDGlctulPFTKSJo4a8/iKz+pm0pAuZykR9m
         0DTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qDQm3rNb54SkhUlNL8RpgRXOxU1huiUJ9bj0ejS8kCk=;
        b=UQS7AZzEFRRXQrmw9XH4wAOgtB+deU2ilPHNrh8XNKQshvPxYsrhZoRxtd/hRyovS0
         zPSiT8e5FKQFapRBL5fYOdNF4zTxmNerA06xdDION3XHS1criGoW1UBDDU7uwq59a1gy
         FKpBNJDcxz3C+F1Bq5Gd4zUcxH983/qciu4pKbaKUafrGpmRMSAVKqF2fgAXU2XnK50W
         zlrqqHCU0mF0kymnHdQlv3lwVElxsqHKLL++/1nAlJVdUL0tyMO8ZGYBKXLFniucNpMj
         ffGXDI/Lb6HTKvgPQbdm76WiWHgjKYnYGkjFE8fdtQSgokXu/PV5huVqn2GYhNpD1k8r
         e3GQ==
X-Gm-Message-State: AOAM5332WS37cnyxvIRW2Q/ddDPlBmUfXif5jNEY5/9JLsEtmf5lTrEd
        zyZW7/9TbEMs/iqHt+BGfC7jms5jbv0=
X-Google-Smtp-Source: ABdhPJy+/o28hDjr4pTZgv+xJ0krk9L41w8CiLD43sF8UIQDD5r7aDtBz54XuH9pd5SDQlDjxUTdmA==
X-Received: by 2002:a19:794:: with SMTP id 142mr4117210lfh.232.1605183091360;
        Thu, 12 Nov 2020 04:11:31 -0800 (PST)
Received: from [192.168.2.145] (109-252-193-159.dynamic.spd-mgts.ru. [109.252.193.159])
        by smtp.googlemail.com with ESMTPSA id t9sm20051lfe.274.2020.11.12.04.11.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Nov 2020 04:11:30 -0800 (PST)
Subject: Re: [PATCH] ARM: tegra: Populate OPP table for Tegra20 Ventana
To:     Jon Hunter <jonathanh@nvidia.com>,
        Rob Herring <robh+dt@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>
Cc:     devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20201111103847.152721-1-jonathanh@nvidia.com>
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <ea73403a-a248-cd2e-b0af-aeb246801054@gmail.com>
Date:   Thu, 12 Nov 2020 15:11:29 +0300
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

I assume you're going to use this cpu0 handle later on.

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

Reviewed-by: Dmitry Osipenko <digetx@gmail.com>

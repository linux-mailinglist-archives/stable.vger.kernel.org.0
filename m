Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D06371600E5
	for <lists+stable@lfdr.de>; Sat, 15 Feb 2020 23:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgBOWJq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Feb 2020 17:09:46 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40444 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726254AbgBOWJq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Feb 2020 17:09:46 -0500
Received: by mail-wm1-f66.google.com with SMTP id t14so14573427wmi.5;
        Sat, 15 Feb 2020 14:09:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pV5h97MNxHxkkK0UrPHKNsf49IPoLGjEnz9UH7Yxj7k=;
        b=OBXEsoSz04atlVd2M/vfeUWlKK0oHCmL8ZEHWd48BoTu/chH9N0uT9YjA3p5dzRvjw
         gcLWXA5tyAuSvDnQK+kJqkjSZlxjNS43KMwBaWIHCObwBADkIH4hyji3JDjAOh72jxwg
         nY5nh2IDkjYV0Tn4qgTwBI3E+FszZsl00F3XBJpOygmZ3ZMn0MU/GAmN46E1vnCmEkkB
         zMlrIk0jxONOQDWfaCRZf69aBPa1E2mGaBBEz4JOtfE0+67z34EYOtsWVbl1AoHkGNcW
         l//jE2JSuND4pJha6Sxz4MxRhqxzT/L+9udvT2kcRvoQGcKjl6LdvcLqjz3WVzqXg1am
         D1sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=pV5h97MNxHxkkK0UrPHKNsf49IPoLGjEnz9UH7Yxj7k=;
        b=C6DfZnWL5L2AZH79L1Rb777EIhnbWhGU63I8I1srMcZVeoTDho4+zHg8zgwAMbXmTa
         gmRj823AMAKxgi0OGO6/tsNwAKRN71T0aFTUW/AlKaMSWe7UIQUKCx6IqG9UvOHzTy8B
         IPds/VuSh+kbJvWLU26h7ArCsX5SDOdUhX8cmCNhhrGGAuKSBR90d2m2KTSr07ePfEKh
         ySgHczDzRNiweyCnj+7kHIj0lnhT3SpioTG2j9bZpTGTzT9Q/PlBf/aV+OV/v2aRlDjF
         j3Y1DcqEV8HQSU5IA60oni0y9hVj1ZWPagB5tZCmhlIPdlndvjLsoNl7fQMW3eZYRonE
         qjHg==
X-Gm-Message-State: APjAAAXk0lBa0Iw9c97tZc0LCGNDAhNISG/BBH8GFQMuc8CkA9pEIM+E
        5xKhM3Iqwj1jaymiDBAApBnvAoTckIM=
X-Google-Smtp-Source: APXvYqygAbdQOBLLH87uesPw+e5BZ5CbqhCXhsRyodruomeLucivLeCTM1fPCC+dLDVFb6WhGz7vwg==
X-Received: by 2002:a1c:4c13:: with SMTP id z19mr12175419wmf.75.1581804583113;
        Sat, 15 Feb 2020 14:09:43 -0800 (PST)
Received: from [192.168.1.35] (78.red-88-21-202.staticip.rima-tde.net. [88.21.202.78])
        by smtp.gmail.com with ESMTPSA id j15sm9109610wrp.9.2020.02.15.14.09.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Feb 2020 14:09:42 -0800 (PST)
Subject: Re: [PATCH] MIPS: ingenic: DTS: Fix watchdog nodes
To:     Paul Cercueil <paul@crapouillou.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paulburton@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Cc:     Zhou Yanjie <zhouyanjie@wanyeetech.com>, od@zcrc.me,
        linux-mips@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20200211145337.16311-1-paul@crapouillou.net>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
Autocrypt: addr=f4bug@amsat.org; keydata=
 mQINBDU8rLoBEADb5b5dyglKgWF9uDbIjFXU4gDtcwiga9wJ/wX6xdhBqU8tlQ4BroH7AeRl
 u4zXP0QnBDAG7EetxlQzcfYbPmxFISWjckDBFvDbFsojrZmwF2/LkFSzlvKiN5KLghzzJhLO
 HhjGlF8deEZz/d/G8qzO9mIw8GIBS8uuWh6SIcG/qq7+y+2+aifaj92EdwU79apZepT/U3vN
 YrfcAuo1Ycy7/u0hJ7rlaFUn2Fu5KIgV2O++hHYtCCQfdPBg/+ujTL+U+sCDawCyq+9M5+LJ
 ojCzP9rViLZDd/gS6jX8T48hhidtbtsFRj/e9QpdZgDZfowRMVsRx+TB9yzjFdMO0YaYybXp
 dg/wCUepX5xmDBrle6cZ8VEe00+UQCAU1TY5Hs7QFfBbjgR3k9pgJzVXNUKcJ9DYQP0OBH9P
 ZbZvM0Ut2Bk6bLBO5iCVDOco0alrPkX7iJul2QWBy3Iy9j02GnA5jZ1Xtjr9kpCqQT+sRXso
 Vpm5TPGWaWljIeLWy/qL8drX1eyJzwTB3A36Ck4r3YmjMjfmvltSZB1uAdo1elHTlFEULpU/
 HiwvvqXQ9koB15U154VCuguvx/Qnboz8GFb9Uw8VyawzVxYVNME7xw7CQF8FYxzj6eI7rBf2
 Dj/II6wxWPgDEy3oUzuNOxTB7sT3b/Ym76yOJzWX5BylXQIJ5wARAQABtDFQaGlsaXBwZSBN
 YXRoaWV1LURhdWTDqSAoRjRCVUcpIDxmNGJ1Z0BhbXNhdC5vcmc+iQJVBBMBCAA/AhsPBgsJ
 CAcDAgYVCAIJCgsEFgIDAQIeAQIXgBYhBPqr514SkXIh3P1rsuPjLCzercDeBQJd660aBQks
 klzgAAoJEOPjLCzercDe2iMP+gMG2dUf+qHz2uG8nTBGMjgK0aEJrKVPodFA+iedQ5Kp3BMo
 jrTg3/DG1HMYdcvQu/NFLYwamUfUasyor1k+3dB23hY09O4xOsYJBWdilkBGsJTKErUmkUO2
 3J/kawosvYtJJSHUpw3N6mwz/iWnjkT8BPp7fFXSujV63aZWZINueTbK7Y8skFHI0zpype9s
 loU8xc4JBrieGccy3n4E/kogGrTG5jcMTNHZ106DsQkhFnjhWETp6g9xOKrzZQbETeRBOe4P
 sRsY9YSG2Sj+ZqmZePvO8LyzGRjYU7T6Z80S1xV0lH6KTMvq7vvz5rd92f3pL4YrXq+e//HZ
 JsiLen8LH/FRhTsWRgBtNYkOsd5F9NvfJtSM0qbX32cSXMAStDVnS4U+H2vCVCWnfNug2TdY
 7v4NtdpaCi4CBBa3ZtqYVOU05IoLnlx0miKTBMqmI05kpgX98pi2QUPJBYi/+yNu3fjjcuS9
 K5WmpNFTNi6yiBbNjJA5E2qUKbIT/RwQFQvhrxBUcRCuK4x/5uOZrysjFvhtR8YGm08h+8vS
 n0JCnJD5aBhiVdkohEFAz7e5YNrAg6kOA5IVRHB44lTBOatLqz7ntwdGD0rteKuHaUuXpTYy
 CRqCVAKqFJtxhvJvaX0vLS1Z2dwtDwhjfIdgPiKEGOgCNGH7R8l+aaM4OPOd
Message-ID: <09a1d877-aee7-3f2d-8f82-6f7ba00e9cf6@amsat.org>
Date:   Sat, 15 Feb 2020 23:09:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200211145337.16311-1-paul@crapouillou.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/11/20 3:53 PM, Paul Cercueil wrote:
> The devicetree ABI was broken on purpose by commit 6d532143c915
> ("watchdog: jz4740: Use regmap provided by TCU driver"), and
> commit 1d9c30745455 ("watchdog: jz4740: Use WDT clock provided
> by TCU driver"). The commit message of the latter explains why the ABI
> was broken.
> 
> However, the current devicetree files were not updated to the new ABI
> described in Documentation/devicetree/bindings/timer/ingenic,tcu.txt,
> so the watchdog driver would not probe.
> 
> Fix this problem by updating the watchdog nodes to comply with the new
> ABI.
> 
> Fixes: 6d532143c915 ("watchdog: jz4740: Use regmap provided by TCU
> driver")
> 
> Signed-off-by: Paul Cercueil <paul@crapouillou.net>
> Cc: stable@vger.kernel.org
> ---
>  arch/mips/boot/dts/ingenic/jz4740.dtsi | 17 +++++++++--------
>  arch/mips/boot/dts/ingenic/jz4780.dtsi | 17 +++++++++--------
>  2 files changed, 18 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/mips/boot/dts/ingenic/jz4740.dtsi b/arch/mips/boot/dts/ingenic/jz4740.dtsi
> index 5accda2767be..a3301bab9231 100644
> --- a/arch/mips/boot/dts/ingenic/jz4740.dtsi
> +++ b/arch/mips/boot/dts/ingenic/jz4740.dtsi
> @@ -1,5 +1,6 @@
>  // SPDX-License-Identifier: GPL-2.0
>  #include <dt-bindings/clock/jz4740-cgu.h>
> +#include <dt-bindings/clock/ingenic,tcu.h>
>  
>  / {
>  	#address-cells = <1>;
> @@ -45,14 +46,6 @@ cgu: jz4740-cgu@10000000 {
>  		#clock-cells = <1>;
>  	};
>  
> -	watchdog: watchdog@10002000 {
> -		compatible = "ingenic,jz4740-watchdog";
> -		reg = <0x10002000 0x10>;
> -
> -		clocks = <&cgu JZ4740_CLK_RTC>;
> -		clock-names = "rtc";
> -	};
> -
>  	tcu: timer@10002000 {
>  		compatible = "ingenic,jz4740-tcu", "simple-mfd";
>  		reg = <0x10002000 0x1000>;
> @@ -73,6 +66,14 @@ &cgu JZ4740_CLK_PCLK
>  
>  		interrupt-parent = <&intc>;
>  		interrupts = <23 22 21>;
> +
> +		watchdog: watchdog@0 {
> +			compatible = "ingenic,jz4740-watchdog";
> +			reg = <0x0 0xc>;

Now the WDT_TCSR register is directly managed by the CPU, OK.

Reviewed-by: Philippe Mathieu-Daudé <f4bug@amsat.org>

> +
> +			clocks = <&tcu TCU_CLK_WDT>;
> +			clock-names = "wdt";
> +		};
>  	};
>  
>  	rtc_dev: rtc@10003000 {
> diff --git a/arch/mips/boot/dts/ingenic/jz4780.dtsi b/arch/mips/boot/dts/ingenic/jz4780.dtsi
> index f928329b034b..bb89653d16a3 100644
> --- a/arch/mips/boot/dts/ingenic/jz4780.dtsi
> +++ b/arch/mips/boot/dts/ingenic/jz4780.dtsi
> @@ -1,5 +1,6 @@
>  // SPDX-License-Identifier: GPL-2.0
>  #include <dt-bindings/clock/jz4780-cgu.h>
> +#include <dt-bindings/clock/ingenic,tcu.h>
>  #include <dt-bindings/dma/jz4780-dma.h>
>  
>  / {
> @@ -67,6 +68,14 @@ &cgu JZ4780_CLK_EXCLK
>  
>  		interrupt-parent = <&intc>;
>  		interrupts = <27 26 25>;
> +
> +		watchdog: watchdog@0 {
> +			compatible = "ingenic,jz4780-watchdog";
> +			reg = <0x0 0xc>;
> +
> +			clocks = <&tcu TCU_CLK_WDT>;
> +			clock-names = "wdt";
> +		};
>  	};
>  
>  	rtc_dev: rtc@10003000 {
> @@ -348,14 +357,6 @@ i2c4: i2c@10054000 {
>  		status = "disabled";
>  	};
>  
> -	watchdog: watchdog@10002000 {
> -		compatible = "ingenic,jz4780-watchdog";
> -		reg = <0x10002000 0x10>;
> -
> -		clocks = <&cgu JZ4780_CLK_RTCLK>;
> -		clock-names = "rtc";
> -	};
> -
>  	nemc: nemc@13410000 {
>  		compatible = "ingenic,jz4780-nemc";
>  		reg = <0x13410000 0x10000>;
> 

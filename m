Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 407D7309D47
	for <lists+stable@lfdr.de>; Sun, 31 Jan 2021 16:13:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbhAaPFv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Jan 2021 10:05:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231913AbhAaPDQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 31 Jan 2021 10:03:16 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B856C061573;
        Sun, 31 Jan 2021 07:02:10 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id v15so13854114wrx.4;
        Sun, 31 Jan 2021 07:02:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LjV7ACSqP+y+JnewS778JoLSAcQ5qx8sJ+ZVcy+lM+4=;
        b=FjBe/XzupUekMOot8PEzjBp8l9ZHr4GVrzUD+osKm2joyH0KvbD6t4boRgT8ffRubS
         /kRI9y4jGlJn1y/zwQ5xOWrxyYf9o3xvsOfZ2FGNO5x3iODENtI6Ms1ihuVB7SL1EvS3
         RVyyFoLWUJAl1b9Ray73p4oeVs7EVLrobwKzi2gyMozlky6CE1yXMi8h4RBxh2hq9vxr
         32mMTRpkhZNxyX65gWxVYpFNw5g5CbGSJ8Cig+6M6kN+h1C53UrB4eeqkN8HG3cFhzQ/
         ciAlntaZgQUnx4Tut892YcGZaBDAPJZ0+7yD7QAcAZMOvIuLuZPQpt54N/fFJjh5QD4C
         Ds8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LjV7ACSqP+y+JnewS778JoLSAcQ5qx8sJ+ZVcy+lM+4=;
        b=PGxgAvZziPaKhylKhVsh0CRHNVqQiuT+f56SRQVf8s+80Xj9FBWaHvJfZPIVGc6wcK
         fG7hjRwpfyMepF1basl7YFtDwroYWfvf4wEO3UI0Emn4sUe54i/rW9Hhoitz0wRdRZRq
         I4sRv8LpSNu+XwLHUg7vAiZgXJ58+TzEPwSTaKT81yyQblh1Onw1HkvGUaPud6RzKE9K
         Wg5GnXihyf92SzZLZN63hdfcNQedqRDDYjKjqTg7W/yensnCQEUNzzGo9tNdpr71L6PK
         PMO5fh37saXjv9THX6g3TLfAW0+XdL2LEHDc0fNMdAP/vfZw2z9a84VcbBZdv0FiqZuF
         i9hg==
X-Gm-Message-State: AOAM533VFNx3cLtbqHJZctE0si2UjFARDIcbah9QsJZIco64eUALzeuV
        t9gCB+629vSRt1RRm63W0ZiHwREpZEn+6G4s
X-Google-Smtp-Source: ABdhPJwADIFtf12tUEUVrchilS5bjUGWeeee7D163mWyiDjr0XlCEtWtBP1e9CDewJbpjk8YOX3gtg==
X-Received: by 2002:a05:6000:188b:: with SMTP id a11mr13699113wri.151.1612105328923;
        Sun, 31 Jan 2021 07:02:08 -0800 (PST)
Received: from ziggy.stardust ([213.195.126.134])
        by smtp.gmail.com with ESMTPSA id i59sm25056300wri.3.2021.01.31.07.02.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 Jan 2021 07:02:08 -0800 (PST)
Subject: Re: [PATCH v2] dts64: mt7622: fix slow sd card access
To:     Frank Wunderlich <linux@fw-web.de>,
        linux-mediatek@lists.infradead.org
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        Rob Herring <robh+dt@kernel.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Jimin Wang <jimin.wang@mediatek.com>,
        Ryder Lee <ryder.lee@mediatek.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sin_wenjiehu <sin_wenjiehu@mediatek.com>,
        Wenbin.Mei@mediatek.com, skylake.huang@mediatek.com,
        stable@vger.kernel.org
References: <20210113180919.49523-1-linux@fw-web.de>
From:   Matthias Brugger <matthias.bgg@gmail.com>
Message-ID: <1109b776-b20d-91e1-d398-c48f3f5aa240@gmail.com>
Date:   Sun, 31 Jan 2021 16:02:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210113180919.49523-1-linux@fw-web.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 13/01/2021 19:09, Frank Wunderlich wrote:
> From: Frank Wunderlich <frank-w@public-files.de>
> 
> Fix extreme slow speed (200MB takes ~20 min) on writing sdcard on
> bananapi-r64 by adding reset-control for mmc1 like it's done for mmc0/emmc.
> 
> Cc: stable@vger.kernel.org
> Fixes: 2c002a3049f7 ("arm64: dts: mt7622: add mmc related device nodes")
> Signed-off-by: Frank Wunderlich <frank-w@public-files.de>

Applied to v5.11-next/dts64

Thanks!

> ---
> changes since v1:
>  - drop change to uhs-mode because mt7622 does not support it
> ---
>  arch/arm64/boot/dts/mediatek/mt7622.dtsi | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/mediatek/mt7622.dtsi b/arch/arm64/boot/dts/mediatek/mt7622.dtsi
> index 5b9ec032ce8d..7c6d871538a6 100644
> --- a/arch/arm64/boot/dts/mediatek/mt7622.dtsi
> +++ b/arch/arm64/boot/dts/mediatek/mt7622.dtsi
> @@ -698,6 +698,8 @@ mmc1: mmc@11240000 {
>  		clocks = <&pericfg CLK_PERI_MSDC30_1_PD>,
>  			 <&topckgen CLK_TOP_AXI_SEL>;
>  		clock-names = "source", "hclk";
> +		resets = <&pericfg MT7622_PERI_MSDC1_SW_RST>;
> +		reset-names = "hrst";
>  		status = "disabled";
>  	};
>  
> 

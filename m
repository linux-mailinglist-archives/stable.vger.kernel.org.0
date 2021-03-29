Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 306CA34D1A0
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 15:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231368AbhC2Nqh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 09:46:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbhC2Nqf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 09:46:35 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A13AC061574;
        Mon, 29 Mar 2021 06:46:35 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id t5-20020a1c77050000b029010e62cea9deso6716161wmi.0;
        Mon, 29 Mar 2021 06:46:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rZ0ttQmQI38kgtwimwZOypMElesqYSV1+5uAEl6XReI=;
        b=aXrEUr2HfLf/OkoGix2kXX2gaejpeIC6TS8dm/pMOZ383IzDcRMNlJIOyRWYzFe0SW
         nySVI9Sx3U87QQwvMpsgSFraJZQ75BFpr3nCfBldspaT6JbL7NPEa+bZlishv3UfKeoU
         d2HFDwZJ/SisxNV7yVr/uWo5Vs9kzG8DVJY4R6YJnJoEDDw5jZnMuSefFCNVHp/pONbs
         w718mLUmn0OT4MQwg1RiUiqSdMBF1E50pYWf+rIm8q/BVQF9q3toq6AlWBPvSt8PtJ8o
         HAe0vKWGlDaBaa6IsdtsfxIIsx7DbI+ih1d48ZA/oNahSgNmbZYOQyHcQkmfzyvrMVb/
         Ns7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rZ0ttQmQI38kgtwimwZOypMElesqYSV1+5uAEl6XReI=;
        b=FcZNzoFvQ4WlaLCumxnygnC3OH/qh13AP5cFYyOaAukniBu+tvmiUlhNstPlMHta3c
         XvyCGWrOIRWLIq9EKW9w9ZY4fgqstDf92q4kDPm95bFpdF2i4JcCywjdqpUkwPm0jKgH
         fof+KZLIoXzyX8hFmKsrLIaBZh8/YUaJdP9THokrWa4pCFdoe3qKPeSjvlySrC8JdDb1
         HipYOtkfiivLqqNf10r3gW7od+0OEJxfG+jPDxFjVYD3gSbpIcp3XOWvRPyK/uOF1UOw
         QyN2gQXAF5dY6UW+P0pQgbc2zuzXSJOgQ6kLmCjinumYPzlaHfD9GxI+IpQMZfKoxfor
         CuJA==
X-Gm-Message-State: AOAM532uAgZw5hE7V6JToRU5VUUDV/8LFtBXeTjYPUEmoboOXU3pMmkN
        4CTAefpn9tSz4A1h2gRcNTrbXPeaUKRHtg==
X-Google-Smtp-Source: ABdhPJwsFeaTfLQho0KOF6d5TsjacpYyW3Pw0n29HGyU/IuKNc+SapdcNLoG9R2gdUilBHUWOqUPCQ==
X-Received: by 2002:a05:600c:2247:: with SMTP id a7mr25237250wmm.131.1617025593712;
        Mon, 29 Mar 2021 06:46:33 -0700 (PDT)
Received: from ziggy.stardust (80.174.240.175.dyn.user.ono.com. [80.174.240.175])
        by smtp.gmail.com with ESMTPSA id c131sm26103482wma.37.2021.03.29.06.46.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Mar 2021 06:46:33 -0700 (PDT)
Subject: Re: [PATCH v5 05/13] arm64: dts: mt8173: fix property typo of 'phys'
 in dsi node
To:     Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Vinod Koul <vkoul@kernel.org>, Rob Herring <robh+dt@kernel.org>
Cc:     Kishon Vijay Abraham I <kishon@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Jie Qiu <jie.qiu@mediatek.com>, CK Hu <ck.hu@mediatek.com>,
        Cawa Cheng <cawa.cheng@mediatek.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-usb@vger.kernel.org,
        stable <stable@vger.kernel.org>
References: <20210316092232.9806-1-chunfeng.yun@mediatek.com>
 <20210316092232.9806-5-chunfeng.yun@mediatek.com>
From:   Matthias Brugger <matthias.bgg@gmail.com>
Message-ID: <849d620a-a209-f89f-8303-9d0c9b740045@gmail.com>
Date:   Mon, 29 Mar 2021 15:46:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210316092232.9806-5-chunfeng.yun@mediatek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 16/03/2021 10:22, Chunfeng Yun wrote:
> Use 'phys' instead of 'phy'.
> 
> Fixes: 81ad4dbaf7af ("arm64: dts: mt8173: Add display subsystem related nodes")
> Cc: stable <stable@vger.kernel.org>
> Reviewed-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
> Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>

Applied now to v5.12-next/dts64

> ---
> v5: merged into this series, add Reviewed-by CK
> ---
>  arch/arm64/boot/dts/mediatek/mt8173.dtsi | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/boot/dts/mediatek/mt8173.dtsi b/arch/arm64/boot/dts/mediatek/mt8173.dtsi
> index 7fa870e4386a..ecb37a7e6870 100644
> --- a/arch/arm64/boot/dts/mediatek/mt8173.dtsi
> +++ b/arch/arm64/boot/dts/mediatek/mt8173.dtsi
> @@ -1235,7 +1235,7 @@
>  				 <&mmsys CLK_MM_DSI1_DIGITAL>,
>  				 <&mipi_tx1>;
>  			clock-names = "engine", "digital", "hs";
> -			phy = <&mipi_tx1>;
> +			phys = <&mipi_tx1>;
>  			phy-names = "dphy";
>  			status = "disabled";
>  		};
> 

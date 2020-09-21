Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2427C271FA2
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 12:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgIUKEp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 06:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726384AbgIUKEp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Sep 2020 06:04:45 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 199E7C061755;
        Mon, 21 Sep 2020 03:04:45 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id j2so12073308wrx.7;
        Mon, 21 Sep 2020 03:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UkuH/WWP5BM2+/HjFiAZ6z/l7IuHecE85iZQkNm/w4E=;
        b=feXCk+RYG8aagpwCWUKrBf5bu0pOD+rXTbio6MrX74CO7k3r/KWMqCta7XbsOmjON5
         wOm/xLi4/wTOU51UQ6AvYik5TSds1ylXsBOCy7ha6l4Bt4M6SiAO9BKGeIWkevRFI7kQ
         mgIEYC8kwG1RB6D4kiE10tx871uAGkH1V6MTDIIeWX2rl7pLUW1bgnl+NlbOYfzLDUas
         B5Cy3gQ50wXh2qOnksL3gJL/Ujdeo2hyO7Lv1xNLi5HBH8VvVjo3Q3X7IqD8+H0K0/R0
         qJITPaGA+d3JXjETXHKW4wK/vPoO930uvrtyyDKK5wbLbB8G27IEYFtI9GQpcpWDxfm4
         eibw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UkuH/WWP5BM2+/HjFiAZ6z/l7IuHecE85iZQkNm/w4E=;
        b=KjRHm1f7Nkv2NMnU/SaDoI0b5CEKP5pPcn6qQmYkoSgMxEv46lkWJwUCuFBatOZUu+
         rDvelzU3fL25G73dU/tn3uljhmKJKRiKHrnCWxmcXm13mOsaXJb3ixaf4A9gLNt83sSJ
         ZfLbW7aDn77baUhokK6BU6hJXZswfC6gGh7sxHjaKCD5+rFQ8Ep0nKSCHZs/jFM9qqNj
         F/OU5+dt5nuD2sLA7h2WCzeAMyN7VwlmRkPSx4kCKj+fF9FFretSFYb3a1lOYBdkwzLU
         CJvM72WSS950P0ndrIOFx3IoNf6G1krqJhqVI7jwWLjLhl1ocBloCOCzbaI5dfRbGhDG
         JLRA==
X-Gm-Message-State: AOAM5301ACVCfxII/YHKNkF8/OWzwxXIMhPYVvBCUi3LOrRJ6SC/6WKV
        2EoZfFJsN3NindAubxO/QdOO0rCBz0waOQ==
X-Google-Smtp-Source: ABdhPJxpykmsqM5GSWO6ureL2EshNJp7ZQNhv3665VbXJ7PZglq45TWDJTqLgbCKs4hA13A2IaFJ6w==
X-Received: by 2002:adf:ea0f:: with SMTP id q15mr36632145wrm.371.1600682683621;
        Mon, 21 Sep 2020 03:04:43 -0700 (PDT)
Received: from ziggy.stardust ([213.195.113.201])
        by smtp.gmail.com with ESMTPSA id n3sm2582093wmn.28.2020.09.21.03.04.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Sep 2020 03:04:42 -0700 (PDT)
Subject: Re: [PATCH] arm: dts: mt7623: add missing pause for switchport
To:     Frank Wunderlich <linux@fw-web.de>,
        linux-mediatek@lists.infradead.org
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        Rob Herring <robh+dt@kernel.org>,
        Landen Chao <landen.chao@mediatek.com>,
        Qingfang DENG <dqfext@gmail.com>,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>,
        Sean Wang <sean.wang@mediatek.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20200907070517.51715-1-linux@fw-web.de>
From:   Matthias Brugger <matthias.bgg@gmail.com>
Message-ID: <ae04ff83-f9f5-ecb0-1221-854d21fc9cfd@gmail.com>
Date:   Mon, 21 Sep 2020 12:04:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200907070517.51715-1-linux@fw-web.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 07/09/2020 09:05, Frank Wunderlich wrote:
> From: Frank Wunderlich <frank-w@public-files.de>
> 
> port6 of mt7530 switch (= cpu port 0) on bananapi-r2 misses pause option
> which causes rx drops on running iperf.
> 
> Cc: stable@vger.kernel.org
> Fixes: f4ff257cd160 ("arm: dts: mt7623: add support for Bananapi R2 (BPI-R2) board")
> Signed-off-by: Frank Wunderlich <frank-w@public-files.de>

Applied to v5.9-next/dts32

Thanks!

> ---
>   arch/arm/boot/dts/mt7623n-bananapi-bpi-r2.dts | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/boot/dts/mt7623n-bananapi-bpi-r2.dts b/arch/arm/boot/dts/mt7623n-bananapi-bpi-r2.dts
> index 2b760f90f38c..5375c6699843 100644
> --- a/arch/arm/boot/dts/mt7623n-bananapi-bpi-r2.dts
> +++ b/arch/arm/boot/dts/mt7623n-bananapi-bpi-r2.dts
> @@ -192,6 +192,7 @@ port@6 {
>   					fixed-link {
>   						speed = <1000>;
>   						full-duplex;
> +						pause;
>   					};
>   				};
>   			};
> 

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D11B4C364B
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 20:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234145AbiBXT6G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Feb 2022 14:58:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234146AbiBXT6F (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Feb 2022 14:58:05 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EC6815DDDC
        for <stable@vger.kernel.org>; Thu, 24 Feb 2022 11:57:35 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id a6so4584425oid.9
        for <stable@vger.kernel.org>; Thu, 24 Feb 2022 11:57:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uRmLZfQHkYzc7u6LM3Bmygv1wthncLvGRmNglYSkNqo=;
        b=DkLVMhs9NzFgLjcSvs/jJ22SRT6eQNzgccJ0Itt5s8Pc790Ehnmyq9abxjBU4SXfXa
         5KxPkqiUURFHLee8AIoP5wsjfNRBW27eJ0wznWxNpFBvljZoII/17nFWntUb4qpvQXoB
         u+vAEjYN53x3PyOZIojVzKBiZwZ0jgiMUDJMDXk/v2SQE+VFrZdWca1ABk+83GasELJ6
         R79poDVtv62uxo1ogqphaKAlk2EkmR9MiWSD6OcrnSZfOqGTcXvcTgWA+SD1E3/MQAJG
         fj9cmBu3lZVSYe1PKlOD1ej4oMiunyqVx+oWAgkWCpp+l1Leb/fO1xrYRVGl85hqw2Ck
         5cdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uRmLZfQHkYzc7u6LM3Bmygv1wthncLvGRmNglYSkNqo=;
        b=3xchTgFVD45soMonUwo5gG12X/ik9sNTcREqIxVoc39kkjHwjlziHlmH35kZSP4YCY
         KZ46oTYA6GkWxUoY3fugjxGRB9dPy0Qu8qHhX5CbzjUgilB3+5gVjTgXtG11LhJz0zgX
         YIHk2hfodCFdGbefSZu/INeWK0ozRTyUWhjcFooDVm4l+37EikMLjNyMQWm7T+5NW+qo
         +rykdLgvwhP7Ikj0FY7nhMq74WkGkbhs05TZrYiunlYE2rWk0gBqEhRmat3bUKgmxJN4
         HPb+5oHvIAc+3/OiwQomBv9CSmj1HDddRaR4dcPmbkrjz7orXnFqLFIk5A1tzGeJnmds
         0J1A==
X-Gm-Message-State: AOAM532BGRRl1yxhRPsEU4mbzko4xcINlEJ6xleiqFlqGmbOr4cjG7Xj
        t1UJyXrwTYzzx1vePY5hL8OswA==
X-Google-Smtp-Source: ABdhPJySDMCKKL+4aV2cblIdnPtj+AQytyxzcFkG7LPcP+u4BgmCi1Pye8INN6Dn8EDDIyOF+uVWyA==
X-Received: by 2002:aca:3e56:0:b0:2d4:c902:b851 with SMTP id l83-20020aca3e56000000b002d4c902b851mr8091956oia.114.1645732654500;
        Thu, 24 Feb 2022 11:57:34 -0800 (PST)
Received: from builder.lan ([2600:1700:a0:3dc8:3697:f6ff:fe85:aac9])
        by smtp.gmail.com with ESMTPSA id d35-20020a9d2926000000b005ad1fa8da87sm141701otb.53.2022.02.24.11.57.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 11:57:34 -0800 (PST)
Date:   Thu, 24 Feb 2022 13:57:32 -0600
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Kathiravan T <quic_kathirav@quicinc.com>
Cc:     agross@kernel.org, robh+dt@kernel.org, varada@codeaurora.org,
        mraghava@codeaurora.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] arm64: dts: qcom: ipq8074: fix the sleep clock frequency
Message-ID: <YhfjLNHCZeK4hYKa@builder.lan>
References: <1644581655-11568-1-git-send-email-quic_kathirav@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1644581655-11568-1-git-send-email-quic_kathirav@quicinc.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri 11 Feb 06:14 CST 2022, Kathiravan T wrote:

> Sleep clock frequency should be 32768Hz. Lets fix it.
> 
> Cc: stable@vger.kernel.org
> Fixes: 41dac73e243d ("arm64: dts: Add ipq8074 SoC and HK01 board support")
> Link: https://lore.kernel.org/all/e2a447f8-6024-0369-f698-2027b6edcf9e@codeaurora.org/
> Signed-off-by: Kathiravan T <quic_kathirav@quicinc.com>

Can you please confirm this? The documentation for GCC says that the
incoming sleep clock is 32000Hz.

Regards,
Bjorn

> ---
>  arch/arm64/boot/dts/qcom/ipq8074.dtsi | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/boot/dts/qcom/ipq8074.dtsi b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
> index 26ba7ce9222c..b6287355ad08 100644
> --- a/arch/arm64/boot/dts/qcom/ipq8074.dtsi
> +++ b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
> @@ -13,7 +13,7 @@
>  	clocks {
>  		sleep_clk: sleep_clk {
>  			compatible = "fixed-clock";
> -			clock-frequency = <32000>;
> +			clock-frequency = <32768>;
>  			#clock-cells = <0>;
>  		};
>  
> -- 
> 2.7.4
> 

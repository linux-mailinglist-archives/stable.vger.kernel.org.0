Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B85165FE45
	for <lists+stable@lfdr.de>; Fri,  6 Jan 2023 10:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231661AbjAFJso (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Jan 2023 04:48:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233538AbjAFJsD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Jan 2023 04:48:03 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC0BCF00C
        for <stable@vger.kernel.org>; Fri,  6 Jan 2023 01:48:00 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id gh17so2359029ejb.6
        for <stable@vger.kernel.org>; Fri, 06 Jan 2023 01:48:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=77vHjeUHiCb66z/I743uh4gP4GpNQ4TQEZW0IuazaZY=;
        b=Mn1qK9ulnq8ImWay2BFBcXNDLq264mzCvmvq6AowQek49U5nYnVbayLOXnP4HwLJIV
         nSpt0a7h8jSPkuLiPG208Jt139i3iPgHUa+YzGZwR/hLDCqxqBrWu3lOof/yW/r45RiU
         iIj2FQY3Qa4Qsy7LeSPOt8J84+CCA8qxGjFy1bAvvpF3q2GLNwujHFR8JDnGZs6Ezwci
         M8U4d13moLskMm3M4IjXxFnJU0bdNheaVCJTbp6IyPGAAYGCjvbBUae5s4cJsZC4W8E2
         go/R8RMiLCj9FnKam+Bw6xcS+jVTkL9QBHeSd1JDjsKXMcV137YfV/5rq6kk/bz7DeSU
         AM7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=77vHjeUHiCb66z/I743uh4gP4GpNQ4TQEZW0IuazaZY=;
        b=aspo5db++iTmOSe+A1/He7uqvYSt9NeSiFP7MLGDkJ5jgigYSwY4/F1AsG4Etkj/hv
         hOCPcO3N3aKl+nSAamFAgqguhBbY2S3A2gI4CSN9b9XVLIuDPoFBGgg1MpQEbgpgWgF9
         cV2epmyuwFuhOKf5M+rPSOLzYK0wIaNZHRPCf3sD/gVHCY6O3X+67UZIgmUIzrHe6+go
         Rqko3M7y/QcnkPSYAqm0rqGT77LowREOY/iht+VsC2R3QMtICTED/UbbzMdApUWgjz/0
         EMIKZX38DEXf2i3bKJAgMC1bsIk4+9psEpATZbgPzlsLmOn3NWo2qEJfxSLB9BlwI/C/
         gYRw==
X-Gm-Message-State: AFqh2kqaH0XeOlpSOxeJGmYjWtnO2sdKwhV73OOTs2CcuWQvww99s56D
        LosAnBeCL0QQP5fJYFyd5McVaA==
X-Google-Smtp-Source: AMrXdXvIYu/IktKkvb5RYfd4aovy6Jrw35I2OrveWf1zeDYWyJafG0t6A/8TBkyL5Db0Nb3k+KEkjw==
X-Received: by 2002:a17:906:4f14:b0:7c1:98e:ed20 with SMTP id t20-20020a1709064f1400b007c1098eed20mr44270717eju.35.1672998479477;
        Fri, 06 Jan 2023 01:47:59 -0800 (PST)
Received: from [192.168.0.104] ([82.77.81.242])
        by smtp.gmail.com with ESMTPSA id lb19-20020a170907785300b0084d1efe9af6sm246287ejc.58.2023.01.06.01.47.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jan 2023 01:47:59 -0800 (PST)
Message-ID: <493d9a10-aaf3-70f6-36c3-9a2cf39f0759@linaro.org>
Date:   Fri, 6 Jan 2023 11:47:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH] mtd: spi-nor: spansion: Keep CFR5V[6] as 1 in Octal DTR
 enable/disable
To:     tkuw584924@gmail.com, linux-mtd@lists.infradead.org
Cc:     pratyush@kernel.org, michael@walle.cc, miquel.raynal@bootlin.com,
        richard@nod.at, vigneshr@ti.com, Bacem.Daassi@infineon.com,
        Takahiro Kuwano <Takahiro.Kuwano@infineon.com>,
        stable@vger.kernel.org
References: <20230106030601.6530-1-Takahiro.Kuwano@infineon.com>
Content-Language: en-US
From:   Tudor Ambarus <tudor.ambarus@linaro.org>
In-Reply-To: <20230106030601.6530-1-Takahiro.Kuwano@infineon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hey, Takahiro,

On 06.01.2023 05:06, tkuw584924@gmail.com wrote:
> From: Takahiro Kuwano <Takahiro.Kuwano@infineon.com>
> 
> CFR5V[6] is reserved bit and must always be 1.

have you seen some strange behavior?
> 
> Fixes: c3266af101f2 ("mtd: spi-nor: spansion: add support for Cypress Semper flash")
> Signed-off-by: Takahiro Kuwano <Takahiro.Kuwano@infineon.com>
> Cc: stable@vger.kernel.org
> ---
>   drivers/mtd/spi-nor/spansion.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mtd/spi-nor/spansion.c b/drivers/mtd/spi-nor/spansion.c
> index b621cdfd506f..4e094a432d29 100644
> --- a/drivers/mtd/spi-nor/spansion.c
> +++ b/drivers/mtd/spi-nor/spansion.c
> @@ -21,8 +21,8 @@
>   #define SPINOR_REG_CYPRESS_CFR3V		0x00800004
>   #define SPINOR_REG_CYPRESS_CFR3V_PGSZ		BIT(4) /* Page size. */
>   #define SPINOR_REG_CYPRESS_CFR5V		0x00800006
> -#define SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_EN	0x3
> -#define SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_DS	0
> +#define SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_EN	0x43
> +#define SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_DS	0x40

No, this looks bad. Instead of overwriting CFR5V with whatever value, we
should instead first read it and then update only the bit that we're
interested in. If it happens to write CFR5V before octal enable/disable,
you'll overwrite the previous set values.

Cheers,
ta

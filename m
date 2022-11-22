Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC3F634291
	for <lists+stable@lfdr.de>; Tue, 22 Nov 2022 18:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234012AbiKVReP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Nov 2022 12:34:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234517AbiKVReL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Nov 2022 12:34:11 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B558329;
        Tue, 22 Nov 2022 09:34:10 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id o30so11263106wms.2;
        Tue, 22 Nov 2022 09:34:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jzklqbfAAgvj9PC/0pw5WYxo6LOoMPvVtiBugerBwFg=;
        b=EKtdox0xep5n1ykg8tUe1ZitEUVy3X4qOlX6tw80klPHuM5HhHANHAoUfT3eFrX7FR
         RvkApEzx7Q0CwVoCN6HkAlfMBsP6yWjiBoAGe5POkLQNhnTp+27KP2V8TcYrJbSfNJio
         2jH8+C7VUOW3j3alnRhZPkT/Yw+QMbFE+sOXSkqn0fOXMDAgXNy0aOP+sbtMakwJoFXK
         +R2BDroACspKPngkpxElwSbBshYr4xmLnFYpy+oi0svr0YW6OUfcoOsdoyQy22nG1cdv
         bhsv2upJN9LdMWcYVHmV5aNuq8lc021wmGPMCgNn9rFZHg9MYqBWTEuN8a1xYah3lIyg
         +J9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jzklqbfAAgvj9PC/0pw5WYxo6LOoMPvVtiBugerBwFg=;
        b=tnYpW1h0fPTJYW1g9vw0FJJxwjfzLhELG3UQZRkl/En0zvJx/s8zKyalHPFjGSUOsY
         VP3j/fSzUPuCYy+tcu5Nl3FM6H7tjaofk+fpvryxmiiTS7cMD759x3aDNnLl8zXQZNZV
         kAKiLgv53W/7oox+jS78sJQZc8nKdA33IWCLWekvWCBj+c5FobJc2sz6SNx2xZ67Muhc
         QkXQg5wCaPbFwzdbTFWayv8jfErWMjQc10dFtRxTUwdVDnkV00J4qsVS7uyZBoRRkfsD
         uVGpSTWfWiNE7G6rVeVIsbobjQxi0YxOLd6ClVVDBfgiEnBrFSrGayNtNaeQ+1dsYKGf
         Y7Ng==
X-Gm-Message-State: ANoB5pnmXEbc8Ny9s/PHB8rPYv60l4n1tBHhT9anGu4WLPg9ldXFmewE
        Vt1BB/WB8oqNKWlRoYEyAByExdxQBTPESw==
X-Google-Smtp-Source: AA0mqf5OOBdBWL4D+WDfrKGFanO92z4WqAf2USzQOiVUkhIBJXKLZCjTrty3XrW4md5tyWVWd9jvSg==
X-Received: by 2002:a05:600c:3393:b0:3cf:81f3:1e4a with SMTP id o19-20020a05600c339300b003cf81f31e4amr21285684wmp.4.1669138448948;
        Tue, 22 Nov 2022 09:34:08 -0800 (PST)
Received: from [192.168.0.25] ([37.222.251.204])
        by smtp.gmail.com with ESMTPSA id o9-20020a056000010900b00228692033dcsm14294563wrx.91.2022.11.22.09.34.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Nov 2022 09:34:07 -0800 (PST)
Message-ID: <2ef0ba5d-0c3c-df67-94f8-046ad22c1d53@gmail.com>
Date:   Tue, 22 Nov 2022 18:34:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [RESEND PATCH v2] arm64: dts: mediatek: mt8195-demo: fix the
 memory size of node secmon
Content-Language: en-US
To:     Macpaul Lin <macpaul.lin@mediatek.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Fabien Parent <fparent@baylibre.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Miles Chen <miles.chen@mediatek.com>,
        Bear Wang <bear.wang@mediatek.com>,
        Pablo Sun <pablo.sun@mediatek.com>,
        Mediatek WSD Upstream <wsd_upstream@mediatek.com>,
        Macpaul Lin <macpaul@gmail.com>, linux-usb@vger.kernel.org,
        stable@vger.kernel.org
References: <20221111095540.28881-1-macpaul.lin@mediatek.com>
From:   Matthias Brugger <matthias.bgg@gmail.com>
In-Reply-To: <20221111095540.28881-1-macpaul.lin@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 11/11/2022 10:55, Macpaul Lin wrote:
> The size of device tree node secmon (bl31_secmon_reserved) was
> incorrect. It should be increased to 2MiB (0x200000).
> 
> The origin setting will cause some abnormal behavior due to
> trusted-firmware-a and related firmware didn't load correctly.
> The incorrect behavior may vary because of different software stacks.
> For example, it will cause build error in some Yocto project because
> it will check if there was enough memory to load trusted-firmware-a
> to the reserved memory.
> 
> When mt8195-demo.dts sent to the upstream, at that time the size of
> BL31 was small. Because supported functions and modules in BL31 are
> basic sets when the board was under early development stage.
> 
> Now BL31 includes more firmwares of coprocessors and maturer functions
> so the size has grown bigger in real applications. According to the value
> reported by customers, we think reserved 2MiB for BL31 might be enough
> for maybe the following 2 or 3 years.
> 
> Cc: stable@vger.kernel.org      # v5.19
> Fixes: 6147314aeedc ("arm64: dts: mediatek: Add device-tree for MT8195 Demo board")
> Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
> Reviewed-by: Miles Chen <miles.chen@mediatek.com>

Applied now to v6.1-next/fixes

Thanks!

> ---
> Changes for v2
>   - Add more information about the size difference for BL31 in commit message.
>     Thanks for Miles's review.
> 
>   arch/arm64/boot/dts/mediatek/mt8195-demo.dts | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/boot/dts/mediatek/mt8195-demo.dts b/arch/arm64/boot/dts/mediatek/mt8195-demo.dts
> index 4fbd99eb496a..dec85d254838 100644
> --- a/arch/arm64/boot/dts/mediatek/mt8195-demo.dts
> +++ b/arch/arm64/boot/dts/mediatek/mt8195-demo.dts
> @@ -56,10 +56,10 @@
>   		#size-cells = <2>;
>   		ranges;
>   
> -		/* 192 KiB reserved for ARM Trusted Firmware (BL31) */
> +		/* 2 MiB reserved for ARM Trusted Firmware (BL31) */
>   		bl31_secmon_reserved: secmon@54600000 {
>   			no-map;
> -			reg = <0 0x54600000 0x0 0x30000>;
> +			reg = <0 0x54600000 0x0 0x200000>;
>   		};
>   
>   		/* 12 MiB reserved for OP-TEE (BL32)

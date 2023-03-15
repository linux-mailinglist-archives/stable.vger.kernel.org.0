Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4C26BB6D3
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 16:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232042AbjCOPAw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 11:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232850AbjCOPAe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 11:00:34 -0400
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D10136040F
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 07:59:45 -0700 (PDT)
Received: by mail-oo1-xc31.google.com with SMTP id bg8-20020a056820080800b0053160781f11so502690oob.11
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 07:59:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678892384;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qUZnXJdG7q37tNhRaQudoPaYbrD3S3nHX6FVLwwb8gI=;
        b=gfYiF84RPRllFKjiC/l0H3B3RuhvsHoTK1a/xdhJU3kG/B8chrpLgJa4Ikv40YRisJ
         PJGPivKtVO5qWpEw5P8QYFzvqBTjZeD8fkurL3ShXWW0jlajr2vEWG4bslDZu0IBir6l
         H9gBYm6V9ko9sC3AhrAf2rm2o1JXeWMivZ4g8qOVwfpRl2i5DewY8Bkh5hWHbk+jCUYM
         +4tnfp/N10fUMQbfLjQ1kiUo/6qn+iPP1U9Z0AtgIbiRzme7wZd1ssHgh11NrQoncoAq
         xGMe4u9opXUd9pW1Y2FXD7VMJgKGQSKqtajS0KrVcIGjUJ+7GvWWNyUgjWObv4VWOKYk
         GGtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678892384;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qUZnXJdG7q37tNhRaQudoPaYbrD3S3nHX6FVLwwb8gI=;
        b=r7AVsUQ/RMbMRUs7F5oNJRw2S7eUYs3jioNLwcBDP9oxw+Mf5Nvo8ao9+xvDgos4ld
         YsCgwHbZkIN1j4HPwmAcWJu0McpwhQIahYT9NVVaogD9Wnz3owv8Dd3Wsba9MQ0xpEjJ
         gS9z9mJD4n7/3s/Q4VoV3LjILmAy5Rd0gjIzWpdwxKlTpD1Rf6J8E7dFkPwVvEnyE37Y
         LS/2ygExHdAnjkgM2kCSih37TNO4tBBpcOVV62LFKVY/ncCeoMvVfXw5zwjq9CIiz1JF
         uKw6rmDXQtp9snLoXvisuuvCxBZ8Ak0106sTyTL9fH46LG1/XMGyefgClVgXCciHqUyI
         pL8Q==
X-Gm-Message-State: AO0yUKUyaryJ01NhtNKROjqZgKp2eFJnrbuure4qodIwqTTjHS43VpTB
        SRTEOmaKPXZIiar+BWJBCk3ISw==
X-Google-Smtp-Source: AK7set99FRnSdN/rBC8wUKYnTash4tD/QtoCdIeAxYjOE6xnjtrbvyNNQ/VFkGqwJIXa1XXp4+wVIQ==
X-Received: by 2002:a4a:d498:0:b0:51a:48f4:75de with SMTP id o24-20020a4ad498000000b0051a48f475demr9979407oos.0.1678892383945;
        Wed, 15 Mar 2023 07:59:43 -0700 (PDT)
Received: from [192.168.17.16] ([189.219.75.19])
        by smtp.gmail.com with ESMTPSA id t10-20020a4ae40a000000b005253a5cc3cfsm2311834oov.29.2023.03.15.07.59.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 07:59:43 -0700 (PDT)
Message-ID: <dce37bda-d5d9-72d8-2b22-2c69b6498870@linaro.org>
Date:   Wed, 15 Mar 2023 08:59:42 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 5.4 00/68] 5.4.237-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
References: <20230315115726.103942885@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20230315115726.103942885@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 15/03/23 06:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.237 release.
> There are 68 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.237-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Lots of build failures: arm, arm64 (Clang-16, Clang-nightly):

-----8<-----
/builds/linux/drivers/gpu/drm/drm_edid.c:5119:21: error: passing 'const struct drm_connector *' to parameter of type 'struct drm_connector *' discards qualifiers [-Werror,-Wincompatible-pointer-types-discards-qualifiers]
         if (!is_hdmi2_sink(connector) && vic > 64)
                            ^~~~~~~~~
/builds/linux/drivers/gpu/drm/drm_edid.c:4994:49: note: passing argument to parameter 'connector' here
static bool is_hdmi2_sink(struct drm_connector *connector)
                                                 ^
1 error generated.
make[4]: *** [/builds/linux/scripts/Makefile.build:262: drivers/gpu/drm/drm_edid.o] Error 1
----->8-----


On PowerPC (GCC-8, GCC-12, Clang-16, Clang-nightly):

-----8-----
In file included from /builds/linux/drivers/usb/host/ohci-hcd.c:1255:
/builds/linux/drivers/usb/host/ohci-ppc-of.c:126:13: error: use of undeclared identifier 'NO_IRQ'; did you mean 'do_IRQ'?
         if (irq == NO_IRQ) {
                    ^~~~~~
                    do_IRQ
/builds/linux/arch/powerpc/include/asm/irq.h:58:13: note: 'do_IRQ' declared here
extern void do_IRQ(struct pt_regs *regs);
             ^
1 error generated.
make[4]: *** [/builds/linux/scripts/Makefile.build:262: drivers/usb/host/ohci-hcd.o] Error 1
----->8-----


Many Arm configs:

-----8<-----
/builds/linux/arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi:409.10-412.7: ERROR (phandle_references): /thermal-zones/gpu-thermal/cooling-maps/map3: Reference to
  non-existent node or label "gpu"

/builds/linux/arch/arm/boot/dts/exynos5422-odroidhc1.dts:238.10-241.7: ERROR (phandle_references): /thermal-zones/gpu-thermal/cooling-maps/map0: Reference to non-exi
stent node or label "gpu"

/builds/linux/arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi:413.10-416.7: ERROR (phandle_references): /thermal-zones/gpu-thermal/cooling-maps/map4: Reference to
  non-existent node or label "gpu"

/builds/linux/arch/arm/boot/dts/exynos5422-odroidhc1.dts:242.10-245.7: ERROR (phandle_references): /thermal-zones/gpu-thermal/cooling-maps/map1: Reference to non-exi
stent node or label "gpu"

ERROR: Input tree has errors, aborting (use -f to force output)
----->8-----


Greetings!

Daniel Díaz
daniel.diaz@linaro.org


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB6FD4D3FBD
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 04:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239279AbiCJDee (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 22:34:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231621AbiCJDed (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 22:34:33 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 629F15EBD8;
        Wed,  9 Mar 2022 19:33:33 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id q19so3619644pgm.6;
        Wed, 09 Mar 2022 19:33:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=WTWmQipKxmyeBo8pqfDtbg/Qx6vy5sgWpfGVM5MIYTQ=;
        b=FQM7WcWQDI3bPtS0dboxwBU8fNM4KD3XzzWoc94VQby0cqCzs1//tI+IrSNBCtP1Ue
         A2Veiz98hi+CegNfC6z0hqGyu6k+RFSdzPfHeKeV+3Qzph0x2M5Kk0MRB+a/ahZGdFzX
         6L4NgtIBByv9M9AwptTb9HYlQIsR9MW4ASg6ZKYjGq/Vpco9jgK83SErwpJEKWELXUYc
         usWHY9n0NFINDmctBsYIKvsr66TuDfbhmobaZbTC9EIrT8afTapt8qim4QI6C7q+7Ar2
         Y/P/SdBDZiAjOOZzRZ9RGUdFvc7QxS5CLtiECJHQ0lQPEcsxgZu7REwXi0+Sc88Llm2g
         I7YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=WTWmQipKxmyeBo8pqfDtbg/Qx6vy5sgWpfGVM5MIYTQ=;
        b=UTJltHhzY/U349nD3ZjEzUnNCeF0b+/Of4K4bYGSrYfS+Z+qpUUh6s3i6mWpQhF4zD
         fB+id2WxP4LLT8yFgdhDrC8vMMQqA++29aIYyLGlUwAJlIQuFhONSyOIV1mHTZu9Qh97
         hXqC8hA9hId2yPTT4zbrCqTbAyoAROWF30U5qrlPSqne1PwjGM51qDLOWjLhPKOE2goc
         5uR/s9eYMfzIokbNGWtiFBTQhKbFTwf6uU6abA7IJ08sAqyeTG4SLmrCgDZmxzI6Ficj
         EYc7Cqah+aaT5PD3sCEjpNz73GulXCQht+jAWaxgsv9D7BJbdu4gS1aR1/hRQoOCto3+
         EOPw==
X-Gm-Message-State: AOAM533i77Hi45PTdHi8QM2JgN+hb6mc1jfHGVrOCLSOn6kJk3CU+NVy
        uoRlnmCiEZJzH9TEoxqti3Q=
X-Google-Smtp-Source: ABdhPJy/YJ6RgEe1MvrzoCZdB3BhsJqTvno/zDBhTUi//4hAcsUIepmereaPSKr+o8KAKbV1dcrXvg==
X-Received: by 2002:a05:6a02:19a:b0:378:4f44:b1da with SMTP id bj26-20020a056a02019a00b003784f44b1damr2371156pgb.568.1646883212745;
        Wed, 09 Mar 2022 19:33:32 -0800 (PST)
Received: from [10.230.24.186] ([192.19.224.250])
        by smtp.gmail.com with ESMTPSA id p16-20020a056a000b5000b004f756b6c315sm4518386pfo.66.2022.03.09.19.33.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 19:33:32 -0800 (PST)
Message-ID: <d124614c-c5a7-50f9-b433-e49e8d5cdb95@gmail.com>
Date:   Wed, 9 Mar 2022 19:33:28 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH 5.15 00/43] 5.15.28-rc1 review
Content-Language: en-US
To:     =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220309155859.734715884@linuxfoundation.org>
 <b17d6dad-b5b3-6c59-b156-831913f7cd3e@linaro.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <b17d6dad-b5b3-6c59-b156-831913f7cd3e@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/9/2022 1:14 PM, Daniel Díaz wrote:
> Hello!
> 
> On 09/03/22 09:59, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.15.28 release.
>> There are 43 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Fri, 11 Mar 2022 15:58:48 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>     https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.28-rc1.gz 
>>
>> or in the git tree and branch at:
>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git 
>> linux-5.15.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> Regressions found.
> 
> The following Arm combinations failed to build:
> - arm-gcc-8-bcm2835_defconfig
> - arm-gcc-8-imx_v6_v7_defconfig
> - arm-gcc-8-omap2plus_defconfig
> - arm-gcc-9-bcm2835_defconfig
> - arm-gcc-9-imx_v6_v7_defconfig
> - arm-gcc-9-omap2plus_defconfig
> - arm-gcc-10-bcm2835_defconfig
> - arm-gcc-10-imx_v6_v7_defconfig
> - arm-gcc-10-omap2plus_defconfig
> - arm-gcc-11-bcm2835_defconfig
> - arm-gcc-11-imx_v6_v7_defconfig
> - arm-gcc-11-omap2plus_defconfig
> - arm-clang-11-allnoconfig
> - arm-clang-11-at91_dt_defconfig
> - arm-clang-11-axm55xx_defconfig
> - arm-clang-11-bcm2835_defconfig
> - arm-clang-11-clps711x_defconfig
> - arm-clang-11-davinci_all_defconfig
> - arm-clang-11-defconfig
> - arm-clang-11-exynos_defconfig
> - arm-clang-11-footbridge_defconfig
> - arm-clang-11-imx_v4_v5_defconfig
> - arm-clang-11-imx_v6_v7_defconfig
> - arm-clang-11-integrator_defconfig
> - arm-clang-11-ixp4xx_defconfig
> - arm-clang-11-keystone_defconfig
> - arm-clang-11-lpc32xx_defconfig
> - arm-clang-11-mini2440_defconfig
> - arm-clang-11-multi_v5_defconfig
> - arm-clang-11-mxs_defconfig
> - arm-clang-11-nhk8815_defconfig
> - arm-clang-11-omap1_defconfig
> - arm-clang-11-omap2plus_defconfig
> - arm-clang-11-orion5x_defconfig
> - arm-clang-11-pxa910_defconfig
> - arm-clang-11-s3c2410_defconfig
> - arm-clang-11-s3c6400_defconfig
> - arm-clang-11-s5pv210_defconfig
> - arm-clang-11-sama5_defconfig
> - arm-clang-11-shmobile_defconfig
> - arm-clang-11-tinyconfig
> - arm-clang-11-u8500_defconfig
> - arm-clang-11-vexpress_defconfig
> - arm-clang-12-allnoconfig
> - arm-clang-12-at91_dt_defconfig
> - arm-clang-12-axm55xx_defconfig
> - arm-clang-12-bcm2835_defconfig
> - arm-clang-12-clps711x_defconfig
> - arm-clang-12-davinci_all_defconfig
> - arm-clang-12-defconfig
> - arm-clang-12-exynos_defconfig
> - arm-clang-12-footbridge_defconfig
> - arm-clang-12-imx_v4_v5_defconfig
> - arm-clang-12-imx_v6_v7_defconfig
> - arm-clang-12-integrator_defconfig
> - arm-clang-12-ixp4xx_defconfig
> - arm-clang-12-keystone_defconfig
> - arm-clang-12-lpc32xx_defconfig
> - arm-clang-12-mini2440_defconfig
> - arm-clang-12-multi_v5_defconfig
> - arm-clang-12-mxs_defconfig
> - arm-clang-12-nhk8815_defconfig
> - arm-clang-12-omap1_defconfig
> - arm-clang-12-omap2plus_defconfig
> - arm-clang-12-orion5x_defconfig
> - arm-clang-12-pxa910_defconfig
> - arm-clang-12-s3c2410_defconfig
> - arm-clang-12-s3c6400_defconfig
> - arm-clang-12-s5pv210_defconfig
> - arm-clang-12-sama5_defconfig
> - arm-clang-12-shmobile_defconfig
> - arm-clang-12-tinyconfig
> - arm-clang-12-u8500_defconfig
> - arm-clang-12-vexpress_defconfig
> - arm-clang-13-allnoconfig
> - arm-clang-13-at91_dt_defconfig
> - arm-clang-13-axm55xx_defconfig
> - arm-clang-13-bcm2835_defconfig
> - arm-clang-13-clps711x_defconfig
> - arm-clang-13-davinci_all_defconfig
> - arm-clang-13-defconfig
> - arm-clang-13-exynos_defconfig
> - arm-clang-13-footbridge_defconfig
> - arm-clang-13-imx_v4_v5_defconfig
> - arm-clang-13-imx_v6_v7_defconfig
> - arm-clang-13-integrator_defconfig
> - arm-clang-13-ixp4xx_defconfig
> - arm-clang-13-keystone_defconfig
> - arm-clang-13-lpc32xx_defconfig
> - arm-clang-13-mini2440_defconfig
> - arm-clang-13-multi_v5_defconfig
> - arm-clang-13-mxs_defconfig
> - arm-clang-13-nhk8815_defconfig
> - arm-clang-13-omap1_defconfig
> - arm-clang-13-omap2plus_defconfig
> - arm-clang-13-orion5x_defconfig
> - arm-clang-13-pxa910_defconfig
> - arm-clang-13-s3c2410_defconfig
> - arm-clang-13-s3c6400_defconfig
> - arm-clang-13-s5pv210_defconfig
> - arm-clang-13-sama5_defconfig
> - arm-clang-13-shmobile_defconfig
> - arm-clang-13-tinyconfig
> - arm-clang-13-u8500_defconfig
> - arm-clang-13-vexpress_defconfig
> - arm-clang-14-allnoconfig
> - arm-clang-14-at91_dt_defconfig
> - arm-clang-14-axm55xx_defconfig
> - arm-clang-14-bcm2835_defconfig
> - arm-clang-14-clps711x_defconfig
> - arm-clang-14-davinci_all_defconfig
> - arm-clang-14-defconfig
> - arm-clang-14-exynos_defconfig
> - arm-clang-14-footbridge_defconfig
> - arm-clang-14-imx_v4_v5_defconfig
> - arm-clang-14-imx_v6_v7_defconfig
> - arm-clang-14-integrator_defconfig
> - arm-clang-14-ixp4xx_defconfig
> - arm-clang-14-keystone_defconfig
> - arm-clang-14-lpc32xx_defconfig
> - arm-clang-14-mini2440_defconfig
> - arm-clang-14-multi_v5_defconfig
> - arm-clang-14-mxs_defconfig
> - arm-clang-14-nhk8815_defconfig
> - arm-clang-14-omap1_defconfig
> - arm-clang-14-omap2plus_defconfig
> - arm-clang-14-orion5x_defconfig
> - arm-clang-14-pxa910_defconfig
> - arm-clang-14-s3c2410_defconfig
> - arm-clang-14-s3c6400_defconfig
> - arm-clang-14-s5pv210_defconfig
> - arm-clang-14-sama5_defconfig
> - arm-clang-14-shmobile_defconfig
> - arm-clang-14-tinyconfig
> - arm-clang-14-u8500_defconfig
> - arm-clang-14-vexpress_defconfig
> - arm-clang-nightly-allnoconfig
> - arm-clang-nightly-at91_dt_defconfig
> - arm-clang-nightly-axm55xx_defconfig
> - arm-clang-nightly-bcm2835_defconfig
> - arm-clang-nightly-clps711x_defconfig
> - arm-clang-nightly-davinci_all_defconfig
> - arm-clang-nightly-defconfig
> - arm-clang-nightly-exynos_defconfig
> - arm-clang-nightly-footbridge_defconfig
> - arm-clang-nightly-imx_v4_v5_defconfig
> - arm-clang-nightly-imx_v6_v7_defconfig
> - arm-clang-nightly-integrator_defconfig
> - arm-clang-nightly-ixp4xx_defconfig
> - arm-clang-nightly-keystone_defconfig
> - arm-clang-nightly-lpc32xx_defconfig
> - arm-clang-nightly-mini2440_defconfig
> - arm-clang-nightly-multi_v5_defconfig
> - arm-clang-nightly-mxs_defconfig
> - arm-clang-nightly-nhk8815_defconfig
> - arm-clang-nightly-omap1_defconfig
> - arm-clang-nightly-omap2plus_defconfig
> - arm-clang-nightly-orion5x_defconfig
> - arm-clang-nightly-pxa910_defconfig
> - arm-clang-nightly-s3c2410_defconfig
> - arm-clang-nightly-s3c6400_defconfig
> - arm-clang-nightly-s5pv210_defconfig
> - arm-clang-nightly-sama5_defconfig
> - arm-clang-nightly-shmobile_defconfig
> - arm-clang-nightly-tinyconfig
> - arm-clang-nightly-u8500_defconfig
> - arm-clang-nightly-vexpress_defconfig
> 
> 
> Here's one error for GCC (imx_v6_v7_defconfig with gcc-9):
> 
>    /builds/linux/arch/arm/kernel/entry-common.S: Assembler messages:
>    /builds/linux/arch/arm/kernel/entry-common.S:166: Error: co-processor 
> register expected -- `mcr p15,0,r0,c7,r5,4'
>    /builds/linux/arch/arm/kernel/entry-common.S:175: Error: co-processor 
> register expected -- `mcr p15,0,r0,c7,r5,4'
>    make[3]: *** [/builds/linux/scripts/Makefile.build:379: 
> arch/arm/kernel/entry-common.o] Error 1
>    /builds/linux/arch/arm/common/secure_cntvoff.S: Assembler messages:
>    /builds/linux/arch/arm/common/secure_cntvoff.S:24: Error: 
> co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
>    /builds/linux/arch/arm/common/secure_cntvoff.S:27: Error: 
> co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
>    /builds/linux/arch/arm/common/secure_cntvoff.S:29: Error: 
> co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
>    make[3]: *** [/builds/linux/scripts/Makefile.build:379: 
> arch/arm/common/secure_cntvoff.o] Error 1
>    make[3]: Target '__build' not remade because of errors.
>    make[2]: *** [/builds/linux/scripts/Makefile.build:540: 
> arch/arm/common] Error 2
>    /builds/linux/arch/arm/kernel/entry-armv.S: Assembler messages:
>    /builds/linux/arch/arm/kernel/entry-armv.S:1088: Error: co-processor 
> register expected -- `mcr p15,0,r0,c7,r5,4'
>    /builds/linux/arch/arm/kernel/entry-armv.S:1111: Error: co-processor 
> register expected -- `mcr p15,0,r0,c7,r5,4'
>    /builds/linux/arch/arm/kernel/entry-armv.S:1134: Error: co-processor 
> register expected -- `mcr p15,0,r0,c7,r5,4'
>    /builds/linux/arch/arm/kernel/entry-armv.S:1157: Error: co-processor 
> register expected -- `mcr p15,0,r0,c7,r5,4'
>    /builds/linux/arch/arm/kernel/entry-armv.S:1196: Error: co-processor 
> register expected -- `mcr p15,0,r0,c7,r5,4'
>    make[3]: *** [/builds/linux/scripts/Makefile.build:379: 
> arch/arm/kernel/entry-armv.o] Error 1
>    /builds/linux/arch/arm/mach-imx/suspend-imx6.S: Assembler messages:
>    /builds/linux/arch/arm/mach-imx/suspend-imx6.S:315: Error: 
> co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
>    make[2]: *** [/builds/linux/scripts/Makefile.build:379: 
> arch/arm/mach-imx/suspend-imx6.o] Error 1
>    /builds/linux/arch/arm/mm/cache-v7.S: Assembler messages:
>    /builds/linux/arch/arm/mm/cache-v7.S:42: Error: co-processor register 
> expected -- `mcr p15,0,r0,c7,r5,4'
>    /builds/linux/arch/arm/mm/cache-v7.S:69: Error: co-processor register 
> expected -- `mcr p15,0,r0,c7,r5,4'
>    /builds/linux/arch/arm/mm/cache-v7.S:142: Error: co-processor 
> register expected -- `mcr p15,0,r0,c7,r5,4'
>    /builds/linux/arch/arm/mm/cache-v7.S:179: Error: co-processor 
> register expected -- `mcr p15,0,r0,c7,r5,4'
>    /builds/linux/arch/arm/mm/cache-v7.S:312: Error: co-processor 
> register expected -- `mcr p15,0,r0,c7,r5,4'
>    make[3]: *** [/builds/linux/scripts/Makefile.build:379: 
> arch/arm/mm/cache-v7.o] Error 1
>    /builds/linux/arch/arm/mm/tlb-v7.S: Assembler messages:
>    /builds/linux/arch/arm/mm/tlb-v7.S:85: Error: co-processor register 
> expected -- `mcr p15,0,r0,c7,r5,4'
>    make[3]: *** [/builds/linux/scripts/Makefile.build:379: 
> arch/arm/mm/tlb-v7.o] Error 1
>    /builds/linux/arch/arm/mm/proc-v7-2level.S: Assembler messages:
>    /builds/linux/arch/arm/mm/proc-v7-2level.S:55: Error: co-processor 
> register expected -- `mcr p15,0,r0,c7,r5,4'
>    /builds/linux/arch/arm/mm/proc-v7-2level.S:57: Error: co-processor 
> register expected -- `mcr p15,0,r0,c7,r5,4'
>    /builds/linux/arch/arm/mm/proc-v7.S:59: Error: co-processor register 
> expected -- `mcr p15,0,r0,c7,r5,4'
>    /builds/linux/arch/arm/mm/proc-v7.S:183: Error: co-processor register 
> expected -- `mcr p15,0,r0,c7,r5,4'
>    make[3]: *** [/builds/linux/scripts/Makefile.build:379: 
> arch/arm/mm/proc-v7.o] Error 1
>    make[2]: Target '__build' not remade because of errors.
>    make[1]: *** [/builds/linux/Makefile:1868: arch/arm/mach-imx] Error 2
>    make[3]: Target '__build' not remade because of errors.
>    make[2]: *** [/builds/linux/scripts/Makefile.build:540: arch/arm/mm] 
> Error 2
>    /builds/linux/arch/arm/kernel/hyp-stub.S: Assembler messages:
>    /builds/linux/arch/arm/kernel/hyp-stub.S:173: Error: co-processor 
> register expected -- `mcr p15,0,r0,c7,r5,4'
>    make[3]: *** [/builds/linux/scripts/Makefile.build:379: 
> arch/arm/kernel/hyp-stub.o] Error 1
>    make[3]: Target '__build' not remade because of errors.
>    make[2]: *** [/builds/linux/scripts/Makefile.build:540: 
> arch/arm/kernel] Error 2
>    make[2]: Target '__build' not remade because of errors.
>    make[1]: *** [/builds/linux/Makefile:1868: arch/arm] Error 2

This one is fixed with:

https://lore.kernel.org/linux-arm-kernel/E1nS1fu-00GcNN-24@rmk-PC.armlinux.org.uk/

> 
> 
> And here's one for Clang (same imx_v4_v5_defconfig config, but with 
> clang-11):
> 
>    ld.lld: error: ./arch/arm/kernel/vmlinux.lds:117: AT expected, but 
> got NOCROSSREFS
>    >>>  __vectors_lma = .; OVERLAY 0xffff0000 : NOCROSSREFS 
> AT(__vectors_lma) { .vectors { *(.vectors) } .vectors.bhb.loop8 { 
> *(.vectors.bhb.loop8) } .vectors.bhb.bpiall { *(.vectors.bhb.bpiall) } } 
> __vectors_start = LOADADDR(.vectors); __vectors_end = LOADADDR(.vectors) 
> + SIZEOF(.vectors); __vectors_bhb_loop8_start = 
> LOADADDR(.vectors.bhb.loop8); __vectors_bhb_loop8_end = 
> LOADADDR(.vectors.bhb.loop8) + SIZEOF(.vectors.bhb.loop8); 
> __vectors_bhb_bpiall_start = LOADADDR(.vectors.bhb.bpiall); 
> __vectors_bhb_bpiall_end = LOADADDR(.vectors.bhb.bpiall) + 
> SIZEOF(.vectors.bhb.bpiall); . = __vectors_lma + SIZEOF(.vectors) + 
> SIZEOF(.vectors.bhb.loop8) + SIZEOF(.vectors.bhb.bpiall); __stubs_lma = 
> .; .stubs ADDR(.vectors) + 0x1000 : AT(__stubs_lma) { *(.stubs) } 
> __stubs_start = LOADADDR(.stubs); __stubs_end = LOADADDR(.stubs) + 
> SIZEOF(.stubs); . = __stubs_lma + SIZEOF(.stubs); 
> PROVIDE(vector_fiq_offset = vector_fiq - ADDR(.vectors));
>    >>>                                          ^
>    make[1]: *** [/builds/linux/Makefile:1183: vmlinux] Error 1

And this one with:

https://lore.kernel.org/linux-arm-kernel/20220309220726.1525113-1-nathan@kernel.org/
-- 
Florian

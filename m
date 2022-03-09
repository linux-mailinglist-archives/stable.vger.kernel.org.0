Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E25C64D3B5C
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 21:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236455AbiCIUvP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 15:51:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236059AbiCIUvO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 15:51:14 -0500
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6B30DF73
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 12:50:14 -0800 (PST)
Received: by mail-oo1-xc33.google.com with SMTP id j7-20020a4ad6c7000000b0031c690e4123so4333356oot.11
        for <stable@vger.kernel.org>; Wed, 09 Mar 2022 12:50:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=w86PkjB8Iuxia7REaPfco2O01L0ZyZq9lCWCqy/ewuY=;
        b=xlFS8gRVuuOEEuVQNAx7gGWhnhMf61G7Jmu2DBVGKLX8o78japRhdPPNRro7RzEK4p
         gdZE06h8pKvjn5xQO7jU602Vpt7ZQ6WsvjwlvtDipalIiuhgWRd+r3pPYBv6Vp6zWAh6
         jahQwSvZtSh6rOmj3qlhF/VAViM1dmeD+uByLUfUA7Iflxv3FBPPYzj4NV89rIM+OB9h
         OYlyrhSYxLv3wEHSUUwFn99fejyw8fgiBD7YJTpwcOSWfEVROHHdebPiQNEJ1ZTP/s+K
         jrcilkV7ckbr1KN7/+CIFMGSw57o0Xjk1FGeRD+qPimN6nku7iexorrBZZ5CrFcXXjaR
         82Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=w86PkjB8Iuxia7REaPfco2O01L0ZyZq9lCWCqy/ewuY=;
        b=UHCbbslCME+UTp9Cm+scZwsmJLIGyJJPIvVkTBNQcInu7YywFStJbbLdAqsbHArL/y
         AeUIunlMAlglP33fRChC9T8qhNKYKiR1mG7d0AWXDx1uoWCvs91ctYH9lLOSAY3UtBuy
         8Yu+ZFQGBPM9802rh5m8bLpcAUy11zbb7VDE6OLn8i11hcSttwdjBjHuD/927PxAXiPi
         7B15PbDtGGrWcszKYvbqBQXDpLGK0ViGagTF9IgQItV7eT6exjfT0J7ueB/dVS8MOPlN
         +pbS1x2pJico0mKEIgnTit9AESnHODiO7WKkLdt0r7iYreuicX0JyvnCzwnR5bAh3BIH
         dfzw==
X-Gm-Message-State: AOAM532PPoA+HPZo7DUUGWU7tDiGQLSx8aOpVmvM8DqSFAsUNbWfs2Q+
        J37ZT1AQpJh0RVRbNFe7vEzFTw==
X-Google-Smtp-Source: ABdhPJyx86MIBVEmlex2bqLZuX/0m4w80vL0DPUkjMjV71cpA368aD9iAoL0GOqDVLAyCG9E9yeKoQ==
X-Received: by 2002:a05:6870:e74c:b0:da:b3f:3238 with SMTP id t12-20020a056870e74c00b000da0b3f3238mr814295oak.232.1646859013563;
        Wed, 09 Mar 2022 12:50:13 -0800 (PST)
Received: from [192.168.17.16] ([189.219.74.147])
        by smtp.gmail.com with ESMTPSA id l14-20020a056820030e00b00320edaf9b8esm1413555ooe.44.2022.03.09.12.50.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 12:50:13 -0800 (PST)
Message-ID: <d6f2a085-9d76-03d6-9b88-aec5769a50d8@linaro.org>
Date:   Wed, 9 Mar 2022 14:50:11 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.4 00/18] 5.4.184-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220309155856.552503355@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20220309155856.552503355@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 09/03/22 09:59, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.184 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Mar 2022 15:58:48 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.184-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Regressions found.

The following Arm combinations failed to build:
- arm-clang-11-allnoconfig
- arm-clang-11-at91_dt_defconfig
- arm-clang-11-axm55xx_defconfig
- arm-clang-11-bcm2835_defconfig
- arm-clang-11-clps711x_defconfig
- arm-clang-11-davinci_all_defconfig
- arm-clang-11-defconfig
- arm-clang-11-exynos_defconfig
- arm-clang-11-footbridge_defconfig
- arm-clang-11-imx_v4_v5_defconfig
- arm-clang-11-imx_v6_v7_defconfig
- arm-clang-11-integrator_defconfig
- arm-clang-11-ixp4xx_defconfig
- arm-clang-11-keystone_defconfig
- arm-clang-11-lpc32xx_defconfig
- arm-clang-11-mini2440_defconfig
- arm-clang-11-multi_v5_defconfig
- arm-clang-11-mxs_defconfig
- arm-clang-11-nhk8815_defconfig
- arm-clang-11-omap1_defconfig
- arm-clang-11-omap2plus_defconfig
- arm-clang-11-orion5x_defconfig
- arm-clang-11-pxa910_defconfig
- arm-clang-11-s3c2410_defconfig
- arm-clang-11-s3c6400_defconfig
- arm-clang-11-s5pv210_defconfig
- arm-clang-11-sama5_defconfig
- arm-clang-11-shmobile_defconfig
- arm-clang-11-tinyconfig
- arm-clang-11-u8500_defconfig
- arm-clang-11-vexpress_defconfig
- arm-clang-12-allnoconfig
- arm-clang-12-at91_dt_defconfig
- arm-clang-12-axm55xx_defconfig
- arm-clang-12-bcm2835_defconfig
- arm-clang-12-clps711x_defconfig
- arm-clang-12-davinci_all_defconfig
- arm-clang-12-defconfig
- arm-clang-12-exynos_defconfig
- arm-clang-12-footbridge_defconfig
- arm-clang-12-imx_v4_v5_defconfig
- arm-clang-12-imx_v6_v7_defconfig
- arm-clang-12-integrator_defconfig
- arm-clang-12-ixp4xx_defconfig
- arm-clang-12-keystone_defconfig
- arm-clang-12-lpc32xx_defconfig
- arm-clang-12-mini2440_defconfig
- arm-clang-12-multi_v5_defconfig
- arm-clang-12-mxs_defconfig
- arm-clang-12-nhk8815_defconfig
- arm-clang-12-omap1_defconfig
- arm-clang-12-omap2plus_defconfig
- arm-clang-12-orion5x_defconfig
- arm-clang-12-pxa910_defconfig
- arm-clang-12-s3c2410_defconfig
- arm-clang-12-s3c6400_defconfig
- arm-clang-12-s5pv210_defconfig
- arm-clang-12-sama5_defconfig
- arm-clang-12-shmobile_defconfig
- arm-clang-12-tinyconfig
- arm-clang-12-u8500_defconfig
- arm-clang-12-vexpress_defconfig
- arm-clang-13-allnoconfig
- arm-clang-13-at91_dt_defconfig
- arm-clang-13-axm55xx_defconfig
- arm-clang-13-bcm2835_defconfig
- arm-clang-13-clps711x_defconfig
- arm-clang-13-davinci_all_defconfig
- arm-clang-13-defconfig
- arm-clang-13-exynos_defconfig
- arm-clang-13-footbridge_defconfig
- arm-clang-13-imx_v4_v5_defconfig
- arm-clang-13-imx_v6_v7_defconfig
- arm-clang-13-integrator_defconfig
- arm-clang-13-ixp4xx_defconfig
- arm-clang-13-keystone_defconfig
- arm-clang-13-lpc32xx_defconfig
- arm-clang-13-mini2440_defconfig
- arm-clang-13-multi_v5_defconfig
- arm-clang-13-mxs_defconfig
- arm-clang-13-nhk8815_defconfig
- arm-clang-13-omap1_defconfig
- arm-clang-13-omap2plus_defconfig
- arm-clang-13-orion5x_defconfig
- arm-clang-13-pxa910_defconfig
- arm-clang-13-s3c2410_defconfig
- arm-clang-13-s3c6400_defconfig
- arm-clang-13-s5pv210_defconfig
- arm-clang-13-sama5_defconfig
- arm-clang-13-shmobile_defconfig
- arm-clang-13-tinyconfig
- arm-clang-13-u8500_defconfig
- arm-clang-13-vexpress_defconfig
- arm-clang-14-allnoconfig
- arm-clang-14-at91_dt_defconfig
- arm-clang-14-axm55xx_defconfig
- arm-clang-14-bcm2835_defconfig
- arm-clang-14-clps711x_defconfig
- arm-clang-14-davinci_all_defconfig
- arm-clang-14-defconfig
- arm-clang-14-exynos_defconfig
- arm-clang-14-footbridge_defconfig
- arm-clang-14-imx_v4_v5_defconfig
- arm-clang-14-imx_v6_v7_defconfig
- arm-clang-14-integrator_defconfig
- arm-clang-14-ixp4xx_defconfig
- arm-clang-14-keystone_defconfig
- arm-clang-14-lpc32xx_defconfig
- arm-clang-14-mini2440_defconfig
- arm-clang-14-multi_v5_defconfig
- arm-clang-14-mxs_defconfig
- arm-clang-14-nhk8815_defconfig
- arm-clang-14-omap1_defconfig
- arm-clang-14-omap2plus_defconfig
- arm-clang-14-orion5x_defconfig
- arm-clang-14-pxa910_defconfig
- arm-clang-14-s3c2410_defconfig
- arm-clang-14-s3c6400_defconfig
- arm-clang-14-s5pv210_defconfig
- arm-clang-14-sama5_defconfig
- arm-clang-14-shmobile_defconfig
- arm-clang-14-tinyconfig
- arm-clang-14-u8500_defconfig
- arm-clang-14-vexpress_defconfig
- arm-clang-nightly-allnoconfig
- arm-clang-nightly-at91_dt_defconfig
- arm-clang-nightly-axm55xx_defconfig
- arm-clang-nightly-bcm2835_defconfig
- arm-clang-nightly-clps711x_defconfig
- arm-clang-nightly-davinci_all_defconfig
- arm-clang-nightly-defconfig
- arm-clang-nightly-exynos_defconfig
- arm-clang-nightly-footbridge_defconfig
- arm-clang-nightly-imx_v4_v5_defconfig
- arm-clang-nightly-imx_v6_v7_defconfig
- arm-clang-nightly-integrator_defconfig
- arm-clang-nightly-ixp4xx_defconfig
- arm-clang-nightly-keystone_defconfig
- arm-clang-nightly-lpc32xx_defconfig
- arm-clang-nightly-mini2440_defconfig
- arm-clang-nightly-multi_v5_defconfig
- arm-clang-nightly-mxs_defconfig
- arm-clang-nightly-nhk8815_defconfig
- arm-clang-nightly-omap1_defconfig
- arm-clang-nightly-omap2plus_defconfig
- arm-clang-nightly-orion5x_defconfig
- arm-clang-nightly-pxa910_defconfig
- arm-clang-nightly-s3c2410_defconfig
- arm-clang-nightly-s3c6400_defconfig
- arm-clang-nightly-s5pv210_defconfig
- arm-clang-nightly-sama5_defconfig
- arm-clang-nightly-shmobile_defconfig
- arm-clang-nightly-tinyconfig
- arm-clang-nightly-u8500_defconfig
- arm-clang-nightly-vexpress_defconfig
- arm-gcc-8-bcm2835_defconfig
- arm-gcc-8-imx_v6_v7_defconfig
- arm-gcc-8-omap2plus_defconfig
- arm-gcc-9-bcm2835_defconfig
- arm-gcc-9-imx_v6_v7_defconfig
- arm-gcc-9-omap2plus_defconfig
- arm-gcc-10-bcm2835_defconfig
- arm-gcc-10-imx_v6_v7_defconfig
- arm-gcc-10-omap2plus_defconfig
- arm-gcc-11-bcm2835_defconfig
- arm-gcc-11-imx_v6_v7_defconfig
- arm-gcc-11-omap2plus_defconfig

Clang failures look like this (like mini2440_defconfig with clang-12 here):

   ld.lld: error: ./arch/arm/kernel/vmlinux.lds:98: AT expected, but got NOCROSSREFS
   >>>  __vectors_lma = .; OVERLAY 0xffff0000 : NOCROSSREFS AT(__vectors_lma) { .vectors { *(.vectors) } .vectors.bhb.loop8 { *(.vectors.bhb.loop8) } .vectors.bhb.bpiall { *(.vectors.bhb.bpiall) } } __vectors_start = LOADADDR(.vectors); __vectors_end = LOADADDR(.vectors) + SIZEOF(.vectors); __vectors_bhb_loop8_start = LOADADDR(.vectors.bhb.loop8); __vectors_bhb_loop8_end = LOADADDR(.vectors.bhb.loop8) + SIZEOF(.vectors.bhb.loop8); __vectors_bhb_bpiall_start = LOADADDR(.vectors.bhb.bpiall); __vectors_bhb_bpiall_end = LOADADDR(.vectors.bhb.bpiall) + SIZEOF(.vectors.bhb.bpiall); . = __vectors_lma + SIZEOF(.vectors) + SIZEOF(.vectors.bhb.loop8) + SIZEOF(.vectors.bhb.bpiall); __stubs_lma = .; .stubs ADDR(.vectors) + 0x1000 : AT(__stubs_lma) { *(.stubs) } __stubs_start = LOADADDR(.stubs); __stubs_end = LOADADDR(.stubs) + SIZEOF(.stubs); . = __stubs_lma + SIZEOF(.stubs); PROVIDE(vector_fiq_offset = vector_fiq - ADDR(.vectors));
   >>>                                          ^
   make[1]: *** [/builds/linux/Makefile:1100: vmlinux] Error 1


These are the kind of failures that GCC is throwing (omap2plus_defconfig on gcc-10):

   builds/linux/arch/arm/kernel/entry-common.S: Assembler messages:
   /builds/linux/arch/arm/kernel/entry-common.S:175: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/kernel/entry-common.S:184: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   make[2]: *** [/builds/linux/scripts/Makefile.build:345: arch/arm/kernel/entry-common.o] Error 1
   /builds/linux/arch/arm/common/secure_cntvoff.S: Assembler messages:
   /builds/linux/arch/arm/common/secure_cntvoff.S:24: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/common/secure_cntvoff.S:27: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/common/secure_cntvoff.S:29: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   make[2]: *** [/builds/linux/scripts/Makefile.build:345: arch/arm/common/secure_cntvoff.o] Error 1
   make[2]: Target '__build' not remade because of errors.
   make[1]: *** [/builds/linux/Makefile:1734: arch/arm/common] Error 2
   /builds/linux/arch/arm/kernel/entry-armv.S: Assembler messages:
   /builds/linux/arch/arm/kernel/entry-armv.S:1093: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/kernel/entry-armv.S:1116: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/kernel/entry-armv.S:1139: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/kernel/entry-armv.S:1162: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/kernel/entry-armv.S:1201: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   make[2]: *** [/builds/linux/scripts/Makefile.build:345: arch/arm/kernel/entry-armv.o] Error 1
   /builds/linux/arch/arm/mm/cache-v7.S: Assembler messages:
   /builds/linux/arch/arm/mm/cache-v7.S:69: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/mm/cache-v7.S:142: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/mm/cache-v7.S:179: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/mm/cache-v7.S:312: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   make[2]: *** [/builds/linux/scripts/Makefile.build:345: arch/arm/mm/cache-v7.o] Error 1
   /builds/linux/arch/arm/mm/tlb-v7.S: Assembler messages:
   /builds/linux/arch/arm/mm/tlb-v7.S:85: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   make[2]: *** [/builds/linux/scripts/Makefile.build:345: arch/arm/mm/tlb-v7.o] Error 1
   /builds/linux/arch/arm/mm/proc-v7-2level.S: Assembler messages:
   /builds/linux/arch/arm/mm/proc-v7-2level.S:55: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/mm/proc-v7-2level.S:57: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/mm/proc-v7.S:59: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/mm/proc-v7.S:183: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   make[2]: *** [/builds/linux/scripts/Makefile.build:345: arch/arm/mm/proc-v7.o] Error 1
   make[2]: Target '__build' not remade because of errors.
   make[1]: *** [/builds/linux/Makefile:1734: arch/arm/mm] Error 2
   /builds/linux/arch/arm/mach-omap2/sleep44xx.S: Assembler messages:
   /builds/linux/arch/arm/mach-omap2/sleep44xx.S:91: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/mach-omap2/sleep44xx.S:131: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/mach-omap2/sleep44xx.S:193: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/mach-omap2/sleep44xx.S:205: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/mach-omap2/sleep44xx.S:223: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/mach-omap2/sleep44xx.S:274: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/mach-omap2/sleep44xx.S:342: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   make[2]: *** [/builds/linux/scripts/Makefile.build:345: arch/arm/mach-omap2/sleep44xx.o] Error 1
   make[2]: Target '__build' not remade because of errors.
   make[1]: *** [/builds/linux/Makefile:1734: arch/arm/kernel] Error 2
   /builds/linux/arch/arm/mach-omap2/sleep34xx.S: Assembler messages:
   /builds/linux/arch/arm/mach-omap2/sleep34xx.S:174: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/mach-omap2/sleep34xx.S:308: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   make[2]: *** [/builds/linux/scripts/Makefile.build:345: arch/arm/mach-omap2/sleep34xx.o] Error 1
   /builds/linux/arch/arm/mach-omap2/sleep33xx.S: Assembler messages:
   /builds/linux/arch/arm/mach-omap2/sleep33xx.S:58: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/mach-omap2/sleep33xx.S:125: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/mach-omap2/sleep33xx.S:192: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   make[2]: *** [/builds/linux/scripts/Makefile.build:345: arch/arm/mach-omap2/sleep33xx.o] Error 1
   /builds/linux/arch/arm/mach-omap2/sleep43xx.S: Assembler messages:
   /builds/linux/arch/arm/mach-omap2/sleep43xx.S:98: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/mach-omap2/sleep43xx.S:320: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   make[2]: *** [/builds/linux/scripts/Makefile.build:345: arch/arm/mach-omap2/sleep43xx.o] Error 1
   make[2]: Target '__build' not remade because of errors.
   make[1]: *** [/builds/linux/Makefile:1734: arch/arm/mach-omap2] Error 2


The following i386/x86_64 combinations failed to build:
- i386-gcc-8-allnoconfig
- i386-gcc-8-i386_defconfig
- i386-gcc-8-tinyconfig
- i386-gcc-9-allnoconfig
- i386-gcc-9-i386_defconfig
- i386-gcc-9-tinyconfig
- i386-gcc-10-allnoconfig
- i386-gcc-10-defconfig
- i386-gcc-10-tinyconfig
- i386-gcc-11-allnoconfig
- i386-gcc-11-defconfig
- i386-gcc-11-tinyconfig
- x86_64-clang-11-allnoconfig
- x86_64-clang-11-tinyconfig
- x86_64-clang-11-x86_64_defconfig
- x86_64-clang-12-allnoconfig
- x86_64-clang-12-tinyconfig
- x86_64-clang-12-x86_64_defconfig
- x86_64-clang-13-allnoconfig
- x86_64-clang-13-tinyconfig
- x86_64-clang-13-x86_64_defconfig
- x86_64-clang-14-allnoconfig
- x86_64-clang-14-tinyconfig
- x86_64-clang-14-x86_64_defconfig
- x86_64-clang-nightly-allnoconfig
- x86_64-clang-nightly-tinyconfig
- x86_64-clang-nightly-x86_64_defconfig
- x86_64-gcc-8-allnoconfig
- x86_64-gcc-8-tinyconfig
- x86_64-gcc-8-x86_64_defconfig
- x86_64-gcc-9-allnoconfig
- x86_64-gcc-9-tinyconfig
- x86_64-gcc-9-x86_64_defconfig
- x86_64-gcc-10-allnoconfig
- x86_64-gcc-10-defconfig
- x86_64-gcc-10-tinyconfig
- x86_64-gcc-11-allnoconfig
- x86_64-gcc-11-defconfig
- x86_64-gcc-11-tinyconfig

On x86_64 (allnoconfig, gcc-10) this is the output:

   /builds/linux/arch/x86/entry/entry_64.S: Assembler messages:
   /builds/linux/arch/x86/entry/entry_64.S:1732: Warning: no instruction mnemonic suffix given and no register operands; using default for `sysret'
   /builds/linux/arch/x86/kernel/cpu/bugs.c: In function 'spectre_v2_select_mitigation':
   /builds/linux/arch/x86/kernel/cpu/bugs.c:973:34: error: implicit declaration of function 'unprivileged_ebpf_enabled' [-Werror=implicit-function-declaration]
     973 |  if (mode == SPECTRE_V2_EIBRS && unprivileged_ebpf_enabled())
         |                                  ^~~~~~~~~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors
   make[4]: *** [/builds/linux/scripts/Makefile.build:262: arch/x86/kernel/cpu/bugs.o] Error 1
   make[4]: Target '__build' not remade because of errors.
   make[3]: *** [/builds/linux/scripts/Makefile.build:497: arch/x86/kernel/cpu] Error 2
   make[3]: Target '__build' not remade because of errors.
   make[2]: *** [/builds/linux/scripts/Makefile.build:497: arch/x86/kernel] Error 2
   make[2]: Target '__build' not remade because of errors.
   make[1]: *** [/builds/linux/Makefile:1734: arch/x86] Error 2

Then on i386 (defconfig, gcc-10) very similar error:

   /builds/linux/arch/x86/kernel/cpu/bugs.c: In function 'spectre_v2_select_mitigation':
   /builds/linux/arch/x86/kernel/cpu/bugs.c:973:34: error: implicit declaration of function 'unprivileged_ebpf_enabled' [-Werror=implicit-function-declaration]
     973 |  if (mode == SPECTRE_V2_EIBRS && unprivileged_ebpf_enabled())
         |                                  ^~~~~~~~~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors
   make[4]: *** [/builds/linux/scripts/Makefile.build:262: arch/x86/kernel/cpu/bugs.o] Error 1
   make[4]: Target '__build' not remade because of errors.
   make[3]: *** [/builds/linux/scripts/Makefile.build:497: arch/x86/kernel/cpu] Error 2
   make[3]: Target '__build' not remade because of errors.
   make[2]: *** [/builds/linux/scripts/Makefile.build:497: arch/x86/kernel] Error 2
   make[2]: Target '__build' not remade because of errors.
   make[1]: *** [/builds/linux/Makefile:1734: arch/x86] Error 2


Greetings!

Daniel Díaz
daniel.diaz@linaro.org

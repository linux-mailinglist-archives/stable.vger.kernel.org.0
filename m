Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0D134D3BBF
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 22:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238369AbiCIVLP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 16:11:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233585AbiCIVLO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 16:11:14 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0DCD2BB38
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 13:10:14 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id j83so3967898oih.6
        for <stable@vger.kernel.org>; Wed, 09 Mar 2022 13:10:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=HKF3K+Rh0z34U0RrkomlbOFfYgQiSSXFENmSSSm1/Ng=;
        b=V/e6V/uocMJ1nKWj9uCl9lSKhg/OJ9SZhhK6uqxPHZcx/Z9U5GXOWA8N71tGswmde6
         Q3WKEKgEYaUKeVUEGin9o4mr9FPyErQtbBXhFyKtZCs1XVe3pWnwV+ERrs4pxMhvAOVU
         t+R/wPp15eRndXy2ceEyKzxAdZTVSTDeJeURRhQmwjEY3e0Bo2X/WzIVg++kbWtd80Pv
         nGijtC6xRlLDf6v+e8A3zKWCwxewqpMTk5HYTFtNq7uDwjv95H8v2JCgRl2OHiKhCRNk
         D9N80TIXI3Tk+juziy7nMzR//rSgyp2lSCnNffXoNDuCSKQ9ghHtcHn+MWkwgXxsLNcn
         TM4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=HKF3K+Rh0z34U0RrkomlbOFfYgQiSSXFENmSSSm1/Ng=;
        b=JLt+yPqqmkG/9UTmnJ+X+FYeM+8Pyv+8lHc7YXh1Lp8KPW1Y2URKV2cvBYnHwLd1Hp
         7lVlHcZUwwEErajtsi9mRZBzG+ck9cI3JiJKfq9PoXmWkS7Q6JTphJUNz7nLYWwXiP3Q
         NDqw+ZsOl3PCP9oQH0285LWW8G4LDKJU8S69S8YKtVUyQwxComzXA4e3i3k9Q0qIkjkr
         +VAuPaOF/2P6LT4C3cbkm9jn+Ly3wOGEOp1wbgYTYLZsVI73g4gms/mWSLDPPLcGIo44
         K0Tbmsk9iFb3ZYdvph65dxFJIrtXkPNhD5Q6u3Maolx7OggzocDHEVkBABHxmjjsFPZZ
         1+Hw==
X-Gm-Message-State: AOAM533wlm0TXDZ4OjahPX8nIkX46KUhH8YHn9/w/7vd/VFvuQZ6rhEy
        dw74Cm+6TdGcr3j9yroyn/5J0TdCs4+FFw==
X-Google-Smtp-Source: ABdhPJx1gJ/ig5WhzoRawO0ToMGnywDUpKVoNdU8dxFnCzNcRR2UPQBlYL/fCJ+xz35vA/PXYeipSg==
X-Received: by 2002:a54:4092:0:b0:2d9:4715:dadf with SMTP id i18-20020a544092000000b002d94715dadfmr7256740oii.151.1646860213955;
        Wed, 09 Mar 2022 13:10:13 -0800 (PST)
Received: from [192.168.17.16] ([189.219.74.147])
        by smtp.gmail.com with ESMTPSA id 89-20020a9d0be2000000b005ae194ec5absm1442363oth.15.2022.03.09.13.10.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 13:10:13 -0800 (PST)
Message-ID: <9c2a575d-72c9-8ba6-0cd3-517f88cf522a@linaro.org>
Date:   Wed, 9 Mar 2022 15:10:12 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.10 00/43] 5.10.105-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220309155859.239810747@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20220309155859.239810747@linuxfoundation.org>
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
> This is the start of the stable review cycle for the 5.10.105 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Mar 2022 15:58:48 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.105-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Regressions found.

These Arm combinations failed to build:
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

On Arm with GCC (like imx_v6_v7_defconfig with gcc-9):

   /builds/linux/arch/arm/kernel/entry-common.S: Assembler messages:
   /builds/linux/arch/arm/kernel/entry-common.S:175: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/kernel/entry-common.S:184: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   make[3]: *** [/builds/linux/scripts/Makefile.build:361: arch/arm/kernel/entry-common.o] Error 1
   /builds/linux/arch/arm/kernel/entry-armv.S: Assembler messages:
   /builds/linux/arch/arm/kernel/entry-armv.S:1093: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/kernel/entry-armv.S:1116: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/kernel/entry-armv.S:1139: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/kernel/entry-armv.S:1162: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/kernel/entry-armv.S:1201: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   make[3]: *** [/builds/linux/scripts/Makefile.build:361: arch/arm/kernel/entry-armv.o] Error 1
   /builds/linux/arch/arm/mach-imx/suspend-imx6.S: Assembler messages:
   /builds/linux/arch/arm/mach-imx/suspend-imx6.S:315: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   make[2]: *** [/builds/linux/scripts/Makefile.build:361: arch/arm/mach-imx/suspend-imx6.o] Error 1
   make[2]: Target '__build' not remade because of errors.
   make[1]: *** [/builds/linux/Makefile:1822: arch/arm/mach-imx] Error 2
   /builds/linux/arch/arm/kernel/hyp-stub.S: Assembler messages:
   /builds/linux/arch/arm/kernel/hyp-stub.S:176: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   make[3]: *** [/builds/linux/scripts/Makefile.build:361: arch/arm/kernel/hyp-stub.o] Error 1
   /builds/linux/arch/arm/mm/cache-v7.S: Assembler messages:
   /builds/linux/arch/arm/mm/cache-v7.S:69: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/mm/cache-v7.S:142: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/mm/cache-v7.S:179: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/mm/cache-v7.S:312: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   make[3]: *** [/builds/linux/scripts/Makefile.build:361: arch/arm/mm/cache-v7.o] Error 1
   /builds/linux/arch/arm/mm/tlb-v7.S: Assembler messages:
   /builds/linux/arch/arm/mm/tlb-v7.S:85: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   make[3]: *** [/builds/linux/scripts/Makefile.build:361: arch/arm/mm/tlb-v7.o] Error 1
   /builds/linux/arch/arm/mm/proc-v7-2level.S: Assembler messages:
   /builds/linux/arch/arm/mm/proc-v7-2level.S:55: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/mm/proc-v7-2level.S:57: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/mm/proc-v7.S:59: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/mm/proc-v7.S:183: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   make[3]: *** [/builds/linux/scripts/Makefile.build:361: arch/arm/mm/proc-v7.o] Error 1
   make[3]: Target '__build' not remade because of errors.
   make[2]: *** [/builds/linux/scripts/Makefile.build:497: arch/arm/kernel] Error 2
   make[3]: Target '__build' not remade because of errors.
   make[2]: *** [/builds/linux/scripts/Makefile.build:497: arch/arm/mm] Error 2
   /builds/linux/arch/arm/common/secure_cntvoff.S: Assembler messages:
   /builds/linux/arch/arm/common/secure_cntvoff.S:24: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/common/secure_cntvoff.S:27: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/common/secure_cntvoff.S:29: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   make[3]: *** [/builds/linux/scripts/Makefile.build:361: arch/arm/common/secure_cntvoff.o] Error 1
   make[3]: Target '__build' not remade because of errors.
   make[2]: *** [/builds/linux/scripts/Makefile.build:497: arch/arm/common] Error 2
   make[2]: Target '__build' not remade because of errors.
   make[1]: *** [/builds/linux/Makefile:1822: arch/arm] Error 2

And with Clang (like allnoconfig with clang-11):

   ld.lld: error: ./arch/arm/kernel/vmlinux.lds:102: AT expected, but got NOCROSSREFS
   >>>  __vectors_lma = .; OVERLAY 0xffff0000 : NOCROSSREFS AT(__vectors_lma) { .vectors { *(.vectors) } .vectors.bhb.loop8 { *(.vectors.bhb.loop8) } .vectors.bhb.bpiall { *(.vectors.bhb.bpiall) } } __vectors_start = LOADADDR(.vectors); __vectors_end = LOADADDR(.vectors) + SIZEOF(.vectors); __vectors_bhb_loop8_start = LOADADDR(.vectors.bhb.loop8); __vectors_bhb_loop8_end = LOADADDR(.vectors.bhb.loop8) + SIZEOF(.vectors.bhb.loop8); __vectors_bhb_bpiall_start = LOADADDR(.vectors.bhb.bpiall); __vectors_bhb_bpiall_end = LOADADDR(.vectors.bhb.bpiall) + SIZEOF(.vectors.bhb.bpiall); . = __vectors_lma + SIZEOF(.vectors) + SIZEOF(.vectors.bhb.loop8) + SIZEOF(.vectors.bhb.bpiall); __stubs_lma = .; .stubs ADDR(.vectors) + 0x1000 : AT(__stubs_lma) { *(.stubs) } __stubs_start = LOADADDR(.stubs); __stubs_end = LOADADDR(.stubs) + SIZEOF(.stubs); . = __stubs_lma + SIZEOF(.stubs); PROVIDE(vector_fiq_offset = vector_fiq - ADDR(.vectors));
   >>>                                          ^
   make[1]: *** [/builds/linux/Makefile:1179: vmlinux] Error 1


Greetings!

Daniel Díaz
daniel.diaz@linaro.org

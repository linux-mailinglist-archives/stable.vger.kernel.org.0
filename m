Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6425F4D3988
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 20:08:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbiCITJH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 14:09:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236202AbiCITJG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 14:09:06 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C1F112F43A
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 11:08:06 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id h10so3653625oia.4
        for <stable@vger.kernel.org>; Wed, 09 Mar 2022 11:08:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=U5d9t3UfT3ndaqxQ5pGVnUUebHdD9XwULGQozUV/MOc=;
        b=nwGQ190eFVVWGLIEGvxzXoLAGhiw5SgzMHqGtWgaGsgWKJQA9HREsLQlnX8nvAcZyK
         sLiCpNgTteb47bqNaNob7svqXQt6tybBMigMjjSBCLTZBmzZKI838vHhVg7MJv8stgPQ
         XDkQqLFB9iuZKUe0snnunesx04X464BZosipUhvwFSovqAXQby2N0RnfmJQjQb9YQtd7
         VyF0g1eydZ4YqKHfZfSETlwhNoOFOU/AY2/cZ2e12DV0DnUqAvf38WB3Ul1EmYX+/llx
         sToD/NA8N7Ar1uS9ma0okiaLcqcoYae2HKl+KEdilIZO045tWDu6OGvBdEoxIC+VET4u
         VzNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=U5d9t3UfT3ndaqxQ5pGVnUUebHdD9XwULGQozUV/MOc=;
        b=oj0YdZSrZTDhCWz5TRrG9OKTsQ3scakDZaJ6dwpKbqW0uLJ4eJ76xZNbAXWfjhFwe+
         1QL1scqfDNePfCcuODMKIVHoCcFJPZWFIP4H5IhUMBKFQC6DiZaSQIPcSenikGzd99F4
         AIjwBDqj0Ys9/CMPeFqHjJ3UBIaHHMzEB09bxbnYSjjpY965bEqJLSplpSGCytfoloZx
         z9wSd6TgGj/eSUhlbS7Vqr7yL04VxMKGVj71gVZdmq+Ff9ocgVmrgnRiVN3+HNDOM0ZZ
         FcyKE2xeWu8aw4HqNvcsRLkVLpbT2LnXMxEP1/ACer3VhlVF3LNK/0rUHfxNAxV0A4ey
         zgeQ==
X-Gm-Message-State: AOAM532sVDut59wsTt3MH3CNAQSkgxyS9os7ywerJReAozItxy3zybWf
        RG/LTYKpzCkbAqKiS+Sov6qCGw==
X-Google-Smtp-Source: ABdhPJw3WQ0uvX2pgqkgc6e2GdGOp/VGkAKPzkdeokNO5NjNrc86cPcTAYFqm44xR9PJwWTGIGJJyg==
X-Received: by 2002:a05:6808:148a:b0:2d9:a01a:48a5 with SMTP id e10-20020a056808148a00b002d9a01a48a5mr6640794oiw.240.1646852885587;
        Wed, 09 Mar 2022 11:08:05 -0800 (PST)
Received: from [192.168.17.16] ([189.219.74.147])
        by smtp.gmail.com with ESMTPSA id y6-20020a4a86c6000000b0031bf43a9212sm1416089ooh.11.2022.03.09.11.08.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 11:08:04 -0800 (PST)
Message-ID: <6652bbe8-dfa7-a866-4f4a-e4790ecafe94@linaro.org>
Date:   Wed, 9 Mar 2022 13:08:03 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 4.19 00/18] 4.19.234-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220309155856.155540075@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20220309155856.155540075@linuxfoundation.org>
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
> This is the start of the stable review cycle for the 4.19.234 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Mar 2022 15:58:48 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.234-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Regressions found.

The following Arm combinations failed to build:
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

The Clang failures look like this (here's lpc32xx_defconfig with clang-11):

   ld.lld: error: ./arch/arm/kernel/vmlinux.lds:98: AT expected, but got NOCROSSREFS
   >>>  __vectors_lma = .; OVERLAY 0xffff0000 : NOCROSSREFS AT(__vectors_lma) { .vectors { *(.vectors) } .vectors.bhb.loop8 { *(.vectors.bhb.loop8) } .vectors.bhb.bpiall { *(.vectors.bhb.bpiall) } } __vectors_start = LOADADDR(.vectors); __vectors_end = LOADADDR(.vectors) + SIZEOF(.vectors); __vectors_bhb_loop8_start = LOADADDR(.vectors.bhb.loop8); __vectors_bhb_loop8_end = LOADADDR(.vectors.bhb.loop8) + SIZEOF(.vectors.bhb.loop8); __vectors_bhb_bpiall_start = LOADADDR(.vectors.bhb.bpiall); __vectors_bhb_bpiall_end = LOADADDR(.vectors.bhb.bpiall) + SIZEOF(.vectors.bhb.bpiall); . = __vectors_lma + SIZEOF(.vectors) + SIZEOF(.vectors.bhb.loop8) + SIZEOF(.vectors.bhb.bpiall); __stubs_lma = .; .stubs ADDR(.vectors) + 0x1000 : AT(__stubs_lma) { *(.stubs) } __stubs_start = LOADADDR(.stubs); __stubs_end = LOADADDR(.stubs) + SIZEOF(.stubs); . = __stubs_lma + SIZEOF(.stubs); PROVIDE(vector_fiq_offset = vector_fiq - ADDR(.vectors));
   >>>                                          ^
   make[1]: *** [/builds/linux/Makefile:1050: vmlinux] Error 1


A GCC failure (bcm2835_defconfig with gcc-9):

   /builds/linux/arch/arm/kernel/entry-common.S: Assembler messages:
   /builds/linux/arch/arm/kernel/entry-common.S:178: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/kernel/entry-common.S:187: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   make[2]: *** [/builds/linux/scripts/Makefile.build:403: arch/arm/kernel/entry-common.o] Error 1
   /builds/linux/arch/arm/common/secure_cntvoff.S: Assembler messages:
   /builds/linux/arch/arm/common/secure_cntvoff.S:24: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/common/secure_cntvoff.S:27: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/common/secure_cntvoff.S:29: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   make[2]: *** [/builds/linux/scripts/Makefile.build:403: arch/arm/common/secure_cntvoff.o] Error 1
   make[2]: Target '__build' not remade because of errors.
   make[1]: *** [/builds/linux/Makefile:1070: arch/arm/common] Error 2
   /builds/linux/arch/arm/kernel/entry-armv.S: Assembler messages:
   /builds/linux/arch/arm/kernel/entry-armv.S:1117: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/kernel/entry-armv.S:1140: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/kernel/entry-armv.S:1163: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/kernel/entry-armv.S:1186: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/kernel/entry-armv.S:1225: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   make[2]: *** [/builds/linux/scripts/Makefile.build:403: arch/arm/kernel/entry-armv.o] Error 1
   /builds/linux/arch/arm/mm/cache-v7.S: Assembler messages:
   /builds/linux/arch/arm/mm/cache-v7.S:64: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/mm/cache-v7.S:137: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/mm/cache-v7.S:171: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/mm/cache-v7.S:299: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   make[2]: *** [/builds/linux/scripts/Makefile.build:403: arch/arm/mm/cache-v7.o] Error 1
   /builds/linux/arch/arm/mm/tlb-v7.S: Assembler messages:
   /builds/linux/arch/arm/mm/tlb-v7.S:88: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   make[2]: *** [/builds/linux/scripts/Makefile.build:403: arch/arm/mm/tlb-v7.o] Error 1
   /builds/linux/arch/arm/mm/proc-v7-2level.S: Assembler messages:
   /builds/linux/arch/arm/mm/proc-v7-2level.S:58: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/mm/proc-v7-2level.S:60: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/mm/proc-v7.S:62: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   make[2]: *** [/builds/linux/scripts/Makefile.build:403: arch/arm/mm/proc-v7.o] Error 1
   make[2]: Target '__build' not remade because of errors.
   make[1]: *** [/builds/linux/Makefile:1070: arch/arm/mm] Error 2


The following x86_64/i386 combinations failed to build:
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


An x86_64 failure (defconfig + LKFT sauce on gcc-11):

   /builds/linux/arch/x86/entry/entry_64.S: Assembler messages:
   /builds/linux/arch/x86/entry/entry_64.S:1738: Warning: no instruction mnemonic suffix given and no register operands; using default for `sysret'
   /builds/linux/arch/x86/kernel/cpu/bugs.c: In function 'spectre_v2_select_mitigation':
   /builds/linux/arch/x86/kernel/cpu/bugs.c:973:41: error: implicit declaration of function 'unprivileged_ebpf_enabled' [-Werror=implicit-function-declaration]
     973 |         if (mode == SPECTRE_V2_EIBRS && unprivileged_ebpf_enabled())
         |                                         ^~~~~~~~~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors
   make[4]: *** [/builds/linux/scripts/Makefile.build:303: arch/x86/kernel/cpu/bugs.o] Error 1
   make[4]: Target '__build' not remade because of errors.
   make[3]: *** [/builds/linux/scripts/Makefile.build:544: arch/x86/kernel/cpu] Error 2
   make[3]: Target '__build' not remade because of errors.
   make[2]: *** [/builds/linux/scripts/Makefile.build:544: arch/x86/kernel] Error 2
   make[2]: Target '__build' not remade because of errors.
   make[1]: *** [/builds/linux/Makefile:1070: arch/x86] Error 2
   /builds/linux/drivers/crypto/ccp/sp-platform.c:37:34: warning: array 'sp_of_match' assumed to have one element
      37 | static const struct of_device_id sp_of_match[];
         |                                  ^~~~~~~~~~~
   /builds/linux/drivers/gpu/drm/i915/intel_dp.c: In function 'intel_dp_check_mst_status':
   /builds/linux/drivers/gpu/drm/i915/intel_dp.c:4129:30: warning: 'drm_dp_channel_eq_ok' reading 6 bytes from a region of size 4 [-Wstringop-overread]
    4129 |                             !drm_dp_channel_eq_ok(&esi[10], intel_dp->lane_count)) {
         |                              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   /builds/linux/drivers/gpu/drm/i915/intel_dp.c:4129:30: note: referencing argument 1 of type 'const u8 *' {aka 'const unsigned char *'}
   In file included from /builds/linux/drivers/gpu/drm/i915/intel_dp.c:39:
   /builds/linux/include/drm/drm_dp_helper.h:954:6: note: in a call to function 'drm_dp_channel_eq_ok'
     954 | bool drm_dp_channel_eq_ok(const u8 link_status[DP_LINK_STATUS_SIZE],
         |      ^~~~~~~~~~~~~~~~~~~~
   make[1]: Target '_all' not remade because of errors.
   make: *** [Makefile:146: sub-make] Error 2


And a similar i386 failure (defconfig + LKFT sauce on gcc-11):

   /builds/linux/arch/x86/kernel/cpu/bugs.c: In function 'spectre_v2_select_mitigation':
   /builds/linux/arch/x86/kernel/cpu/bugs.c:973:41: error: implicit declaration of function 'unprivileged_ebpf_enabled' [-Werror=implicit-function-declaration]
     973 |         if (mode == SPECTRE_V2_EIBRS && unprivileged_ebpf_enabled())
         |                                         ^~~~~~~~~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors
   make[4]: *** [/builds/linux/scripts/Makefile.build:303: arch/x86/kernel/cpu/bugs.o] Error 1
   make[4]: Target '__build' not remade because of errors.
   make[3]: *** [/builds/linux/scripts/Makefile.build:544: arch/x86/kernel/cpu] Error 2
   make[3]: Target '__build' not remade because of errors.
   make[2]: *** [/builds/linux/scripts/Makefile.build:544: arch/x86/kernel] Error 2
   make[2]: Target '__build' not remade because of errors.
   make[1]: *** [/builds/linux/Makefile:1070: arch/x86] Error 2
   /builds/linux/drivers/crypto/ccp/sp-platform.c:37:34: warning: array 'sp_of_match' assumed to have one element
      37 | static const struct of_device_id sp_of_match[];
         |                                  ^~~~~~~~~~~
   /builds/linux/drivers/gpu/drm/i915/intel_dp.c: In function 'intel_dp_check_mst_status':
   /builds/linux/drivers/gpu/drm/i915/intel_dp.c:4129:30: warning: 'drm_dp_channel_eq_ok' reading 6 bytes from a region of size 4 [-Wstringop-overread]
    4129 |                             !drm_dp_channel_eq_ok(&esi[10], intel_dp->lane_count)) {
         |                              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   /builds/linux/drivers/gpu/drm/i915/intel_dp.c:4129:30: note: referencing argument 1 of type 'const u8 *' {aka 'const unsigned char *'}
   In file included from /builds/linux/drivers/gpu/drm/i915/intel_dp.c:39:
   /builds/linux/include/drm/drm_dp_helper.h:954:6: note: in a call to function 'drm_dp_channel_eq_ok'
     954 | bool drm_dp_channel_eq_ok(const u8 link_status[DP_LINK_STATUS_SIZE],
         |      ^~~~~~~~~~~~~~~~~~~~
   make[1]: Target '_all' not remade because of errors.
   make: *** [Makefile:146: sub-make] Error 2


Greetings!

Daniel Díaz
daniel.diaz@linaro.org

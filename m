Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 245424D3BF5
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 22:19:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238395AbiCIVUh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 16:20:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236573AbiCIVUh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 16:20:37 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2793818AE
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 13:19:37 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id x193so4052186oix.0
        for <stable@vger.kernel.org>; Wed, 09 Mar 2022 13:19:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=6maCRm3iifsIgLZG+3qgOXX+dysFZClxsnc5sToPlVY=;
        b=t73MWXKefOv4BDqfQnOSnS45XeqM3oY1XXBiPXhfJo2hG3+S1Sy04w1wUKLGM+jh/U
         YXem4obNxcgnjYNCioGiiC5JQ/UOj8oMD+L4Wp2VCkKOFMZ04Tq13DB96asdGDXvG8EM
         p3z0dbtIv24XDxew40R45CU/gyWFOkVY+aboNPD7w8ZfeJb68ANBvAamOynXg/C3ywTE
         /MftiDGdNEhTxuWZTflXwRx5CF/K79qTzlNcq8pXAIofPrAYz6viK4V11zJW1tE8uSsk
         A59l+YoUwBJRtPPOuB4iQmaTNs5kHXIf9ILFHQEV0P28mAvXzKkD+a7H414tGqsZXUP7
         GB9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=6maCRm3iifsIgLZG+3qgOXX+dysFZClxsnc5sToPlVY=;
        b=1AtBPBl/gazW7T0JEytSVhj3pkstlZ+38iVFlYy4MwIC90lK0NkWgPCpHFajm/NRO5
         NepKq8VjZHTVNKiYP2RdzA83jJY7GJpemq1pHVWDtdqNe+Brq4z5BRSc3OI1BF9OcbQ6
         fC9f/kSoFvq+ZDlDqHV/X8soZxepLNnxOPh7Rc1Tisbs0N7omAQ6pGJ0eHB0vdpd00g/
         zjrACP9w9V+FjdsWh1+HYDSuBU3I2fHlnuYz3T+l2Fu6sLV21xB1J1S/5UFw5fsDSBx5
         Y3KCmyvdQVqykaWeacQXBNICHZPJIY12YckbQHlZN/xCmSeuBHgRTxp6s5N2pCO0WK7W
         PUeQ==
X-Gm-Message-State: AOAM5324OLBULZ1txCI34SdIj8sHC77zGmHJEouSDuTMvTLvMVPDqpxh
        OIlJIB0rmQ3Q1X7NOxYSeyKXKg==
X-Google-Smtp-Source: ABdhPJwm+k8IwPuudRK8b5BCdUbpPDwqHatQBrfelOirOyRhmFP74iHNhCKTzGynEy8OoRtQQWsiDw==
X-Received: by 2002:a05:6808:1450:b0:2d9:dad1:a14e with SMTP id x16-20020a056808145000b002d9dad1a14emr7307661oiv.294.1646860776986;
        Wed, 09 Mar 2022 13:19:36 -0800 (PST)
Received: from [192.168.17.16] ([189.219.74.147])
        by smtp.gmail.com with ESMTPSA id u13-20020a9d720d000000b005af257c1cc3sm1603263otj.5.2022.03.09.13.19.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 13:19:36 -0800 (PST)
Message-ID: <377dd5db-4bd5-6b0e-a5bd-344e65776745@linaro.org>
Date:   Wed, 9 Mar 2022 15:19:35 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.16 00/37] 5.16.14-rc1 review
Content-Language: en-US
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220309155859.086952723@linuxfoundation.org>
 <3e00dc5b-e147-e231-4d56-6b5b32968833@linaro.org>
In-Reply-To: <3e00dc5b-e147-e231-4d56-6b5b32968833@linaro.org>
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

Oops! Slipped away.

On 09/03/22 15:17, Daniel Díaz wrote:
> Hello!
> 
> On 09/03/22 10:00, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.16.14 release.
>> There are 37 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Fri, 11 Mar 2022 15:58:48 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>     https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.14-rc1.gz
>> or in the git tree and branch at:
>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
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
> This is a GCC failure (bcm2835_defconfig with gcc-8):
> 
>    /builds/linux/arch/arm/kernel/entry-common.S: Assembler messages:
>    /builds/linux/arch/arm/kernel/entry-common.S:166: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
>    /builds/linux/arch/arm/kernel/entry-common.S:175: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
>    make[3]: *** [/builds/linux/scripts/Makefile.build:388: arch/arm/kernel/entry-common.o] Error 1
>    /builds/linux/arch/arm/kernel/entry-armv.S: Assembler messages:
>    /builds/linux/arch/arm/kernel/entry-armv.S:1090: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
>    /builds/linux/arch/arm/kernel/entry-armv.S:1113: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
>    /builds/linux/arch/arm/kernel/entry-armv.S:1136: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
>    /builds/linux/arch/arm/kernel/entry-armv.S:1159: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
>    /builds/linux/arch/arm/kernel/entry-armv.S:1198: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
>    make[3]: *** [/builds/linux/scripts/Makefile.build:388: arch/arm/kernel/entry-armv.o] Error 1
>    /builds/linux/arch/arm/common/secure_cntvoff.S: Assembler messages:
>    /builds/linux/arch/arm/common/secure_cntvoff.S:24: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
>    /builds/linux/arch/arm/common/secure_cntvoff.S:27: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
>    /builds/linux/arch/arm/common/secure_cntvoff.S:29: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
>    make[3]: *** [/builds/linux/scripts/Makefile.build:388: arch/arm/common/secure_cntvoff.o] Error 1
>    make[3]: Target '__build' not remade because of errors.
>    make[2]: *** [/builds/linux/scripts/Makefile.build:549: arch/arm/common] Error 2
>    /builds/linux/arch/arm/mm/cache-v7.S: Assembler messages:
>    /builds/linux/arch/arm/mm/cache-v7.S:42: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
>    /builds/linux/arch/arm/mm/cache-v7.S:69: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
>    /builds/linux/arch/arm/mm/cache-v7.S:142: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
>    /builds/linux/arch/arm/mm/cache-v7.S:179: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
>    /builds/linux/arch/arm/mm/cache-v7.S:312: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
>    make[3]: *** [/builds/linux/scripts/Makefile.build:388: arch/arm/mm/cache-v7.o] Error 1
>    /builds/linux/arch/arm/mm/tlb-v7.S: Assembler messages:
>    /builds/linux/arch/arm/mm/tlb-v7.S:85: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
>    make[3]: *** [/builds/linux/scripts/Makefile.build:388: arch/arm/mm/tlb-v7.o] Error 1
>    /builds/linux/arch/arm/mm/proc-v7-2level.S: Assembler messages:
>    /builds/linux/arch/arm/mm/proc-v7-2level.S:55: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
>    /builds/linux/arch/arm/mm/proc-v7-2level.S:57: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
>    /builds/linux/arch/arm/mm/proc-v7.S:59: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
>    make[3]: *** [/builds/linux/scripts/Makefile.build:388: arch/arm/mm/proc-v7.o] Error 1
>    make[3]: Target '__build' not remade because of errors.
>    make[2]: *** [/builds/linux/scripts/Makefile.build:549: arch/arm/mm] Error 2
> 
> 
> And this is a Clang failure (

axm55xx_defconfig with clang-12)

   ld.lld: error: ./arch/arm/kernel/vmlinux.lds:123: AT expected, but got NOCROSSREFS
   >>>  __vectors_lma = .; OVERLAY 0xffff0000 : NOCROSSREFS AT(__vectors_lma) { .vectors { *(.vectors) } .vectors.bhb.loop8 { *(.vectors.bhb.loop8) } .vectors.bhb.bpiall { *(.vectors.bhb.bpiall) } } __vectors_start = LOADADDR(.vectors); __vectors_end = LOADADDR(.vectors) + SIZEOF(.vectors); __vectors_bhb_loop8_start = LOADADDR(.vectors.bhb.loop8); __vectors_bhb_loop8_end = LOADADDR(.vectors.bhb.loop8) + SIZEOF(.vectors.bhb.loop8); __vectors_bhb_bpiall_start = LOADADDR(.vectors.bhb.bpiall); __vectors_bhb_bpiall_end = LOADADDR(.vectors.bhb.bpiall) + SIZEOF(.vectors.bhb.bpiall); . = __vectors_lma + SIZEOF(.vectors) + SIZEOF(.vectors.bhb.loop8) + SIZEOF(.vectors.bhb.bpiall); __stubs_lma = .; .stubs ADDR(.vectors) + 0x1000 : AT(__stubs_lma) { *(.stubs) } __stubs_start = LOADADDR(.stubs); __stubs_end = LOADADDR(.stubs) + SIZEOF(.stubs); . = __stubs_lma + SIZEOF(.stubs); PROVIDE(vector_fiq_offset = vector_fiq - ADDR(.vectors));
   >>>                                          ^
   make[1]: *** [/builds/linux/Makefile:1161: vmlinux] Error 1


Greetings!

Daniel Díaz
daniel.diaz@linaro.org

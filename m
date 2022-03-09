Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C41B04D3BEE
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 22:17:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233122AbiCIVSs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 16:18:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231465AbiCIVSr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 16:18:47 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A97735261
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 13:17:47 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id ay7so3979622oib.8
        for <stable@vger.kernel.org>; Wed, 09 Mar 2022 13:17:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=rbmc8BdN8wPgc1BDfOsuXIXyrg5uoDqiCn8RTpOLzZA=;
        b=ifXyeO9m93yAbEVOSzbE3IuF0Gj20q67LR5hZNuqI7ePath53DUn38nJbEaOLuokuD
         nsYhNoEamV1iOQ2D57lBypvIcRd/qXIAfN3qA2r6qw1kV67Z+Bk6SshwXuKYp7LALTJQ
         eSxgkMYIgSXstgyeNrK3fde4WC8EUWx2+afPE7+Bd3KEeVgQuk80i0EaztNYu5p55p00
         P31QfB5V8NBdUD+cTY3dq9ZHiy6iLXnYr82kPFs5xYkF/iRYKDKs15c9eKSnpbyY2J3x
         FcoAZilTDpGLdM4ujWB1ETZSLGXKGYK0g5a10c5n//OSXGVGTKYvsOh/IZxXWmqCd03Z
         P4vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rbmc8BdN8wPgc1BDfOsuXIXyrg5uoDqiCn8RTpOLzZA=;
        b=vMBGZIlZJD5WISg5dKWwxXB4zqWNIfSPnZ+5v5xIGBXh8tVYkc3Dazsl7gY+v3V7lq
         fkxVqJOHysswQoC8rb/JUAm3GMQrrw9Vtnf/vb/pKUZGApa2/h2G6S/5qgvTuXAjyMj/
         +l8nRMTnQ8LXoaV46gl23+Ugrb6ohNVtN4R0zznm5oNCjMt74jaxO+a/zqZBF/nGlSeG
         +yx/XlGC3TdHh+BEPWGY85BI/omV8Q4Vn60ZVbXO5eBKZXDlhMtIYlgl07u+9fSNjsk/
         aZ8rirKPgBaex8uSo009Jo4RqJh50LlnPQCD+Jh9fPPa7U2GQ4BvyV9c699cD7KOtpsB
         /hsw==
X-Gm-Message-State: AOAM5320sB7VVVA/BljZOAf34LUQDzC6uTIfNbj4cfTQ4O26GJlnWzHB
        aJ+HX32JjH30yIqMnrG0neM67g==
X-Google-Smtp-Source: ABdhPJwakXmD66mhiHCZJ+QE1uklRFM4cRMElE0uFYnmncuueQnfsrzkmIvYnbM0koL4LQV2SbORiw==
X-Received: by 2002:a05:6808:14cc:b0:2d9:a01a:48ac with SMTP id f12-20020a05680814cc00b002d9a01a48acmr7322833oiw.247.1646860666456;
        Wed, 09 Mar 2022 13:17:46 -0800 (PST)
Received: from [192.168.17.16] ([189.219.74.147])
        by smtp.gmail.com with ESMTPSA id l7-20020acabb07000000b002da34f9ffc3sm1566617oif.37.2022.03.09.13.17.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 13:17:46 -0800 (PST)
Message-ID: <3e00dc5b-e147-e231-4d56-6b5b32968833@linaro.org>
Date:   Wed, 9 Mar 2022 15:17:45 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.16 00/37] 5.16.14-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220309155859.086952723@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20220309155859.086952723@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 09/03/22 10:00, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.14 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Mar 2022 15:58:48 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.14-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
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

This is a GCC failure (bcm2835_defconfig with gcc-8):

   /builds/linux/arch/arm/kernel/entry-common.S: Assembler messages:
   /builds/linux/arch/arm/kernel/entry-common.S:166: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/kernel/entry-common.S:175: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   make[3]: *** [/builds/linux/scripts/Makefile.build:388: arch/arm/kernel/entry-common.o] Error 1
   /builds/linux/arch/arm/kernel/entry-armv.S: Assembler messages:
   /builds/linux/arch/arm/kernel/entry-armv.S:1090: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/kernel/entry-armv.S:1113: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/kernel/entry-armv.S:1136: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/kernel/entry-armv.S:1159: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/kernel/entry-armv.S:1198: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   make[3]: *** [/builds/linux/scripts/Makefile.build:388: arch/arm/kernel/entry-armv.o] Error 1
   /builds/linux/arch/arm/common/secure_cntvoff.S: Assembler messages:
   /builds/linux/arch/arm/common/secure_cntvoff.S:24: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/common/secure_cntvoff.S:27: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/common/secure_cntvoff.S:29: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   make[3]: *** [/builds/linux/scripts/Makefile.build:388: arch/arm/common/secure_cntvoff.o] Error 1
   make[3]: Target '__build' not remade because of errors.
   make[2]: *** [/builds/linux/scripts/Makefile.build:549: arch/arm/common] Error 2
   /builds/linux/arch/arm/mm/cache-v7.S: Assembler messages:
   /builds/linux/arch/arm/mm/cache-v7.S:42: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/mm/cache-v7.S:69: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/mm/cache-v7.S:142: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/mm/cache-v7.S:179: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/mm/cache-v7.S:312: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   make[3]: *** [/builds/linux/scripts/Makefile.build:388: arch/arm/mm/cache-v7.o] Error 1
   /builds/linux/arch/arm/mm/tlb-v7.S: Assembler messages:
   /builds/linux/arch/arm/mm/tlb-v7.S:85: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   make[3]: *** [/builds/linux/scripts/Makefile.build:388: arch/arm/mm/tlb-v7.o] Error 1
   /builds/linux/arch/arm/mm/proc-v7-2level.S: Assembler messages:
   /builds/linux/arch/arm/mm/proc-v7-2level.S:55: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/mm/proc-v7-2level.S:57: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/mm/proc-v7.S:59: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   make[3]: *** [/builds/linux/scripts/Makefile.build:388: arch/arm/mm/proc-v7.o] Error 1
   make[3]: Target '__build' not remade because of errors.
   make[2]: *** [/builds/linux/scripts/Makefile.build:549: arch/arm/mm] Error 2


And this is a Clang failure (

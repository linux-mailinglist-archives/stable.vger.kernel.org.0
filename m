Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC00A55D4B7
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236564AbiF0Swu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 14:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234920AbiF0Swt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 14:52:49 -0400
Received: from mail-oa1-x41.google.com (mail-oa1-x41.google.com [IPv6:2001:4860:4864:20::41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31C41EBC
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 11:52:48 -0700 (PDT)
Received: by mail-oa1-x41.google.com with SMTP id 586e51a60fabf-101b4f9e825so14080541fac.5
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 11:52:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=XKZM258eeVNalbW9PviyXuddlycPIKbUhYNUTTlTg/M=;
        b=F8kXXgXcSZrDyiu/yv1/sVQb26Py2Tr+6heeVEg/m42Z0yE+ptv/JjJSKZ+7x9IGO0
         MFpBWzseFnhA8rYBmvX+bkj1/uidr7QLfhlIEEJnQs+nqAXLd0NUG5d+xiZNelgwlFeR
         4A/1i0xMwCd9XuYrpJGnLO6Wbvt82xSK624MAKmsW1mFref+qNRZ8FV63JOcC3rREUSI
         emgSbHdzCXvGBMlXCQ2r66yBd63IMcPltHq7Y58e7mGwIs9uADBDGxzEnFlZDxnsraQw
         cvgUCwxDlR5RLsh4PJ4JPpIG2JO0/IcB1JksU+qqKafYd2CaN0aOMorV5DTELZY//rhE
         dM/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XKZM258eeVNalbW9PviyXuddlycPIKbUhYNUTTlTg/M=;
        b=urBfqSS7wDBwsqS8P5dLBYYr1KQXQewljocJxTTdEZb4YEjsg2NGvdnTHrAllFrqYz
         A0uEckyKtv4KdAswKWrwwzjNhk9EEJKLmNl3pWVWc947zlWta3PTjBrti101az7yLFuZ
         Nw+K1JCK1DuJtFYTTH2ZqD3XAWWhWhy4/eKU3RSPeFUzZQ5fMgZN3aoF/la75Y1C9YB4
         zkboAMqMDL+1tgCbuOwsw1VLuv+xSu2OqvUzTtTPjT8HMrDNfENnv/hkNXRhLvNxmT9a
         12kpPnKtoJWDCxGx0FvyavJGHvOIO878PKZexaB+7DU8CuZ6g+Su/V+Mvyrf4oI3w1HP
         hWDg==
X-Gm-Message-State: AJIora9/4WlJ5f2mSLMsBgEgzPfShoZmk2wZ9Bn5g6ArgpyoZx1HKcC8
        KeBd2daSygly5gz9puUdn+mpTw==
X-Google-Smtp-Source: AGRyM1vh6kLi1AYeeZWbLYz/aG1GJtHaS9hz3XK4wcGnPTkKl3GRsBPgJsty3BDw4pM1peCSUvnZTw==
X-Received: by 2002:a05:6870:a707:b0:101:c416:f837 with SMTP id g7-20020a056870a70700b00101c416f837mr11461670oam.237.1656355967403;
        Mon, 27 Jun 2022 11:52:47 -0700 (PDT)
Received: from [192.168.17.16] ([189.219.74.211])
        by smtp.gmail.com with ESMTPSA id a5-20020a056808120500b00335713cd3f8sm2020568oil.17.2022.06.27.11.52.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jun 2022 11:52:47 -0700 (PDT)
Message-ID: <1dac60a4-8f97-6914-b2ce-f24449fc5036@linaro.org>
Date:   Mon, 27 Jun 2022 13:52:45 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 5.10 000/102] 5.10.127-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220627111933.455024953@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20220627111933.455024953@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
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

On 27/06/22 06:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.127 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Jun 2022 11:19:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.127-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Results from Linaro's test farm.
The following new warnings have been found while building for all architectures with GCC:

   WARNING: modpost: vmlinux.o(___ksymtab+drm_fb_helper_modinit+0x0): Section mismatch in reference from the variable __ksymtab_drm_fb_helper_modinit to the function .init.text:drm_fb_helper_modinit()
   The symbol drm_fb_helper_modinit is exported and annotated __init
   Fix this by removing the __init annotation of drm_fb_helper_modinit or drop the export.

   WARNING: modpost: drivers/gpu/drm/drm_kms_helper.o(___ksymtab+drm_fb_helper_modinit+0x0): Section mismatch in reference from the variable __ksymtab_drm_fb_helper_modinit to the function .init.text:drm_fb_helper_modinit()
   The symbol drm_fb_helper_modinit is exported and annotated __init
   Fix this by removing the __init annotation of drm_fb_helper_modinit or drop the export.


## Build
* kernel: 5.10.127-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 0075d2af9da3b9fa78240432ba9847ff9838f92f
* git describe: v5.10.125-105-g0075d2af9da3
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.125-105-g0075d2af9da3

## No test regressions (compared to v5.10.125)

## Metric Regressions (compared to v5.10.125)
* arm, build
   - gcc-8-at91_dt_defconfig-warnings
   - gcc-8-bcm2835_defconfig-warnings
   - gcc-8-davinci_all_defconfig-warnings
   - gcc-8-defconfig-warnings
   - gcc-8-exynos_defconfig-warnings
   - gcc-8-imx_v6_v7_defconfig-warnings
   - gcc-8-integrator_defconfig-warnings
   - gcc-8-ixp4xx_defconfig-warnings
   - gcc-8-lpc32xx_defconfig-warnings
   - gcc-8-multi_v5_defconfig-45747f0c-warnings
   - gcc-8-multi_v5_defconfig-warnings
   - gcc-8-mxs_defconfig-warnings
   - gcc-8-nhk8815_defconfig-warnings
   - gcc-8-omap2plus_defconfig-warnings
   - gcc-8-s5pv210_defconfig-warnings
   - gcc-8-sama5_defconfig-warnings
   - gcc-8-u8500_defconfig-warnings
   - gcc-8-vexpress_defconfig-warnings
   - gcc-9-at91_dt_defconfig-warnings
   - gcc-9-bcm2835_defconfig-warnings
   - gcc-9-davinci_all_defconfig-warnings
   - gcc-9-defconfig-warnings
   - gcc-9-exynos_defconfig-warnings
   - gcc-9-imx_v6_v7_defconfig-warnings
   - gcc-9-integrator_defconfig-warnings
   - gcc-9-ixp4xx_defconfig-warnings
   - gcc-9-lpc32xx_defconfig-warnings
   - gcc-9-multi_v5_defconfig-45747f0c-warnings
   - gcc-9-multi_v5_defconfig-warnings
   - gcc-9-mxs_defconfig-warnings
   - gcc-9-nhk8815_defconfig-warnings
   - gcc-9-omap2plus_defconfig-warnings
   - gcc-9-s5pv210_defconfig-warnings
   - gcc-9-sama5_defconfig-warnings
   - gcc-9-u8500_defconfig-warnings
   - gcc-9-vexpress_defconfig-warnings
   - gcc-10-at91_dt_defconfig-warnings
   - gcc-10-bcm2835_defconfig-warnings
   - gcc-10-davinci_all_defconfig-warnings
   - gcc-10-defconfig-warnings
   - gcc-10-exynos_defconfig-warnings
   - gcc-10-imx_v6_v7_defconfig-warnings
   - gcc-10-integrator_defconfig-warnings
   - gcc-10-ixp4xx_defconfig-warnings
   - gcc-10-lkftconfig-debug-kmemleak-warnings
   - gcc-10-lkftconfig-debug-warnings
   - gcc-10-lkftconfig-kasan-warnings
   - gcc-10-lkftconfig-kselftest-kernel-warnings
   - gcc-10-lkftconfig-kselftest-warnings
   - gcc-10-lkftconfig-kunit-warnings
   - gcc-10-lkftconfig-libgpiod-warnings
   - gcc-10-lkftconfig-perf-warnings
   - gcc-10-lkftconfig-rcutorture-warnings
   - gcc-10-lkftconfig-warnings
   - gcc-10-lpc32xx_defconfig-warnings
   - gcc-10-multi_v5_defconfig-45747f0c-warnings
   - gcc-10-multi_v5_defconfig-warnings
   - gcc-10-mxs_defconfig-warnings
   - gcc-10-nhk8815_defconfig-warnings
   - gcc-10-omap2plus_defconfig-warnings
   - gcc-10-s5pv210_defconfig-warnings
   - gcc-10-sama5_defconfig-warnings
   - gcc-10-u8500_defconfig-warnings
   - gcc-10-vexpress_defconfig-warnings
   - gcc-11-at91_dt_defconfig-warnings
   - gcc-11-bcm2835_defconfig-warnings
   - gcc-11-davinci_all_defconfig-warnings
   - gcc-11-defconfig-warnings
   - gcc-11-exynos_defconfig-warnings
   - gcc-11-imx_v6_v7_defconfig-warnings
   - gcc-11-integrator_defconfig-warnings
   - gcc-11-ixp4xx_defconfig-warnings
   - gcc-11-lpc32xx_defconfig-warnings
   - gcc-11-multi_v5_defconfig-45747f0c-warnings
   - gcc-11-multi_v5_defconfig-warnings
   - gcc-11-mxs_defconfig-warnings
   - gcc-11-nhk8815_defconfig-warnings
   - gcc-11-omap2plus_defconfig-warnings
   - gcc-11-s5pv210_defconfig-warnings
   - gcc-11-sama5_defconfig-warnings
   - gcc-11-u8500_defconfig-warnings
   - gcc-11-vexpress_defconfig-warnings

* arm64, build
   - gcc-8-defconfig-40bc7ee5-warnings
   - gcc-9-defconfig-40bc7ee5-warnings
   - gcc-10-defconfig-40bc7ee5-warnings
   - gcc-11-defconfig-40bc7ee5-warnings
   - gcc-11-lkftconfig-64k_page_size-warnings
   - gcc-11-lkftconfig-armv8_features-warnings
   - gcc-11-lkftconfig-debug-kmemleak-warnings
   - gcc-11-lkftconfig-debug-warnings
   - gcc-11-lkftconfig-devicetree-warnings
   - gcc-11-lkftconfig-kasan-warnings
   - gcc-11-lkftconfig-kselftest-kernel-warnings
   - gcc-11-lkftconfig-kselftest-warnings
   - gcc-11-lkftconfig-kunit-warnings
   - gcc-11-lkftconfig-libgpiod-warnings
   - gcc-11-lkftconfig-perf-warnings
   - gcc-11-lkftconfig-rcutorture-warnings
   - gcc-11-lkftconfig-warnings

* i386, build
   - gcc-8-i386_defconfig-warnings
   - gcc-9-i386_defconfig-warnings
   - gcc-10-defconfig-warnings
   - gcc-11-defconfig-warnings
   - gcc-11-lkftconfig-debug-kmemleak-warnings
   - gcc-11-lkftconfig-debug-warnings
   - gcc-11-lkftconfig-kselftest-kernel-warnings
   - gcc-11-lkftconfig-kselftest-warnings
   - gcc-11-lkftconfig-kunit-warnings
   - gcc-11-lkftconfig-libgpiod-warnings
   - gcc-11-lkftconfig-perf-warnings
   - gcc-11-lkftconfig-rcutorture-warnings
   - gcc-11-lkftconfig-warnings

* powerpc, build
   - gcc-8-ppc6xx_defconfig-warnings
   - gcc-9-ppc6xx_defconfig-warnings
   - gcc-10-ppc6xx_defconfig-warnings
   - gcc-11-ppc6xx_defconfig-warnings

* riscv, build
   - gcc-8-defconfig-warnings
   - gcc-9-defconfig-warnings
   - gcc-10-defconfig-warnings
   - gcc-11-defconfig-warnings

* x86_64, build
   - gcc-8-x86_64_defconfig-warnings
   - gcc-9-x86_64_defconfig-warnings
   - gcc-10-defconfig-warnings
   - gcc-11-defconfig-warnings
   - gcc-11-lkftconfig-debug-kmemleak-warnings
   - gcc-11-lkftconfig-debug-warnings
   - gcc-11-lkftconfig-kasan-warnings
   - gcc-11-lkftconfig-kselftest-kernel-warnings
   - gcc-11-lkftconfig-kselftest-warnings
   - gcc-11-lkftconfig-kunit-warnings
   - gcc-11-lkftconfig-libgpiod-warnings
   - gcc-11-lkftconfig-perf-warnings
   - gcc-11-lkftconfig-rcutorture-warnings
   - gcc-11-lkftconfig-warnings

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## No test fixes (compared to v5.10.125)

## No metric fixes (compared to v5.10.125)

## Test result summary
total: 113063, pass: 101475, fail: 233, skip: 10740, xfail: 615

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 314 total, 314 passed, 0 failed
* arm64: 58 total, 58 passed, 0 failed
* i386: 52 total, 49 passed, 3 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 51 total, 51 passed, 0 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 21 total, 21 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 56 total, 55 passed, 1 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kunit
* kvm-unit-tests
* libgpiod
* libhugetlbfs
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-cpuhotplug
* ltp-crypto
* ltp-cve
* ltp-dio
* ltp-fcntl-locktests
* ltp-filecaps
* ltp-fs
* ltp-fs_bind
* ltp-fs_perms_simple
* ltp-fsx
* ltp-hugetlb
* ltp-io
* ltp-ipc
* ltp-math
* ltp-mm
* ltp-nptl
* ltp-open-posix-tests
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* packetdrill
* perf
* rcutorture
* ssuite
* v4l2-compliance
* vdso


Greetings!

Daniel Díaz
daniel.diaz@linaro.org

-- 
Linaro LKFT
https://lkft.linaro.org

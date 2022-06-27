Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 208B855DDFF
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240381AbiF0TIQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 15:08:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237802AbiF0TIP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 15:08:15 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFFA4C35
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 12:08:13 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id q11so14083947oih.10
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 12:08:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=zh6s7nD7luk04qRXIjIb+WBt8LxVAnCFYF380i7oqSI=;
        b=aNeHHhlvg3mghPdR1oMD4oLFc7JMCZB3jhuxSvhNvPpL9jN9eBhXuNbcylh1vBrqhT
         z5FTMQ65QHN2UYEMIrSsAwxbt+euJhdYJefOLTu8UdjoOv1c4n2x2rLRHv1bK2jzg3nP
         MNLh6Wup0Jc8AskdGI9EVbPWRwiOGtFd7PLKQck32/hvgZkjVfzMlK5zzmh80NW8L1Uq
         nVtUvdciBrz3i9vWI0MizQJVksiEM0eh6BVwBzTIZVlB+N7Eeh8ycuId9wohZNlU0lkJ
         Tumb2m/pJAyye9iXak8jQUIywPx2Jv4CAj4hHZfllb4vqcxfO407HCsI9efUL9KuiRzM
         CSug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=zh6s7nD7luk04qRXIjIb+WBt8LxVAnCFYF380i7oqSI=;
        b=XIAi2VoKzxsfMvE1NKTdG/8AKAzzxGN3DW7UbhgRcKZPVy23RpHqqluutzW1CRidAk
         eRjCv5ugHFavR8c0YRuTlxUVMkYiC3n/xyg25DhAYE+ye4MavwIpV/WShbVtW9lcoYQi
         TwzOa66DrtFC4yYQjCbJW4ZF+9SXrP54/94iXqxGNB3RrV5mY4U13NIX6PtWLoWpxf/C
         xBDQMKxPbMRu+GAYv4Ui2Dh7yjwQl/G+ASCzcsa7jveRua3N8CskNulVRWNWsHXrBTK2
         Dm+pPReVRjj9VLLLJ1nBuQ+QTxpKnRon9lEw6L0o6UDpPlqF+PVlUN5mKWeRv2pfN30Q
         uR1w==
X-Gm-Message-State: AJIora8mGhjj9zv0PNB4/7/cUjZIlMTz6WICozY9BeHwNUBPM8ktqBzi
        XOkYN3g8QK0qY42MGkfsvPXBSQ==
X-Google-Smtp-Source: AGRyM1ug7gRwlSieSlpRshPw6m7S6kK6Rl+WiY8kvfNzB01JrBjCtq41RPeRmsjBFlZPva5aUZRUqQ==
X-Received: by 2002:a05:6808:e89:b0:2f7:34db:6915 with SMTP id k9-20020a0568080e8900b002f734db6915mr8524587oil.284.1656356892978;
        Mon, 27 Jun 2022 12:08:12 -0700 (PDT)
Received: from [192.168.17.16] ([189.219.74.211])
        by smtp.gmail.com with ESMTPSA id c8-20020a4ab188000000b0041b86fcc8dasm6311737ooo.25.2022.06.27.12.08.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jun 2022 12:08:12 -0700 (PDT)
Message-ID: <fe46a586-1af9-5988-9644-f7dd9ca63ca3@linaro.org>
Date:   Mon, 27 Jun 2022 14:08:11 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 5.4 00/60] 5.4.202-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220627111927.641837068@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20220627111927.641837068@linuxfoundation.org>
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

On 27/06/22 06:21, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.202 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Jun 2022 11:19:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.202-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
* kernel: 5.4.202-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: 1c351e730d68becde35c20fa77ae48dccd9b9fc2
* git describe: v5.4.201-61-g1c351e730d68
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.201-61-g1c351e730d68

## No test regressions (compared to v5.4.201)

## Metric regressions (compared to v5.4.201)
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
   - gcc-8-s3c6400_defconfig-warnings
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
   - gcc-9-s3c6400_defconfig-warnings
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
   - gcc-10-s3c6400_defconfig-warnings
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
   - gcc-11-s3c6400_defconfig-warnings
   - gcc-11-s5pv210_defconfig-warnings
   - gcc-11-sama5_defconfig-warnings
   - gcc-11-u8500_defconfig-warnings
   - gcc-11-vexpress_defconfig-warnings

* arm64, build
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

## No test fixes (compared to v5.4.201)

## No metric fixes (compared to v5.4.201)

## Test result summary
total: 106600, pass: 95406, fail: 218, skip: 10208, xfail: 768

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 313 total, 313 passed, 0 failed
* arm64: 57 total, 53 passed, 4 failed
* i386: 28 total, 25 passed, 3 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 54 total, 54 passed, 0 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 55 total, 54 passed, 1 failed

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

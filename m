Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5EF855C38C
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237137AbiF0SI7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 14:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237064AbiF0SIz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 14:08:55 -0400
Received: from mail-oa1-x42.google.com (mail-oa1-x42.google.com [IPv6:2001:4860:4864:20::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CABFB4A6
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 11:08:53 -0700 (PDT)
Received: by mail-oa1-x42.google.com with SMTP id 586e51a60fabf-101dc639636so13934425fac.6
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 11:08:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=fVYDQU+gBhu38IXi5bFyQVgwb4L4dNqLLVf62l/pwXQ=;
        b=Q6PLK+0mtOmm1I7jye3iHghKJqssh1irStcb/wTuyQBoQdm3sHaTB9huVMgHSj4Y70
         YQ1c3BQkCm+ambDltqi35ZkDd8LrQ2I/WpN5cfoqSeAVFQGdwypBDKOsnHzCYicciaRn
         Oo/eU8TaQu35ahOrN0b495PeKP148NmMcFdWVlfiXfxB7AkuISsOS5xjUYfg+BgBmb2x
         5SarktSQSr27kX5/JGaLGeikKi1nd+SnWQfrxC4MMNQsXBYTLfQ3cLDVsCm1CBY96Itg
         FgX5KpyF/j9Ada+5KQcPqcvmU+iDnZ73GR2lLTJZ7B1hlXHHDYT43MoJ2KYUF/0vy+bv
         ishg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fVYDQU+gBhu38IXi5bFyQVgwb4L4dNqLLVf62l/pwXQ=;
        b=sgWQNf6YP1RQiaeK81BmExX8nNdTB1S6V5D1ecdEbPPYc77vpcggwamHrRVg5KTD8k
         xKJcQDlhqGROLNMIefBGPjjFw0BE77bZzeFncSaeaxyA3uPkwmnc94Lr+z7cMCc+Juja
         gbcNiSibj3y04928hTyLjrrUJo8xr3B+35YKaPrpZBVkpW0poMrXs9bGBh2rjcpMkSAs
         tzS1jsquPTSaZrNNPefaXYFOgwmJ3CjYEymqHKNg8qCzpy4WcRXTJLXhEuS/an4zrR3E
         Hocx+Ge/ruGOi5rzS3sWNKdMtvxd4rBvw65jFveCRhgWV8Z/TvA1naoTRzz5dtCG4FN+
         +Low==
X-Gm-Message-State: AJIora/JUwvT5Im/L2kp+DS5p+xO52GuWxoJZIAWbnptiK7dS6Y9FHcN
        xfb6LuDtq5p0YWkEaPCdwMjabw==
X-Google-Smtp-Source: AGRyM1vMIcUmdED97gLWmKwRp5zTR72vMU8bSaRY0IJDeHqd4exUIe92E41BZFA8BghSfpLkpAcJ7Q==
X-Received: by 2002:a05:6870:c08b:b0:101:45fd:7245 with SMTP id c11-20020a056870c08b00b0010145fd7245mr8493191oad.296.1656353332726;
        Mon, 27 Jun 2022 11:08:52 -0700 (PDT)
Received: from [192.168.17.16] ([189.219.74.211])
        by smtp.gmail.com with ESMTPSA id c26-20020a4ae25a000000b0042575b730dbsm6194079oot.45.2022.06.27.11.08.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jun 2022 11:08:52 -0700 (PDT)
Message-ID: <04e07f2b-7c0f-cdcf-ef95-9c164422ed78@linaro.org>
Date:   Mon, 27 Jun 2022 13:08:50 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 5.18 000/181] 5.18.8-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220627111944.553492442@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
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

On 27/06/22 06:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.8 release.
> There are 181 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Jun 2022 11:19:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Results from Linaro's test farm.
The following new warnings have been found while building ixp4xx_defconfig for Arm combinations with GCC:

   WARNING: modpost: vmlinux.o(___ksymtab_gpl+ixp4xx_irq_init+0x0): Section mismatch in reference from the variable __ksymtab_ixp4xx_irq_init to the function .init.text:ixp4xx_irq_init()
   The symbol ixp4xx_irq_init is exported and annotated __init
   Fix this by removing the __init annotation of ixp4xx_irq_init or drop the export.

   WARNING: modpost: vmlinux.o(___ksymtab_gpl+ixp4xx_timer_setup+0x0): Section mismatch in reference from the variable __ksymtab_ixp4xx_timer_setup to the function .init.text:ixp4xx_timer_setup()
   The symbol ixp4xx_timer_setup is exported and annotated __init
   Fix this by removing the __init annotation of ixp4xx_timer_setup or drop the export.


## Build
* kernel: 5.18.8-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.18.y
* git commit: 188f58194f3c72f6d47077c7dfe205b4f62d01ba
* git describe: v5.18.7-182-g188f58194f3c
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.18.y/build/v5.18.7-182-g188f58194f3c

## No test regressions (compared to v5.18.7)

## Metric regressions (compared to v5.18.7)
* arm, build
   - gcc-8-ixp4xx_defconfig-warnings
   - gcc-9-ixp4xx_defconfig-warnings
   - gcc-10-ixp4xx_defconfig-warnings
   - gcc-11-ixp4xx_defconfig-warnings

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## No test fixes (compared to v5.18.7)

## No metric fixes (compared to v5.18.7)

## Test result summary
total: 122034, pass: 110497, fail: 531, skip: 10313, xfail: 693

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 319 total, 316 passed, 3 failed
* arm64: 64 total, 62 passed, 2 failed
* i386: 57 total, 50 passed, 7 failed
* mips: 41 total, 38 passed, 3 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 65 total, 56 passed, 9 failed
* riscv: 32 total, 27 passed, 5 failed
* s390: 23 total, 20 passed, 3 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x86_64: 62 total, 58 passed, 4 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-android
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-drivers-dma-buf
* kselftest-efivarfs
* kselftest-filesystems
* kselftest-filesystems-binderfs
* kselftest-firmware
* kselftest-fpu
* kselftest-gpio
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-lib
* kselftest-membarrier
* kselftest-netfilter
* kselftest-nsfs
* kselftest-openat2
* kselftest-pid_namespace
* kselftest-pidfd
* kselftest-proc
* kselftest-pstore
* kselftest-rseq
* kselftest-rtc
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-splice
* kselftest-static_keys
* kselftest-sync
* kselftest-sysctl
* kselftest-tc-testing
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-vm
* kselftest-zram
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

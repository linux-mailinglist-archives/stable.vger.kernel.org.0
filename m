Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B10934D6103
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 12:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239127AbiCKLxu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Mar 2022 06:53:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233234AbiCKLxt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Mar 2022 06:53:49 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AB594D60E
        for <stable@vger.kernel.org>; Fri, 11 Mar 2022 03:52:45 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id x200so16626954ybe.6
        for <stable@vger.kernel.org>; Fri, 11 Mar 2022 03:52:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vcfCQf2ipBXym0WGWa/TPLq262jF+MOIdkhc8cIElBc=;
        b=qT6Ctf9FHvk5UXjURmdbs62M1JDay7M+EVARQ2dkMVVf+RhXGnyAClPHGmYONCKgow
         INFKIBS3t7CwxZsdD/OeaAinCjIdI9blsmY/P5ICQv3iQaCppBePlntLQlpJNwjVGddz
         Pi32uihRrfaFX6oxskxTdjd1f6+nJHG67qwGL4g3/xbfPn7sCZ2EeXmFLjg2xeB3Vj0p
         QSjouGtbY9EYf7pU3UveTOT7zcaotD5rK7zgiVv+dYk9oTQtcaKEakM6MvUJxoKTS2S7
         UDpZQSws0lcYUrYNO17coAtjXj2nFB6O+D6sqV1RhifF5q72MDMNArDfGDq7WM2bkiVB
         oPbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vcfCQf2ipBXym0WGWa/TPLq262jF+MOIdkhc8cIElBc=;
        b=YLdzSuVxxYaLqqmJ+V2QbTTzJ6KHE1NFGiUBQtCRljCD8MaoqzR9Pre0e1/KdQHm9N
         pv7I9ylxTWKbeOHctB4lxXqXgwj8jsnB3GNY1il0sU0SVL0rAc5GXM4gCKV/3lr0EI6Z
         v4KxpMR5xGRJQGy/IaWcgw6gTQ1tsd4bhmk07+k9X+03owiyFmsE1j5PKFlaLpoMlLhK
         y96qIUCDFU9wjSS2eK8nfu2zvB2lZY6E6gBl6et+z46kfsmKYBqgdhWHswe1bA4h3XGm
         xKVmd6RZnpuCR3QU+8PmKYHpBbVmT3Vd8PgVC/ln4um1TXWyABZQFe2ncblcmlGDaHbm
         Hrqw==
X-Gm-Message-State: AOAM533ZiYUAt5uQtNup1rIyk2rkMG3eYzjcCodee0b+I6JqvxZZVlaG
        J38Bu75zZq2SpT0qW7MGf/jqIEGvTnEpNDIJtgLDzg==
X-Google-Smtp-Source: ABdhPJz/cuI5oGeD+7slacIT8yD/BzgUoTMLR5eYU9e7xyrQS31gC2q8RtTsPCwh4VJ0sXH2N3uPpHsFU23FwhMiVVs=
X-Received: by 2002:a25:da91:0:b0:628:aa84:f69e with SMTP id
 n139-20020a25da91000000b00628aa84f69emr8246947ybf.603.1646999564536; Fri, 11
 Mar 2022 03:52:44 -0800 (PST)
MIME-Version: 1.0
References: <20220310140812.869208747@linuxfoundation.org>
In-Reply-To: <20220310140812.869208747@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 11 Mar 2022 17:22:33 +0530
Message-ID: <CA+G9fYsV1RA=jfBqG88NsZhdouCsB7=xg2Oq78AAL5_vUhObjw@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/58] 5.10.105-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 10 Mar 2022 at 19:54, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.105 release.
> There are 58 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 12 Mar 2022 14:07:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.105-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.105-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.10.y
* git commit: 222eae85893657f02832253fe1c164f7d0b2c88c
* git describe: v5.10.104-59-g222eae858936
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.104-59-g222eae858936

## Test Regressions (compared to v5.10.104-43-ge5e4a8f0fb6e)
No test regressions found.

## Metric Regressions (compared to v5.10.104-43-ge5e4a8f0fb6e)
No metric regressions found.

## Test Fixes (compared to v5.10.104-43-ge5e4a8f0fb6e)
No test fixes found.

## Metric Fixes (compared to v5.10.104-43-ge5e4a8f0fb6e)
No metric fixes found.

## Test result summary
total: 103231, pass: 87446, fail: 919, skip: 13751, xfail: 1115

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 291 total, 291 passed, 0 failed
* arm64: 41 total, 41 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 40 total, 40 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 60 total, 46 passed, 14 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 21 total, 21 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 41 total, 41 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-android
* kselftest-arm64
* kselftest-bpf
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-drivers
* kselftest-efivarfs
* kselftest-filesystems
* kselftest-firmware
* kselftest-fpu
* kselftest-futex
* kselftest-gpio
* kselftest-intel_pstate
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-kexec
* kselftest-kvm
* kselftest-lib
* kselftest-livepatch
* kselftest-membarrier
* kselftest-memfd
* kselftest-memory-hotplug
* kselftest-mincore
* kselftest-mount
* kselftest-mqueue
* kselftest-net
* kselftest-netfilter
* kselftest-nsfs
* kselftest-openat2
* kselftest-pid_namespace
* kselftest-pidfd
* kselftest-proc
* kselftest-pstore
* kselftest-ptrace
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
* kselftest-x86
* kselftest-zram
* kunit
* kvm-unit-tests
* libgpiod
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-open-posix-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* network-basic-tests
* packetdrill
* perf
* perf/Zstd-perf.data-compression
* rcutorture
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org

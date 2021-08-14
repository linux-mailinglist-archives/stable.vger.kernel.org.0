Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA2BD3EC268
	for <lists+stable@lfdr.de>; Sat, 14 Aug 2021 13:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238188AbhHNLki (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Aug 2021 07:40:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238105AbhHNLkh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Aug 2021 07:40:37 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2CF8C061764
        for <stable@vger.kernel.org>; Sat, 14 Aug 2021 04:40:09 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id u13-20020a9d4d8d0000b02905177c9e0a4aso4639788otk.3
        for <stable@vger.kernel.org>; Sat, 14 Aug 2021 04:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hAEsRYbaf43Z8kS1BA3yPNfebzmp9X64YxZ1ilahGVI=;
        b=QdcyU/1qJ5serQkKG0MMijgHeDChhMdhl322LsB1jWsssItXTcIVGsfNEY+Rc2phcE
         CZW4vTS4dWGzqM4PvVShN5BbfThJUpKJdCSYSNLSf4UkNICuhnYzBB6zCa2FR51tTmB/
         9zQJYf7NipnSfHdNgkHDtaIsnxJDBz/XcR2ioJx2e9OqA5+h7ApvBQRFsfvVKdcaLOXE
         ZstmGfb6bvjEqhqiTl/1pDjVlyMKm6PTjt/oT79Cn9IZyJVTdiWkHY4dKGozfXoLwgar
         YoCRhRba8FBEYhmYn/Q+ay0T/9pxH6MeN4YP5VqAgyVcgsxEdBbzMS4+tDVxrcsGIYow
         zSjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hAEsRYbaf43Z8kS1BA3yPNfebzmp9X64YxZ1ilahGVI=;
        b=DC6QvkYPDOqSPjWmmZkb07pVrsuf6tXaf1pJcpFQWN9ImTs5rZJ/M4wqHqE4pG5pgs
         vJpJrZcKfwMeHa62IIDyFbTfTQASxDKOjdy1LD6/qYhz/Nt/ZzDjWz+PpaSkjpYPAyLQ
         XQmuYV15ZygcqxXSWo5dEGqvOOHqHaageCf3udMl/Nm/Nb10Hg3/cPRqsnFhvsXfNm1O
         X7jjv5zXDW1kVAGv6Jl3WdJiMUPSvx5vb6WO4HoToNMBvBKNzyQkVOeO3O5Tl9EN1DqK
         DYsCw+38m9Nnho+i/ct/G51LeyG0gBIuUH0MzWpncaTNki7K99qytcAPbxtqUCQPbe1+
         +qIQ==
X-Gm-Message-State: AOAM533iPTKmX1PLRtHTMppCgepP6ea6pzJ/RqZFko3+3Zip8l9Yf1sj
        n5Vax5cel7zJ+21qMJPTc4xQ9dqGb3cG54MztDr7Iw==
X-Google-Smtp-Source: ABdhPJwkrHF3OcP+O/QsRjhXYTKguhKusMRMufv0AfymLr/nf2X4/Clo+vABI37wuFKdiaRnNSuwBk9gQLyhYf8smtw=
X-Received: by 2002:a9d:7087:: with SMTP id l7mr5642765otj.72.1628941208239;
 Sat, 14 Aug 2021 04:40:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210813150523.364549385@linuxfoundation.org>
In-Reply-To: <20210813150523.364549385@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 14 Aug 2021 17:09:56 +0530
Message-ID: <CA+G9fYuYQu4WP=Hd9edWP5RN+ztH7fMa46W1vO3BVY_afF4Mgg@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/27] 5.4.141-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 13 Aug 2021 at 20:44, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.141 release.
> There are 27 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 15 Aug 2021 15:05:12 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.141-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.4.141-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: df6ce9b59c705e13e7fdf19dbba5a715b993b712
* git describe: v5.4.139-114-gdf6ce9b59c70
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
39-114-gdf6ce9b59c70

## No regressions (compared to v5.4.139-86-gff7bc8590c20)

## No fixes (compared to v5.4.139-86-gff7bc8590c20)

## Test result summary
total: 77974, pass: 64106, fail: 387, skip: 12161, xfail: 1320

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 193 total, 193 passed, 0 failed
* arm64: 27 total, 27 passed, 0 failed
* i386: 15 total, 15 passed, 0 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 21 total, 21 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 18 total, 18 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x86_64: 27 total, 27 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-android
* kselftest-arm64
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
* kselftest-kvm
* kselftest-lib
* kselftest-livepatch
* kselftest-lkdtm
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
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-vm
* kselftest-x86
* kselftest-zram
* kvm-unit-tests
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
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12D534D1A04
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 15:07:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242477AbiCHOId (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 09:08:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347304AbiCHOIa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 09:08:30 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB446592
        for <stable@vger.kernel.org>; Tue,  8 Mar 2022 06:07:33 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id f38so38009826ybi.3
        for <stable@vger.kernel.org>; Tue, 08 Mar 2022 06:07:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=eS0l7en5kynGt3cRHPFIsipgTmWpQYTaBB4iGuiUyWE=;
        b=iKbtGYe+OzWCk39Dwv2qUEoWjf+JA7E+3udO/PLQnP5y1YG4A/cZpcERNYbKNdLUbi
         ZuYn01YwLp1mLeDAhVpliopen6EdekVNkgHQuXRWfaZI8v88vJgrFPvI0ykWnSnf9TDe
         aDesPU6Qmwv7f4VJKhXXibW/VRJ5IKUsCECelkOOIveJWJOs4BSgGrBsRqwRhAjRSRby
         3SXxig4X4oycamZJEtlGPuWu2qDcI1xYycDX50vC/bzofSYo1o81ig0tcV7roK7WimjS
         LV/EHIarwFFwfA8TBrdN6mH++H1DxyBZp3p97YEngVqPIobhSZoAqpxaSX83NDbC7bUq
         Vxww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eS0l7en5kynGt3cRHPFIsipgTmWpQYTaBB4iGuiUyWE=;
        b=L0Lud4h9yKJaxCZh/+Fc1wyTKDZCL7C15ckn+3L4KxvEsSuPNLL8I5XSQcaPItGOaw
         FI1AOxGNuZ6XJ8otKOSfC6WDFWmteyRP+47WCOqnG8CRKDt8/VDCaybfDX0b7OyQ8GCZ
         BSqPdOiSUWv09Z0o/EKAtF3WgXsT6varDMWKC2Qkg6OAQwNE7CisQs2ICMozklGsVuqW
         4mCDZjK32cQZAcnsR9xrmJQX2L/ngj7k6a0gL9YrRkbqmxiWibVjAO5dY5UOjvcevayB
         sobeI1Kik7cIt011iOPbkzgi9+tNptap4gMXpLZJydHMSsDeAVaCSszGBMdvuowF1dXX
         jwhQ==
X-Gm-Message-State: AOAM532VVklw8XRNFMHnsMNQBPDvSrs51W/qazxChUpK9TghCUwQvRu+
        Vg95OsuwvcjGnX+uSMnwN62rhRUqeyJaQrbtQIuVTA==
X-Google-Smtp-Source: ABdhPJz84RZo0O57JXEhy755jv6Ko9Xe53ByV0D8Kh7akvFNPjsm+xAk8zkN232whC+0+o/BAb9z4518DeCUKeOGLP0=
X-Received: by 2002:a25:da91:0:b0:628:aa84:f69e with SMTP id
 n139-20020a25da91000000b00628aa84f69emr13010545ybf.603.1646748452927; Tue, 08
 Mar 2022 06:07:32 -0800 (PST)
MIME-Version: 1.0
References: <20220307091636.988950823@linuxfoundation.org>
In-Reply-To: <20220307091636.988950823@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 8 Mar 2022 19:37:21 +0530
Message-ID: <CA+G9fYtg5rveiJ7CFbPEBWYNeD3ZnmteJv3_mWNCESZh1w-WcQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/51] 4.19.233-rc1 review
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

On Mon, 7 Mar 2022 at 14:54, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.233 release.
> There are 51 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 09 Mar 2022 09:16:25 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.233-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.19.233-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: [None, 'linux-4.19.y']
* git commit: e227a7bfe445a282a8ba16771c3716b19839820b
* git describe: v4.19.232-53-ge227a7bfe445
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.232-53-ge227a7bfe445

## Test Regressions (compared to v4.19.232-45-g5da8d73687e7)
No test regressions found.

## Metric Regressions (compared to v4.19.232-45-g5da8d73687e7)
No metric regressions found.

## Test Fixes (compared to v4.19.232-45-g5da8d73687e7)
No test fixes found.

## Metric Fixes (compared to v4.19.232-45-g5da8d73687e7)
No metric fixes found.

## Test result summary
total: 86182, pass: 69715, fail: 1010, skip: 13571, xfail: 1886

## Build Summary
* arm: 281 total, 275 passed, 6 failed
* arm64: 39 total, 39 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 19 total, 19 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 27 total, 27 passed, 0 failed
* powerpc: 60 total, 49 passed, 11 failed
* s390: 12 total, 12 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 38 total, 38 passed, 0 failed

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
* vdso

--
Linaro LKFT
https://lkft.linaro.org

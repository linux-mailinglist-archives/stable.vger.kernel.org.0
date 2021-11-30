Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77027462FB2
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 10:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236272AbhK3Jfe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 04:35:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236083AbhK3Jfd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 04:35:33 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D68CC061746
        for <stable@vger.kernel.org>; Tue, 30 Nov 2021 01:32:14 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id l25so83797868eda.11
        for <stable@vger.kernel.org>; Tue, 30 Nov 2021 01:32:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xoXOLJWpD0lHUX6hFbdZV58Ab4Q2/gT90EA5saamkEU=;
        b=D6SapCyyPKCp06PaCKTy+m7XXWQ0waD1v0k39IbTt4l5t/a7TFWxI2IWxmrUjSAhZE
         mOWpnkm/05w+FW9vwwuAPuAT/tUzql3Y8J+aO+ex6tYsIw/4PlJ6rkCewmSbLggY5/px
         1AUjAPXNzGOlj+wgCR0sK3xYdDytMhFWSn+hu8ejP9QcaxnQRFNffnT3g2zun1ugblef
         O6y9R/t2yF97g2mGbo5+5ZKtkMPCIh6rXLpT4WaVahMnKgTCNKTygTvW6W87TitKdwEL
         FnyA478ZIq09E8/xGpubbyStQuUG2DYgFCXHQ7EU+L76JKOdK+g+AmGnNdSoHeu6gt4V
         m0uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xoXOLJWpD0lHUX6hFbdZV58Ab4Q2/gT90EA5saamkEU=;
        b=aoZ6ViPbvMihlTW+FP+DTvXig9aaM5vIlXDAJ5I6wES8VncSeGXmYOIy0U0aJ2WeC3
         JQ2Q6QntYR3krLSnfKGooqxCwsbwfd+kr9iAkHYqeNCTvJOdUgcQMIRiJsJTkJISO6Wv
         qro3sl34YMu92uhdw0mZohDzKiKe9ovMROmv3P3E38Ty6Z/jzVCZasg7927tjsW7phQh
         evWWf2G36uFmu6ahcEDqvU8UZvBdpdp+EKtV6afoEXkuGKe9G4kmjSOq+5PhE1J41nXz
         +HdvbRJ+CDaFtMrTD3ievtvphwAPbtOwrQFzi+sCzGrbCKHb70DAigGy7UVNVfd59rdt
         QqLQ==
X-Gm-Message-State: AOAM5307Elv4NOEb/MnFz+UhzYYnTNPfjzWAYg+71eWkisYlWUmKZIQz
        y050eA9wx/i5pnL92V8NlPabqJQXDDz2ML7ItiwLzw==
X-Google-Smtp-Source: ABdhPJwVC/Jc+0BLK1FXkRMFbLvZzD456y/TUVHcnDXZ7SKN27TolOtE5iiz9/cnlZ61+U3t8nFD7+BZZzF9v4/J0mU=
X-Received: by 2002:a05:6402:14f:: with SMTP id s15mr38056725edu.118.1638264732486;
 Tue, 30 Nov 2021 01:32:12 -0800 (PST)
MIME-Version: 1.0
References: <20211129181703.670197996@linuxfoundation.org>
In-Reply-To: <20211129181703.670197996@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 30 Nov 2021 15:02:01 +0530
Message-ID: <CA+G9fYuQEFsYa-pQBCqu5kFpKHnTODZRZj2agOxFh+XJWagy6A@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/69] 4.19.219-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, shuah@kernel.org,
        f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 29 Nov 2021 at 23:51, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.219 release.
> There are 69 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 01 Dec 2021 18:16:51 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.219-rc1.gz
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
* kernel: 4.19.219-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: 9697017144726ee73f348d6bb4c549151f92320a
* git describe: v4.19.218-70-g969701714472
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.218-70-g969701714472

## No regressions (compared to v4.19.217-321-g078e3b8561f3)

## No fixes (compared to v4.19.217-321-g078e3b8561f3)

## Test result summary
total: 66999, pass: 54132, fail: 570, skip: 10820, xfail: 1477

## Build Summary
* arm: 130 total, 130 passed, 0 failed
* arm64: 35 total, 35 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 19 total, 19 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 26 total, 26 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 22 total, 22 passed, 0 failed

## Test suites summary
* fwts
* kselftest-android
* kselftest-arm64
* kselftest-arm64/arm64.btitest.bti_c_func
* kselftest-arm64/arm64.btitest.bti_j_func
* kselftest-arm64/arm64.btitest.bti_jc_func
* kselftest-arm64/arm64.btitest.bti_none_func
* kselftest-arm64/arm64.btitest.nohint_func
* kselftest-arm64/arm64.btitest.paciasp_func
* kselftest-arm64/arm64.nobtitest.bti_c_func
* kselftest-arm64/arm64.nobtitest.bti_j_func
* kselftest-arm64/arm64.nobtitest.bti_jc_func
* kselftest-arm64/arm64.nobtitest.bti_none_func
* kselftest-arm64/arm64.nobtitest.nohint_func
* kselftest-arm64/arm64.nobtitest.paciasp_func
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

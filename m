Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE3E4A5816
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 08:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235229AbiBAHt1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 02:49:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235156AbiBAHt1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 02:49:27 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 031E2C061714
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 23:49:27 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id k31so48317942ybj.4
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 23:49:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JNKdFmAJl0yPZWafMVR1SRjZRlR2Tc0K6mbzmgilJXw=;
        b=PUGRi8PhLOihy6HuuBpkNaQAzVo8Yg58FRaTxryaYkO6zoW67+nRjhOCIxV50WLi2Z
         7A65ju7G/idSEtW40iAHRmHAMFKLUMTRVMYBFoMbmKNngJnMftF/2ok4LRdsUSzBPvFk
         dEwESCuUVXHqZMKELUXy6rK0n3Lnrzy/YndheFkKMVdf0V2z1hwOmXGp+ib3QIZk2Kpk
         PPxm0EgN6J9kscHcQ6JWuF8oeijt9AHjXutj+TOGSL0dGfpKwevgYtdw/C/l0FwQKWPR
         XEu6RCFP/nfH86lsvALcQ4Fh4669BXpz++202o0XF8KVFzLllWmjpjh0jWwmNkEY0+Uj
         k1xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JNKdFmAJl0yPZWafMVR1SRjZRlR2Tc0K6mbzmgilJXw=;
        b=pCDtpB8SLloXhHqojUBZipg3mNW3NyWCVIpjr7QWHHWSquLnP8oQ3ojvP0yQJtKV6b
         WrI1cQ7KiRd7r7gyayjLJCBzO6q4yh1hwWXiUCcUBlb5ol69rmyfasjSDPiW5M5oVind
         O2N5R9ToATpB7IwCsr6N439aL0IdEvODX+x2xFbXuWxe1IJm3dygpqglvY8tDJFzMFFM
         XwAzvEsxyovelPuO0FyM077XGV6AWjkg68bWr0j5jakqrXHP1JJH+QzHNC8vTemmS6Ih
         8lfTJXaxn69NMT4G47G826Pvk2XmHlw7fhY1/16m/+CgFWMGoXkxpQ5XwzsD1AA4AAA3
         Cc8A==
X-Gm-Message-State: AOAM530/iUph4vZaFkaWfE7zj/exziaXbOsuyz5TPFFquYBskf2qfEFS
        FM0cgDjVtFosPJYtdinlW0OYlOFPk4uySjtTabD6Gg==
X-Google-Smtp-Source: ABdhPJy3A7m7ySlGi0lmSlOn53HvQe3NEjgaKhW+Uo7EzINk44/gj84pBRx5UngicYWhsvV9o/Pt2+0Zqu3d3ovDqzQ=
X-Received: by 2002:a25:5143:: with SMTP id f64mr36552834ybb.520.1643701766028;
 Mon, 31 Jan 2022 23:49:26 -0800 (PST)
MIME-Version: 1.0
References: <20220131105220.424085452@linuxfoundation.org>
In-Reply-To: <20220131105220.424085452@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 1 Feb 2022 13:19:14 +0530
Message-ID: <CA+G9fYsLy+ozLHXsgC94_3F7waMaeQwHLbznh0hTMMx-E2Qiqw@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/100] 5.10.96-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 31 Jan 2022 at 16:33, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.96 release.
> There are 100 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 02 Feb 2022 10:51:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.96-rc1.gz
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
* kernel: 5.10.96-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.10.y
* git commit: bf18cfd8183fafa8bbba6fdd2c236624bbef333c
* git describe: v5.10.95-101-gbf18cfd8183f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.95-101-gbf18cfd8183f

## Test Regressions (compared to v5.10.95-97-g5abe721dc35b)
No test regressions found.

## Metric Regressions (compared to v5.10.95-97-g5abe721dc35b)
No metric regressions found.

## Test Fixes (compared to v5.10.95-97-g5abe721dc35b)
No test fixes found.

## Metric Fixes (compared to v5.10.95-97-g5abe721dc35b)
No metric fixes found.

## Test result summary
total: 95051, pass: 81215, fail: 565, skip: 12502, xfail: 769

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 259 total, 259 passed, 0 failed
* arm64: 37 total, 37 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 36 total, 36 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 34 total, 34 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 52 total, 46 passed, 6 failed
* riscv: 24 total, 22 passed, 2 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 37 total, 37 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
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
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org

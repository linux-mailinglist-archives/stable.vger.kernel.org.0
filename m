Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF5F41ABBF
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 11:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239708AbhI1J17 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 05:27:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239687AbhI1J16 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Sep 2021 05:27:58 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 969A8C061575
        for <stable@vger.kernel.org>; Tue, 28 Sep 2021 02:26:18 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id dn26so3661845edb.13
        for <stable@vger.kernel.org>; Tue, 28 Sep 2021 02:26:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wAcX3sCT345ARd1qWMjICS1I0tdu1z6MUxEDqgzdHaE=;
        b=rcIBwGwVLcVCfx2Z9MspMhS5B9ZfEoWGWLEgjGgIzN+MDLC9wUN9IO4Y4WqKDUGY2q
         viPNK8UwNLU8/qyH8QviALVH4Vm7XQOFSDMyG9MoYhj77bztR1JVXyahkupuEjffGsng
         Ks/FT/9wl0U3l/jhSHml+uKhkvTp8fWGgBl2VgBvzotr6HsSWDp2g9zX3f3lpQVtLlIv
         e33tuvr1AM4DIIeeOWQY1CfmxX+gwOR94yzlpE4L7q6XIgXkhudKRd4PcrbZwnLOjN1i
         sKg+c/l9JzrP23NrjuVACquHJ0aQ009/+weqYy3l8TJRaGQ5jgy8VypPuvN6xR+jv4G7
         0u2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wAcX3sCT345ARd1qWMjICS1I0tdu1z6MUxEDqgzdHaE=;
        b=nKWSlumSwJtX48BNh1MpBRTYgij4j8iBX91/K67hSn314M9UpYMAEVrN2yDyP+U059
         zK46LOlOmeQANfGh/cjxnQfvgsWY07zcJjhMbUZuQQ5L9lznfQyz4DS9lY09TpyI7ZLS
         wEj4dzFFRFevkw8liIBUkbm83nMkrCWjH6YUPfq9ynuTan44EIJLv3su+mEx9ioapZdA
         zqwEZP7ousDOtfzKFMhtNifp1HTtitiIzRxuj3+3nzq8YIUcPt++oE/5wwvOTAaHrVVE
         +FZh8BuE6CK8q2MJpmgbjTtO4iXWwGFLEXCc+KAMEraZLW+fC3pFcIcrMpW7rUJ1ePH8
         QeHA==
X-Gm-Message-State: AOAM531QT8LGbV49iPtWO1ovF7rA1DsrxOZE5kDxwyCqvLhayzqrbK1+
        er6HAPov8nV+v5kwpRgrQqVdAIGFlQntP2p4TeY5Vw==
X-Google-Smtp-Source: ABdhPJwRTFbg568fKLRcO+AIcdX7atTMGfHNz6wbO83QX5vnBMX7XP56M1qHxI4WhFBhUu/cBLjt/U0NcFC1mN7j8XU=
X-Received: by 2002:a17:906:4f96:: with SMTP id o22mr5417229eju.169.1632821176932;
 Tue, 28 Sep 2021 02:26:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210927170219.901812470@linuxfoundation.org>
In-Reply-To: <20210927170219.901812470@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 28 Sep 2021 14:56:05 +0530
Message-ID: <CA+G9fYsvAymC-W2D+BL_EzX--okZquiVeex7oRNKoFGBc_-_ig@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/68] 5.4.150-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 27 Sept 2021 at 22:35, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.150 release.
> There are 68 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 29 Sep 2021 17:02:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.150-rc1.gz
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
* kernel: 5.4.150-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.4.y
* git commit: aa1e7cd620d9f606f5b03b2e2d3ab68f5540359c
* git describe: v5.4.149-69-gaa1e7cd620d9
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
49-69-gaa1e7cd620d9

## No regressions (compared to v5.4.149-69-g143ba1e50d69)

## No fixes (compared to v5.4.149-69-g143ba1e50d69)


## Test result summary
total: 71836, pass: 58826, fail: 561, skip: 11488, xfail: 961

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 288 total, 288 passed, 0 failed
* arm64: 38 total, 38 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 19 total, 19 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 51 total, 51 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 36 total, 36 passed, 0 failed
* riscv: 30 total, 30 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 38 total, 37 passed, 1 failed

## Test suites summary
* fwts
* igt-gpu-tools
* install-android-platform-tools-r2600
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
* prep-tmp-disk
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA31365255
	for <lists+stable@lfdr.de>; Tue, 20 Apr 2021 08:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbhDTG1D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Apr 2021 02:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbhDTG1B (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Apr 2021 02:27:01 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADAD9C06174A
        for <stable@vger.kernel.org>; Mon, 19 Apr 2021 23:26:29 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id i3so17914198edt.1
        for <stable@vger.kernel.org>; Mon, 19 Apr 2021 23:26:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NjNCq2dBhMuHx3bF3hOsrzMTcPdRtKJAuEU4vqxU098=;
        b=Don9oKH38in1jVz/Sji3w712bn/WGonhEZY4AO9kUv9mqf+xlyDk3ZIO0jV7U7NiDq
         jB6Ay7U6mERivGZEjTZdTQLHB2+KTJaVCtHSV1I7jLKN21z5yV8qsCKRxNiji7OTaVA0
         Gdk8+FpzfkfQuITUswbXMsaf0Urh/GGC581SHN/q8nfv16WwLqSnBnvhTj/Ib5ErU1Sl
         qDljo4MuAdo82FZgWuXHeh/mwiLBYE/9KuqM6/anShXdMztH6Cwr6k+eeQ7vdpVjTT/p
         87MUali8ax1YLlOmOP2j9CDUwNniyCnZTPjYGec1EdhdzBvZvbSAYTnYjECw3Q+Qht0J
         kgTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NjNCq2dBhMuHx3bF3hOsrzMTcPdRtKJAuEU4vqxU098=;
        b=MaAGSog3adrL+8lrRhPzjzy8PQOowQF6Qa0tZJyWhMCbKKJr6zFmIzBaO5ukAQowOD
         HK3WDfKX3NYAgn9D6dsb1crsF1oe7Uqhw23bAY1VLRk0wIGiL83Bnk8qzRoLRuzyKJah
         7JPyskvHmG9mfxAejy2FnZVY6ku17DgnsHsa050cbny/EAwiXgR9m4CYpaDwgn/RaBhw
         oQj2R7oNfPKUD4Zm/s8u7H6XYm/5CjamW5dYkaa60+w+gtqX1XGj60GWxk8Mxrnw3ChV
         VDphyQYScEg2JCCFlfJflaTWUEQqv63KHgTrw4dxqmji/ONa3D25SVPZXh2HxR23nksd
         N0EA==
X-Gm-Message-State: AOAM533gtRUgVLetqAYBb/XvHLQedAZdMxVZqicX20si0wMcg02i7M+1
        1pdXe7u1zMPCH6IGJl7qsH0hyhQGWf7HZttU/gSUVw==
X-Google-Smtp-Source: ABdhPJyrF+QGPWpgWQ30bFN3g0HpzfsGXLg3v1r88IwrDOpvDNFEF6StOV/tAucv/xDMrJB50Apl1Yb7ansOld3ko0g=
X-Received: by 2002:a05:6402:5113:: with SMTP id m19mr30742141edd.78.1618899988236;
 Mon, 19 Apr 2021 23:26:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210419130530.166331793@linuxfoundation.org>
In-Reply-To: <20210419130530.166331793@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 20 Apr 2021 11:56:16 +0530
Message-ID: <CA+G9fYuogahExjxgL7pTbF6cvXtdRGT07jx6fGMXkrXHpmpx-g@mail.gmail.com>
Subject: Re: [PATCH 5.11 000/122] 5.11.16-rc1 review
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

On Mon, 19 Apr 2021 at 18:39, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.11.16 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 21 Apr 2021 13:05:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.11.16-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.11.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.11.16-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.11.y
* git commit: f34f787f0e47983f4f18c818b2cf23f5e3bf576e
* git describe: v5.11.15-123-gf34f787f0e47
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.11.y/build/v5.11=
.15-123-gf34f787f0e47

## No regressions (compared to v5.11.14-24-g7825299a896f)

## No fixes (compared to v5.11.14-24-g7825299a896f)

## Test result summary
 total: 76776, pass: 63385, fail: 2827, skip: 10320, xfail: 244,

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 192 total, 192 passed, 0 failed
* arm64: 26 total, 26 passed, 0 failed
* dragonboard-410c: 2 total, 2 passed, 0 failed
* hi6220-hikey: 2 total, 2 passed, 0 failed
* i386: 26 total, 26 passed, 0 failed
* juno-r2: 2 total, 2 passed, 0 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 21 total, 21 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 18 total, 18 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 0 passed, 1 failed
* x86: 2 total, 2 passed, 0 failed
* x86_64: 26 total, 26 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* install-android-platform-tools-r2600
* kselftest-
* kselftest-android
* kselftest-bpf
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
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
* kselftest-vsyscall-mode-native-
* kselftest-vsyscall-mode-none-
* kselftest-x86
* kselftest-zram
* kunit
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
* perf
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org

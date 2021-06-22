Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23C163AFB08
	for <lists+stable@lfdr.de>; Tue, 22 Jun 2021 04:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbhFVC0i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 22:26:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbhFVC0i (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Jun 2021 22:26:38 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A622C061574
        for <stable@vger.kernel.org>; Mon, 21 Jun 2021 19:24:23 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id i5so4114408eds.1
        for <stable@vger.kernel.org>; Mon, 21 Jun 2021 19:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tCIfIS3eohZy92oSMrzEBVAKlDW05o4oyi0vFuNyc44=;
        b=nbckcP9O6LAzwVA9GSt39qYz0zzRNvnwyR2OrtUNArLokfuYw+Jwf3rcrzPBnzXVHb
         J6h5E9WlkhYZxpMWb5su6lGmq4GDobfKE4jW4JlUXfocs3hmI+SfWtVxvFj66SpjL57C
         EhS03wFtf0/cyUEn/Io+91uiCm9EyY0tNMob9IItAhr9pHEO2RIzllFj1SDp/QJZ1Vgt
         5emrnEq2aGeV3xHTC6ZFujdoGGo6qe5KHhXM+4ap8jZ9+4YcaEDpe/Lmte1U7IZAMfNP
         N9368JAHXervRB4111Xewvd1ABiSTp0QnDIoH+wEJVF3yHwBz5vDHFMDml+BXquvdsIP
         XPCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tCIfIS3eohZy92oSMrzEBVAKlDW05o4oyi0vFuNyc44=;
        b=FHDKW/6gx2NigZWE3KN2qbrkvrLbB8ULYtPgNFvqshschkzkJhuWcK+jbPvpwjQ0ml
         3TXebuPywYltyRIBFEwMSb3jyLRbaao+ZuP4/t2wFjt6J1otf/bcfGwRYU+E1kApOr/F
         LjuBntkjlQiQxkgmLLtMlXoiwNTi3otybunp5Riq0I3CKL/aN2Cn8lKuyUNhhF2xJkBP
         eLkcXqdJgwMGf5Wj4j7PKY1Ot48hzQ6htteAWmKmuixFteUTbiM8ipZdbnoZzA3eybTc
         7aDZWt7oQKE++hBG3BFDBeG/SgaJ5Hc4gAGBbTPOMHBd5ZI/s8ALRyD3d8RQB6+SEsTN
         m8Zg==
X-Gm-Message-State: AOAM531eQEj02dEZVz2HGy4gXOmVP7PZEb3n8+IU9eGxNN38FEYF3yc4
        YSDwZoivki6FMoL8W3k9V/nxVoNnCoP2kcmSZj+ccw==
X-Google-Smtp-Source: ABdhPJy9veWqYRf6qd3C9gfWWDGnwRq909nyQjvhT5/MHYbSq9Si0iFNQu7pKa1kriVEpnMP4pLlczp0QTXhRAy8p9g=
X-Received: by 2002:a05:6402:402:: with SMTP id q2mr1688319edv.239.1624328661904;
 Mon, 21 Jun 2021 19:24:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210621154911.244649123@linuxfoundation.org>
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 22 Jun 2021 07:54:11 +0530
Message-ID: <CA+G9fYvH4WDXTcZfHGLqw9Cki-TihbFwukFGzrn=OpU6v5hz+A@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/146] 5.10.46-rc1 review
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

On Mon, 21 Jun 2021 at 21:51, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.46 release.
> There are 146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 23 Jun 2021 15:48:46 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.46-rc1.gz
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
* kernel: 5.10.46-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.10.y
* git commit: c00b84692b513471386cc0db08f8ac9020f88659
* git describe: v5.10.45-147-gc00b84692b51
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.45-147-gc00b84692b51

## No regressions (compared to v5.10.45)

## No fixes (compared to v5.10.45)


## Test result summary
 total: 79686, pass: 65434, fail: 2147, skip: 11258, xfail: 847,

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 193 total, 193 passed, 0 failed
* arm64: 27 total, 27 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 26 total, 26 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 45 total, 45 passed, 0 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 21 total, 21 passed, 0 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 18 total, 18 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 27 total, 27 passed, 0 failed

## Test suites summary
* fwts
* install-android-platform-tools-r2600
* kselftest-
* kselftest-android
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
* packetdrill
* perf
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55964476F3A
	for <lists+stable@lfdr.de>; Thu, 16 Dec 2021 11:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233527AbhLPKyW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Dec 2021 05:54:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233516AbhLPKyW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Dec 2021 05:54:22 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB24EC06173E
        for <stable@vger.kernel.org>; Thu, 16 Dec 2021 02:54:21 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id g14so84463282edb.8
        for <stable@vger.kernel.org>; Thu, 16 Dec 2021 02:54:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NzMGgtHLVkL7Zoni4ZKWdaDDzYlWc7/QvgZKMJdK/Jg=;
        b=nDIa1YIPfbmjy6W4A9M6vsAXp4t06DD3oIpi3i9W9ddrVZHdrism1eMnItOw5R4Nox
         ThD5ZsDGQgtvjKavmlrkffj+c1WOLTVa+QSZ7ndgcvVk1WlplUaQ/cikHVeLIabjChzx
         DwGzMrjSkegK3g5CERbpOA0VwtPQB4TrI7WWitsUN/EGRdgSvV+FgkxJEnhw/gLQ+Yng
         EqBeJFtYHMnMdK2kOnfYvsLVPRE7YOKrYpGFSECgYu4kQNPvkuosPU3uPf7NaDFEIF7Q
         vy4k1orwslb4Jo/hFYX0bCb94ELhB5kBq6ynsUGzHTZo04VIMiRATUmxLnoRHydT01TB
         5X4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NzMGgtHLVkL7Zoni4ZKWdaDDzYlWc7/QvgZKMJdK/Jg=;
        b=5d4/aBvoJQM/KQp8aug2TSMJrPrfybV35LEebz4tzW+fKTDDo/O9IKSDtxCcVlpazR
         3zDkOYocp9RGfeTQjd8DnHe1tJ/oPZATOkmOnUiqLgCHFcV6EKr8hWiMI8F6hZQ3XoLF
         AJ6pj1FloDxMJtjaAig7QqUnM/hIF1kfVa6jDqYkOP1ke4HER37JxZe+iY6Nv9pbiZhL
         qjnKw1tg6yP/tQAOnZeaDHfndEGyWRFnYuNhFn+yzcDvdJ4ohGMz0qzVQ1oHvzJFbgEX
         PpLO/X1xllJAiqhIW1iqVkvM8JsQVCNqmVWUNuuIVQ0zwqMXvCVOIvIDJKj1ajnZzahV
         svvQ==
X-Gm-Message-State: AOAM532UEWTRIzCTDbxEnE85cFzBladNs19g70kYRsa9ZvPdtDucmlRp
        RXtz7dX1u6y5jqgmWJJyx7CHrfUBHh/1FsvKqpeZjQ==
X-Google-Smtp-Source: ABdhPJxpeX1sQ5t3tCT7e0duXvHHxHhGX/RvqKYXjPcACTyrPJdWCPx0iXiUqm/J/NKHrd1QnUJR6pQRZxWARoIMRnA=
X-Received: by 2002:a05:6402:4b:: with SMTP id f11mr19626141edu.267.1639652060086;
 Thu, 16 Dec 2021 02:54:20 -0800 (PST)
MIME-Version: 1.0
References: <20211215172024.787958154@linuxfoundation.org>
In-Reply-To: <20211215172024.787958154@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 16 Dec 2021 16:24:08 +0530
Message-ID: <CA+G9fYuTJdgN2MHPB3YSQobn5DMrczu_GOkPwv9NgxRnDfZvAA@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/33] 5.10.86-rc1 review
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

On Wed, 15 Dec 2021 at 22:54, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.86 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 17 Dec 2021 17:20:14 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.86-rc1.gz
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
* kernel: 5.10.86-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: fb04daaadf03a67265eaa54966f45e30b83f1049
* git describe: v5.10.85-34-gfb04daaadf03
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.85-34-gfb04daaadf03

## No Test Regressions (compared to v5.10.84-128-g24961377099e)

## No Test Fixes (compared to v5.10.84-128-g24961377099e)

## Test result summary
total: 91173, pass: 78137, fail: 562, skip: 11764, xfail: 710

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 259 total, 255 passed, 4 failed
* arm64: 37 total, 37 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 36 total, 36 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 34 total, 30 passed, 4 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 52 total, 46 passed, 6 failed
* riscv: 24 total, 16 passed, 8 failed
* s390: 18 total, 18 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 2 total, 1 passed, 1 failed
* x86_64: 37 total, 37 passed, 0 failed

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

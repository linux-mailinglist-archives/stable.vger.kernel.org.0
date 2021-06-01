Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67407397191
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 12:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbhFAKiP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 06:38:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbhFAKiL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 06:38:11 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 615BCC06174A
        for <stable@vger.kernel.org>; Tue,  1 Jun 2021 03:36:29 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id t15so7924125eju.3
        for <stable@vger.kernel.org>; Tue, 01 Jun 2021 03:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=n2rcYxr+4iyg+FBD+P9vQi6mlsQoT7vy+quq4xOTEAs=;
        b=gxfdf/cOkVSWRs1fgAIrmRFwFwEZ1+BluexLtMqM8NifMmi5IOaYB1zBYecQtd9yDc
         ratzfPxzNuQQu1HSG0d1m5AwiGwtnkNPA/kOknHQA1HnqrLV4brTUV88CDc+fw32gcug
         M4R5MO1HxZRxuvWYA/NO9yaOyIV+xn5Q97XKXBL/ZxHk52u/gLoFb+IDQNibezwVMFnm
         u61fzYpIrsecS7VBCy6IrLUhcrGc85zdU5jJZNa4ffCuRds7OxCw5zubO0IJIdGyWjQV
         LnjMShp87ugilyUHXuZBzPybgOHYMDiXuz3UwD7yq3EyqkmK9e4SKVTdOpYbUbjaqSme
         9fKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=n2rcYxr+4iyg+FBD+P9vQi6mlsQoT7vy+quq4xOTEAs=;
        b=jE8JH3Dk1bGvsJn+S9KMa7E7Qhmw1ZjV1inYpUjn1Pic9gWGP1IIR2DJL213X6yS6i
         ESF4x2BKoDGuiTlSWqqTLtH5nB/3mn0MpnFQqfwAwWPbrNJfco9bJJvxsNpfu3ZiEUbj
         PkQNfwlZzI5rUY78QwqjmFBnoNGxwMrq0UzQJT71BHiZ4z2Xykeb3T74pFCgjZzvBtJh
         c/L2ZiTbPByxlAjO+XimMtHTtsiDfamjjce3y+3NWLNiKag62btvxgmu7PyFRvG4x85o
         1VWNACyKANjCO9PO3XMzx0dBAdopLpjK5vdnq6vFds3LkMRd++i+ZrabWtnjKdPSK7DW
         9Kpw==
X-Gm-Message-State: AOAM530LJoU8fUVwC+8Pj84dwytVmtEAm+xbsLSr/1qUffPqUy0BipQ/
        hXEVD5R9caKbISkZq2EBoRN/BiLe1LnFglFrc11VGA==
X-Google-Smtp-Source: ABdhPJw9+tUu+tyx6oUfkMuvkhZT4WmRAUVO3uuHwKPIwpLsMnTahGwHegIo9sVxfKqlrd37K5NPK5QUxMwcOC4gaTM=
X-Received: by 2002:a17:906:d0da:: with SMTP id bq26mr16625220ejb.287.1622543787889;
 Tue, 01 Jun 2021 03:36:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210531130636.002722319@linuxfoundation.org>
In-Reply-To: <20210531130636.002722319@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 1 Jun 2021 16:06:15 +0530
Message-ID: <CA+G9fYvJC050CGZ5Gsd8bAfTmahAfSPJqxyJu__GBYfO9X-9TA@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/79] 4.14.235-rc1 review
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

On Mon, 31 May 2021 at 18:59, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.235 release.
> There are 79 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 02 Jun 2021 13:06:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.235-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

This set of results are from 4.14.235-rc1.

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.14.235-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.14.y
* git commit: 506e0ba115126ff217295dca5197f9688c6f07c0
* git describe: v4.14.234-80-g506e0ba11512
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.234-80-g506e0ba11512

## No regressions (compared to v4.14.233-38-g535f9ea88cc8)


## Fixes (compared to v4.14.233-38-g535f9ea88cc8)
* ltp-mm-tests
  - ksm03
  - ksm03_1

NOTE: The LTP test suite upgraded to latest release version LTP 20210524.

## Test result summary
 total: 62263, pass: 49714, fail: 1558, skip: 10203, xfail: 788,

## Build Summary
* arm: 97 total, 97 passed, 0 failed
* arm64: 24 total, 24 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 14 total, 14 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 36 total, 36 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 14 total, 14 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* install-android-platform-tools-r2600
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
Naresh Kamboju
https://lkft.linaro.org

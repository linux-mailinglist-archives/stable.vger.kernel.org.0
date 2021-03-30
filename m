Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2FBA34E192
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 08:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbhC3Gxi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Mar 2021 02:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231285AbhC3Gxe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Mar 2021 02:53:34 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BBB9C061762
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 23:53:34 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id x21so16894288eds.4
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 23:53:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Yl6Jy7MuWjHimvar2yIAZHCUQGma25nEMpVmobdsF1s=;
        b=DjZPsg8EuhGUIJtQjsPhnbpTsSeTHzlq2g6PoQ9yxShFewdaaG3ag019yCt2GeIdCk
         A6BjzxyrCGCHRuGZmzDAPsc6D1C51g3KEfLV18YzKDnZF5oGoS6HKs15VKuGgNqaIExi
         WJlRwk/RTxzOCOISypnZXjUYvTCbqak95m5tZgiJfAWBUbVYo5bwLttjhRZhs6loyGum
         170wooWgRq3ewKYTx03TtLlmKX/KpQYT0S+Vw8MByFXPB+CTvQIBQexYZFCIBKBFBM8d
         QVUf5V2xg6Tbw01E8x919Iu+QaDRBBk4jjIcm2ASr0D7/9mC9kMdEXrr9Q6t3jOKfUXS
         SLvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Yl6Jy7MuWjHimvar2yIAZHCUQGma25nEMpVmobdsF1s=;
        b=NvP2dtfB5wPZlaHytuSCRZaZZUtkMA7+TWyW9hYUhIqr85tes4eTTf/Gl8iNNKxmPN
         WuY8p3ZM9y2iGx4LzLcwvsJt5V9jq8VMk3oA+lbc6At4JbQxt239pVNBgolBjLz/b5ds
         +gzNICoKpGY7S/V70Mqrx/zTZS/MrcmgWrZIZqm08e7Zxhfeh8jnGmboxJZwIiOwhTFy
         L0XjGu/19S+zRi45MtGHHhW+WG3hJS/WtR/QYBxMqn2ye95xhMFbuIYBjI1+oHZkydlM
         eU+9yaM+B+iFVIy6eAGwz7rzYAWR2M/O3wJVwHEdg1buzOvJmyYNwyVhh1i59HG9+OVd
         NALQ==
X-Gm-Message-State: AOAM530D0u135H9VUP0nNiJiX+VQR1yMlmDtKDEkFf6zhP5QixWK5XN1
        c4HT6H62KkcqlgbylYmTXHYbwp4Q+C5FFIaT3ZW2ow==
X-Google-Smtp-Source: ABdhPJxnLjTWUyelEY1C2zvLk514sIRLuwQuy1QlZZoyh8pYtGC9qrfUjJ0QqQPgneLLa0K+oITHCTxZvRLrB5G6meE=
X-Received: by 2002:a05:6402:5113:: with SMTP id m19mr32641986edd.78.1617087212964;
 Mon, 29 Mar 2021 23:53:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210329075608.898173317@linuxfoundation.org>
In-Reply-To: <20210329075608.898173317@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 30 Mar 2021 12:23:21 +0530
Message-ID: <CA+G9fYvStCWDgpuwB3M8ZYBLfyQYMcJjbphTSg_UTSaWUESJrQ@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/59] 4.14.228-rc1 review
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

On Mon, 29 Mar 2021 at 13:37, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.228 release.
> There are 59 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 31 Mar 2021 07:55:56 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.228-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 4.14.228-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: 4cee23773c6e6701bbedeed75e7d4dd2fe5bb8c0
git describe: v4.14.227-60-g4cee23773c6e
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14=
.y/build/v4.14.227-60-g4cee23773c6e

No regressions (compared to build v4.14.227)

No fixes (compared to build v4.14.227)

Ran 50616 total tests in the following environments and test suites.

Environments
--------------
- arm
- arm64
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-64k_page_size
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- mips
- qemu-arm-debug
- qemu-arm64-debug
- qemu-arm64-kasan
- qemu-i386-debug
- qemu-x86_64-debug
- qemu-x86_64-kasan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- sparc
- x15 - arm
- x86_64
- x86-kasan
- x86_64

Test Suites
-----------
* build
* linux-log-parser
* igt-gpu-tools
* install-android-platform-tools-r2600
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
* kselftest-net
* kselftest-netfilter
* kselftest-nsfs
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
* kselftest-zram
* ltp-controllers-tests
* ltp-cve-tests
* ltp-ipc-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* perf
* fwts
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-mm-tests
* network-basic-tests
* kselftest-android
* kselftest-bpf
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-vm
* kselftest-x86
* ltp-commands-tests
* ltp-dio-tests
* ltp-fs-tests
* ltp-io-tests
* ltp-math-tests
* ltp-open-posix-tests
* v4l2-compliance
* kvm-unit-tests
* rcutorture
* kselftest-kexec
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org

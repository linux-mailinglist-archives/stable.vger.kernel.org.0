Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD7F4238E0
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 09:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbhJFHbp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 03:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbhJFHbp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 03:31:45 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D16BC061749
        for <stable@vger.kernel.org>; Wed,  6 Oct 2021 00:29:53 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id p11so6149738edy.10
        for <stable@vger.kernel.org>; Wed, 06 Oct 2021 00:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=z844VJHlxmzvOdY4OzjauvhY0H4JFbINr/ZD7bsQcsk=;
        b=vN1K8uIBti7VTjj7axQNZBJHsGBZExPEJVHpOmXtVDlN3P4jZK0Gsthi48g9SFs7LU
         RPEWTaJAO/aMhW2yRwTwybT673w0KTLA1X8GQdsBJPDNQP7FWlk3m4f9D1PWjN8nJWnw
         M889WovAgR4/WZOQMQMu6v4BXRIxnPhH82JPD/l3Glr/h0c5ayWzfV/bEskengfpXwDu
         NmHM3IQxrJYR0WLflZZQLI+AzHyoA8+TURDPJHxO6P40Hbe/DIOjPYXiZZLc2WUJmhm7
         OzH4Iqh8GjGMlSoAO4RJX7S67lSZmENF6MC8B/+AhWTXyrTpv/MoeQP5qOWGNxNSHGGw
         h9yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=z844VJHlxmzvOdY4OzjauvhY0H4JFbINr/ZD7bsQcsk=;
        b=0UK7yF7GWaYdhCvXkWy6wyEu4FN5oh019nTRUA0r+McaSCW0aWTBV6VKDVj3xQQA7o
         iPCKL35b/IXtha+odsTTZcoWVUX97/45JyX3s66p6kNsxtTkw6FhIxL7HMsmI02Y0gmS
         U9T05CbOOT40cZi513CwJUzuWIvYW1tn6pgXz4+gRMh+AdJfzRuOKWsH3A7ckpzIcszC
         IjKjxgmgE+gnAAhSGBgPQyDGLtE0R9+sfSHQ1NnttRagn5mbSRteWsD1kIhU6ZlyvUjQ
         7Buje+ThJ4s+uDaSJzr0wwGSGnZVp9h6ruscKItBfvyLlZxJIsmcSDqocPS2dJc57Wfx
         MHfw==
X-Gm-Message-State: AOAM531tnScf0Smd+uet2uN2CGCy5OXjYLyTU+nh5X8Q963ODzVA/Zen
        DB03VaM8pFCLTpoC3wiWeQR4O0DFO29shA7ruqs/MA==
X-Google-Smtp-Source: ABdhPJwFaYFjTUiAM0bIVE8z8rHBC8xMOT3uRVWuAmOUVUJFCSkxzbtWbx3It1lwvTMlmeU9R4xmLYq3jrG1efTs0Hw=
X-Received: by 2002:a17:906:4f96:: with SMTP id o22mr30180033eju.169.1633505391881;
 Wed, 06 Oct 2021 00:29:51 -0700 (PDT)
MIME-Version: 1.0
References: <20211005083258.454981062@linuxfoundation.org>
In-Reply-To: <20211005083258.454981062@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 6 Oct 2021 12:59:40 +0530
Message-ID: <CA+G9fYv33Bh4q9O8wvSV33+NT=ZNBqqarjMmjRDGxbz4tZc+GA@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/75] 4.14.249-rc2 review
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

On Tue, 5 Oct 2021 at 14:08, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.249 release.
> There are 75 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 07 Oct 2021 08:32:44 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.249-rc2.gz
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

## Build
* kernel: 4.14.249-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.14.y
* git commit: b56df9ef1a53d484fa3653206dd4ae0e5c45c6ff
* git describe: v4.14.248-76-gb56df9ef1a53
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.248-76-gb56df9ef1a53

## No regressions (compared to v4.14.248-76-g7f6d4fdae68d)

## No fixes (compared to v4.14.248-76-g7f6d4fdae68d)


## Test result summary
total: 74585, pass: 59188, fail: 675, skip: 12625, xfail: 2097

## Build Summary
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 1 total, 1 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed

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

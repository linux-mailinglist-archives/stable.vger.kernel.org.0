Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19D514AA73E
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 08:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379547AbiBEHB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 02:01:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379537AbiBEHB4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 02:01:56 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53821C061346
        for <stable@vger.kernel.org>; Fri,  4 Feb 2022 23:01:55 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id y6so10354932ybc.5
        for <stable@vger.kernel.org>; Fri, 04 Feb 2022 23:01:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5GMBi+gkxjCw1wEOJS7/XrFS7/0JirqIvwhhHXkV+vc=;
        b=eeayCM+VPZEVrrSQALMhfbBHR+OdJnicusq0jnua17xWUhHhQfshy9aAnYOS8eEF/v
         bAwAHyXf0iSJnNDtShvKaYcqqhffBttWNkPJIwK8TfC5ZOURfAjYIA7vGC1Qixrw6dio
         ppN5Tx30nlEPWcEPt3YyFgsymaBvFnj/4sG0SG0e+dTfldoDY8WzTczRXHB23R+lRTjx
         B/VxAqgYaciKaS6U9x2/abgpC2I0rgbBoHdu+MHUZDv5zsAyefPpgbEumwTKB7JST49x
         V66JeuGaY0VY+p6V5zte2laIStp8HJrfyvsAtlaWx/lG7bF70Z3LD9YcrU6BhRIGJFlE
         0umw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5GMBi+gkxjCw1wEOJS7/XrFS7/0JirqIvwhhHXkV+vc=;
        b=gWY9I7xsdMx6NhBz7CNt6Ak+3fv3CRkID7WzVWRBHuVCWEaTuBj1y0GWN9Ieu7gB4E
         EYops6rxtRXKtGRIDpqjLupMFQxwAef3v4DOspwzqu/yQWcFQti9bTWDFT1lf+y/JRXD
         SOta0UHXlVQwPMLsKhxnvpUI1n4jIzTm7Yj4S+/+4vHXMon0lTvd5gP0yvDjcOePI70K
         wXPfYHa1gp4URC6vUNNeBFIJMjEboL0xW27fHAxC1FW4XK9vCmTumwK54waMgY1ib0B/
         NkrYc7/3c7kX4ptZxBrZe1zXP+nbBVzBH/3empbAQrqosPLpxReGC0InsqNdmSbRYxpm
         vsrw==
X-Gm-Message-State: AOAM5304QtK+iv4GAkkKqpg10r1VN1DdwOM1arG1jcgwiHRwuMo19OfL
        iJSFIw5UbXR52gepvsbHsYDPmP59WHKbgV1jpVad8Q==
X-Google-Smtp-Source: ABdhPJys2pkhAa3B+povPTwmD0YWBSUizsHYHJB3XGuFKby5uRaIk0zw2U/+ebrZxZS2RgQLMRieZiF4k7UFYq+e5Ls=
X-Received: by 2002:a25:97c4:: with SMTP id j4mr2667748ybo.108.1644044514366;
 Fri, 04 Feb 2022 23:01:54 -0800 (PST)
MIME-Version: 1.0
References: <20220204091914.280602669@linuxfoundation.org>
In-Reply-To: <20220204091914.280602669@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 5 Feb 2022 12:31:43 +0530
Message-ID: <CA+G9fYuuDJh=zwZVb8Z8E1g6OpfxRJ0trzQei0a-hChTtRViMw@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/25] 5.10.97-rc1 review
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

On Fri, 4 Feb 2022 at 14:52, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.97 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 06 Feb 2022 09:19:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.97-rc1.gz
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
* kernel: 5.10.97-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 847fbfddce327344933153bb39a4379b080bede7
* git describe: v5.10.96-26-g847fbfddce32
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.96-26-g847fbfddce32

## Test Regressions (compared to v5.10.96)
No test regressions found.

## Metric regressions (compared to v5.10.96)
No metric regressions found.

## Test fixes (compared to v5.10.96)
No test fixes found.

## Metric fixes (compared to v5.10.96)
No metric fixes found.

## Test result summary
total: 98319, pass: 84375, fail: 545, skip: 12496, xfail: 903

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

--=20
Linaro LKFT
https://lkft.linaro.org

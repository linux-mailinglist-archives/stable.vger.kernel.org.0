Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 612734E81AD
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 15:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbiCZOwV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Mar 2022 10:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbiCZOwV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Mar 2022 10:52:21 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F3CA2467D3
        for <stable@vger.kernel.org>; Sat, 26 Mar 2022 07:50:44 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id f38so18803326ybi.3
        for <stable@vger.kernel.org>; Sat, 26 Mar 2022 07:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fb5kGuUvvdUK4XMy1yH8Sc2VVKSMt6SqLVzOmZhik8k=;
        b=KWWi/LGkiZKg8vN7EGtbsW3GeWnIXFu3Ck7FMstxFyR3Y3+PwUXdl50txsL9/FESpX
         /wIX/cwXdwz5JnnkqIx1t3ttnwPloBSaY5x9hJ5GAVocBjwOCHaDuzowA8GxVvfNmPD9
         NUBuo+w23SBYWcMQgyrZG4E+wLK3YlQjWDTf6KC3qHdwxafMNSwp5zZkvx8MXfrCM0T3
         UyMGuCiioYEkwq4T4WCH7SyTqCplDYNslTkOMKWIXA+WsthVRttJkaGlm5s7bFRokhbB
         BWQbWowMTGpiDbfezdEIkO74VEIOTQWNIl8W848Xnrrx/dJpSIzEcZ/XLQb1hj2wk1yE
         vZog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fb5kGuUvvdUK4XMy1yH8Sc2VVKSMt6SqLVzOmZhik8k=;
        b=iyDnlCCO8qcigRBWKiHVySEyUcx3gg3KHXPQNacAu/h1iVVzTLbDuuQiszsOlgA2hL
         A/1X7CZ/62aDBv4LQEWciR1abqLb+gGCa32+5C8Dg2CDQGqIurhlJRNQ3jgvZrwRGAAt
         13b9GD+mDYDmx3NTI4rSew82cbmENGZyIJKwC8aGG0Tg5NgJ0FOjCHXW266tdXq+u2q9
         lkR1jTrTwWOV+TVaCicJMH2gV0aZdC6F2i0z6kd8Be7oAqw5P7IzSu+N3cIyD/h0nugJ
         5lP9KKYwsqFTq1ZCx0cDrMasD813JimAV7IgrwUi/6+wJMmeSQXiIqaetlIeHpe8twQd
         FA2w==
X-Gm-Message-State: AOAM533vPBow0T3ERxxzg1DqqTzGpD6Kz7UGxSjZ2La9ju5xRgrqNGkp
        iXtdEwE7w2ylGEjbaL2g9I+PopPrQYu6AQQMTvBdbA==
X-Google-Smtp-Source: ABdhPJzXg2Vgn6zZmpmBOIY6w2mTDofy+P+b6rmMjh9oax5UPFQhT18hRYDZ2+QY8cq6aTmhK4AIVteRCSncc/EM274=
X-Received: by 2002:a5b:892:0:b0:633:ba98:d566 with SMTP id
 e18-20020a5b0892000000b00633ba98d566mr15065304ybq.128.1648306243354; Sat, 26
 Mar 2022 07:50:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220325150415.694544076@linuxfoundation.org>
In-Reply-To: <20220325150415.694544076@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 26 Mar 2022 20:20:32 +0530
Message-ID: <CA+G9fYs22ySD63HYqcLtqgWt=E9h9avGeT3eiY6e36Gq+6Yv=w@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/14] 4.9.309-rc1 review
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 25 Mar 2022 at 20:34, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.309 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 27 Mar 2022 15:04:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.309-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.9.309-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.9.y
* git commit: ebc053b844b704373fb74ff8f019e29785bed7e9
* git describe: v4.9.308-15-gebc053b844b7
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.3=
08-15-gebc053b844b7

## Test Regressions (compared to v4.9.308)
No test regressions found.

## Metric Regressions (compared to v4.9.308)
No metric regressions found.

## Test Fixes (compared to v4.9.308)
No test fixes found.

## Metric Fixes (compared to v4.9.308)
No metric fixes found.

## Test result summary
total: 60629, pass: 47943, fail: 552, skip: 10058, xfail: 2076

## Build Summary
* arm: 254 total, 238 passed, 16 failed
* arm64: 32 total, 32 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 19 total, 19 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 31 total, 31 passed, 0 failed

## Test suites summary
* fwts
* kselftest-android
* kselftest-arm64
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
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org

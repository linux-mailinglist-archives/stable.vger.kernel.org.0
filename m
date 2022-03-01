Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C95554C8FAC
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 17:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235918AbiCAQHa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 11:07:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235974AbiCAQH2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 11:07:28 -0500
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A78AC46B02
        for <stable@vger.kernel.org>; Tue,  1 Mar 2022 08:06:47 -0800 (PST)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-2dc0364d2ceso1023427b3.7
        for <stable@vger.kernel.org>; Tue, 01 Mar 2022 08:06:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5ZXATWH1idWVljLBSYFysoYYRfP4q7oy1uj7Xp77Wes=;
        b=sqLTHgZG89xSvZiHTJav7yC0zJw3cK+2YWORei7/4iHXDFR2odGC8va9Yuxvz5H37Y
         zeDY/0/3v8xNJpi26vp4lEdl5D4wb1AYx8g8gYBFL10Pc21eRcvqMhaIhU7v9gQqKuYH
         Od3oq4FUViEVT16rLrAfoKNn4JFq24+brSLtXf3W/XuzyynirrGfmaFB8Z6++Pe5WMXU
         VScxzul81KIiGteUH4JKXTvOTzMUYkHYOvfUUUA0UMpYaQV/hV5sU4aUZKczZelIlOrn
         Cqj/XiLCbEi0f2pHm4bQbJJnuK8ny1q+BBcZ1nUYOPgVH/3Dcnq0G0DoPNsYxprmDsCj
         mraA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5ZXATWH1idWVljLBSYFysoYYRfP4q7oy1uj7Xp77Wes=;
        b=g17AuCMZ5CNZc2yTZzbFHSbwXkOp6FhMmCY7Sc+ayh9SVOIHGK+7H0qS7HeQuXws1p
         /8A9sH7EvcwITJ+TsKyaGwNgCoL+YakcYy7mhYHMuJI8xcKeaiW0nm3NwBnzLMCn+3w6
         uHGylKfOcvECyjnnge1JDWz3VN052+LHhspH3VA8dwCQHc8Yhyv9kIqrAztv5tRChmux
         1C7kMSV4tW1jn2uGnSazQ9H9vtBTdAeSP+xu3nJSENlaHnSTLsXCc6u5aZmsQk8iasPR
         KsRnZ8OtsKZLw9IKCsoclpttI/jz9JTJ7UCSYKDemJK9CegHpioTm+Rw7rGWodwawLfH
         TZrw==
X-Gm-Message-State: AOAM5306ku42TBZLvPQAmRCiP+SHea0BO0eLlI44H6Tv6c8lKouZr4hb
        6fnqFRTTzP5y/mB0GGbUmO83zc/iGRDfOEJlMSYVQg==
X-Google-Smtp-Source: ABdhPJwL8lH0SOVvzS1cm5/oug45cK/I3RxyU9yOfG0VFgIdbrjKcgq5WTdct81ihM+voEShGwhsvz74D/Q93VtuO4E=
X-Received: by 2002:a81:e90c:0:b0:2db:d63e:56ff with SMTP id
 d12-20020a81e90c000000b002dbd63e56ffmr5126928ywm.60.1646150806723; Tue, 01
 Mar 2022 08:06:46 -0800 (PST)
MIME-Version: 1.0
References: <20220228172159.515152296@linuxfoundation.org>
In-Reply-To: <20220228172159.515152296@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 1 Mar 2022 21:36:35 +0530
Message-ID: <CA+G9fYsuzZVa+LT0stskODz5nrgsWhXgU7qPTXSBN2gbFfjC2g@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/31] 4.14.269-rc1 review
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

On Mon, 28 Feb 2022 at 22:58, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.269 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 02 Mar 2022 17:20:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.269-rc1.gz
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
* kernel: 4.14.269-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.14.y
* git commit: 43ab82ea0bf0a7b6afb31831af7cefaa3e21c9d6
* git describe: v4.14.268-32-g43ab82ea0bf0
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.268-32-g43ab82ea0bf0

## Test Regressions (compared to v4.14.268)
No test regressions found.

## Metric Regressions (compared to v4.14.268)
No metric regressions found.

## Test Fixes (compared to v4.14.268)
No test fixes found.

## Metric Fixes (compared to v4.14.268)
No metric fixes found.

## Test result summary
total: 79045, pass: 65997, fail: 354, skip: 11390, xfail: 1304

## Build Summary
* arm: 280 total, 270 passed, 10 failed
* arm64: 35 total, 35 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 19 total, 19 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* powerpc: 60 total, 12 passed, 48 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 34 total, 34 passed, 0 failed

## Test suites summary
* fwts
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
* vdso

--
Linaro LKFT
https://lkft.linaro.org

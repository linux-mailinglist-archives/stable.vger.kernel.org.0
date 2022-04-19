Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B91B50680D
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 11:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348414AbiDSJxk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 05:53:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236109AbiDSJxj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 05:53:39 -0400
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E4481EEF0
        for <stable@vger.kernel.org>; Tue, 19 Apr 2022 02:50:56 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-2f18982c255so50297517b3.1
        for <stable@vger.kernel.org>; Tue, 19 Apr 2022 02:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dl90oSwpu1I2JqHuv4Jr4MICWXPdF5LiEbJFOyplxM0=;
        b=k4zQPDwLKtPzuXs/AROjg5x/L2123QZrb73Fbk6KUxgSStgu/Fr08Ovg6Qen+tpU1a
         2C30/x7h1HgTSgoeWChYyokW4EvkTXMc+8ThGLR4jOoXx2s7c0w5SpivViJHziN7tZcT
         EVTY1Kwa+s3yCi/j4F5UZpYH9Jll6wPz5NFN/HeVFZpVgXNNk2T4/cMbqEO/zKD0+MCG
         3AWU0cHXWRlVnkbNFyjAaofHSTntuPzwewZMuq3vU2c4ZWKXesuLmVGwD3CwPXDXLHrO
         JdpHBn+aYuRuKZ1Um29RuP8Djerek3RVOC9tfbfhVeuNZyDGIUvz/bPlQOrO1FLTA++r
         NysA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dl90oSwpu1I2JqHuv4Jr4MICWXPdF5LiEbJFOyplxM0=;
        b=JSwSH1PwPTS3MiNlUYLBzf0F12jTcO9ekNbIg/i5aBWXoGMBIWxjyQv6Qnz0lp4YNv
         LUjpy5JQpLRzN5QK66Xfie4QTbzvg2SKSdE2vGKQVhj3FfqmBENT/h6YwduypuPrLq65
         2AIBRyppJNbMWW3lgwqmOyR/dT0niLm/o5tGfQMElrW9XjtELCqoPzlZoqA3+TT+OlRg
         Yxi7mvbGEiBIT7ndLVKNqCnpKTJQhsce/eEcQgobPF4XiB4Q2LSkIYi3PX3sDtS+r0qX
         p0VD22Eym75a+Qh4mVgi1ExeAzrbheuoGy3mNVZKeKSODQGG0dJXY+f05LWnLNlNjob7
         us6w==
X-Gm-Message-State: AOAM530IYwTbem4p9G/6IzJmHe+B3NSdSlu/TTCOHW0o0Ca+9PaPnqwk
        C9creA84NakuccIcFzKDtpUoV6oOyECCmW6A6Einzg==
X-Google-Smtp-Source: ABdhPJxVfpiNqlMqKBIiQd4TDt5ub6ivMN/JZ1VjIGroBGjZh+44/kjqnkcU9sdUQb6WZiNy1apeWuKUqtoD9ykas3U=
X-Received: by 2002:a81:bf51:0:b0:2ef:414a:f03b with SMTP id
 s17-20020a81bf51000000b002ef414af03bmr14639495ywk.199.1650361855670; Tue, 19
 Apr 2022 02:50:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220418121210.689577360@linuxfoundation.org>
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 19 Apr 2022 15:20:44 +0530
Message-ID: <CA+G9fYst4DK2ekv3AQXbxCj5P7Z-tCpryW26AXO6nJLQBsykrQ@mail.gmail.com>
Subject: Re: [PATCH 4.14 000/284] 4.14.276-rc1 review
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

On Mon, 18 Apr 2022 at 18:19, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.276 release.
> There are 284 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 20 Apr 2022 12:11:14 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.276-rc1.gz
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
* kernel: 4.14.276-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: e419aef383a11eecb0ea07a61430afa74c724e9b
* git describe: v4.14.275-285-ge419aef383a1
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.275-285-ge419aef383a1

## Test Regressions (compared to v4.14.275-264-g7bdda4a2902a)
No test regressions found.

## Metric Regressions (compared to v4.14.275-264-g7bdda4a2902a)
No metric regressions found.

## Test Fixes (compared to v4.14.275-264-g7bdda4a2902a)
No test fixes found.

## Metric Fixes (compared to v4.14.275-264-g7bdda4a2902a)
No metric fixes found.

## Test result summary
total: 80663, pass: 64544, fail: 876, skip: 12943, xfail: 2300

## Build Summary
* arm: 280 total, 270 passed, 10 failed
* arm64: 35 total, 35 passed, 0 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* powerpc: 60 total, 16 passed, 44 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 34 total, 34 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
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
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org

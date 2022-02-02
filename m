Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1ADD4A6C92
	for <lists+stable@lfdr.de>; Wed,  2 Feb 2022 09:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242058AbiBBICk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Feb 2022 03:02:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241774AbiBBICi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Feb 2022 03:02:38 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 669A5C06173B
        for <stable@vger.kernel.org>; Wed,  2 Feb 2022 00:02:38 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id k17so58475633ybk.6
        for <stable@vger.kernel.org>; Wed, 02 Feb 2022 00:02:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5ULnuSMw6BaafnM0dXfWCNvtwKS09lgezUw+stHInS8=;
        b=Y7bQbHPPQr1LLRjw84cKLVNPallo6EJeAY36Y1X6RJJCuLHf6NTKlDxOmcyShUXmp1
         DB/TvA/VpqojM6OlSeyb6C0dwg2c7o0jfFetZpZFyuULXtlTNts3ZACV1MliS/3ky8CI
         i84lRuie5MY5Uqg+kKVEflR0AQUf9tXWJ0//Wa4YLv1hdFnRYA7bVs9PFbjyVG5g3GBN
         IrLx4RWoGnr/aSayfga+yWwrjr484blmV+OAw37dbQgjVw9MAnLf7O5+xt9X0lGjT+kB
         Iw/yBft6kNt96SylsqIWD8G1iKJTf6zwwyQqO6Go1hVLurOCPBHD70pkHFEyBDEFj5Z8
         egYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5ULnuSMw6BaafnM0dXfWCNvtwKS09lgezUw+stHInS8=;
        b=YZXi1wgmKolEd5rRbQkbITHf26dswu9PYYvr57lczZxoqErUW2bujGhhMuh4Rfb0xn
         b3ocpqvIqBZ4txCqgBNAyT27xeQJ+GuCC3lBZOErxrGYc7z2bDDLaSMT50qqmv4m3rvt
         wWNVFN+Nu0fGE5BMrceboU/QppgxoFmQsGdbTl+xLCwa5rP4vuyktNkVOdjM1IKmBjub
         uYoxvPKI+BhPizH98oJxCqP8EXkhz5FM/CTzQcJwI38OLQHghBlcJIJ61jMvPu55VSTM
         4MxTP4IoFeM+xIgaSY8eOBH7yVTDyw8Yki0rvXXUHUBfRqKkAKLh5lh/CrE7a45h1HW8
         +/5g==
X-Gm-Message-State: AOAM53172UYuySGjG86zehjdI855L0Z5grmQYXPEseBMEPES/xD8ynlJ
        x/ELzMqyoOuAXqMCBqvdGvWADv17lBekvzcXAbU+2g==
X-Google-Smtp-Source: ABdhPJySyX8uXEgfILIb5iQ/uH0ZoNt0kzAhB6o9r05s+YYosOlvSnTSgyf1Kc6EadgCF0WxKNwI1XPbox9eTXxWV8c=
X-Received: by 2002:a25:97c4:: with SMTP id j4mr42773358ybo.108.1643788957241;
 Wed, 02 Feb 2022 00:02:37 -0800 (PST)
MIME-Version: 1.0
References: <20220201180822.148370751@linuxfoundation.org>
In-Reply-To: <20220201180822.148370751@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 2 Feb 2022 13:32:23 +0530
Message-ID: <CA+G9fYvOzZq+zd2YJmTCOCPazy_A85DrZWr2VrK+y-mGg5Nu7w@mail.gmail.com>
Subject: Re: [PATCH 4.4 00/25] 4.4.302-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 1 Feb 2022 at 23:47, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> NOTE!  This is the proposed LAST 4.4.y kernel release to happen under
> the rules of the normal stable kernel releases.  After this one, it will
> be marked End-Of-Life as it has been 6 years and you really should know
> better by now and have moved to a newer kernel tree.  After this one, no
> more security fixes will be backported and you will end up with an
> insecure system over time.
>
> --------------------------
>
> This is the start of the stable review cycle for the 4.4.302 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 03 Feb 2022 18:08:10 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.4.302-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.4.302-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.4.y
* git commit: 806b2893e0101bdff3ead10f038759a025f73557
* git describe: v4.4.301-26-g806b2893e010
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.4.y/build/v4.4.3=
01-26-g806b2893e010

## Test Regressions (compared to v4.4.299-114-g37c6a274092f)
No test regressions found.

## Metric Regressions (compared to v4.4.299-114-g37c6a274092f)
No metric regressions found.

## Test Fixes (compared to v4.4.299-114-g37c6a274092f)
No test fixes found.

## Metric Fixes (compared to v4.4.299-114-g37c6a274092f)
No metric fixes found.

## Test result summary
total: 55060, pass: 44792, fail: 242, skip: 8710, xfail: 1316

## Build Summary
* arm: 258 total, 258 passed, 0 failed
* arm64: 62 total, 62 passed, 0 failed
* i386: 35 total, 35 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 44 total, 44 passed, 0 failed
* sparc: 24 total, 24 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 2 total, 1 passed, 1 failed
* x86_64: 60 total, 48 passed, 12 failed

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
* perf
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org

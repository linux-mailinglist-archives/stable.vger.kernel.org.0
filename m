Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7B271CBFBF
	for <lists+stable@lfdr.de>; Sat,  9 May 2020 11:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727889AbgEIJWR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 May 2020 05:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725930AbgEIJWR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 May 2020 05:22:17 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B412DC061A0C
        for <stable@vger.kernel.org>; Sat,  9 May 2020 02:22:16 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id e25so4211621ljg.5
        for <stable@vger.kernel.org>; Sat, 09 May 2020 02:22:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3r2q7lbwhYacRNyV9QGzwXdGy2ioZNd6LAcHxLVxfTo=;
        b=SiqQS9i+Kqa3biT4qPmmxUQDUS1krFphNwUKlArZHcnOSrlMgA+gPCgjW3sYKO4PH0
         czoqI9I++l2cLH9K+Ey8uIfF+LldntFQQQfIe5DEmR08D4MZsQv2Nm+YE8W00984lLui
         kN6KuHX0+L6MArCv7KvMa5lR33X0K8e1+kp8J1OSo57QPPyUbfKwfg0g7Uj0HhVbL4gI
         YASg34tV49C6laY56+sF3Mn0e9bqFYu9PRN6TSgSZmPFvNGvGEPdHAONBqzQ37mNLeOH
         a0rQDiDOTc7tBXOi8r0MsYmX+wfvrhHmZ4pREkiRGUrD2Os16oKUnLFyNxumzrVtpCpu
         Q4QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3r2q7lbwhYacRNyV9QGzwXdGy2ioZNd6LAcHxLVxfTo=;
        b=E4KcH/KFqiI6npqG9Bva7Pl/++LzWjxISZBHMMqwR5sCpnbNiI31mImDr8JIZx2SEM
         rR2IFxzkU3fm5b8G/fOb+6Y/ux3cSpSRq4auc5CZBkCyviGX1iKrqwzfZxtQqjcy7JvJ
         UZ+j68t4+wAIqj7AS+uZCtCWZot55WgPzz7vFU2GLx40y9jvXf5ag7ndQoAR0HyuQbjv
         yX4VXcLDH0mqwpv571sedMtb7y5OBBfkjESdP6HO9WU5UEhJ7okLENK6tULz3jewWfRG
         36T9qEqOWaKKHMK+J9BRf7sn1yI2AmOEv6u2PA3uXav1fDe/OyZiLqEzSrXEf8Qda/gL
         5UfA==
X-Gm-Message-State: AOAM530v0carVz9aZvx2Zho6xbg8ocLRs4+YUDSC2X+ELSOD1ght+xf9
        KfWe6AmsXzOzrr7OAx1IuOTMRYuyBP6YIdpuqcvJlw==
X-Google-Smtp-Source: ABdhPJwiCAHcvsa9foC0mSIq82cdg1PIgxRM/MwMbvWz4exhaHajPnSGKaxPeG0CRmVX/tlpuLxnJNa9O3k8SbiyJCE=
X-Received: by 2002:a2e:8912:: with SMTP id d18mr4437132lji.123.1589016135071;
 Sat, 09 May 2020 02:22:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200508123030.497793118@linuxfoundation.org>
In-Reply-To: <20200508123030.497793118@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 9 May 2020 14:52:03 +0530
Message-ID: <CA+G9fYsWg1y28V36jwo0k=FuAzMQcDUAVW9r7LCyeziU+n8PpQ@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/18] 4.9.223-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 8 May 2020 at 18:20, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.223 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 10 May 2020 12:29:44 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.223-rc1.gz
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

Summary
------------------------------------------------------------------------

kernel: 4.9.223-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: 7d23d52af97eef655fac0057e12d85ce7d4894c3
git describe: v4.9.222-19-g7d23d52af97e
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.9-oe/bui=
ld/v4.9.222-19-g7d23d52af97e

No regressions (compared to build v4.9.222)

No fixes (compared to build v4.9.222)

Ran 30701 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* install-android-platform-tools-r2800
* kselftest
* kselftest/drivers
* kselftest/filesystems
* kvm-unit-tests
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
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
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* perf
* v4l2-compliance
* network-basic-tests
* ltp-open-posix-tests
* kselftest/net
* kselftest/networking
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/filesystems

--=20
Linaro LKFT
https://lkft.linaro.org

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1520A2F2896
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 07:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730266AbhALGzh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 01:55:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727676AbhALGzh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jan 2021 01:55:37 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF47AC061786
        for <stable@vger.kernel.org>; Mon, 11 Jan 2021 22:54:56 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id f4so872231ejx.7
        for <stable@vger.kernel.org>; Mon, 11 Jan 2021 22:54:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HFUW6YIdb+QGr5644vCV9zETWEFQM+cW7iz1T1KNU7c=;
        b=hxILZSPSntWbwHo+PktBcenkNIxubreqmoBxSKjRwe9O8wANsvx+lCQWGwWgtoeoht
         xa54TX+qbBgl1IKaYS3TAAMglTn6JpU+J1RO1L7TTNo1QZGcoQoDGvcYaEmaOFULqllY
         d4ZA/370BYju4HdON3FJ9V8WMDBymFwBN4tXinycK6zIZ2Tdo61uuPj84OcCiBJEpLJl
         5RvPa3ivoZZQnBvJ9enQW7MOPy8pDdxV3UPhl2t5dDatGf1/VDC4HY3Z+joZ9lP0u2xt
         R3xKo092AUWgn6DNwaq5ehoo8UuUol7/lz8QjejIbQI3TK5BZtTEnoy6UJSlx+KVLKP0
         BeEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HFUW6YIdb+QGr5644vCV9zETWEFQM+cW7iz1T1KNU7c=;
        b=L1aTTlECPXdE9pfB12IuHS308Pk7POEaA17pmqZ7Y+HCQ+sAPjDDWy/j0ut/ag4/Dp
         Oq6lvTPB04W+w2O6Rc8hrk5yaZSdLqK1KqnPLhO0McY221W/rcCmT79P3ljduTB4+hWT
         S7U74RGPo6t/KajKFQvb+hzDlIa+epVULINfaHEGfJLV9WJ/1TZPXrzMPzs0R3mKl6E7
         jmePVLu7t0S5Q9QCaAT7cF8qkEHmoBykY/1dkaJgXVqlRJwQ3Da8ORuO6c69zAb2t7Ec
         jm+XG+hfYs7BIWaEXHU+Yl6PltvYYcp+B/oUCewlc1hoWz9D/Q0Ylj+52NlXyP+ISdep
         lqtQ==
X-Gm-Message-State: AOAM5338mQtgeA6AO8UhayfUy/xrP8Yv0mSbKjYsGxGUIT5jPRMV2F0/
        9fTAePqTeDCYO1Y83pXqZidfjL8WBHWmBQfNbMFsrA==
X-Google-Smtp-Source: ABdhPJz25Gzh9Qlfm0PSj+6KL9TtcXDWIb97CM1mRsi75E+q0SaCFm0Iny79STQnszUTE6u7hmp37MmhNczniGyhUaM=
X-Received: by 2002:a17:906:4c85:: with SMTP id q5mr2133114eju.375.1610434495370;
 Mon, 11 Jan 2021 22:54:55 -0800 (PST)
MIME-Version: 1.0
References: <20210111130039.165470698@linuxfoundation.org>
In-Reply-To: <20210111130039.165470698@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 12 Jan 2021 12:24:43 +0530
Message-ID: <CA+G9fYsNByrDQvgXpaaaUHJa95xvwT75MZQtj_3QqGdWxPc1Xg@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/92] 5.4.89-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 11 Jan 2021 at 18:41, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.89 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 13 Jan 2021 13:00:19 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.89-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
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

kernel: 5.4.89-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: cdbc5a73c7f4b2b8796ceea91083a4ad1ebfd113
git describe: v5.4.88-93-gcdbc5a73c7f4
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.=
y/build/v5.4.88-93-gcdbc5a73c7f4

No regressions (compared to build v5.4.88)

No fixes (compared to build v5.4.88)

Ran 49720 total tests in the following environments and test suites.

Environments
--------------
- arc
- arm
- arm64
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- juno-r2-compat
- juno-r2-kasan
- mips
- nxp-ls2088
- parisc
- powerpc
- qemu-arm-clang
- qemu-arm64-clang
- qemu-arm64-kasan
- qemu-x86_64-clang
- qemu-x86_64-kasan
- qemu-x86_64-kcsan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- riscv
- s390
- sh
- sparc
- x15
- x86
- x86-kasan

Test Suites
-----------
* build
* linux-log-parser
* install-android-platform-tools-r2600
* kselftest
* kvm-unit-tests
* ltp-controllers-tests
* ltp-cve-tests
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-ipc-tests
* ltp-mm-tests
* ltp-tracing-tests
* perf
* fwts
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-io-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* network-basic-tests
* v4l2-compliance
* ltp-commands-tests
* ltp-math-tests
* ltp-open-posix-tests
* ltp-syscalls-tests
* rcutorture
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org

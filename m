Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 399FA30510C
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 05:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239296AbhA0Ejr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 23:39:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238247AbhA0EJr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 23:09:47 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9943CC0613D6
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 20:09:06 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id kg20so756081ejc.4
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 20:09:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=U3acTrLM8xhKwHMhHEO6cd99IHssqXQmEaqLeVUAk4E=;
        b=v2fG/+XTw9fClXast2hda5/X5t4jjjuzS9D7u1nqgdslrqa2VMdN9xLjATgqu2M8dX
         Sz27PCYsZ3Q0v2NawwSkf7W9NlF+s8tzlkiH9YppKRr94WbTcALcJqzmP44FHqvgjV5m
         6baDllxgvalyh6W5onoCBy68+cgaXfPC45A1kkjxMpOPZXH4ZoCvv+whTAxIOIovdd+U
         n9AStSTQn6uamRXQZZdHfCZiyFsxnUjI6cAw9b+QteTJQXHIJM1faTSTKQVWmGsd826+
         dH10OBsQxvCXShX3b94a6IqCfsxZ/QK/POYlmfNp1/KyDLvD6/eD6qVju1SB993NclZZ
         ohZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=U3acTrLM8xhKwHMhHEO6cd99IHssqXQmEaqLeVUAk4E=;
        b=JVntsoC/IHcqqtoWIicIgbNHeI9FXpSdP09Jfec7wd0Zy/1UgnEuHCyqBb9V8rn2P4
         mG8xt6x9JjaJ5vMYKyFerXzUv4llt7dpb5p2RhhdEMAjses9MAnKDZ9fjcZkhKTr2SOb
         oLsTTjjfE9Mi3P27yseYUnpRu1T8W420LBGb3eCLE8lbZa0ajSEJVdLUPf9p1NSob7Z+
         R8yiOFy1ANNyQWpoe9wilQR5bjTodGJ0sqQLPXkdwuTdMcKbsPr8hroM/Z6PcYTCMjws
         s8vPkbO61pFFGEtPh72V5DydjU3n82x8Gh+zEeL0rOusc64zcb3OyPKuTzx7mCDn979j
         EiLw==
X-Gm-Message-State: AOAM5333+8rYPr6SElJkUcBbZWBBRqOtZlPy8O9Ky2IN4FP980FVfPhJ
        opWQGgIhk6rlagzV2ncnq0sA+vQU7e0KcZzIKxBPcw==
X-Google-Smtp-Source: ABdhPJy7ORBzCB+ACol4OVGUc5UJSHzzY3lSUFEKjCmXjxxeLPsRvsnIdklZSijhufmXWtvOpE6vILE1MdhNAcrQM7k=
X-Received: by 2002:a17:906:dc95:: with SMTP id cs21mr5712877ejc.287.1611720545180;
 Tue, 26 Jan 2021 20:09:05 -0800 (PST)
MIME-Version: 1.0
References: <20210126111748.320806573@linuxfoundation.org>
In-Reply-To: <20210126111748.320806573@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 27 Jan 2021 09:38:53 +0530
Message-ID: <CA+G9fYvgJxG8YWyE7JVWkPOPqBFvOve6xEWF5i++pjXf=KbrfQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/87] 5.4.93-rc3 review
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

On Tue, 26 Jan 2021 at 16:52, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.93 release.
> There are 87 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 28 Jan 2021 11:17:31 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.93-rc3.gz
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

kernel: 5.4.93-rc3
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: a2ea77508efe6948f831b5f5bb3a86e014cc4163
git describe: v5.4.92-88-ga2ea77508efe
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.=
y/build/v5.4.92-88-ga2ea77508efe

No regressions (compared to build v5.4.92)


No fixes (compared to build v5.4.92)


Ran 52601 total tests in the following environments and test suites.

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
- x86_64

Test Suites
-----------
* build
* linux-log-parser
* install-android-platform-tools-r2600
* kselftest
* libhugetlbfs
* ltp-commands-tests
* ltp-controllers-tests
* ltp-hugetlb-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* perf
* v4l2-compliance
* fwts
* ltp-cap_bounds-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* network-basic-tests
* ltp-dio-tests
* ltp-io-tests
* ltp-open-posix-tests
* kvm-unit-tests
* rcutorture
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org

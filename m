Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66DC92678A8
	for <lists+stable@lfdr.de>; Sat, 12 Sep 2020 09:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725849AbgILHwa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Sep 2020 03:52:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725814AbgILHw1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Sep 2020 03:52:27 -0400
Received: from mail-ua1-x944.google.com (mail-ua1-x944.google.com [IPv6:2607:f8b0:4864:20::944])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06EE9C061757
        for <stable@vger.kernel.org>; Sat, 12 Sep 2020 00:52:26 -0700 (PDT)
Received: by mail-ua1-x944.google.com with SMTP id w23so3712598uam.9
        for <stable@vger.kernel.org>; Sat, 12 Sep 2020 00:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zxztea30xe4XNiG9NCyw+l4HYaGwfmnd3JgO7+jw3Pk=;
        b=Aw9NptenT0zjf5k5U6QuKbXcf6qR7dmdOVPtc/tdL2RSegOXL+6UNOpJ3bSYWYQOvM
         F2xfEIknqpBe184JiLZZGnzIZSTulz+wGpMJvQ8D0COIbVZzLqGdttM0Q4ixB/SEKiUa
         GMRvlXA1JCxP1kOYABer0zaWcN52n4/SaMZNXu8FLr06n3bSnw5YWquiujlmOdFud3Gt
         AjeYgkv1gfI7sTixu0GD234xDYME/B3Sna+aPxOGU+9dHyUK+VowsD3HzSxMaOiRzlJl
         xScmkqCI0j+bv73ntteLVFBeoI7aKX67XSFbR0VRWw4mjNbOSb5PHkxoh5I1B8mpqo5k
         FJrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zxztea30xe4XNiG9NCyw+l4HYaGwfmnd3JgO7+jw3Pk=;
        b=Wi8TWNbvZr5jQMeTr9GmhZJRXu2pj6rUsXZgtH3RHSvVWgESdPBiYmxiM145TpT+PG
         lUrwOa8efYWAJUmJ6P7SKulPIeTxBLBKoTY5l2TTsOcQ4TVkXdkj2eq42GiGXqzkeU8d
         T61Em0ymmGdkHmv6/casONY/ENu2yxUtfGQLVgtYVXLDEqa11JsC5rumyPYWGyMSjIxI
         WfDbEC1iXq+/LP8MdBucsM7hH0+FS3tPFeGHMVxyTd8WdpAIg5alOPQAX6bVvyZMZsT1
         FrBLjiJq6K2jAYA/hf0MVxOckA/a6mi6Ej2ApdlP7krYwP6RcrevSm38xlrFzN1594eU
         jvAQ==
X-Gm-Message-State: AOAM533PsrsyVNoGLlHEbh3SGbGjOu+WHTUg3JSUoV+MJIkXtRLXnxVC
        bpQcxUUr/yXYDolJ8aVCAnKcSCuggmrHQjX9uV+i0Q==
X-Google-Smtp-Source: ABdhPJy5xPR/H+g3JodOXvFZIMEb2UDD22jZoVWLZMzJ7tVV/uiGJk8yv30i8Ia39y+zm81DeWldxckFhERjCS84Wt0=
X-Received: by 2002:a9f:3491:: with SMTP id r17mr2880940uab.113.1599897145898;
 Sat, 12 Sep 2020 00:52:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200911122458.413137406@linuxfoundation.org>
In-Reply-To: <20200911122458.413137406@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 12 Sep 2020 13:22:14 +0530
Message-ID: <CA+G9fYswUq1JbqQSjEvr2uXi1s8QJisJeyRFV+fZP+YqTuzP5w@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/12] 4.14.198-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 11 Sep 2020 at 18:29, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.198 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 13 Sep 2020 12:24:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.198-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 4.14.198-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: 69fa365ca674b7df0b29cce9ffdfc43c0fa311dc
git describe: v4.14.197-13-g69fa365ca674
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14=
.y/build/v4.14.197-13-g69fa365ca674

No regressions (compared to build v4.14.197)

No fixes (compared to build v4.14.197)


Ran 19581 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15 - arm
- x86_64

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kselftest
* kselftest/drivers
* kselftest/filesystems
* kselftest/net
* linux-log-parser
* perf
* network-basic-tests
* libhugetlbfs
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
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* v4l2-compliance
* ltp-open-posix-tests
* ssuite
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-native/net
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems
* kselftest-vsyscall-mode-none/net

--=20
Linaro LKFT
https://lkft.linaro.org

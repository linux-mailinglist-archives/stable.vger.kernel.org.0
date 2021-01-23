Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E62DE3013AF
	for <lists+stable@lfdr.de>; Sat, 23 Jan 2021 08:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726665AbhAWHVS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jan 2021 02:21:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726653AbhAWHVR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jan 2021 02:21:17 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C771C06174A
        for <stable@vger.kernel.org>; Fri, 22 Jan 2021 23:20:37 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id g3so10864686ejb.6
        for <stable@vger.kernel.org>; Fri, 22 Jan 2021 23:20:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KBT4hSRvsCHJY8mmdL+j2n7s1QEKLTs3BtDbKDLdqIc=;
        b=QF4A+pJFGOL2lDMM6IuqUT+UcPYIwLGI2VlPGTJt/GN7pIHAxMwvoPpmE0uq1Q68w9
         XcCP41/nH6WNt9wBA1sWVzyb+0Qav1bf0J3zW8Rjc06UNz+Vmmb5atAzcMZwQQb63kSV
         FLw4jtwCQ6uRxpu2z1CvsDpk2N1sNfgoVhAk4P4YmVFTHfB2UCIvVF/o8dPl7Z/adGXl
         L0kau/ZDY1Up3l3dJNSvcCK9FBFzDJxaoVoA6zuMve3OM/mmtd5cvZ5gmTk8ifPGxk85
         dvfHqWaE4QNSc2lzzaMwP/tWsCPic4cIfoxKsnSBkvWHsd3wdXYI1JU9M4mISgoIrlT4
         Inpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KBT4hSRvsCHJY8mmdL+j2n7s1QEKLTs3BtDbKDLdqIc=;
        b=FzrwOJsad/zQO7uKyhUp9Icm3b6ASL6+Bu2vjy0VcQ20Tp5tCD9Bb9MOApQGNtWEiB
         /QRzVx/JCoeuJQLgeZNxreDQOPo5u8Iri+EYqFBwZGM6k902QObOBd0pP8FB3KFHGu1X
         dixU2NfLmDAo6Ib1ixt3q6vg0Ht2RYRnS2MvGugpb6d0ugZHXD5m+HWLLYLSDzFObXWo
         D1ygNmQI8HkqA5efed4KricB5dL79TLFljpH8nsk4XFl1hGX0879O7OhQQu17+5G8eCJ
         miPTJLZNWdbLUdc3xPPvOfhtclym2701FXDilEtOjJUS9+MxTAhoD5KgyfzRP1tKYcfx
         WhJQ==
X-Gm-Message-State: AOAM530yJtkSQVYXK0398G0hEeVu0ohpuToOWvWIkIgsbxFqPcJpbmyT
        +oWoOzV77cgUGbSBMEtw0jRXl1NAg5OLt6kxBY1DLA==
X-Google-Smtp-Source: ABdhPJy7mTgzQym7e0g/rncsYR/6l58MyHL170z1qPA5TvXC2az/7FPqxMp9btySD06BqLfRw71X3C+hg/zS4WUUK9o=
X-Received: by 2002:a17:906:4c85:: with SMTP id q5mr400252eju.375.1611386435860;
 Fri, 22 Jan 2021 23:20:35 -0800 (PST)
MIME-Version: 1.0
References: <20210122135735.652681690@linuxfoundation.org> <CA+G9fYun4MY72zD1SUPRktJdbXsotqi0G-a=cvdAk-8kOo_dwQ@mail.gmail.com>
In-Reply-To: <CA+G9fYun4MY72zD1SUPRktJdbXsotqi0G-a=cvdAk-8kOo_dwQ@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 23 Jan 2021 12:50:24 +0530
Message-ID: <CA+G9fYu-oJMYJxStRiG88xUyb2qNgH64q370b0CTcBW4j3ZtnA@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/43] 5.10.10-rc1 review
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

On Sat, 23 Jan 2021 at 11:14, Naresh Kamboju <naresh.kamboju@linaro.org> wr=
ote:
>
> On Fri, 22 Jan 2021 at 19:49, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.10.10 release.
> > There are 43 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun, 24 Jan 2021 13:57:23 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patc=
h-5.10.10-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git linux-5.10.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
> Results from Linaro=E2=80=99s test farm.
> No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

>
> Summary
> ------------------------------------------------------------------------
>
> kernel: 5.10.10-rc1
> git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
> git branch: linux-5.10.y
> git commit: 402284178c914c87fd7b41bc9bd93f2772c43904
> git describe: v5.10.9-44-g402284178c91
> Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.=
10.y/build/v5.10.9-44-g402284178c91
>
>
> No regressions (compared to build v5.10.9)
>
>
> No fixes (compared to build v5.10.9)
>
> Ran 55124 total tests in the following environments and test suites.
>
> Environments
> --------------
> - dragonboard-410c
> - hi6220-hikey
> - i386
> - juno-r2
> - juno-r2-compat
> - juno-r2-kasan
> - nxp-ls2088
> - qemu-arm-clang
> - qemu-arm64-clang
> - qemu-arm64-kasan
> - qemu-i386-clang
> - qemu-x86_64-clang
> - qemu-x86_64-kasan
> - qemu-x86_64-kcsan
> - qemu_arm
> - qemu_arm64
> - qemu_arm64-compat
> - qemu_i386
> - qemu_x86_64
> - qemu_x86_64-compat
> - x15
> - x86
> - x86-kasan
>
> Test Suites
> -----------
> * build
> * igt-gpu-tools
> * install-android-platform-tools-r2600
> * libhugetlbfs
> * linux-log-parser
> * ltp-commands-tests
> * ltp-containers-tests
> * ltp-cve-tests
> * ltp-dio-tests
> * ltp-fcntl-locktests-tests
> * ltp-filecaps-tests
> * ltp-fs-tests
> * ltp-fs_bind-tests
> * ltp-fs_perms_simple-tests
> * ltp-fsx-tests
> * ltp-hugetlb-tests
> * ltp-io-tests
> * ltp-ipc-tests
> * ltp-math-tests
> * ltp-mm-tests
> * ltp-sched-tests
> * ltp-tracing-tests
> * fwts
> * kselftest
> * ltp-cap_bounds-tests
> * ltp-cpuhotplug-tests
> * ltp-crypto-tests
> * ltp-nptl-tests
> * ltp-pty-tests
> * ltp-securebits-tests
> * ltp-syscalls-tests
> * network-basic-tests
> * perf
> * ltp-controllers-tests
> * ltp-open-posix-tests
> * v4l2-compliance
> * kvm-unit-tests
> * kunit
> * rcutorture
> * kselftest-vsyscall-mode-native
> * kselftest-vsyscall-mode-none
>
> --
> Linaro LKFT
> https://lkft.linaro.org

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7675B2AD3BB
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 11:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730740AbgKJK1v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 05:27:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727651AbgKJK1u (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Nov 2020 05:27:50 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 606D1C0613D1
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 02:27:50 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id a15so12125291edy.1
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 02:27:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JBsUXq+aOpg3CDCyNVK2yMK4/COQDEd01UsYZ8vI250=;
        b=t7Y6a7CDXPYB6n7yM3M+TFh6SIhtVKkcmzH6Kss/QQrVQav6yac7ibHOB8SnlbrRTH
         2VfPY41mKd9b58QxWeDkZXlMo8K+67610LZZEK4/TcSAqMze4xjD8SP9IElhc3W/Cp3q
         nNMTjWZb+80H88YrYqTGfkyu5W+fSsOMQ1F4Jvq7Xadkmb5XSdjHIFvJouY3DET8ptBA
         LaffICEgfjL7PDkcRJBPBNiBvwBOeZvQ+TCBdzWWxOBmPoBlfQOd8OhFOIghtxH5ov9H
         Jzts62LRfA8OkBsFBzIDv0Z6rM8sFoI7IZrEgNkHPUo1G7dGyMXJYEebzHyse4QOyNP2
         tSbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JBsUXq+aOpg3CDCyNVK2yMK4/COQDEd01UsYZ8vI250=;
        b=N+C03rlE7Mheg4fiLZGuNkQWZ0AIFYuhRSqpJBtKJjzC8cbFKy6bUWmK5SNp2anLQN
         49IFLD1lx4IM5LpemSnLxHZ5OkTGoLpjZiBXeLhTY9I615gGr+Oa46msE7Vyzy7pyCUp
         1QDUskGi+ov3RMrMBxrP8/vVj6CjmzFZ27HjYGUeGAwZpGevVzHUzrBIuEIV9Pybs4Ro
         eEMLGDJVItuXKwYQgmayMP3lGItE0KuerTMTzXVRRmL6gPNhX6u6RE32Rqon5WlmKGuf
         2SDdCq41zeIliI+cye8agddpotj7cJ9Y9eGdqpfzeWzhvyzcBWwp5MtDRKODV2NYZ2mf
         e10w==
X-Gm-Message-State: AOAM532OchxVH6INWHQhFNk6EKoO0zkchYInOQ3pn9EpWXn05Do/3+K2
        q8aVjY9VewabTGRPlXQnK0u/X9CreqVHL6f7E4pJ3g==
X-Google-Smtp-Source: ABdhPJxuqK0WV8ZzW2llCSqO8MgbvNVxmgLcMcdoE1pXemGfzVwLeIKk/u64ev1OCbNE4gDvRoNLp37lPsw9YQk9Cuo=
X-Received: by 2002:aa7:d54f:: with SMTP id u15mr20235652edr.239.1605004068939;
 Tue, 10 Nov 2020 02:27:48 -0800 (PST)
MIME-Version: 1.0
References: <20201109125025.630721781@linuxfoundation.org>
In-Reply-To: <20201109125025.630721781@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 10 Nov 2020 15:57:37 +0530
Message-ID: <CA+G9fYuha4Kv-FB7K6Ge16Ub0y5LnRzuOP326M9VoMK1zKg=Mg@mail.gmail.com>
Subject: Re: [PATCH 4.9 000/117] 4.9.242-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 9 Nov 2020 at 18:30, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.242 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 11 Nov 2020 12:50:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.242-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.9.y
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

kernel: 4.9.242-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: 8c35ccda0e15d9e502046f5a33f6a1e0fdea56d5
git describe: v4.9.241-118-g8c35ccda0e15
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.=
y/build/v4.9.241-118-g8c35ccda0e15

No regressions (compared to build v4.9.241)

No fixes (compared to build v4.9.241)

Ran 29032 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- qemu-arm64-kasan
- qemu-x86_64-kasan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
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
* perf
* ltp-cve-tests
* network-basic-tests
* v4l2-compliance
* ltp-open-posix-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* kvm-unit-tests

--=20
Linaro LKFT
https://lkft.linaro.org

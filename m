Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92B0A29CA29
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 21:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S372883AbgJ0U36 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 16:29:58 -0400
Received: from mail-il1-f196.google.com ([209.85.166.196]:36203 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S372881AbgJ0U35 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Oct 2020 16:29:57 -0400
Received: by mail-il1-f196.google.com with SMTP id p10so2736037ile.3
        for <stable@vger.kernel.org>; Tue, 27 Oct 2020 13:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qCGzWkcEyGnMVc1qKpErd8kCJvl0khNlNWtvTfBJ+DM=;
        b=rUaQakr8Dxd5tOeL99b4gwolnH/7dz5+XX5dWo1Rb1s2grIUJqDzx3GWykAMdOqkLO
         c/YHfBLEU0MGJ6gbWPrhf15MOK+qB9JwhMU8QEZ+YEWLt70Ae4C/Y5eN86gnZlvZZfnM
         RpGeO57EOTMKg8j+cEyo8LYLqhykkIA3Z7oiXRSZYYFWotyaDxl1x22IL90ob/QP4Oqk
         YzXCZUt0eyCTvi7zBElrH0YTw+NRFT0/8EkbywhS70ComCjav2W51EmfJUqSzHMc3var
         V7ezfT/3n1PIvoH9r7X1/BSIRx+GmWyq422unUg1TehTX7LV+TbO1c+zUnMs3gOxLCjH
         /dqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qCGzWkcEyGnMVc1qKpErd8kCJvl0khNlNWtvTfBJ+DM=;
        b=tYUGEpgmAeTZM3nd/0ENnRzwO0mhriNXtR9xYKQN7DsgTF7u5P8VAdd1fztZTPzcDH
         Wfz23TJa2hIIDat9aV7qeycv8ZTiPH+odtv657bxvJ+1r0KzrXzB7c5pRF2toPrCIE+5
         7L7wZ03bnZxfHoppt6RcvMDvH9sIxoQGO1E4OVZ6T7ImHe15qgb2j4QpMeizQxNQ3YYp
         LNMm0qHR3OtqSdYQo9NEDHZDU6I/ow7E8xsoxw37aUIMaWTnX/H3jC7M1Etn5n8PSOYj
         Wl1BxxaqHgLf7RWLq83yQFjKaYP3N+S3DGrIq2sVKoRujP+08ZajRY7OjPfZuYUIyM3Q
         HGvg==
X-Gm-Message-State: AOAM532U/6KpVvJmvb27zHTn9HbakvmBAqpTOw0yqVfl0uxfFyYG4Qzc
        8NMeDqxnoAYfWQuBFNvp4RxRRTpNJUDl/d2AtvQ7jQ==
X-Google-Smtp-Source: ABdhPJyFKfw0jPyV5fKyuqup8ssnqCqTLIfhBSVEEM/Zema6ZVNNnN6Wtg9264VuMXjxAQxQARuEa1J5tJYmyksvLnQ=
X-Received: by 2002:a92:d20e:: with SMTP id y14mr2643442ily.252.1603830595261;
 Tue, 27 Oct 2020 13:29:55 -0700 (PDT)
MIME-Version: 1.0
References: <20201027135450.497324313@linuxfoundation.org>
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 28 Oct 2020 01:59:43 +0530
Message-ID: <CA+G9fYuJjfM-fsJjhrvyTp6DaNVY13vPHuc_WCTv51+C2cc54A@mail.gmail.com>
Subject: Re: [PATCH 5.9 000/757] 5.9.2-rc1 review
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

On Tue, 27 Oct 2020 at 20:57, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.9.2 release.
> There are 757 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 29 Oct 2020 13:52:54 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.9.2-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.9.y
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

kernel: 5.9.2-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.9.y
git commit: e0fc0952949384402dd11b124f531c3740ea224c
git describe: v5.9.1-758-ge0fc09529493
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.9.=
y/build/v5.9.1-758-ge0fc09529493

No regressions (compared to build v5.9.1)

No fixes (compared to build v5.9.1)

Ran 28214 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- juno-r2-compat
- juno-r2-kasan
- nxp-ls2088
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15
- x86
- x86-kasan

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
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
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* perf
* ltp-containers-tests
* ltp-controllers-tests
* network-basic-tests
* v4l2-compliance
* kselftest
* ltp-mm-tests
* kunit
* ltp-open-posix-tests

--=20
Linaro LKFT
https://lkft.linaro.org

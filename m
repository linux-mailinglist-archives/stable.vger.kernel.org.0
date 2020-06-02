Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3051EC13D
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 19:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728128AbgFBRkH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 13:40:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727070AbgFBRkG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jun 2020 13:40:06 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAAEBC08C5C0
        for <stable@vger.kernel.org>; Tue,  2 Jun 2020 10:40:05 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id e125so6709336lfd.1
        for <stable@vger.kernel.org>; Tue, 02 Jun 2020 10:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dLJrgH5zMtfibk7etWOY3mqShPtnbXCa7eJ2xauqAo4=;
        b=uGcctUsxo7RRq6hbD/gMToHKnzm2mnWci/27rpnEfpCLXB2c6as+ZnwvA6ezEkHlZH
         niJimd8I+cFdKQtjDMmsE0GvVKu92FGpBmmWaWQYpCjqhG1WYTyvqyuFgdo0a8Yw+9ak
         DdO2uPw1V3BwXLqFv2ODlW8YO0d1x9OcJOGMzGE9Ru6merd0hyhhG+zk5U3yK4HmQFI2
         2zmAGhqecz3XIEd+Tla1WuEmiieDYBvbkzePRQkHschE2Sg8flcT18H8y4en3ZGX/Z9R
         sEDVyKdliUC8QswPnT1nJHr1+8aaSyKjZk8vBC6TSZneKIOnL1drhSJ1HCp0D1L1hjI4
         0K5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dLJrgH5zMtfibk7etWOY3mqShPtnbXCa7eJ2xauqAo4=;
        b=eRbbVQoA2DuGOTpL+Ar7CDZuochYfT9QRWkxek8qXYa5yXqxVPtORsNjcSSWKgPuYZ
         LP6Lv1B+ZRstEx2+PUOKSKv3UqzUFH4hY9g81KhTwXgcPc65YSWbw4BPKCt9ad4O3UxQ
         qPS0p2O2ul8B/WPn0zmRUGvBF7uzUrY3i4umlaM1Hk3GflH7L9XHnLu41g7AkLMjgTDu
         EopYj33ETaxCRRpfZFQwD0I+Jt6p+mq5zHH5A1+QZyzo6n3leYUFkLa7eTMS2SzVg9jK
         +I+NJb6odeT/w3jVI2Nsa+xGXcZpIHeapye4O1z2CUYRIR09dUkqE4pycVJHQKroPckG
         NR6Q==
X-Gm-Message-State: AOAM533v5butsUdrqnM0yfg6fXfuZceL9OZCNg6RWrJOY+6f3ZOFlj8x
        uGGXJYjo4LzNQzhUXqVufUbNqSBuXoQASgMpDQlsTQ==
X-Google-Smtp-Source: ABdhPJyUua6FvTRJvp9p5S5Md/iOKZBYNsP4v8dYt1Fu6QDoTbqP2bHsYuM1ct2JGqz8P9W5zikoRgMEnh0ww2bbJOo=
X-Received: by 2002:a05:6512:31c5:: with SMTP id j5mr274903lfe.26.1591119604021;
 Tue, 02 Jun 2020 10:40:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200602101919.871080962@linuxfoundation.org>
In-Reply-To: <20200602101919.871080962@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 2 Jun 2020 23:09:51 +0530
Message-ID: <CA+G9fYtGJZ2Q0jRxW8Z65G4we-tABaVTwyqa3wf+fr0Jdt_vfg@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/139] 5.4.44-rc2 review
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

On Tue, 2 Jun 2020 at 15:54, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.44 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 04 Jun 2020 10:16:52 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.44-rc2.gz
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

Summary
------------------------------------------------------------------------

kernel: 5.4.44-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: f5694d7c427e7134b05b816e56fc41c191c4782b
git describe: v5.4.43-140-gf5694d7c427e
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/bui=
ld/v5.4.43-140-gf5694d7c427e

No regressions (compared to build v5.4.43)

No fixes (compared to build v5.4.43)

Ran 25227 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- juno-r2-kasan
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
* install-android-platform-tools-r2800
* kselftest
* kselftest/drivers
* kselftest/filesystems
* kselftest/net
* kselftest/networking
* libgpiod
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* perf
* v4l2-compliance
* kvm-unit-tests
* ltp-commands-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-sched-tests
* network-basic-tests
* ltp-open-posix-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-native/net
* kselftest-vsyscall-mode-native/networking
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems
* kselftest-vsyscall-mode-none/net
* kselftest-vsyscall-mode-none/networking

--=20
Linaro LKFT
https://lkft.linaro.org

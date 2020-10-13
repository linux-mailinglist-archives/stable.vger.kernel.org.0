Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 710DD28C858
	for <lists+stable@lfdr.de>; Tue, 13 Oct 2020 07:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732506AbgJMFoy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Oct 2020 01:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728800AbgJMFou (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Oct 2020 01:44:50 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06D2EC0613D0
        for <stable@vger.kernel.org>; Mon, 12 Oct 2020 22:44:48 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id d16so2081668iln.10
        for <stable@vger.kernel.org>; Mon, 12 Oct 2020 22:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mv6cqs+iS3nWt7sl83B1vWYXMblxkRnrK5O4id5akdI=;
        b=xgrAJzGgLEqYR8gdhpOk5NvxeBQvAyGijClknsZ5Zd1oaYGRXs6e3A9D7l1wTPmeCp
         FpsKxbWJeY+/HtGZA/XGNLysnCrHGf7rtgJzlJudgjeX3cgIjo3YPqvnFnbST8Z+EU3J
         RoDhvKfYkMq//+ORyiyLxi82b4uVnTEW5gqZ2AFq3/kZ1CCHVv3ce9G8pU+YfowmnYKu
         kCYSUjD22oDZSyCZVFLmVYrhXlLuOdepjxmb2HUS203iE+7vlyirvMoqgMExPMU3eZtj
         EzJlKxYWnk6+0gMlqxXxXCCau9z9YkY0M9bIw6Dpos9HE5X8IVs1EC+mRPYjSZv3Yh1P
         8+sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mv6cqs+iS3nWt7sl83B1vWYXMblxkRnrK5O4id5akdI=;
        b=eIw3w9/Gt6oDPOB680j40nXy0/MjatfzluBXw7edyMXM8HjGq+6YBkShn2DBJdB+Do
         zQGkYNi+kFnARUdftVlXRss+cvet6egDmvfQSJK7pv7VfYi8r8p6Bn2rvsOfPSLCQHDM
         n7qvioZ4f8b+l/oPB2Jrk792fPoH3J1KkyslKkdthG2qb7g6PcyqEOJPOD6XjBflN+/+
         cf2t0s+6x3K78vEiBGQsrA0uTNU6Xmrypue1DFNiZgdcVJZ4JV+By/w7qhpIAoSiI8lo
         O7Eld/kpE09bBmxfUIUkFqQEaqdiTIsLexeOAbu3DPU3akXnzBi2LlaxRc5TOql4A5vn
         tgUw==
X-Gm-Message-State: AOAM530bBud4mzZnLIapNjax4aLKVpXoG5TN/ao2RYDak69aygSqZW9C
        zKsGRpocpA7W+tmO5rQS0MN3ayNTx2d5r8SIOi0+yA==
X-Google-Smtp-Source: ABdhPJxtKYmQ3DwCirWa56MaO4tM9M8bDa79i1IZx2gFUgwbWLDsYI8EReFJz4o5QoNJuKBiax8BAMeqbhekGwr5Rqo=
X-Received: by 2002:a92:9944:: with SMTP id p65mr1742349ili.127.1602567888091;
 Mon, 12 Oct 2020 22:44:48 -0700 (PDT)
MIME-Version: 1.0
References: <20201012133146.834528783@linuxfoundation.org>
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 13 Oct 2020 11:14:36 +0530
Message-ID: <CA+G9fYsTcM-iAwno8ur3teBzakVE1EaBJ7F7FmDD7Hhewxb=vQ@mail.gmail.com>
Subject: Re: [PATCH 5.8 000/124] 5.8.15-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 12 Oct 2020 at 19:15, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.8.15 release.
> There are 124 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 14 Oct 2020 13:31:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.8.15-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.8.y
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

kernel: 5.8.15-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.8.y
git commit: f4ed6fb8f1680de812daf362f28342e6bf19fdcc
git describe: v5.8.14-125-gf4ed6fb8f168
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.8.=
y/build/v5.8.14-125-gf4ed6fb8f168

No regressions (compared to build v5.8.14-5-g0b030df1725b)

No fixes (compared to build v5.8.14-5-g0b030df1725b)

Ran 37577 total tests in the following environments and test suites.

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
* kselftest
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
* ltp-pty-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* perf
* v4l2-compliance
* libhugetlbfs
* ltp-sched-tests
* network-basic-tests
* ltp-open-posix-tests
* ltp-tracing-tests
* ltp-quickhit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org

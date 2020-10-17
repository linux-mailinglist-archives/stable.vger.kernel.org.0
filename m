Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46E5729107E
	for <lists+stable@lfdr.de>; Sat, 17 Oct 2020 09:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411792AbgJQHSx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Oct 2020 03:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2411783AbgJQHSx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Oct 2020 03:18:53 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6910FC0613D3
        for <stable@vger.kernel.org>; Sat, 17 Oct 2020 00:18:53 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id i7so3176786ils.7
        for <stable@vger.kernel.org>; Sat, 17 Oct 2020 00:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mOXF3ZRhcAdJq9d5jsCmLnGzHw/gmfcOBR2I4XS02as=;
        b=hSqM+IHlQ5xex2nF1vosEmMq1O/yiqmTJhDgYgiYYE48S5QEbnzjlJk7f0YV9oYY9m
         1tZAux8Sm3s4kKTA18VKFj7d2n1vgmhgBnRfbnZk2w2dyEPjUIHY8fBxdeHPHSfrUCub
         tOPd0hc7SJcaVuj7e27GPj5cHWymidM5/lV5QD87Je+8u2o11oJiEto503Dd/MOFqFJR
         9D+FO9Mcwu2wyaXZDZjY3vUYwGVsWKyfCXu7edIyCSRH3uVDKZBbwOXiJewdxEF7pDkB
         fg/dZ2iNlpAAtARfwLNgow1+RSFSUvt1mpItUi0m+4Ls00QNAhJe/IT3tuNufzAsNp45
         46KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mOXF3ZRhcAdJq9d5jsCmLnGzHw/gmfcOBR2I4XS02as=;
        b=EAlIqzlAVNDzhFe6ja9CGbUgfYb+5H2HDIN8hNL6bxsmD74CMTxXemdaQgLHfJn79L
         9b107HMBrkv5GPTxQlxX/vjhVvsozd10rSV4DXv03uGEoL4YQyRuq0W503chtCPQYjEp
         N4XGtoROPGQtq5Sa7fKkNDaAGxy/z4Ko9DB5wOvCjIdlHHhLz/nR0tt3oP2FdwDxzGzw
         xeRpD1sAW0Piy70FvTmdkjzVmcdTKh5BM82n0yRlx3Bw5fkAFX8ajsx7idwPBZUyDC5R
         +q6AJT3WJwkMOx89+BfyIfOz1wkPQlpVtL1P9j83QLsaiP6RP4R/1xSbsWU4+kprVXYl
         ytww==
X-Gm-Message-State: AOAM530NZ5zRzMvjylqLgOHndGL7E6r89muWm03SGH9QTvzniK2eBgya
        B4G+aK/STYCviibw9qvXO5EbXMsMuUMi2pP7rNOXGw==
X-Google-Smtp-Source: ABdhPJzQbCaw6s+WBgBlVJ+xIoF01DpOKN7p9HexQLMg2LiCkzKhJ6GLpYQkMuDWVVey9j6yBtAtFJJWyFFPm0BC/xQ=
X-Received: by 2002:a05:6e02:664:: with SMTP id l4mr5545220ilt.81.1602919132515;
 Sat, 17 Oct 2020 00:18:52 -0700 (PDT)
MIME-Version: 1.0
References: <20201016090437.308349327@linuxfoundation.org>
In-Reply-To: <20201016090437.308349327@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 17 Oct 2020 12:48:41 +0530
Message-ID: <CA+G9fYtcgyPUJQ9aZa=1GQJv_r5LiPkSHA8jT64pMd0M3K-wrw@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/22] 5.4.72-rc1 review
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

On Fri, 16 Oct 2020 at 14:41, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.72 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 18 Oct 2020 09:04:25 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.72-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
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

kernel: 5.4.72-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: a3f8c7f24ee00462a09758774aee840317650b51
git describe: v5.4.71-23-ga3f8c7f24ee0
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.=
y/build/v5.4.71-23-ga3f8c7f24ee0

No regressions (compared to build v5.4.71)

No fixes (compared to build v5.4.71)


Ran 24730 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- juno-r2-compat
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
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-fs-tests
* ltp-ipc-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* perf
* v4l2-compliance
* ltp-commands-tests
* ltp-containers-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-math-tests
* ltp-mm-tests
* network-basic-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org

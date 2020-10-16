Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB6A4290C08
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 21:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409698AbgJPTDT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 15:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409694AbgJPTDT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 15:03:19 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BE67C061755
        for <stable@vger.kernel.org>; Fri, 16 Oct 2020 12:03:19 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id l16so3775477ilt.13
        for <stable@vger.kernel.org>; Fri, 16 Oct 2020 12:03:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rhXvB127CgmNZaT5aVO87+trEM6r5CPZEs1DuC4WiLQ=;
        b=Uu4aUsm9QyKvHqSOUIqW/AewHn/qqFd9S5qRzL2wZcitgnf/fJA8pH8lWFT2d+uZZc
         YBPvCDiF9HopzvIeEgn0Xrj3gAzT3qkmFDo99NHXJzTlCj7pQFE8yT+aD5ExBeGgKcsq
         bTlwG7fH401mq4atSbyQDJeo54Nf2ScpEbM8C1Rfd0qEuXVydl8/PtfwTofj5LXg5oYo
         5tmmObR6eXCzd7Ql+9nwJ/ee5VxlMyumDgkK+7nvxDlFXY+mgBW/jVKaK4MMsIXP5C0e
         Do5A3h1heKjCv92HV/+erKnEQTYmGuA2q9n3YkclyPvkjb9eNdrz6rf3hAC/HJBFWA6W
         iWzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rhXvB127CgmNZaT5aVO87+trEM6r5CPZEs1DuC4WiLQ=;
        b=V2VM8Q0On3ix2uNTPssdrHv8ywWQy+2VlF38Q9GYXDnd1QRCZGbxj5NAu1PxSLSBtY
         LoANjGA4tTiMms8+sw/Fn5135TnSduylPNyuthBz5NrkfwfIr+t2gx3vYrpvKV8UQ7uF
         S2QAsWSIyIvqhVDNsdhJ1yG9YOYvTCrZQbAmjarSfNII2C99Bhd/No1YEyQDuPDymhrw
         DTylLoigSIL8kxB86yMA7CSFOGVcUfKNGDmKa+Tmgm/NP4X3xT97Jjkwch1J7BVoAaUa
         +VtnT5h2xy+P7JkNabFK/N98tCN/oXvr5xN9ijN0XoATo/p0HsOnmFuCD1tgVOl+RUp8
         b1QA==
X-Gm-Message-State: AOAM532Yc1MSgkOfj2FILgoJDgTqwTGjOUrCvviWKrP+AN0hR4iorqEB
        v35XPaN71dm0OeJZXIxPht4eF/CCoyW6sb3tfIxTLg==
X-Google-Smtp-Source: ABdhPJzCP2po4gVQwsjHb0Omj/pFsKqZ21h7VtQabMhzBzubeZXFRar6oYxlyUQ2DNNZwCLIu8NTGeM1rJU+kvwzezA=
X-Received: by 2002:a05:6e02:664:: with SMTP id l4mr4043591ilt.81.1602874998234;
 Fri, 16 Oct 2020 12:03:18 -0700 (PDT)
MIME-Version: 1.0
References: <20201016090437.170032996@linuxfoundation.org>
In-Reply-To: <20201016090437.170032996@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 17 Oct 2020 00:33:06 +0530
Message-ID: <CA+G9fYuEpbTX3_hjeGhfue49a051i3iuzdKfFQ3YGpy86vCZnQ@mail.gmail.com>
Subject: Re: [PATCH 5.9 00/15] 5.9.1-rc1 review
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

On Fri, 16 Oct 2020 at 14:42, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.9.1 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 18 Oct 2020 09:04:25 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.9.1-rc1.gz
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

kernel: 5.9.1-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.9.y
git commit: 1cbc5f2d0eace639921f0e26fd6817e346961d5d
git describe: v5.9-16-g1cbc5f2d0eac
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.9.=
y/build/v5.9-16-g1cbc5f2d0eac

No regressions (compared to build v5.9)

No fixes (compared to build v5.9)

Ran 29051 total tests in the following environments and test suites.

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
* libhugetlbfs
* linux-log-parser
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
* ltp-hugetlb-tests
* ltp-ipc-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* v4l2-compliance
* install-android-platform-tools-r2600
* ltp-commands-tests
* ltp-controllers-tests
* ltp-dio-tests
* ltp-io-tests
* ltp-math-tests
* network-basic-tests
* perf
* ltp-sched-tests
* ltp-quickhit-tests
* kselftest
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org

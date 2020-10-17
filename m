Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEDB1291089
	for <lists+stable@lfdr.de>; Sat, 17 Oct 2020 09:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437464AbgJQHcG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Oct 2020 03:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2411853AbgJQHcF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Oct 2020 03:32:05 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB02DC0613D3
        for <stable@vger.kernel.org>; Sat, 17 Oct 2020 00:32:05 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id i7so3195366ils.7
        for <stable@vger.kernel.org>; Sat, 17 Oct 2020 00:32:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4Fk3OnLiw5ztAx8v/gYaz77wwN28d2Wfn4uwAsNjxKQ=;
        b=jT8WMOW1ve3dXCzPD6Nuv+tCvINtSg6Gqi8Lbj4uSbalDeBSFbN41DAgVY2knhkxlq
         56eLHMQ3YnAEuya6Hg5OTCeFgZeTcES0Ym7LPDUxLBrBLtA0DYWeW0s7wdiew0+8MMp7
         kycTrbJsXfLBXaYbsbDol3DFW0SZzAjp/QscSEP0V4y1GFOr+6pC8gCUeNkcC5zjK9kk
         NaiLnh3pc66cWKQL8lan3+Q0q10iKJdNI1QoMP2UXacYmL1wa1qWUxT5IHKWGyDZtL3o
         E7QUqXzi0tfIAaeDtNnCEKtoMheFqM3fl5EbgCY7fbjYCC/EjqGl1EQpO18JJemPU9Yr
         BHOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4Fk3OnLiw5ztAx8v/gYaz77wwN28d2Wfn4uwAsNjxKQ=;
        b=sEr0TgcvPNxoBCRYEjR1D9XkyACDoHBPpRv0bYP3dry2rn0Vbc/RwzGNdOqMqhPjm2
         1g9HBY1j2HQaZYYKN8UGE/KaY+ahFdLohnfDFDPQfSH7Elp/lRIW14QkkxIuKZbTbZ2H
         B9n7EeHmUszXKZxs1BSzLsFXD5/sQ2X7qfbehkB1UfH34q4Q1sxntlbL6EN+9YG4N/vV
         eOrTa3d94XfPtaFVawANbnIP4cAGX/93Y0WB0HEUrBM/WpEODqJCLCRfE/4luRNSHGra
         zjmwFCs5WFwl8O6rmt/k+/U3UCMnlAysm2dSLc19GYv338Ufk3U3Xrgvj+ji9PrXM0vv
         kelg==
X-Gm-Message-State: AOAM531NkST5ezCRQCGt4H4aq87tnnTRN9Ijf8XkrqKt72zfKoyVEWRY
        DYpNufdc6HhAfk13N1GkdnQ6sb8oh5q48IXHYT9e5Q==
X-Google-Smtp-Source: ABdhPJxRXPXtmsdw8rYPXpvYboUdzlQ8bJV3kOcd4PAhMuDZclH19mi1sUHxf6/scOAqGe6EqSG+qHrjPehozgwYZXo=
X-Received: by 2002:a05:6e02:bf4:: with SMTP id d20mr5204235ilu.252.1602919924794;
 Sat, 17 Oct 2020 00:32:04 -0700 (PDT)
MIME-Version: 1.0
References: <20201016090437.301376476@linuxfoundation.org>
In-Reply-To: <20201016090437.301376476@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 17 Oct 2020 13:01:53 +0530
Message-ID: <CA+G9fYsZh9L_1RsH+LipyzOzEYFunSU=b_bZeuzMi6-SQxRMKw@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/21] 4.19.152-rc1 review
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

On Fri, 16 Oct 2020 at 14:40, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.152 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 18 Oct 2020 09:04:25 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.152-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
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

kernel: 4.19.152-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 5f066e3d5e44986dffd040360637a0dee8c66ccb
git describe: v4.19.151-22-g5f066e3d5e44
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19=
.y/build/v4.19.151-22-g5f066e3d5e44

No regressions (compared to build v4.19.151)

No fixes (compared to build v4.19.151)

Ran 27932 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- nxp-ls2088
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kselftest
* libhugetlbfs
* linux-log-parser
* ltp-cve-tests
* ltp-hugetlb-tests
* ltp-ipc-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* perf
* v4l2-compliance
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-io-tests
* ltp-math-tests
* ltp-sched-tests
* network-basic-tests
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-fs-tests
* ssuite
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org

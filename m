Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8D3D29361
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 10:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389515AbfEXIss (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 May 2019 04:48:48 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:37925 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389473AbfEXIsr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 May 2019 04:48:47 -0400
Received: by mail-lj1-f194.google.com with SMTP id 14so7952287ljj.5
        for <stable@vger.kernel.org>; Fri, 24 May 2019 01:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GhIlaR2R/WDcCpztQRUoJRfl8xHyTqpHnxSrqDeAz1A=;
        b=esWJX+crexokT24aSBq5Qlk0UnAO4fbSyr2+zVaV61DjyX54uyW31dzHTs9zhRemz0
         MPZM5vt3law+QdnOKFtJDUDEtivlLS9uENDJNeWW7riuob+6NJGhammsgZI4BWppGwoa
         mchEo0oPeLbxsIUMue1nwTmKpSwLD9lkeT3kvyDq9uTQKBma6+ahMdLu6kpkZ+ghH+FS
         BDqnGyfxmKXu+BR98QbRRsgU9PaYSXv1w/yV1Ql1BoKlp2ytfaH5/tqB4jc/42MMEAGv
         eCcVZK7cmqrHqd+535XWH7ms5RYWUE6COeOGxVZTHbHeLkBPV7IWPNbOUfDURqI2uWhx
         HTpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GhIlaR2R/WDcCpztQRUoJRfl8xHyTqpHnxSrqDeAz1A=;
        b=sJooOVAF6ZfpqWsoQSeaLZR7zeRxdnRrJlWhNJTTeJoSgoC5zNCTtGuw1clesuWw39
         IHzYBX1AU8RTtIQe5rzbE2fMzM6h/Wmxm05HhyV5ox+kGmR2GGund+whoGu7cUe21efV
         4NBlUshY3Zkn4Tl1Glq5CVjflWU9l6UudlNx9rRNyBMDAPDPdykSTZ3Ig0jQpoV3mLyN
         ISrhepvdY+Awlqq4X+szaA3MmU8+uN+YWgnGfkvkrJxe4SUyQJFUAhBXPWibajklnZwh
         /WX4qZz0YtsMPQWHPgJ8nHth6X5y6FtouhQiFbT5d/JYPqDo1HTYXkKERl2lAtivvFIS
         yv2Q==
X-Gm-Message-State: APjAAAVCnf3kYJYj3f2PAmuIhDDnmSmsFO/4N9xx0dMPk//aou0NC08X
        esBsXaIduThQVQc8JJYfFY3VBb1mi6itp31IABXE6hqNM68=
X-Google-Smtp-Source: APXvYqwEYr9zI6BkhnUM++IfeCcC+xbSOsMTtYqvpe6zA/njTkpkrPLs5HySfbG+rBCaT0DAWzeOiXT/AKbWPtdZdlc=
X-Received: by 2002:a2e:864e:: with SMTP id i14mr20074286ljj.141.1558687726068;
 Fri, 24 May 2019 01:48:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190523181731.372074275@linuxfoundation.org>
In-Reply-To: <20190523181731.372074275@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 24 May 2019 14:18:34 +0530
Message-ID: <CA+G9fYsXDbU-ZLD1mji8c8rNErVu+YOUvbw2rpXvMPXdRC5NPg@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/114] 4.19.46-stable review
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

On Fri, 24 May 2019 at 00:44, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.46 release.
> There are 114 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat 25 May 2019 06:15:02 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.46-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.19.46-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 071ff9cc98498f489abc097471549b19933ba3e2
git describe: v4.19.45-115-g071ff9cc9849
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.45-115-g071ff9cc9849


No regressions (compared to build v4.19.45)

No fixes (compared to build v4.19.45)

Ran 23173 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
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
* libgpiod
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
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
* ltp-timers-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org

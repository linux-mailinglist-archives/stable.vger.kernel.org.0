Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7052F29D8
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 09:18:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729752AbhALIR3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 03:17:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727530AbhALIR3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jan 2021 03:17:29 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1622C061575
        for <stable@vger.kernel.org>; Tue, 12 Jan 2021 00:16:48 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id q22so2263316eja.2
        for <stable@vger.kernel.org>; Tue, 12 Jan 2021 00:16:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wLnLCvk9v39pek1MIDVV95VomZ0S6QWBwikCBxFTKTQ=;
        b=xC3M6EnbXkwGMraBH0nfEAF4EKBJ2JUTHVFfmpggSy54535fFWp5+fdA37X6hqgo4j
         PBSkGGRLrBB3gFuziwZkwDQQ+IwuyG5Z14q3Av07PQiTzKzC6MDW+0/4bW6djyeybnaa
         ldLpNjpPg0m28MFBQ0RT0FXv3uBcKp0TCsnRy6hINWBpvMAJIi846aM5MeZgGZtBiZtP
         I+s1G67TD+h/ablC+k+ihsyTtTN6jO/rXqDyNMouNXHMhKEMdGy+XLUvtEIeczpLtn1S
         lUL5KfP7Xb2T8RfrmZ77W8xPokml6LRJAdlVyJWapBQJJdEefPaMaKy6JQ5EbdV4HOJk
         aniA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wLnLCvk9v39pek1MIDVV95VomZ0S6QWBwikCBxFTKTQ=;
        b=XF1SJ3RfAM5XTH1vAR6Qha4Qjoq6MtuzsUKxLqtkP5GZjmfRMob/VJyO+S5vWiAIQh
         P23G2DHHWcrKxvzdwNBQFjgtvuH+KMlI4xWliESBSgjySWVISijg9W92jrZQt2PNzo6V
         MWjq796atSbJwajQCFW2ngL5Re+gLegWewFvQnEw+JFTrrlxE8kxigQRxrMAxG4Z1sTx
         Ymr2QS0UGUasbopcr/kjHsqEZhJnwvPR+fRkbyiwauCV6FIGpWDR8v3Nhn4aDOwv78W4
         sKaedabJNAqM0f3mOuWVhrT4f+uQFDgfPchj5JgOZ2/bsUT2qdEmfM5DRWIVMP4yPP+z
         pE+A==
X-Gm-Message-State: AOAM530oDLNPRWBF4freV+XQwo4c7aXFOt6BVUAVIR6ZCcOBBHVjSqme
        pC/KRUTciEinDzAfTwDMU7NuKv3qEGb9KVoz5PUrxA==
X-Google-Smtp-Source: ABdhPJyGBMXoedRpz3XWyghhcjUsySPEMW0Cb7/xw/AZB3zbcNSzZ+kVWTpsm5e0gWnkx0E/6PWgJXnNcFoRx3ASHdw=
X-Received: by 2002:a17:906:4c85:: with SMTP id q5mr2334315eju.375.1610439407158;
 Tue, 12 Jan 2021 00:16:47 -0800 (PST)
MIME-Version: 1.0
References: <20210111130033.676306636@linuxfoundation.org>
In-Reply-To: <20210111130033.676306636@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 12 Jan 2021 13:46:35 +0530
Message-ID: <CA+G9fYuU7eysELa0vBXJHCYuwq_rU2wLvim2MsQ2C6b8jUk+dw@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/45] 4.9.251-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        John Stultz <john.stultz@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 11 Jan 2021 at 18:33, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.251 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 13 Jan 2021 13:00:19 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.251-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

NOTE:
The following BUG noticed while booting on arm64 Hikey 6220 platform
from v4.9.249 onwards. We will bisect this and get back to you.
This issue is platform specific.

BUG: scheduling while atomic: kworker/u16:3/81/0x00000002
       Workqueue: dwc2 dwc2_conn_id_status_change

BUG: workqueue leaked lock or atomic: kworker/u16:3/0xffffffff/81
      last function: dwc2_conn_id_status_change

Full test log,
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.2=
50-46-g6d954ea12bd6/testrun/3726871/suite/linux-log-parser/test/check-kerne=
l-bug-2131647/log

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 4.9.251-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: 6d954ea12bd6f384f3129de8f74bb0a30baffa7b
git describe: v4.9.250-46-g6d954ea12bd6
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.=
y/build/v4.9.250-46-g6d954ea12bd6

No regressions (compared to build v4.9.250)

No fixes (compared to build v4.9.250)

Ran 38830 total tests in the following environments and test suites.

Environments
--------------
- arm
- arm64
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- mips
- qemu-arm64-kasan
- qemu-x86_64-kasan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- sparc
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* build
* linux-log-parser
* install-android-platform-tools-r2600
* libhugetlbfs
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cve-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* perf
* v4l2-compliance
* ltp-cap_bounds-tests
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
* ltp-tracing-tests
* network-basic-tests
* ltp-mm-tests
* ltp-open-posix-tests
* kvm-unit-tests
* fwts

--=20
Linaro LKFT
https://lkft.linaro.org

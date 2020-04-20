Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06D731B1310
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 19:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbgDTRbV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 13:31:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725784AbgDTRbT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Apr 2020 13:31:19 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 748EAC061A0C
        for <stable@vger.kernel.org>; Mon, 20 Apr 2020 10:31:17 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id l19so8396841lje.10
        for <stable@vger.kernel.org>; Mon, 20 Apr 2020 10:31:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NIryELAm6gImzJkGH6fQiYjp+mAEletB7eZIJsyqgWk=;
        b=krnMdGb/MWv2/hJFB2GXAivA1eafT/qLbqvbghWtyv7B4Zpq/GcxvHi6mOd+6FBM6C
         IY5BdQiWf7sdkhevezJPXXQjRugRZy0mDc6xcxmSPQsM2u3cbnw+z69yM3DOOQGwzCJu
         SSNbDvdaUQAGzazYsVocKKQJWyDeffZwnGaAUWk6PRvukjItFTuj4aVvsEWCSI685UF8
         IJ503RbuLWh37H/qn5eVIFJK+0vQ6eNWomJ//9XsZC1rCpLVbE6i16bTzPysDUuOzYf3
         K5lPzAN6eO9nger9P74Ws7hlToyCxgIMqr1EYuvkgky1tvewNclC/FXB24Fofob0rrID
         IdBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NIryELAm6gImzJkGH6fQiYjp+mAEletB7eZIJsyqgWk=;
        b=Dvn01uU2F+XfSlloH/p9MDZqL6v34MmbfteeUffEnxeHZy62v0iUuCKyxMF0XPD/HV
         ATeH0qof+O2KcEBk9oWBHR4Vd2wltS4Jv/LJzibYvN29FzQfdtllPXjhl1aMyGfzVeFt
         tHq+Nf6lOYcQHGXksbSAITqloGsAq+1kAQaXrM/sm+H/9VNn/a/I3IaVM0VQI7CQ3p/h
         jApu64MFyq7CEjrf3jrncfUd1kBQrZxTPEjNgy+CkFJQZPQNnuSWRIE1qBqxMUNC3BnV
         X0PsbKWM/36Ky/ZkD+PjGTqmF88OYD3TgX/n0Ulslu9PxsykSpYWIKJoPo/VRMrVOKHN
         1dtw==
X-Gm-Message-State: AGi0Puagg48Avk49UJYMHn/npsaV3InhkUmN000S0/2858bhL9d2seC0
        m9Z29ZJ9611IABdJvnI5nWEomktR1RZhlTSTYNuz0w==
X-Google-Smtp-Source: APiQypJPD4m+tp3Womo4xhkAYM19+Ic04WM4krQ4hxUkoUaj9x6ghuqC4Zj9qVE2fQ/7SPMQH92K3u/JyQ21IzldG4k=
X-Received: by 2002:a2e:9496:: with SMTP id c22mr9468296ljh.165.1587403875593;
 Mon, 20 Apr 2020 10:31:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200420121508.491252919@linuxfoundation.org>
In-Reply-To: <20200420121508.491252919@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 20 Apr 2020 23:01:04 +0530
Message-ID: <CA+G9fYscmrzf27SWRSxS5v-oYvJcRaqQw1rmDj-27kqBJXjRcQ@mail.gmail.com>
Subject: Re: [PATCH 5.6 00/71] 5.6.6-rc1 review
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

On Mon, 20 Apr 2020 at 18:13, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.6.6 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 22 Apr 2020 12:10:36 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.6.6-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.6.6-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.6.y
git commit: 906ecc0031ed5fb7b4dfddb2c990f975e114829d
git describe: v5.6.5-72-g906ecc0031ed
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.6-oe/bui=
ld/v5.6.5-72-g906ecc0031ed


No regressions (compared to build v5.6.5)

No fixes (compared to build v5.6.5)


Ran 32044 total tests in the following environments and test suites.

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
* install-android-platform-tools-r2800
* kselftest
* libgpiod
* libhugetlbfs
* linux-log-parser
* ltp-commands-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-io-tests
* ltp-math-tests
* ltp-sched-tests
* v4l2-compliance
* ltp-hugetlb-tests
* ltp-mm-tests
* kvm-unit-tests
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
* ltp-ipc-tests
* ltp-nptl-tests
* ltp-open-posix-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* network-basic-tests
* perf
* spectre-meltdown-checker-test
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org

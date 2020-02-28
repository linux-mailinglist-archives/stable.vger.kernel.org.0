Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82603172F53
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 04:29:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730668AbgB1D3p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 22:29:45 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:36477 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730646AbgB1D3p (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 22:29:45 -0500
Received: by mail-lf1-f66.google.com with SMTP id s1so522330lfd.3
        for <stable@vger.kernel.org>; Thu, 27 Feb 2020 19:29:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=78tHbOll36uBw2XMxvLXTIrb/7Hwcn3/bSQBtRwNyV4=;
        b=Esy8PrSDrE8pziSziw6UMtRLBPv9knn60C6HwboX7hLSXMn40d9NOyO5Pmi6O/EkBd
         feru0BtMSB6K1RwlP1g+aFOiMHS5b8fdanX3dnXciHmFxqlOkPFBXPKKgX0JXYwbv0NH
         R8v6TbaLCvh9+RmXjcvW9As+oQ6zojN2AnzUIGs3E7I4wrdgMedhWxNl+tO3pzi5BK5R
         3iq0B09gkoAtBGPaNQyQpUomEmacdCA/z+aRX1i99vcMelOLfeEPM6HV2Pzkz+NXeFfs
         L2fsF2RbrEcGgxaZy+P0vnGbotgZSh7/WwQPPBK1KMZ86GyJlVV4MPp6ECO4btrqF0eI
         Yhew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=78tHbOll36uBw2XMxvLXTIrb/7Hwcn3/bSQBtRwNyV4=;
        b=O2EvgDLOaikLqYrVm8fcxTSFQEZ8bK6JS5UQ3HNafkKBXmFfqK7r5scp3oZRrVtEtA
         Yve+3d9Ffak8S/QHNebr1ThAJtG6UQGwqMYfBS8GLsqQtqjCRUFghMaiMbLDgsuzoPgt
         alh7pm5BlBYASpFi8WHITICPbpwkWdsSF965PHVIv696kyjKdFUsiiSvEBj9k1pAbBFb
         tDB6mi4mb00I6AAaEAy7Ns26037KKE7F28+gi/KJ8EFfMUSWYWslzSMVRLiU+5Cqo29e
         3w7IDfQA1Z1O7xIZEaouaA4/rjx1MU+3+Qse4XOsJ5i5Q86qJalDAwAv06aFJlhulx08
         OclA==
X-Gm-Message-State: ANhLgQ0iOCw7jQEe3PCoYDE5Rmk+tGvrUlmboZsL6Z4cDcFkSVV+hLJm
        4uLJgQFI5VRKcpo/3iu2dHa7W023MJ8eu1slL2vIVQ==
X-Google-Smtp-Source: ADFU+vvuQAgNrjgT3mnY4SiNWU/Oj1NGZRYrcJYA8fh4Jpu4CjS8OByXAxe/MyN76/cnDE/LRq0wM3dCm6lifHt9UGA=
X-Received: by 2002:a05:6512:3e5:: with SMTP id n5mr1359899lfq.55.1582860582649;
 Thu, 27 Feb 2020 19:29:42 -0800 (PST)
MIME-Version: 1.0
References: <20200227132255.285644406@linuxfoundation.org>
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 28 Feb 2020 08:59:30 +0530
Message-ID: <CA+G9fYse5vNkUmMJ7E5DL2NcY9Cp1RUdAJif+DVsDdv+u9QiTw@mail.gmail.com>
Subject: Re: [PATCH 4.14 000/237] 4.14.172-stable review
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

On Thu, 27 Feb 2020 at 19:23, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.172 release.
> There are 237 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 29 Feb 2020 13:21:24 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.172-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.14.172-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: 47e811c62a4a89755af4c26a95985cec9cf10e80
git describe: v4.14.171-238-g47e811c62a4a
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/bu=
ild/v4.14.171-238-g47e811c62a4a

No regressions (compared to build v4.14.171)

No fixes (compared to build v4.14.171)

Ran 28113 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
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
* libhugetlbfs
* linux-log-parser
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
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* network-basic-tests
* ltp-open-posix-tests
* kvm-unit-tests
* ltp-cap_bounds-64k-page_size-tests
* ltp-cap_bounds-kasan-tests
* ltp-commands-64k-page_size-tests
* ltp-commands-kasan-tests
* ltp-containers-64k-page_size-tests
* ltp-containers-kasan-tests
* ltp-cpuhotplug-64k-page_size-tests
* ltp-cpuhotplug-kasan-tests
* ltp-crypto-64k-page_size-tests
* ltp-crypto-kasan-tests
* ltp-crypto-tests
* ltp-cve-64k-page_size-tests
* ltp-cve-kasan-tests
* ltp-dio-64k-page_size-tests
* ltp-dio-kasan-tests
* ltp-fcntl-locktests-64k-page_size-tests
* ltp-fcntl-locktests-kasan-tests
* ltp-filecaps-64k-page_size-tests
* ltp-filecaps-kasan-tests
* ltp-fs-64k-page_size-tests
* ltp-fs-kasan-tests
* ltp-fs_bind-64k-page_size-tests
* ltp-fs_bind-kasan-tests
* ltp-fs_perms_simple-64k-page_size-tests
* ltp-fs_perms_simple-kasan-tests
* ltp-fsx-64k-page_size-tests
* ltp-fsx-kasan-tests
* ltp-hugetlb-64k-page_size-tests
* ltp-hugetlb-kasan-tests
* ltp-io-64k-page_size-tests
* ltp-io-kasan-tests
* ltp-ipc-64k-page_size-tests
* ltp-ipc-kasan-tests
* ltp-math-64k-page_size-tests
* ltp-math-kasan-tests
* ltp-mm-64k-page_size-tests
* ltp-mm-kasan-tests
* ltp-nptl-64k-page_size-tests
* ltp-nptl-kasan-tests
* ltp-pty-64k-page_size-tests
* ltp-pty-kasan-tests
* ltp-sched-64k-page_size-tests
* ltp-sched-kasan-tests
* ltp-securebits-64k-page_size-tests
* ltp-securebits-kasan-tests
* ltp-syscalls-64k-page_size-tests
* ltp-syscalls-compat-tests
* ltp-syscalls-kasan-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org

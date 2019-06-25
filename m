Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 545735201A
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 02:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728459AbfFYApu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 20:45:50 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:45827 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728252AbfFYApu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jun 2019 20:45:50 -0400
Received: by mail-lf1-f67.google.com with SMTP id u10so11302965lfm.12
        for <stable@vger.kernel.org>; Mon, 24 Jun 2019 17:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4VRBV23X7CMhqByGit4IxjjQ4d/eDPyD6TIKsw0ukNQ=;
        b=hAR85fHT6Xqx79RDeSD0fXvrAwDQ0Wixbj/BblJouw3E8nlkTeiYi/3L9uWVLavTe7
         1JFnJDmyfY4J+P9oelU85/PNoDntEVb+4hw/1awwL508wcFz0Xi25YBToBWexcGJ471q
         u0cwJcUpaKvbvCgGpVijUyQv4tDWlMmaQ59Zx1DgnNvptNPNTU2CLVO5Q14iRcCnQWGk
         GuBEYdeKoJIi0otaEvZ5yX4OVnqmugOXEuhBu7mdEUVc/oWWpYU0yR3h8aYFnsTgARlu
         TGVxkHGdshwr7htvbJCI4a5wkz4H6JBNCLeCDYDCK3tFWEnSc56EwwnlaKp58ubS50Sg
         T1uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4VRBV23X7CMhqByGit4IxjjQ4d/eDPyD6TIKsw0ukNQ=;
        b=AaEVPO3P3AvuZb53j3Wm64+ohxlEgS7M3gW8RsswLyzrThZYA4dO0McGpiCafDQlaY
         X33Y3+ki/WjKPlpWwbJxbcgNW+vGSYh9fPDve4tq34sKAeHyKVes8hZZUzXKH+2KHLas
         46AD5aA2IEgSNAwr/2TUr80oU7UWjW37Mu8RYviIPs0rkIk6lyXACh4UCOoV6geX7EUP
         653RA1XRdC1EBpdKAcToCe62yvKNSRjXSG4UMCufJcAx1PgssD4xECY9j93jOHClTuGW
         X7VsareTMuZ3DiEXrNyN2Aq1jag1W0baCLaB7S4ctfARv+NpP6kbOXvAq+ufw37ACjdh
         ieTg==
X-Gm-Message-State: APjAAAVk8cIe5LNnRcpKZdd7fJBg82aui1nudNlDiv0t+H2nw35EL2Pu
        tJbvwiQ3/gYKQ9mQeNSvNGv6fYelPXjGVgKRflskSg==
X-Google-Smtp-Source: APXvYqyIaDpffn7grow+EzToiDWbaCtIu+C4nwTkN9runRiYSKuD9MwDzFdUFCBxaaCyTZaomiIsJdsjwT6G193S+kA=
X-Received: by 2002:ac2:4ace:: with SMTP id m14mr19701768lfp.99.1561423548820;
 Mon, 24 Jun 2019 17:45:48 -0700 (PDT)
MIME-Version: 1.0
References: <20190624092320.652599624@linuxfoundation.org>
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 25 Jun 2019 06:15:37 +0530
Message-ID: <CA+G9fYsxR5FtxPWNF5zs8uGWpAZCNRLAq+7azZCg_k0Mm_=fxA@mail.gmail.com>
Subject: Re: [PATCH 5.1 000/121] 5.1.15-stable review
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

On Mon, 24 Jun 2019 at 15:38, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.1.15 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed 26 Jun 2019 09:22:03 AM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.1.15-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.1.15-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.1.y
git commit: 815c105311e8cdba0f84293235f6f043152808cd
git describe: v5.1.14-122-g815c105311e8
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.1-oe/bui=
ld/v5.1.14-122-g815c105311e8


No regressions (compared to build v5.1.14)

No fixes (compared to build v5.1.14)

Ran 24427 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15
- x86

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
* ltp-fs-tests
* network-basic-tests
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org

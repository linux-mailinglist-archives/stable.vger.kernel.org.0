Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45863156565
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 17:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727341AbgBHQR5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 11:17:57 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:39373 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727340AbgBHQR5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 11:17:57 -0500
Received: by mail-lj1-f193.google.com with SMTP id o15so2494701ljg.6
        for <stable@vger.kernel.org>; Sat, 08 Feb 2020 08:17:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=T+jhEmwK62D2omi5f6yscaoXNvvsKmtEp4hiSm1NIpk=;
        b=EhS2sXocp71uM6tAB8CjgM/NSWSXsUEiEDUwAmpQfWWds9Bo/uUJEaOrCh1fPpPqF8
         /QCJmM5g8M1pxx+GLv5S0uVrX/290cJGRMIUaBt0Y5b67mjcJYQMF+2otdO8cZd3BVbb
         z0oZdKS7zRMvKQI8T+J69lF2sSQV4TEfz3o0igpiBrNHx/URJdkYejGmMGBggfr4UVZ0
         4U4wX/VWge4VzK4Laq98YH5g9uoDyfmaClNMkG1hf/yZC/r9mzvx54qFLtmpbsG7ketd
         Za1uaTRj+1yOlsg1PWOFBeaHIBy31XfTH99Lo6FV1ISN1dbvK2kcT7S4GtjDCEwqva/l
         DaKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=T+jhEmwK62D2omi5f6yscaoXNvvsKmtEp4hiSm1NIpk=;
        b=qOdPHnEOlCabTyxhoJJMalUXfsCn6s7h40qEYIZ77nM434SAuq9E+ZAifor7osxVD9
         iN/0TWdAKA9XmtrjCzzYBCnQG7g7iBS6FmEuOBRVC20hcgftpGQ6hPYRK+GqCVIaFx85
         +yQozbn+o/j6A+ybhPuQPPiyAqEOq3k2I2szILXWcRn6Yn4oSk9PyA33ZRH4hGyoYU35
         wq02LeqtDeKu6v5sIapvHrBteGLz4ixUK7eGih3vGKcyc+f4KCAou5xuHAF9+0tfbCPL
         bRnyJNZ7YaFl0TdnQe7/zPYZUlogAipV/R2aNWYMkZiievHhzlTvjIzKcKfHZzcfWFDZ
         ZZ4w==
X-Gm-Message-State: APjAAAVOeplXjlcqfSxR5vPOj79yf+IaM8Mymo9tp6RaeNoTxHUn8uGT
        oyt5TXSI56SM0vUfMt5+9CxHxFdMtV576TdDvsKW8/4L++w=
X-Google-Smtp-Source: APXvYqyYQIbsAt/4mWDg+3lvPNwGhlfiIH2e4GYL1lOkW3EMW6FpgdzF1I9T1QWtWuhVbhH211QAs67bvZ/Hii3JlGI=
X-Received: by 2002:a2e:9008:: with SMTP id h8mr3020913ljg.217.1581178675281;
 Sat, 08 Feb 2020 08:17:55 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 8 Feb 2020 21:47:44 +0530
Message-ID: <CA+G9fYsJXy-3t-G9k=6k-JFbc3vHKcq1O+r6gk+pHVYn4=2Scw@mail.gmail.com>
Subject: stable-rc 5.4.19-rc1/bffcaa93483d: no regressions found in project
 stable v5.4.y on OE
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.4.19-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: bffcaa93483dead5ac6145d67dd6cfefb9d9a2e4
git describe: v5.4.18-141-gbffcaa93483d
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/bui=
ld/v5.4.18-141-gbffcaa93483d

No regressions (compared to build v5.4.17-238-gbffcaa93483d)

No fixes (compared to build v5.4.17-238-gbffcaa93483d)

Ran 21786 total tests in the following environments and test suites.

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
* network-basic-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* libhugetlbfs
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org

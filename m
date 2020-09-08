Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 821EA260BE3
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 09:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729269AbgIHHY4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 03:24:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729142AbgIHHYy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Sep 2020 03:24:54 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC5EC061756
        for <stable@vger.kernel.org>; Tue,  8 Sep 2020 00:24:53 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id q67so8469478vsd.5
        for <stable@vger.kernel.org>; Tue, 08 Sep 2020 00:24:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=dyif1skiZcwcYbpP3+xm5xpCB1/4ksaJ7JYhN4/9mdo=;
        b=HDlco5w/yk6QgzNKxt1/Vbbgz8FZUF7jsz4EMLpANf1VebfYJBW8JHqm6Kigf5TmkM
         ospSZzJEqyzdsMOW5XIcdx50P33RZNJPdlkh7WsSgh8LNc7bICd7w55HqZ8iZin+3KzG
         +Q+GUniiwd/OnJb3r+29VN1X7mUWeFjgoojjRrOUL/cLmCurz2YPEFWP62nzvmCVGAHW
         rGXlbYVHPv9pbj5aAJgOYD96+okoWMmHbZWx/Vhxt5/C8d0iQWMHpxyB4y1R6blOLTxf
         MVN/pt1AsCvnrnMDLLVO8/XX1z8sGTbd4KLwyVUlKz8YTjxZhoJHOAAGTZgUneMXKvIs
         VAKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=dyif1skiZcwcYbpP3+xm5xpCB1/4ksaJ7JYhN4/9mdo=;
        b=LUUdKcRAIBfc7rb1JXAHnZ5ASKGA6Oax6wO2iD9DwAd1nuIvu0ORSSeNLhO6xQ4Lrl
         RDjynv5WELHuh/VElKG159+PgCsDjrGnQWWLuHuUHdmmZJUJdVXlENhhsmDbuAtYiU0c
         60b8HFsJ5ICFiPf1Pk2bQQeeEkfRnOFzRavRubIqqypwhcKYktxsi8Js/wmAAJLygutI
         Ms2qKbW8yBr/U7F4ASLf1HHsbDTLYYX9u0IabN7Jp5jOXf2Lm3VHyCfMXIo+7wWNud/U
         krEFR7e74TgJ64KmBedUnyN1eoFDM6uA+dMVNcjW4uzzaYWHIZQEKTdHyQz0/UKgYTGY
         YGcA==
X-Gm-Message-State: AOAM533Rche7rIZQwn5SOy3UOCgeFzBPGyuvDRB2Kc52uCKWEaqptlsS
        wnIbmShNsnoVa2rYq05XOToQv6VBuny9YmIc72wUCXbIh7aISM1e
X-Google-Smtp-Source: ABdhPJxHmscu239s0hfUNqpOefO/229NI9bGm+eHyPsf3yL4akjC/053yyQ8j07MYDfn0TmyZAafbX1KvQ6ZRiZMnAQ=
X-Received: by 2002:a67:7c17:: with SMTP id x23mr15225386vsc.166.1599549891107;
 Tue, 08 Sep 2020 00:24:51 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 8 Sep 2020 12:54:40 +0530
Message-ID: <CA+G9fYu+zRW6pvFm4ccufF+LzqVRBmYHQD-PD=1a9j0+aOTRZw@mail.gmail.com>
Subject: stable-rc 4.19.144-rc1/58651549ea03: no regressions found in project
 stable v4.19.y on
To:     linux- stable <stable@vger.kernel.org>
Cc:     lkft-triage@lists.linaro.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 4.19.144-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 58651549ea0369e2dd16baee518e5faa846eccbd
git describe: v4.19.143-55-g58651549ea03
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.143-55-g58651549ea03

No regressions (compared to build v4.19.143)


No fixes (compared to build v4.19.143)

Ran 35321 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
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
* igt-gpu-tools
* install-android-platform-tools-r2600
* kselftest
* kselftest/drivers
* kselftest/filesystems
* kselftest/net
* kvm-unit-tests
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-sched-tests
* ltp-tracing-tests
* perf
* v4l2-compliance
* ltp-dio-tests
* ltp-io-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* network-basic-tests
* ltp-fs-tests
* ltp-open-posix-tests
* ssuite
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-native/net
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems
* kselftest-vsyscall-mode-none/net

--=20
Linaro LKFT
https://lkft.linaro.org

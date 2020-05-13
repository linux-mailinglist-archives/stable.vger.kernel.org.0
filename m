Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDD11D0C08
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbgEMJ2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbgEMJ2p (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 May 2020 05:28:45 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D33CBC061A0E
        for <stable@vger.kernel.org>; Wed, 13 May 2020 02:28:44 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id o14so15912021ljp.4
        for <stable@vger.kernel.org>; Wed, 13 May 2020 02:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=wQxU0jyrHzKEkXou1yOIjNJHHQfsfmWMdJ2AoZ354UQ=;
        b=D9YifD/SW20ytyogAuVn9VrK0eKC+bwfpvlTRVGFjX4/WlCGcAUK8+6+pcocUtJIWn
         ZY3rWBAeBgljvsqnfct1Io+mMPT3L2HAseZ5JSaAHdu9NBzNVcZuseHblNApYRDZ2FAI
         IJT6Xa/ZprsZ838WypM1E6w4WiqkjDebPDwy3b/iAB7wkl9kAXL5YkjIcJ0R3lKDKUUV
         OTm47/l1qbqJTpQ/nqDAO7Ea/2ko42fRl9mDRTrY5fHzNxRsY9aLGdDq24Gd+Y/eOE17
         nvVYDr24QN1JkQnxIrfW7Uij3wv0nd7BO99xqhUu5uxQ/5TcBMTyYu0gDO1S5R5zO9bv
         S/FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=wQxU0jyrHzKEkXou1yOIjNJHHQfsfmWMdJ2AoZ354UQ=;
        b=qL7oZGGAVsiMzJBXQh3KO3A+8NyFCaEQbuxW80/dg1PZ6ITFqf94DION7uvanU50Up
         QKBsPkK9csCFInIJ554S8ZcAf+IJK56oaI7JmpOdqRktkP9FeNPItP2/2B+I/e5GEVM0
         vyAnXZzSMjNYlch3zwB97iO14sUgqvxLNGxxty014uMesjjosACMcXA7KaqzK/DSp8Ku
         eMjpfkal3h2ZpQR25MZSpVIplFJNUJgqT75VY+jFSpoyonS1sWTV9msFNA2UCy0FJ6vm
         +iwG629of04Y97TKf8uTZR2W08PsYZhsuLvRrafA01p7imXg3p9ccRPkf0vIGwQ07md6
         BQsQ==
X-Gm-Message-State: AOAM53113lVDmUF2kdJVJPToSEXf7LufQaTQSeUpJ8+Z8XBTFMxqMZ7a
        gapuozoG+sf4Cec6wzNcibBN1d1TarGVWNvqEMRC/07U/Gbb2w==
X-Google-Smtp-Source: ABdhPJymCx/vtL0zSaB9nQywQfka98iDN4CnnB2w41wAW/txsjCb6bxprZhxbc18emb5CImBf8voznVttHoAckZeEBk=
X-Received: by 2002:a2e:8999:: with SMTP id c25mr16869377lji.73.1589362122301;
 Wed, 13 May 2020 02:28:42 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 13 May 2020 14:58:30 +0530
Message-ID: <CA+G9fYv=uqK7qHfkE4VrGKwJ3G3E3meYH9vjzZKpS+K4sP-yhw@mail.gmail.com>
Subject: stable-rc 4.4.224-rc1/e6bc7c5d4464: no regressions found in project
 stable v4.4.y
To:     linux- stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     lkft-triage@lists.linaro.org,
        open list <linux-kernel@vger.kernel.org>
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

kernel: 4.4.224-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: e6bc7c5d44642105766e5b29c57be37c6319c772
git describe: v4.4.223-17-ge6bc7c5d4464
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.4-oe/bui=
ld/v4.4.223-17-ge6bc7c5d4464

No regressions (compared to build v4.4.223)

No fixes (compared to build v4.4.223)

Ran 20346 total tests in the following environments and test suites.

Environments
--------------
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* build
* kselftest
* kselftest/drivers
* kselftest/filesystems
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
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
* ltp-open-posix-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* network-basic-tests
* perf
* v4l2-compliance
* kvm-unit-tests
* install-android-platform-tools-r2600
* install-android-platform-tools-r2800
* kselftest/net
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems

Summary
------------------------------------------------------------------------

kernel: 4.4.224-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.224-rc1-hikey-20200512-720
git commit: 55c9d63788c49cf307f7cad2e830681578e6a7f6
git describe: 4.4.224-rc1-hikey-20200512-720
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.224-rc1-hikey-20200512-720


No regressions (compared to build 4.4.223-rc3-hikey-20200509-718)


No fixes (compared to build 4.4.223-rc3-hikey-20200509-718)

Ran 1814 total tests in the following environments and test suites.

Environments
--------------
- hi6220-hikey - arm64

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kselftest
* kselftest/drivers
* kselftest/filesystems
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

--=20
Linaro LKFT
https://lkft.linaro.org

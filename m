Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98A1A1E1F6A
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 12:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbgEZKLb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 06:11:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728810AbgEZKLb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 May 2020 06:11:31 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E68B4C03E97E
        for <stable@vger.kernel.org>; Tue, 26 May 2020 03:11:30 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id k5so23728310lji.11
        for <stable@vger.kernel.org>; Tue, 26 May 2020 03:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=miTmksXCIqWVN7jcmZgQP6TpCq/FL/NzIjahwtva+v4=;
        b=zNrTbrfZwsgVbnF4crxEdBf0O1XF/0EVpVUk8By5REX0TG7RzQO6na2FfcECwc42Iv
         0jO/iii62wLmkDPB117YkHA5ZVo7uk7WdkcWGJj5BzXstf7vcQmsnGYUxLfOSxlq3kEZ
         6+yX3IQEvO6tC7LLO6g5gaFPxhJ0twsMPDHH7MPR9jRP3kVNHHnbtT/813MTvg+6JWah
         zvSVms/xt225gzIb4lzcaLnFuyuZ42MSiMsVu5O2CzhYteT65bGrHzTMGsIg/ztguCtW
         FW+GAi5jRKSGClV6hXekI0o39CHyf3OBSZqsB9jACQqmuojH96iCB4KyNELR6GyAU8hJ
         VhZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=miTmksXCIqWVN7jcmZgQP6TpCq/FL/NzIjahwtva+v4=;
        b=mGPB0qLHd8XH5l3n5Az/9qRJ9ie1LETeYyLI8DgA+HjOHHJuVHfL2RLjnpnAfq9CSf
         GCTR6eks6N79sVf1XJU2E2LPBW6K6KK1wXxKAO0D6OxlgXRnThT1xVhdSzCCiI0jT1h6
         hw6DKP6UGMnsySf9jfqREUbmr2eP72/CCsMcYhgwH4md1pZJ2l9Q+xosaviHBOGxc3Oj
         t71aOQfhWxUu2Or6iMOtGDMSOEWcWK/hn4EBcmZqWxAd9X/b/a+ut5RnrQgft725fH4Z
         Yfp2Tl4M/SYbH9VSw022cgBUZwYL5WmiUXmiS8wUb3gPxTQj0Tt7zFZTCIOZLBTIf6mk
         pFsw==
X-Gm-Message-State: AOAM532gyBk4h6GN76rV2gsTJxJbJcBzFR5nt9/rPVzx+QMIIt7tbvqm
        WYZ3IEmX6d7P9ZHJCz1TEQTlVIj+mY3DIMEiu8j1dA==
X-Google-Smtp-Source: ABdhPJzQSdVdEvKK8oUPnWbfl4I+DXi85OXtP18SOEqu8m/LBJ46KckoPZMIfpfsFUYp/sGaczjFNC36CwbcQM0RftM=
X-Received: by 2002:a2e:5446:: with SMTP id y6mr228714ljd.55.1590487889309;
 Tue, 26 May 2020 03:11:29 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 26 May 2020 15:41:18 +0530
Message-ID: <CA+G9fYuvWXOMmzvJFTK69CvxXamWnY_QdMFynoXi=Vjcoa8cxg@mail.gmail.com>
Subject: stable-rc 4.9.225-rc1/7b44b8e27432: no regressions found in project
 stable v4.9.y on OE
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux- stable <stable@vger.kernel.org>
Cc:     lkft-triage@lists.linaro.org
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

kernel: 4.9.225-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: 7b44b8e27432c38eb9fd9e98eb66b781ed4944ae
git describe: v4.9.224-65-g7b44b8e27432
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.9-oe/bui=
ld/v4.9.224-65-g7b44b8e27432

No regressions (compared to build v4.9.224)

No fixes (compared to build v4.9.224)


Ran 24369 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
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
* install-android-platform-tools-r2800
* kselftest
* kselftest/drivers
* kselftest/filesystems
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-mm-tests
* ltp-sched-tests
* perf
* ltp-commands-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* network-basic-tests
* libhugetlbfs
* ltp-containers-tests
* ltp-cve-tests
* ltp-fs-tests
* ltp-open-posix-tests
* v4l2-compliance
* kvm-unit-tests
* kselftest/net
* kselftest/networking
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems

--=20
Linaro LKFT
https://lkft.linaro.org

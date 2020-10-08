Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EDCC287140
	for <lists+stable@lfdr.de>; Thu,  8 Oct 2020 11:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728701AbgJHJKh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Oct 2020 05:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbgJHJKh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Oct 2020 05:10:37 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E088C061755
        for <stable@vger.kernel.org>; Thu,  8 Oct 2020 02:10:36 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id o18so5034049ill.2
        for <stable@vger.kernel.org>; Thu, 08 Oct 2020 02:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=1eS0SNuGbY+Bm880lS3+F6SikAs+MjpCG/24nYbBmrc=;
        b=DPvBJ42wNRIYGS6hhWpghjLVXDv47/74g2LkgIiEzEkXsvBqypLIhjc+riIyAF9m2U
         jGwyu9bUS1h5WdkGPpd+1kLLM0PTO4fhWvznichxqtr2bWEDz7EP8R8pM4FuUyAhagAz
         dBMIKxCzdjCv2t4hg6+5NC55EslZt5Pt2ZC2gxzDrBMIhuYNBjOMCVrkKnYruQwnNA/+
         LSNnfq8pyANn+NWZhryMuURkcDmAxXkokVDKQwd61LQj/9qQIqA+NKK8wAAKzQYMXvca
         wHhtavGECwCH+BpdxQUDiZmXSFuP08SK2r5mi2wEmPS3A2eR/waJ6Z7L7bp2kfWWgRxL
         4nVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=1eS0SNuGbY+Bm880lS3+F6SikAs+MjpCG/24nYbBmrc=;
        b=d0gWgCfPhY/rXrpOFNOJR2n/pM+NllxQfBYpf4CnXHbqDWrs7Z+cPoyPmzOFWXVbCk
         is7m231iNfil93WLI4YonS5ZV/Lzw1pt18aoF4nIRyh8j+b6iciAlKD9wPXo5rNnK8nQ
         b/63gPfLFb4eI41xrgLDkkJ0yK9LSzBfyeWRccLV7QuTKzZVbLzBdjn6J+z+ZwDukPvK
         zcxHx/2yNcwMkPxkdELiHl20597P6Ty/1F0+CIxMYEYcofX1yVia/B5xb36xVcKf8YCM
         PSwEWBRXqy4MAovV4rBmHKA8Oay38EuGniHZLVzI4Unj09+OOskn/MJ1+0wvP1JfTJGG
         HWcg==
X-Gm-Message-State: AOAM531zSIvGo5BKHcqC230lpKWO/E9XS2nXsVgzSMmH4piq8Dmf+yUK
        KlETK6g+gB/iIIdkGp4Q7bFdZkJcOH3GvpHUNHGYABmpi4cd0VGG
X-Google-Smtp-Source: ABdhPJxk6rfhsn7rscbUDaS39Sezqrwv/bfrTVJc/5DMji9HoXxGx4e7hzmimTf+9do72+4wkGeyhDfCe0hwGXOk7hI=
X-Received: by 2002:a92:c949:: with SMTP id i9mr5736121ilq.252.1602148234681;
 Thu, 08 Oct 2020 02:10:34 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 8 Oct 2020 14:40:23 +0530
Message-ID: <CA+G9fYtUoGRgjsMVdfgYN8+EA=COH39PBDwh8CZuLP8=mV_3DA@mail.gmail.com>
Subject: stable-rc 5.8.15-rc1/0b030df1725b: no regressions found in project
 linux-stable-rc linux-5.8.y
To:     linux- stable <stable@vger.kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 5.8.15-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.8.y
git commit: 0b030df1725b77cd5aaba81f25208a79f4aaf5f4
git describe: v5.8.14-5-g0b030df1725b
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.8.=
y/build/v5.8.14-5-g0b030df1725b

No regressions (compared to build v5.8.13-86-g8bb413de12d0)

No fixes (compared to build v5.8.13-86-g8bb413de12d0)

Ran 37941 total tests in the following environments and test suites.

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
* kselftest
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* perf
* v4l2-compliance
* ltp-commands-tests
* ltp-controllers-tests
* ltp-fs-tests
* ltp-ipc-tests
* ltp-math-tests
* network-basic-tests
* ltp-mm-tests
* ltp-open-posix-tests
* ltp-tracing-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org

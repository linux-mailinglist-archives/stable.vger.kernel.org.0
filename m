Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 608F11E1DA5
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 10:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728527AbgEZIuD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 04:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725771AbgEZIuD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 May 2020 04:50:03 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9E94C03E97E
        for <stable@vger.kernel.org>; Tue, 26 May 2020 01:50:02 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id z13so13826763ljn.7
        for <stable@vger.kernel.org>; Tue, 26 May 2020 01:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=yN+rHF7J+Skms3bErCE7+jl1AGV/pUkVgptkFUMAq4o=;
        b=sKz3IKhRcZmjQNxjp9LVCTlTq0I1IsBSiVEkNjZaTRxPi5dWMmkd8P7cTXGX2X1nfj
         04e5T9UKZxMSXP+ZluvREb0HgQxIq+vOsMVJ9H2GOAbJqt2dw05CD5UyzcVqydL8WCQI
         V0hWLXNXEmWnbE+Vg4EuZynCS169tmdrtYcRuiL8QYJWetB90vzT7dInnqlrWhm8HIIt
         oYskES8ec6tk+5HQCnx2e4Got0i8YJdB5Ea+6vWcQlzlw5vcjqIBMMuUe759L2hJ5spi
         L+bOg8KlEGaGiayntzOQcivNeMgFZstyP1z5fL2FGcHomYoEP0JFH1itRfs6avcPmbHC
         eiGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=yN+rHF7J+Skms3bErCE7+jl1AGV/pUkVgptkFUMAq4o=;
        b=O5HbU9rI8vn3CptyHlFxI7ubSc+8IbVtOkpCR5ppUVgd3cTyL3ptrIZvF2ZMQ6nxaf
         DFM0w7WzxxhKXJ8DbhaIQwSXfFljLYLl5IdllRO9VZ6ZvpcGYVxDJDYT8DhnNssmKLJo
         T61GtI6WGl1UZSSfbfc3PamXanoIfEiN8lpu9GH7lgTYrUeSZ9MfS0OWAOAqBaUHV11J
         LsAU/4HsFwOzQxsgPIe5XPhYlcr9L6QtY4uYHiKus1u442pfJWFcISD4zpTsRG1M62RA
         yNWy6FEEaC/Ehdi3BEXYzoC94rNgxhNg8IfP9u5XKFxFNMIeGOviEYb/SiWtQW6eWiIe
         GG5g==
X-Gm-Message-State: AOAM5312Wb9L7UBpOPGeLC7R7IB4OIlOl/jT1RpTNXyHncN8fpJ1liuI
        iLimnVl38JjrZJPPg9qRm7Q6rbPd7g3PRpVLm1nZNQ==
X-Google-Smtp-Source: ABdhPJwAuouvKji87wW/7TM9DU2CKvVOZ9xkfA8FrGDxpGyDzc+s/hihU/MBj900vP4kGsm0LfexFhTHFez+eQEsuBg=
X-Received: by 2002:a2e:9684:: with SMTP id q4mr75700lji.431.1590483000835;
 Tue, 26 May 2020 01:50:00 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 26 May 2020 14:19:49 +0530
Message-ID: <CA+G9fYsYVNcANxEq1nka8zGeBKtzuFUC8gM7-Hd7p3tQeQ7Z9Q@mail.gmail.com>
Subject: stable-rc 4.14.182-rc1/2c9e54b6ad6a: no regressions found in project
 stable v4.14.y on OE
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

kernel: 4.14.182-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: 2c9e54b6ad6a1307ba4365dae90d882bc31ada04
git describe: v4.14.181-59-g2c9e54b6ad6a
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/bu=
ild/v4.14.181-59-g2c9e54b6ad6a

No regressions (compared to build v4.14.181)

No fixes (compared to build v4.14.181)

Ran 30442 total tests in the following environments and test suites.

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
* kselftest/net
* kselftest/networking
* linux-log-parser
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-mm-tests
* ltp-syscalls-tests
* perf
* kvm-unit-tests
* network-basic-tests
* v4l2-compliance
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-open-posix-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-native/net
* kselftest-vsyscall-mode-native/networking
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems
* kselftest-vsyscall-mode-none/net
* kselftest-vsyscall-mode-none/networking

--=20
Linaro LKFT
https://lkft.linaro.org

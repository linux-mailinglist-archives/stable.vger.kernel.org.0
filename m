Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 397CE118C13
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 16:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbfLJPKL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 10:10:11 -0500
Received: from mail-lj1-f178.google.com ([209.85.208.178]:45654 "EHLO
        mail-lj1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727420AbfLJPKL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 10:10:11 -0500
Received: by mail-lj1-f178.google.com with SMTP id d20so20262803ljc.12
        for <stable@vger.kernel.org>; Tue, 10 Dec 2019 07:10:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=e4fOWsD68+cnUWiN260cGOynhW87TdKmLEWtHghSPt8=;
        b=lXYNLIPCquLqDScs/OZe3gyKLnSOwBTne9eY01rdCU+rfKuXFkpzt0CUlNnB87hGif
         8XuPTenNKgMcdoTnuVDlc4TEhLzq0J3HWgPaxnBriaqR9fHwkDS+8GD8yYgUHUPGVzrF
         E4BsEQDQityl3t9vRKWy8mZ1V/NGfBtthzeVQjGEcEqHZTRF/aAp40CN+v2w4I/ZLCwA
         6ktqUDhXvdmicUc/pEUK7tSnG7XE1oedfVCNh5BFAq8B0ZAxdnDXmGr54pZzsmTfIufN
         1n9tDkTp8mdTpCMrlvXmE94r4c8c0uoWD4tlCmCaVT3+/uChmUqcNvnMTA2sYxGqcW7p
         yohw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=e4fOWsD68+cnUWiN260cGOynhW87TdKmLEWtHghSPt8=;
        b=Tz/247Mo5ZhZiN8ig+T7tZn/EVNFxy5vF670+oW3vWYIxWhRmKYM2ZmWfOFUos7KO2
         FMppPASYGOg8lzrPiEfPJRAMo+UZRnCaeenahLI1oofDjs0HMVWH0nq1zDCMHy/TsZlR
         5cOvt+XlPXkwzsPmV3WujqFgmg0R8053jPXCTkzlrgQo1l9ww2N7PdSbyG+N8u14GlnO
         4BX4Ap3+QFH1fz4zHs/pU3u3mMArWNhB8aamV+Lpvubbm+IPNzkbXI+4ATJS95++msrp
         L+7CPQR4+B7K5QZXYclUKsjOFiv1SwfENCysLdXXnwT8JdSPzfJ3NxPr+b/Zz4+ooRR4
         siRw==
X-Gm-Message-State: APjAAAWisjr3SiGYPdwuO3cqNmsvKMd+BAMyXRGOe0jfKUSmwD8V1Wzs
        O+gQ7OBXssIlvxdcy3Nr+7tFbCejAaVn+nq05EXs5G8COe4=
X-Google-Smtp-Source: APXvYqwjQcbrRrK+W75WfEe7UAQ7JTy6kVNcDAun2NU60tU+bgtO/nGUFzXzAhWb7s2g+nFzGQEV7HxcPJ11eKGf7lk=
X-Received: by 2002:a2e:868c:: with SMTP id l12mr9865064lji.194.1575990608131;
 Tue, 10 Dec 2019 07:10:08 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 10 Dec 2019 20:39:56 +0530
Message-ID: <CA+G9fYtDYJN2XgFfH6439Wc4+GGDJ1R0A7adFvAJbdiMzPJX5g@mail.gmail.com>
Subject: linux-stable-rc-5.4.3-rc1
To:     linux- stable <stable@vger.kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
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

kernel: 5.4.3-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: 2c14cfb654dd93746ebbc348c0072564690981f5
git describe: v5.4.2-81-g2c14cfb654dd
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/bui=
ld/v5.4.2-81-g2c14cfb654dd


No regressions (compared to build v5.4.2)


No fixes (compared to build v5.4.2)

Ran 19727 total tests in the following environments and test suites.

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
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* network-basic-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-hugetlb-tests
* ltp-mm-tests
* ltp-open-posix-tests
* ltp-syscalls-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org

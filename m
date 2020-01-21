Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 215851435C0
	for <lists+stable@lfdr.de>; Tue, 21 Jan 2020 03:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbgAUCpx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jan 2020 21:45:53 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:36529 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726890AbgAUCpx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jan 2020 21:45:53 -0500
Received: by mail-lf1-f66.google.com with SMTP id f24so930781lfh.3
        for <stable@vger.kernel.org>; Mon, 20 Jan 2020 18:45:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=fECX5OaG4TM2K958PFAXWPaYhzGMse1b9pM3X8LIbn0=;
        b=nDgFDjRGzrvOH1tY8VsvaZdh6hkup1imNrSEmU5u15rXAC5QER+JCNQBKmk4zGt1tY
         rBi+KTxjx9a+V8Olqo6vUaIeCG0SG0/NxuSmonLDOvL5UlKHcId7dUWGjalTbCCZ5Ew1
         1DOWH8uqn+oAqn0t0KRaw64nsPUlw1+5tk85ygfuCIVkPYVhjNRDKajVxsiqwXYCQvAw
         he2QrEFxLpb8n1vIYADjdistZOrGoMH+gOVM88fC8QRysaNzvQn6pX+KKKAA6GnEvpjy
         2Dgm9LDGvaFqToCYMO4I4bEM8B6FsfbiQZio2qprTd18zfFEB5uOfGhmMdnpqAEfpWFl
         g0sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=fECX5OaG4TM2K958PFAXWPaYhzGMse1b9pM3X8LIbn0=;
        b=hZkrRbL48V10mcbeknrckT2jsNRoKA9EVIjm7ZXUfQ28Lchs0shAuTaPVfFiNCwi16
         eAvUEXnSlZeppru+okwJEwLrpsaIYpm6nWti7W5aKHquBCXTqzqMbBtJUFiZPPkRXZNR
         b4+oiunYoU+ErHJQIvI+psXbo2geiEJPuArP6VFYbt5EnTY+sEaUtEecwmjMtm8fYMN7
         7kAr4iFXNn5aF2OrKrCzhAqZ6I5ce9g/4Knw7CqCyeU2utoXuzLO8w4pDgEuV1mw0MwS
         sMsGf66pkqsCGhNLX2JbJn44f7FRsl42RTIkKKXhIWhuSN0/G9Veoef/QI4gqgMRHbP3
         uByw==
X-Gm-Message-State: APjAAAWwOK4vSCgMW5OobqGqoLP2rpS2871Gn6FrOBePPVUxxtfPtQ3D
        NGb2sxUGciKZRQ2tbEwY6aF82006f9agthN1jkv0BQ==
X-Google-Smtp-Source: APXvYqw7B0mu4Uv55JJ+J1FcCQuavDSPGC6ibyrLEo4yGUBvSg/eix/J45Kbv6O+onwUoWe4Z4y0T8Uf8UsKSXD+Kdw=
X-Received: by 2002:a05:6512:64:: with SMTP id i4mr1286593lfo.55.1579574751538;
 Mon, 20 Jan 2020 18:45:51 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 21 Jan 2020 08:15:40 +0530
Message-ID: <CA+G9fYtnB5v8rM9PEj7w9P31xDfMv0kzV3rf-1CbZczyE=JqtQ@mail.gmail.com>
Subject: stable-rc 5.4.14-rc1/0c9293cd7435: no regressions found in project
 stable v5.4.y
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     linux- stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org
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

kernel: 5.4.14-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: 0c9293cd7435931b5a09621105770386ac189335
git describe: v5.4.13-136-g0c9293cd7435
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/bui=
ld/v5.4.13-136-g0c9293cd7435

No regressions (compared to build v5.4.13)

No fixes (compared to build v5.4.13)

Ran 23702 total tests in the following environments and test suites.

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
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
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
* ltp-hugetlb-tests
* ltp-mm-tests
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org

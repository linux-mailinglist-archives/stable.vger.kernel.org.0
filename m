Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64BDE1180F4
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 07:58:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727119AbfLJG6n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 01:58:43 -0500
Received: from mail-lj1-f174.google.com ([209.85.208.174]:33234 "EHLO
        mail-lj1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727004AbfLJG6n (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 01:58:43 -0500
Received: by mail-lj1-f174.google.com with SMTP id 21so18620788ljr.0
        for <stable@vger.kernel.org>; Mon, 09 Dec 2019 22:58:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=feb9SM247Rr/XNo/mbJAl3wHHizAkCEwkvHW35EoT90=;
        b=bPjp7NxUktXOYZPhQdsZJAQ4KfWF1XnoaIOyFuiUo+KBjvw/ydLVPbWxDlo0o09nfD
         cXRuwOzi/bnxka9NSZr1lOwVa/xIid09ubXHFOXscIu7atvgnA8sUCIpiQVIpEhv3I5i
         IyUN7DPNQeWnphQgS2HELc2m4NSBfl0uhj3NnwYe+SaPYBCvrsnoQ3PDVY3Yv6DMdxkv
         rPRAxj+UdpfM5kIzCq+jzCvybHxOFQ0b4csaPQz4J5AKwk2in+nOJWz6QLiLn/Z4H6n8
         u/k3782lRvjpbNJ+r6CSoITB+EQaWKRMBezg1EJn/vUaRK9GZQni5wilNaUmlo35dVWB
         P3WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=feb9SM247Rr/XNo/mbJAl3wHHizAkCEwkvHW35EoT90=;
        b=j4YySr6XtzZq4cXup7KR3wUtCpaHj/JYyfrvIuD7x5B4qIngyA/NCldX1KntT9B//Q
         BMv8HWTNP+HOV4rG0bFhuB/GP6fjzfJafSRLODsJY9GdZp53Rkt4G0GI88nIbzgs22Uq
         VGf/rggjxfTHIerBdY9ftnRw+jP6QYFtgVWAOVnOZQ4CO5igk4ESr/e2CEgl3QnCjP9d
         hzgVscB3jqYB7ZssrG1J27AivJWvjHWvjISTgT+ttENM1X/qU8MrBu9asf8+SaQqNlDr
         XQdovZCfogpqbNajLV7ikSTziks7RWtrPwMdnGEk0QDeFI44tWbBot9mcOQJFQCbedc6
         UNIA==
X-Gm-Message-State: APjAAAUB3Lv3+LlYJauXlzhsaUSN0RqOcdj1ATGhfjyxSwdwQhHYrlCp
        Y1v4p3lOGLpsPLvtFQ1TsxrqS05DVfQ1Gx9TOWSf8jeeTvs=
X-Google-Smtp-Source: APXvYqxRogc51tV5KnNSfyptTqXlNZAgvJr40866gnj5QPrX3XEh22ODqNbl9uFLwxWf2mcHlovW7f2T74qXQ60fUrs=
X-Received: by 2002:a2e:7818:: with SMTP id t24mr19948925ljc.195.1575961121060;
 Mon, 09 Dec 2019 22:58:41 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 10 Dec 2019 12:28:29 +0530
Message-ID: <CA+G9fYtkphb7FrHmuH1VyQ=HkoiwgcM7=NYVp6zEiUxkHTF0og@mail.gmail.com>
Subject: linux-stable-rc-4.9.207-rc1
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

kernel: 4.9.207-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: fcce4e2ef50facc12c163a573e5723f22cbcf194
git describe: v4.9.206-91-gfcce4e2ef50f
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.9-oe/bui=
ld/v4.9.206-91-gfcce4e2ef50f


No regressions (compared to build v4.9.206)

No fixes (compared to build v4.9.206)

Ran 20399 total tests in the following environments and test suites.

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
* prep-tmp-disk
* kvm-unit-tests
* kselftest-vsyscall-mode-none
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org

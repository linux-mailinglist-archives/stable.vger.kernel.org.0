Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B181014C5AC
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 06:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725816AbgA2FYN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jan 2020 00:24:13 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:36515 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbgA2FYN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jan 2020 00:24:13 -0500
Received: by mail-lf1-f66.google.com with SMTP id f24so10935256lfh.3
        for <stable@vger.kernel.org>; Tue, 28 Jan 2020 21:24:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3LtlN808L/eCSbIBoZuFWZkXYkhY8RQIoVO6UQH1e2E=;
        b=eAcfRzxtPLrP35bNQsSw+ImsilucwpYXka/5rc02WJqVXvNR2JDnLBaZddzjpcCMQX
         C8fAPpxqinvkP/iFe/kOsxYl2QLNaekJWsrDszFbilfj7emdGwvAQOStzJH5PHGJ6Wmb
         5g1d6PGvnwrPsWHtYA6uHy38CIvBUNXDspgUgePniIg87yEHTdkJiXF9s7UatU2I7Wz1
         XS3zwMWSuvY8jnDgrUO5KQi/fMeT/ND0TrsBm5+m/Myy/z9jzxnX38L/mp+JvXJtjdiR
         f2xWkL2nCEQc5z/INZqAOrAkqGv++EGWgOtr6PsQS8aIhd2+iJs1/rTI1ODlL7hYnEHX
         uoaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3LtlN808L/eCSbIBoZuFWZkXYkhY8RQIoVO6UQH1e2E=;
        b=lzs6UtG5J2iGz68clM4wUbV+jduTrefzOvjUwRVLmlWX7qPkdazFodHqJ1B/ZYRfJf
         5Sa3koQvGVjTDSk0KQKewQBgC7Zy2t7XMF7OylRZi/xuRkavvBUIl8c4acz4Co9DteD2
         2mvRgKW+6SNmF5+C0TFxc31Ec8t5QRoWB7/9bvMecxcTaNOprKixgmmbcu2QG/IKDI5l
         /1Opbd8miQmdqYjrmzzxPJKkTohVmFhY0sP3mWdZwF09/IHZngT10o7MkXAasEPkfgqG
         4QyeqSRQBO7nV+CcWhJ+HUTBbX3lT4ZwPvRscE+ymuLeChFeAFvK7jqRruLWlKOnI9Ta
         hujw==
X-Gm-Message-State: APjAAAVfiQCgjYELXmY9h5ibXyD185DY6fF+Z3dghsIMPhcBaouiCRRl
        ywrdRhORQNF3rjK/B44/7v3vEbIppK9sCO/TFkkmRg==
X-Google-Smtp-Source: APXvYqwwA7ZrSqc9LfOKonkJ6y8BQLNlPN2DFVLvqiuvKtRb97MAB9TuY4RqV1wSfz6TdIpOCtcbUgcRA0i10VfcdC0=
X-Received: by 2002:a05:6512:64:: with SMTP id i4mr4470456lfo.55.1580275450572;
 Tue, 28 Jan 2020 21:24:10 -0800 (PST)
MIME-Version: 1.0
References: <20200128135829.486060649@linuxfoundation.org> <20200128175119.GA8176@roeck-us.net>
 <20200128181435.GB3673744@kroah.com>
In-Reply-To: <20200128181435.GB3673744@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 29 Jan 2020 10:53:59 +0530
Message-ID: <CA+G9fYt66SB2RtYz2uE=5tDKJEtoNLRjvocUv60NgN0E-SUJZQ@mail.gmail.com>
Subject: Re: [PATCH 4.4 000/183] 4.4.212-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
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

> Will go fix this in 4.4.y and 4.9.y and push out new -rc2 trees with

This is 4.4.212-rc2 test report.

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.4.212-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.4.y
git commit: fc5b03776f2d3b13543520d5a61a0c56ee4d1a5f
git describe: v4.4.211-184-gfc5b03776f2d
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.4-oe/bui=
ld/v4.4.211-184-gfc5b03776f2d

No regressions (compared to build v4.4.211)

No fixes (compared to build v4.4.211)

Ran 18829 total tests in the following environments and test suites.

Environments
--------------
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
* ltp-open-posix-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* network-basic-tests
* perf
* prep-tmp-disk
* spectre-meltdown-checker-test
* kvm-unit-tests
* v4l2-compliance
* install-android-platform-tools-r2600
* kselftest-vsyscall-mode-native

Summary
------------------------------------------------------------------------

kernel: 4.4.208-rc1
git repo: https://git.linaro.org/lkft/arm64-stable-rc.git
git branch: 4.4.208-rc1-hikey-20200101-645
git commit: 45aaddb4efb9c8a83ada6caeb9594f7fc5130ec3
git describe: 4.4.208-rc1-hikey-20200101-645
Test details: https://qa-reports.linaro.org/lkft/linaro-hikey-stable-rc-4.4=
-oe/build/4.4.208-rc1-hikey-20200101-645


No regressions (compared to build 4.4.208-rc1-hikey-20200101-644)


No fixes (compared to build 4.4.208-rc1-hikey-20200101-644)

Ran 1568 total tests in the following environments and test suites.

Environments
--------------
- hi6220-hikey - arm64

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

--=20
Linaro LKFT
https://lkft.linaro.org

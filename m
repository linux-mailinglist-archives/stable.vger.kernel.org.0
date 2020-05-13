Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8191D0C8E
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732530AbgEMJoX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726532AbgEMJoX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 May 2020 05:44:23 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B7FAC061A0C
        for <stable@vger.kernel.org>; Wed, 13 May 2020 02:44:22 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id a4so13053929lfh.12
        for <stable@vger.kernel.org>; Wed, 13 May 2020 02:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=RoLkUNFxl44rQsAAaaLWM4h2o93P54V/VDyS6ZJtpB0=;
        b=fhLZPTMZCSNCpnwPT8h7NHvn2rjVXU/f7yLuMmU7G0KEBg6ZR6L/nV7HfN2IQkJKGY
         DBmN0Hiz3qI2JFZJ9nr+NZRe3XQA2R9Ygd5Z1IqUZnYXGuxaE4Ti0leFPSg8MKttLTty
         uySr6/+ZE6uAhyhXVx1bAb49WZURJOKoV1dgdRC/UiMbV5vpC7cnB6rTdOyB1GMg7584
         2ExTdn+8Og7rzAhrgN/6Jk/H7+vd4De1nNuS2GGH15mWXkP3G42kLEcMDoF9h8/rUj/9
         A/goNr7h1remTsfFg48K2zqrMGRpL050VxKnFqh6kDOrthf1JALJTOb3mQGnuwtYjZld
         Yqpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=RoLkUNFxl44rQsAAaaLWM4h2o93P54V/VDyS6ZJtpB0=;
        b=IPwy5zzSm9BGs/K3rEhSSWmmCUpZBfs6ai2RMTUC3YFow5im5ghQ3qr/T/y5L9lv9O
         aG4ItMQFTLS8IPxNOueFKHOfT8dT022MQE3lfCOi5Q6DmgAxcm4HyXDSvBk/5D0Dg+23
         5/KTtaNCPptYGk1sHxXTlvmi3oL+e6NkT7OZVCsdV4aJ9G2gKobjtRaGQjd0eRNz8K/Q
         HnTzm+TFajdldmqJk/o5NEzpkxufKPWR4LhCLzbHANFqujCgehIG7jXXuvcLu8MBPr31
         QH8rTX5Nj6JuaW3w8qRWJ/VSSVYnQulI07LDbefmVnQbjDKEH3oZvzfTP973T7mrFVRK
         1SaA==
X-Gm-Message-State: AOAM531Db+S0XnI8sIVFAaecngj1hypYcMNTNkdIyQEqs1V3nhVPvVHK
        Zpfshy/ksocAcf0yldM2E3fT3tEKJA73FH3v1fCrxwWPvcRY9w==
X-Google-Smtp-Source: ABdhPJxbUEzgXP+9pDol0glFC29phpQEYNvu8auisuoYBGexDAuhxN6FVr6V2SYMVFQNlNVKoQWF91DgrpgWLHm0G8M=
X-Received: by 2002:a19:40d2:: with SMTP id n201mr17379799lfa.82.1589363059789;
 Wed, 13 May 2020 02:44:19 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 13 May 2020 15:14:08 +0530
Message-ID: <CA+G9fYtzKp6BTSTMECffK4TgQ1ycX53yga5igdeAaD3niVgzBQ@mail.gmail.com>
Subject: stable-rc 4.9.224-rc1/6dfb25040a46: no regressions found in project
 stable v4.9.y
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

kernel: 4.9.224-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: 6dfb25040a462e890aebd5342dbb6878a3b0177c
git describe: v4.9.223-25-g6dfb25040a46
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.9-oe/bui=
ld/v4.9.223-25-g6dfb25040a46


No regressions (compared to build v4.9.223)

No fixes (compared to build v4.9.223)


Ran 28134 total tests in the following environments and test suites.

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
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* perf
* v4l2-compliance
* kvm-unit-tests
* network-basic-tests
* ltp-open-posix-tests
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

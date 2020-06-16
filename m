Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99ABD1FABF1
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 11:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725911AbgFPJKi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 05:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbgFPJKh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Jun 2020 05:10:37 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25F88C05BD43
        for <stable@vger.kernel.org>; Tue, 16 Jun 2020 02:10:37 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id 9so22634479ljc.8
        for <stable@vger.kernel.org>; Tue, 16 Jun 2020 02:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=xeKp/56vUSbA7wyeIB0Lcm8buCbBZuyWW82UjpHlOO8=;
        b=z8lXr/oaT4Avbd0jpDo/+r9XStLwjH/ojbMMFIXnGVQ+5SZxeP7TkoofqrUaQI1szq
         zcJKCJZR2WCNtyRHNGiZZaiiCv85vKFtmPfZB+zHSC56dIbM+zwbZQiQNBEu70bGrnRr
         HLASvjyW6Ax4EbQzxZVW5Tkle55tzaXdgDMesYhgxZcWuReF3DZUiQo3snHqGE313Dnj
         IOS0yi7SODpwv40iFDgrhIZYWNs6GC6SFOd7y5bC6C8dTtO3nHNq8tliKm9W4UrosVh+
         nY3PlySLqwRAf48KmRGc7pgJcuX6BeK7OarIugubcGfAWwmV7q2D0mLBrSujzSFH7JSP
         i7kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=xeKp/56vUSbA7wyeIB0Lcm8buCbBZuyWW82UjpHlOO8=;
        b=LzGV8aba3xXRDkTPZPOR81JEbnFIMhN45z9Ca/dN2nH8s2LBid/VICLZ7p83XGkQQW
         UwhrErs00dxFm4WxM2S7jvjB5M9ZMHyjpqF6sn3DOVGCb9THf9z7o+wwfBOhsGXQh/gM
         JRDaO5GkLUIExWGrnVxElLD75/uV1YSSjjUjIfeo2aKm8TNCRy6YEMrFprnXZAXyxirI
         vS4lhd8pVKF75yv/B17clW2aVqIiTnz9mygcFNlSsWs5HCwJawzXYBDhMY24knhmD8qN
         XDI29Zbf/hhEzbEwzDUF7sevEbik4VCtPID2jaWPDfqJh55lDkyMKr4wbAuPMa9LFTcR
         57NQ==
X-Gm-Message-State: AOAM53375wiVZ/j762y1snIwgrb1FM4/mVdkihW7yp+Fx0WLAsA5WC7W
        tfy2J0I/ztQ9MXNC3kDD3EoYAK5lPIzOR8wwXOZrcxR35Rt1cQ==
X-Google-Smtp-Source: ABdhPJxN/zJOu2T5gDYBUOuGE+X2tmh0edZwHM9yB0ljZHB8wELoJNnoiTLwR/STTBt8pr3XkKpl+I5RzGfyAj8q+OA=
X-Received: by 2002:a2e:974e:: with SMTP id f14mr899433ljj.102.1592298634783;
 Tue, 16 Jun 2020 02:10:34 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 16 Jun 2020 14:40:23 +0530
Message-ID: <CA+G9fYtKQWup-XvW0taa4AZqQ4Bb7MBnt5n7wqNZ1T1xnn3hxw@mail.gmail.com>
Subject: stable-rc 5.6.19-rc1/d73794b63b4e: no regressions found in project
 stable v5.6.y
To:     linux- stable <stable@vger.kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, lkft-triage@lists.linaro.org
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

kernel: 5.6.19-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.6.y
git commit: d73794b63b4ef9b4bd884d4e00d1fd78679a74e0
git describe: v5.6.18-104-gd73794b63b4e
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.6-oe/bui=
ld/v5.6.18-104-gd73794b63b4e

No regressions (compared to build v5.6.17-42-g1bece508f6a9)

No fixes (compared to build v5.6.17-42-g1bece508f6a9)


Ran 34859 total tests in the following environments and test suites.

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
* install-android-platform-tools-r2800
* kselftest
* kselftest/drivers
* kselftest/filesystems
* kselftest/net
* libhugetlbfs
* linux-log-parser
* ltp-commands-tests
* ltp-containers-tests
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
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* perf
* v4l2-compliance
* kvm-unit-tests
* ltp-syscalls-tests
* network-basic-tests
* ltp-cap_bounds-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-ipc-tests
* ltp-open-posix-tests
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

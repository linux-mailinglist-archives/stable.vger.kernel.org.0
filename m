Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8683C1C3220
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 07:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbgEDFPw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 01:15:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726578AbgEDFPw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 May 2020 01:15:52 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F187CC061A41
        for <stable@vger.kernel.org>; Sun,  3 May 2020 22:15:51 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id e25so8372705ljg.5
        for <stable@vger.kernel.org>; Sun, 03 May 2020 22:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=cwqbllBIWL3ZExSh1bV8P6amAXmG3PGyqnfloiJkBps=;
        b=PSY/c4MRDcZa0mLzcdxMiot+ZTyEBnoCvCmfgTsSx63WMVoB6NCbjyUBHgI/WxROL9
         ffjJpUVVLfFULppbVbSaXlaLlVNO4Gqb70WUwR8ZkSB3bHdYoK4XzJG78DnzFj5EhXdz
         pKn85G/45ndAPW4DavWkLHNzEbjA1PHWXGhg1Y+kebQtxFs1lsO2qXpYo0i67BVs1u26
         jRc3AzAQ9LrGpswMEW07jAA4B8N6d6yDF74x4D8qmc+BPjvlAkTC6w8mqkhsgeNfa1fm
         UWn+H+Jk1o0dCIUBwn0z56J/sqP2Y08p5Oll1MJVShInASW1uyqCelyglINvBIB2jU5u
         9kFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cwqbllBIWL3ZExSh1bV8P6amAXmG3PGyqnfloiJkBps=;
        b=r2la11iXEEyD+HBDIOU1XBvd3DQ4/1KEh/K8kptQsFAEgW6Gs0wFZ3DI0chZ8b5lBm
         qBESrRJ3sNoaIPP97pYCijHBSa7utm0Rolv3s3Iao1KPD8CYndvokBJq6qeRQFM2eL12
         MNfWYRCHH5F50/rawfPrCh/itbkZxmUrB57c5e/W87l3S4lh+QEkJ3VSvxCuK6CLkh/a
         bvuskoeMOgjpldbFAAsX5q5ldBTakb3cqL1H2KtKLYgJhcjvW8yNwRgrEYItINQgGKI/
         aT732J1vUIEy35/mO7vQs99mNVtIUHy2v/7JEARqp5Q/KZVaDqGVq10PHGo0T9n1ovie
         8njg==
X-Gm-Message-State: AGi0PuZvz4vRT+DVVKhv69+WABMfVZ2Lj5q6e2efrHyL9YXvQLP0PDg7
        1JAYCHaHPUmsQcqJ/cYHnmj8OAlHveurptGtaPEmTQ==
X-Google-Smtp-Source: APiQypJjy6oTVTf76WpYVJapBiroQogllDrvOa/9zHpITjmJyd6cUOzE4du4O5GpNg8QYzFnjQqQkmb6ayHqEK8VWvg=
X-Received: by 2002:a2e:8912:: with SMTP id d18mr9537411lji.123.1588569350005;
 Sun, 03 May 2020 22:15:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200502064301.079843206@linuxfoundation.org>
In-Reply-To: <20200502064301.079843206@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 4 May 2020 10:45:37 +0530
Message-ID: <CA+G9fYuXkHZCb8xtyxyiQJvckyvgnXLZx_q=-r242n6Zc9jEmg@mail.gmail.com>
Subject: Re: [PATCH 4.14 000/117] 4.14.178-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
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

On Sat, 2 May 2020 at 12:17, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.178 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 04 May 2020 06:40:34 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.178-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.14.178
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: 773e2b1cd56a17bab4cdd4fe7db12f2140951668
git describe: v4.14.178
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/bu=
ild/v4.14.178


No regressions (compared to build v4.14.178)


No fixes (compared to build v4.14.178)

Ran 27517 total tests in the following environments and test suites.

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
* libhugetlbfs
* linux-log-parser
* ltp-commands-tests
* ltp-containers-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-sched-tests
* perf
* v4l2-compliance
* kvm-unit-tests
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-fs-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* network-basic-tests
* ltp-hugetlb-tests
* ltp-mm-tests
* ltp-open-posix-tests
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

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27CF7B2990
	for <lists+stable@lfdr.de>; Sat, 14 Sep 2019 06:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbfINEDr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Sep 2019 00:03:47 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:43654 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbfINEDq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Sep 2019 00:03:46 -0400
Received: by mail-lj1-f195.google.com with SMTP id d5so28914779lja.10
        for <stable@vger.kernel.org>; Fri, 13 Sep 2019 21:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YAILvVmzVY+oyM5IyEQYcJFFrXuuvoLs9ijrxQktmHI=;
        b=JmImBwQ1Vp4B2Jb4vOOywPx9wvBR5y+XgxwR3Ebq3Pcp2p6xyT/mDvU+7CYeocP1ij
         Q1Djl2gFSTCWgaCBEqkB/PLzkF5kXjVZvts4tLuGt3ftCdSn+ain5tyAW5MkAVnjuqae
         Y9LlAU60K4YbWSMo7iMqZi0TRf1smTKTv63riz7R+YpkHiswLz5TMc9z6Oa8tmdOc1Ht
         GZgsDLKSy5zxUq0IGG3GpY8OBtpz95vpuNRBVHxbcKtRNEWN1eLfT9JNL+o7uLEteUgn
         /L7aVNA2dEHVbg/t+1nKTHMnuyuaXtzMcmTTa/LvOe2JejAq5WmWhBojHgjDURRMO6UF
         ku5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YAILvVmzVY+oyM5IyEQYcJFFrXuuvoLs9ijrxQktmHI=;
        b=hVEdAKfPnoXQemoH4FDsDqP6UpNO2kPTFW60zZmiv2YloJaKADCrZfmGxU+5vYZK4t
         hxhWHxZjeZZuI2aS5C2cctHzde2cf3BRhdV5HWSHiwDeco00HdakQEdwcVT4wifx2Lko
         mxy0l2VDd2kfReqv5D8UPQUZZQAiGKkMY4Q6r1bA+YPzbyGXH+k/IaQTL44gfs0/kZuI
         FNxv6pBveVMZulJ51pnhNNh5KyV4ssUL4ZGH9ErnuheCH5tMhZwhGGCkSodcgaRXXdF5
         la0p7sFIgFyzFKvTqHpwiD6TBF+vQJNgfzT5b4+4eg3FsX+4y41sQhLTfeBCoJFHbev6
         SQNg==
X-Gm-Message-State: APjAAAWTdVPFgQwSwS6rVHVUBIyJgfHx4CVvor57Fe5AYGVtUBhbsxh0
        agD57oIFpqDR10O6j2th33x2XmVLDA2R/g7A7qzyyw==
X-Google-Smtp-Source: APXvYqyraRF1vyvspKAKybvVT65es4fFVx5SweGoJhhYz0CW/T6qXqdzdu2iky7NeINrcLaK45T83GzcaTh8qfkTvuU=
X-Received: by 2002:a2e:890d:: with SMTP id d13mr5852243lji.224.1568433822816;
 Fri, 13 Sep 2019 21:03:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190913130501.285837292@linuxfoundation.org>
In-Reply-To: <20190913130501.285837292@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 14 Sep 2019 00:03:31 -0400
Message-ID: <CA+G9fYvmZViVnK2ZiOG1t1AV-JUyCNr17KzJevzzqrecizkDzg@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/21] 4.14.144-stable review
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

On Fri, 13 Sep 2019 at 09:11, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.144 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun 15 Sep 2019 01:03:32 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.144-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 4.14.144-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: 6073f0ee406c52baaf3625e28c631a33b20efef5
git describe: v4.14.143-22-g6073f0ee406c
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/bu=
ild/v4.14.143-22-g6073f0ee406c


No regressions (compared to build v4.14.142-41-g9ea9c62091b3)

No fixes (compared to build v4.14.142-41-g9ea9c62091b3)

Ran 23599 total tests in the following environments and test suites.

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
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-cpuhotplug-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
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
* ltp-timers-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-containers-tests
* ltp-fs-tests
* network-basic-tests
* ltp-open-posix-tests
* kvm-unit-tests
* ssuite
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org

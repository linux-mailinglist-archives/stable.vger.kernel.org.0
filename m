Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9485D334
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 17:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbfGBPoK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 11:44:10 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:37215 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbfGBPoK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jul 2019 11:44:10 -0400
Received: by mail-lj1-f196.google.com with SMTP id 131so17379357ljf.4
        for <stable@vger.kernel.org>; Tue, 02 Jul 2019 08:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=J/Zq9g98WhFnjJ6y9wBnnlW6K7Ygb2l9Rki+bO5sY+I=;
        b=Q8PZzJ3eZS8L9ysfK8C6aSAQh4HfqdNWbqXXILy/RbRM+y7YWs2Iw7KBgd9rkNKoC+
         HxLR7rGe4Iz3iDBYPicAmzpVXipEj74zq0pCzjftJKPn9b1SsdjNDpNKpy7hansSQry0
         FDt+5PL1G2DBHIhXyApvTjr+vaTqBBa/SqYKSAu9+N82t1otddwa9HjHPkhZMgRqHnkY
         9HRJCTh/hZpSjlyoz04GUG06eIbKI1zzPnTgEGZvCmmBZQ/bl7OZcOV7mhHhOSPRYWwl
         m4iOwXGXLClMW3mQ51tl7oDcDm11HjQn82vM/1qG612oQ5G7kW1BCKeXUafGDGguEFQu
         zufg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=J/Zq9g98WhFnjJ6y9wBnnlW6K7Ygb2l9Rki+bO5sY+I=;
        b=ZvBh+UyA8NnUyezMs1SPDrDlNM1+7yavNhutiwasPEk/AHDflKzyDA4t4HFFDcPCOn
         F4lt5o6EovjnSIoxzPXIv4v9ZBKK1YQzZPTrgLvQQ+5ZVtYyiAxfAIzAUtymSezde5w5
         Jt+e39Z9eZ4Q9rdcL8OIRQ6QHk3WiFhNMt0rwq7ORMlABhkWG97gT6/lp4fbl6iQjWK2
         5JsSf4xNVwZhnYyz9WFq49XATGvowb/QJ39UFgEfMc7Hd7x0hn8ajKsHbIPs+5ZSoBbK
         4p3XtA1KyFa0mf5ordRvho7PqRVmmL/eiuYRIETeDeDvNID3GkOhF26rZf3WhMEaFiMo
         8E/Q==
X-Gm-Message-State: APjAAAXK6Lqnp+wb7ZXozCxKwYRp9qA994BeS6P2zB7bEb4SMk070bZa
        /YAUxAotVWmFLGaD4+FeGgO/0sT45I4lT1Z229/GKA==
X-Google-Smtp-Source: APXvYqxEhb3B1z/H72FVDsDuHgIXwdXzYIWyPbk5VQgwkxwUTrr29cmyE4xym6p4R5jLar9LhfjCRBn3aaLaLsABrpc=
X-Received: by 2002:a2e:b0f0:: with SMTP id h16mr17941985ljl.21.1562082248436;
 Tue, 02 Jul 2019 08:44:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190702080123.904399496@linuxfoundation.org>
In-Reply-To: <20190702080123.904399496@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 2 Jul 2019 21:13:56 +0530
Message-ID: <CA+G9fYuKoCVAK7C4Urr_LpAb5KNFGusVELUYjVt3PMVU3+=K0w@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/43] 4.14.132-stable review
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

On Tue, 2 Jul 2019 at 13:39, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.132 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu 04 Jul 2019 07:59:45 AM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.132-rc1.gz
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

kernel: 4.14.132-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.14.y
git commit: 3734933c2330c5fe94ed2724033965b2eb545028
git describe: v4.14.131-44-g3734933c2330
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.14-oe/bu=
ild/v4.14.131-44-g3734933c2330


No regressions (compared to build v4.14.131)

No fixes (compared to build v4.14.131)


Ran 22541 total tests in the following environments and test suites.

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
* ltp-cap_bounds-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
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
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-timers-tests
* perf
* v4l2-compliance
* libhugetlbfs
* ltp-commands-tests
* ltp-cve-tests
* ltp-math-tests
* ltp-sched-tests
* ltp-syscalls-tests
* network-basic-tests
* spectre-meltdown-checker-test
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org

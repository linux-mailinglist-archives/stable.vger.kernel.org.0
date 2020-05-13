Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 905D11D1C95
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 19:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389931AbgEMRu2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 13:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389858AbgEMRu2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 May 2020 13:50:28 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0703C061A0E
        for <stable@vger.kernel.org>; Wed, 13 May 2020 10:50:27 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id u15so566910ljd.3
        for <stable@vger.kernel.org>; Wed, 13 May 2020 10:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WDWcfT3+toKvx/QbSYq3IfgLQ4Ag9VHbt7vkJOTIQcA=;
        b=M4L96kVZtACgifD95COKMoR3C+jvdmjC+sBw31DjcSMni2jSjPqbVDZXmKCvZ7dHXp
         UanAQ34EAiMCzsdTbfHc0cJKp14ulxUhphTgpvGdALVhxCZx3xsraOk8WPqxJtgDSHNx
         5fDgN/SsXGOWf5YWDxcTTdGaNmgzKnw5AAGbAOb7QXfE8SvZ10QLx+7+sG91v3hnp1K+
         j/wdnRepr+DnL+fsBFz+PDKDJBSBvS01hZVj26a3jEex6kS1JyQo3tDZ1y+RmGBT2rlG
         njzJcx7R8bKtfOEHe7lgq3hQaQpRlRfl4KeqIPEXNtON8ks64VhwcH04iUqUyHlWOVi/
         kYqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WDWcfT3+toKvx/QbSYq3IfgLQ4Ag9VHbt7vkJOTIQcA=;
        b=p0jLM58OWWdzSgRfvO/F8tBQTxH3Snkw1vZZOCdJ8BJT8jSavntnyFl0hC41ycNrNL
         cb//kEMnXH4doNuje/HiOJb0773YTQiFr2Od7WDfqJ9/0Z+7Q98TB21t+kbBM1vvHeGS
         aDk1S3E+JIkqfzlfUebh8dhmeBWuFtgvu33c5ROFc+23hDTe9t+G8kgBOKU4vvW5hXFZ
         IvdohWkQnxHnNig18Ks8iRewFfiVg0CJcDCJs5njf53C5DhNdfrqKu+X9HipwoKZidRa
         lIrQUqrR7nNeQLYDlezVLzfRQnO3m3Ju5xHgj7RuAsr+TUo0yoKI28GOzefsOMqgJA1Z
         Ceow==
X-Gm-Message-State: AOAM533+BD6PrK5IFM8H4yrNOBDnvGCidmXTbpsItIzc8yFprJCz8Cqa
        f/CyzbEZYvEAwgFe6jpvjRdhZaiZkDPCx2Iwn9OJjw==
X-Google-Smtp-Source: ABdhPJxgDxf7qQjQMeGUC3B8dc6vpIKzopfyn+EckbsQgbzzs9f5yjN6rt3ECaGWFNanWjOjvI20Bn8QebXGNuo7YSc=
X-Received: by 2002:a2e:8912:: with SMTP id d18mr160083lji.123.1589392225106;
 Wed, 13 May 2020 10:50:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200513094408.810028856@linuxfoundation.org>
In-Reply-To: <20200513094408.810028856@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 13 May 2020 23:20:13 +0530
Message-ID: <CA+G9fYufijvAAz9RmVybi_Aygc+R=5-BT3w772dhmYOK+4BuZg@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/90] 5.4.41-rc1 review
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

On Wed, 13 May 2020 at 15:19, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.41 release.
> There are 90 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 15 May 2020 09:41:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.41-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

NOTE:
While running libhugetlbfs fallocate_stress.sh on stable-rc 5.4 branch kern=
el
on arm64 hikey device. The following kernel Internal error: Oops: found.
https://lore.kernel.org/stable/CA+G9fYvvDjA5t+zi0Zyn2F6D=3D7aE-Gu-m13o47LXY=
YfCD3SvrA@mail.gmail.com/T/#u

Summary
------------------------------------------------------------------------

kernel: 5.4.41-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: 132220af41e6fd872e8c8d08d7b4e3a1b674f843
git describe: v5.4.40-91-g132220af41e6
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/bui=
ld/v5.4.40-91-g132220af41e6

No regressions (compared to build v5.4.40)

No fixes (compared to build v5.4.40)

Ran 33743 total tests in the following environments and test suites.

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
* kselftest/networking
* libgpiod
* libhugetlbfs
* linux-log-parser
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* perf
* v4l2-compliance
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fs-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-sched-tests
* ltp-syscalls-tests
* network-basic-tests
* ltp-open-posix-tests
* kvm-unit-tests
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

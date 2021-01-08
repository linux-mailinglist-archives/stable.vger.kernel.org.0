Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C67882EEE3E
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 09:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727554AbhAHIBI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jan 2021 03:01:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbhAHIBI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jan 2021 03:01:08 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A9FEC0612F4
        for <stable@vger.kernel.org>; Fri,  8 Jan 2021 00:00:28 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id x16so13331739ejj.7
        for <stable@vger.kernel.org>; Fri, 08 Jan 2021 00:00:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=QXjysu6y0pGBnxc+e5HtoTW8YRit8L8xxCUW1SnHWis=;
        b=YJsOhxKAndTG3Dz8uozNhqu+W/BGhCDkUbG8Ms/578ZrIe91qUSXkMNWhDl/hg++FC
         wFofv6qFygRjAqH+WB43k18Ce6J1W5jd4kF6zXgU8oo4U4WoMRHD6WqQKydaKxpOC8ZK
         /Ei+lUSQYOuHp/mjhRzWpsKAxlbdtbJAiKvl7kZCy4ZZHLHYQU1HN8e69mXINI049fMe
         CSR1akzqP4+Sja4Mlnvh44VYjXk3UFxKi+rFWUzYwYWcovCN1Y7ZClZabcQvXn1lSkrt
         aIlRZpF9uHPQXZtTPbbp4cK+zGOvTZE/3EBB7jxqbOv9lw7GoyuVr/UQpO7LnNxwFZ9A
         Zm6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=QXjysu6y0pGBnxc+e5HtoTW8YRit8L8xxCUW1SnHWis=;
        b=Dav8Bm1MRKg0ZDC3S6cNXoGWbNdR/wwbJ9Gpp1pC84ZfRIY62Y0oEam9ro2dm5honc
         +ywo0h7UMQ8pMuco9QVup6DlAs7N0sN+1bEaHJkrErGi+6YLvKkET/qI/MsN02fQGeMM
         X62ihf7rmfn/JxPEVbPoB7P4mCmKtjIyR7LQoCM80i3sruO6AtGmmdNu3MYTNH1NUy9w
         KASRD5n40Y+tHzjmrNx2UslqqKg0foM7/ZsQVs5HYI1LZeOgacWoYuNKvw2F7r6Po+11
         YfjWKn2PaBvfIRaVCxwew3HzmL0VKYy9SQayeyDbrPNJNawdN1twv4JJDstiBMEfnERL
         SehQ==
X-Gm-Message-State: AOAM531iyZB7kyX/n7UEDTgGxaeQIr91jot5mGD1evxpWkc9Cbk51E2Y
        /+CDU6nY4czNJvAVtntQGhYDeqMGqOIFyK/sc7+DdA==
X-Google-Smtp-Source: ABdhPJydtj2gBY0mQI+kfryVYq/vLMXDNsLBua2nwHP3pFitqpA7AiSUork7THEMxK0RzhX+AHQ5zssiRg78cyZ01KE=
X-Received: by 2002:a17:906:4c85:: with SMTP id q5mr1840518eju.375.1610092826861;
 Fri, 08 Jan 2021 00:00:26 -0800 (PST)
MIME-Version: 1.0
References: <20210107143053.692614974@linuxfoundation.org>
In-Reply-To: <20210107143053.692614974@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 8 Jan 2021 13:30:15 +0530
Message-ID: <CA+G9fYsB27gO+wQR6nJmNAXMy-xW4zja381RKZHJCuwJZWtbbg@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/33] 4.9.250-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 7 Jan 2021 at 20:00, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.250 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 09 Jan 2021 14:30:35 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.250-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 4.9.250-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: 15b2e80c9e2bc3a803caae7dca549cb7c9233ba2
git describe: v4.9.249-34-g15b2e80c9e2b
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.=
y/build/v4.9.249-34-g15b2e80c9e2b

No regressions (compared to build v4.9.249)

No fixes (compared to build v4.9.249)

Ran 38960 total tests in the following environments and test suites.

Environments
--------------
- arm
- arm64
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- mips
- qemu-arm64-kasan
- qemu-x86_64-kasan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- sparc
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* build
* linux-log-parser
* install-android-platform-tools-r2600
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
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
* ltp-tracing-tests
* fwts
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* network-basic-tests
* perf
* libhugetlbfs
* ltp-open-posix-tests
* v4l2-compliance
* kvm-unit-tests

--=20
Linaro LKFT
https://lkft.linaro.org

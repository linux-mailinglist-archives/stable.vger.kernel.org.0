Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 384D81EB601
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 08:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbgFBGum (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 02:50:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbgFBGui (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jun 2020 02:50:38 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F70AC05BD43
        for <stable@vger.kernel.org>; Mon,  1 Jun 2020 23:50:37 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id m18so11195686ljo.5
        for <stable@vger.kernel.org>; Mon, 01 Jun 2020 23:50:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7Wo7fT19tXyFFYyKiTjQy59VceiF2uEuq4cijfOLwUI=;
        b=v6HbjXlC9ACLtEvChrpt07F5wUIMbtYke18tLj+orBAtNKu8USAaquH/F/6ekNBB2S
         V26ZHcNrdOHLPESB1/b1jLtutPBKWANurqW6K2seSGzH735tuIswhGyoeyk64h9GEhNA
         iqOeYj9qNFbwzzTo92DP81rS4uTPJ11WKsL3lr9JPgmfcEztV9G/EC8ICl+oSdPT/GUA
         4hs8dpSia/CV0d0gUMkCA4ViWUrPXyOIDqcBF9f8Nv+K6ytdXf4kK/pzD1oRHlpU1ye0
         V/D3YRtlCvUDVShtAzS9GXgX0wQOUZqJceK6BlFkzVXQf0tHFtsX5Bo4FkT1NaKFJA+r
         KDxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7Wo7fT19tXyFFYyKiTjQy59VceiF2uEuq4cijfOLwUI=;
        b=On7N/k2H8MNT1y8rkdlVgxtM6nSby7e5ruNTSiAX+6YaZTNRJRmheCzTbGbDAcQyCn
         pIkfk1154AjSyg8zQbX6zHFO9OpqwqDhut+VDyf2PzRJHzcdAyqo+TrMFZ0AJcvipgnz
         C5LfYMw4aqBR6uxXAigEiZFJgytQVIqTnfaQcM9Xjj4eneDdfwbWJmVmKTTGKcIVMb4C
         J9Jrd47pZVzzgmRH22JvfxA1fy2NSjAFx6/6+B/q1bEeFg3u0IAnu50Dj/XF7xpe8Qeq
         +AqBAVcHl5r+ge/FzvLcgIjm2vaJ2SsWFV/EeTb8l6T6E59PZWEmmomnVRNOJmzTLQi2
         5TNA==
X-Gm-Message-State: AOAM532u8RRQA+6b21rRtOphzJtvtu619wMTaUH8UZjEGIgBywCUatlE
        s4xu4aSzfypGMoc+MY7bukhpvr9XXy0xR+7JVz2mOg==
X-Google-Smtp-Source: ABdhPJzUAYGiV7DKMjwbpS0prtxHtSvjG7yx11ItYL2IcE/iv4zlYWKgRA/5cWmCrIemKGgRUq7C8CoH0P5tax8hbvs=
X-Received: by 2002:a2e:9a4f:: with SMTP id k15mr9093168ljj.55.1591080635263;
 Mon, 01 Jun 2020 23:50:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200601174037.904070960@linuxfoundation.org>
In-Reply-To: <20200601174037.904070960@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 2 Jun 2020 12:20:23 +0530
Message-ID: <CA+G9fYvG6oy-KRj42-EaRK841od=4W8qrVpkoYEpS7fTT5Sh5A@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/142] 5.4.44-rc1 review
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

On Mon, 1 Jun 2020 at 23:36, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.44 release.
> There are 142 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 03 Jun 2020 17:38:19 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.44-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
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

kernel: 5.4.44-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: 1fd4226c4fe1a358bb8277e25ebb03950180443a
git describe: v5.4.43-143-g1fd4226c4fe1
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/bui=
ld/v5.4.43-143-g1fd4226c4fe1

No regressions (compared to build v5.4.43)

No fixes (compared to build v5.4.43)

Ran 31360 total tests in the following environments and test suites.

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
* linux-log-parser
* ltp-commands-tests
* ltp-containers-tests
* ltp-dio-tests
* ltp-fs-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* perf
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* network-basic-tests
* v4l2-compliance
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

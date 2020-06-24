Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE242074BA
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 15:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390050AbgFXNkh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 09:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389611AbgFXNkg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jun 2020 09:40:36 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21626C0613ED
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 06:40:36 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id i27so2554417ljb.12
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 06:40:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TTD7NjmzyKHTJZV83JdTRScKCdf2lfqn/Ppwzo4LdzQ=;
        b=BpaQ7c8+ii45qK+WaFepwQT/3OzrRlqBc93UJZa7Ziwc/XhRrOYkfFPJEqQ5HPDxEh
         0IJiL1ue2uCFrEsYVA3niH2Jd04SQQyPfP5SuUc4MmLcF1gZQ1zdib+Kz920NVBVMzUO
         jeP7Sqdg8FXw+fJvD1TVdxYXOA8MIfphN/C3PA3I5aq2OnQzcEehb6Y7GLuzJvlsGa/R
         rNSLhX1ww2V5tcacktmgGjyh2Ije31f1/AiWh9fJK41EISDEr9WPXizONfouqxK1hpAn
         fTw3ED0ZgqTt2Yqw0yBiz3nU7C33+hW/NkA9T8wn7vGE2MFAwDvRXzRzKfHv5dikca+2
         sVgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TTD7NjmzyKHTJZV83JdTRScKCdf2lfqn/Ppwzo4LdzQ=;
        b=fKfy2ZU5W2JKqrTDuq8ryhq8ox7xRDhX5cxl0v5HakNsOajW1V1qmoYwk4Rr/Js7Cn
         P1dh8pMKwaXC8L37c5+3/rq/PP/EBNXxQ6Q+/3zunhz7R2mbvCf387RHTM6yDMeCU9wU
         vABc/+CQGsa35WfcuD0Od8+r11Bj6pkFsdEPCG5KvO5/wjC/vjJmrnOL8LrJht/CTtmc
         Iwq5UKaa8XLZYh6Nn70o7WbDXx9yJ05LA1KCkT8kxj6VI7c+a9YvVT+Z0KmOllGQjKZ6
         sw0F/P0FargzA99fsZh8AAWKBJqH638Dgk7DpAMQd21YthC22NzKQsph0bg7qeqXy1c+
         TgRQ==
X-Gm-Message-State: AOAM531vDpuUjFgtItM7RYybNPC3ErTQEmHfsqj6sVyDD6RxfsmHaIMh
        Kiv326Y0T4WVE4LKX1QTnNE3fWdBLagwWMmAhhTPyMEn8bS6wQ==
X-Google-Smtp-Source: ABdhPJxeHITljzJW4eM+Yb0vDcfBE6HwOhJuqQposKyX2vw7S9z4/m5IVrZCoQ6Wx0bA7FahWahvcczbG2RH7IWOxvI=
X-Received: by 2002:a05:651c:318:: with SMTP id a24mr13396808ljp.55.1593006034289;
 Wed, 24 Jun 2020 06:40:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200624055926.651441497@linuxfoundation.org>
In-Reply-To: <20200624055926.651441497@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 24 Jun 2020 19:10:22 +0530
Message-ID: <CA+G9fYsF-+rnVFrDd=RngPOpWpvjKj=A0mAgnE-HAdEs=gEdcg@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/311] 5.4.49-rc2 review
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

On Wed, 24 Jun 2020 at 11:40, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.49 release.
> There are 311 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 26 Jun 2020 05:58:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.49-rc2.gz
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

kernel: 5.4.49-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.4.y
git commit: f7f0329304087129517c90fe7d149309706936a6
git describe: v5.4.48-312-gf7f032930408
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/bui=
ld/v5.4.48-312-gf7f032930408

No regressions (compared to build v5.4.47-260-ga9a8b229b188)

No fixes (compared to build v5.4.47-260-ga9a8b229b188)

Ran 34102 total tests in the following environments and test suites.

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
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
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
* ltp-sched-tests
* perf
* kvm-unit-tests
* libhugetlbfs
* ltp-containers-tests
* ltp-fs-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* network-basic-tests
* v4l2-compliance
* ltp-open-posix-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-native/net
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems
* kselftest-vsyscall-mode-none/net

--
Linaro LKFT
https://lkft.linaro.org

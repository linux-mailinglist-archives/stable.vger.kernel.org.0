Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9741D2AD098
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 08:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728234AbgKJHpL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 02:45:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbgKJHpL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Nov 2020 02:45:11 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D04E7C0613D1
        for <stable@vger.kernel.org>; Mon,  9 Nov 2020 23:45:10 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id o21so16080214ejb.3
        for <stable@vger.kernel.org>; Mon, 09 Nov 2020 23:45:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tIEVx9J7sAxB8dgvOxJcRL3Qv91aaLpMtBBcDV4ez+8=;
        b=za6F23BUcGLLOH3GAeEH1mbCMozYPWuAnDLfD0kDTuMY+AQinK9Qie2q4b80AbTKFR
         0sEvKat52o8U9SfSblgGXnis9jOOrMRfF4Z96Mr0wKcBBHYq/phbUmq1PNAlIQCF23/h
         iLkdEqspnIMXjNgn9oj1ezoq8uhyUh2qNv+uKEBdNjb4nH32F/9/AMZPo2HbfnrWt/0i
         F/z/KAlxecE6ItPdmj1KrVLXA0NHXkyLuD1maAiMZxBzpcSAQsWA/qrp59/miVtDNRqC
         o4MI1u9OPaS9SCL6r3yDnhU1PUUCOtsDQVShMdWbYFx3ISsLELc5So2FA1aj6FmQ3MG6
         JptQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tIEVx9J7sAxB8dgvOxJcRL3Qv91aaLpMtBBcDV4ez+8=;
        b=d39n5NeoIRgTGm6aZErAaI0/lwaXn6JClB5fVheCJGZgWpQSVHAvEKy3K6BFxti6qU
         jH+6+EHZljeaO/bL7/ruz5+SKYBEJavO8mJfCVhCOJd/oQRaIUQRAF68CZGG/98pKKwv
         99boGSnIc7+T6WQbtl7h2/vHfMaVkejqwkOcb6MSSflmJhhsYFtkVav5SPiekxH6iJbK
         XR2OuFbg8wEyiqAdZPJNIxAjZfWarFKPbayi/COWCWqyJh126IpkEJ4thPbfxiJ7AFNa
         mUjb/lUJRLCDIbbEG5Gj6zp33meBNYnKu4b4x1f5rVpIn7mKU1TCvej2sWhGcJVJY6eM
         IVEQ==
X-Gm-Message-State: AOAM533YX1Tqik7g9KJTdkdrAJUrlLTmZ+EEWNeLuDpNrYUH1UdEWd8M
        vRy9FwNixtkNkheKlF+zbC5e5N1xMvgCIfiblcma7g==
X-Google-Smtp-Source: ABdhPJxNKUXfulaBmk+1lqdoXRnK6dmMlRKFKjRAA93HN9RXzvGcL/DZJs/waAaJ08HGJadhPwAnfZoKba2ak0UZMv4=
X-Received: by 2002:a17:906:4742:: with SMTP id j2mr18486129ejs.247.1604994308945;
 Mon, 09 Nov 2020 23:45:08 -0800 (PST)
MIME-Version: 1.0
References: <20201109125019.906191744@linuxfoundation.org>
In-Reply-To: <20201109125019.906191744@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 10 Nov 2020 13:14:57 +0530
Message-ID: <CA+G9fYsQjHSukBtPbJJu8VyQEWJBHFTfox83-eu8AoRdENfKCw@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/71] 4.19.156-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 9 Nov 2020 at 18:40, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.156 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 11 Nov 2020 12:50:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.156-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
The following kernel warning noticed while cpu hotplug on arm64 db410c devi=
ce.
I did not bisect this problem yet.
WARNING: CPU: 2 at kernel/workqueue.c:4762 workqueue_online_cpu
https://lore.kernel.org/linux-pm/CA+G9fYu+KK=3Dhm1AmQ78GCCgQTwsRCzyA6WHYR68=
ozZBzp7USiA@mail.gmail.com/T/#u

Summary
------------------------------------------------------------------------

kernel: 4.19.156-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 4d10cdd4ac507ec787b8f4a1770b0c44350ff5cf
git describe: v4.19.155-72-g4d10cdd4ac50
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19=
.y/build/v4.19.155-72-g4d10cdd4ac50

No regressions (compared to build v4.19.155)

No fixes (compared to build v4.19.155)

Ran 35947 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- juno-r2-compat
- juno-r2-kasan
- nxp-ls2088
- qemu-arm64-kasan
- qemu-x86_64-kasan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- x15 - arm
- x86_64
- x86-kasan

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kselftest
* linux-log-parser
* ltp-containers-tests
* ltp-ipc-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* network-basic-tests
* perf
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-controllers-tests
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
* ltp-math-tests
* ltp-mm-tests
* ltp-open-posix-tests
* ltp-sched-tests
* v4l2-compliance
* kvm-unit-tests
* ltp-tracing-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none


--
Linaro LKFT
https://lkft.linaro.org

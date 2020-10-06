Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD7452845B2
	for <lists+stable@lfdr.de>; Tue,  6 Oct 2020 07:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgJFFzH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Oct 2020 01:55:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbgJFFzH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Oct 2020 01:55:07 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 769FCC0613A8
        for <stable@vger.kernel.org>; Mon,  5 Oct 2020 22:55:07 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id j13so9993855ilc.4
        for <stable@vger.kernel.org>; Mon, 05 Oct 2020 22:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+S6tydLurUDpfqqIJ3NPBxeMc9ESUmLJ3tmCFVKnprI=;
        b=ZD608extQCdAvtmJ1rP0yUNo2eff+7DJl+3Hu6wwzG3r9e2iCuKjYzY8e/eijynYeb
         qnLjOMxxFTQWrTl6FLtNGeXPk7N92wrSn4I/fCi51wQ2Uc5YCd52lspEBdatdEPZmrlJ
         OTTEcOzbxS1iYmKMYRRLBtv9164alYymgyxvd9B4xjNY99fnwKFrr3PXKwh038Wiv20H
         5APLtyla8fPoT1Y56bIbfc0mGAjgHvZI3JxYeNtJBOJBXzkAG06mVoWCmHJsu3eacb64
         aokeIAan1N1THB+L+L7nQuSnFanWUwIXycj+NogZ3j+ry441OhskIJqx657Dr7sXKwG7
         k3Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+S6tydLurUDpfqqIJ3NPBxeMc9ESUmLJ3tmCFVKnprI=;
        b=nJeYbUHEbOQwyYSWgowBs4fL9xjOaNlVq/4AMMLT882ts0RLx51rQ3twBrgM+Quai+
         ii7FxT62ZHTZBkKGVjtm6mtE2sy74jB6VpjORZ6OGK+kNZELFGG0ombgzoEHAsCJWJMd
         BI9h8fMOhQ3cfW+vIs8zUsgF6/uegW3Ug+wgTjuGXlwXCjqbGd7oi+r9+T+whSY+eBZu
         XEVRpUrF5feY551kViPV2izkpZnvfN9oLtoaK8yyQxE3lCkSPuwCLyUTR/APjrolbJI1
         GxgcJDJ0Hg5glYmdcBbRgCkCQ1V8VoeaWZfrP1BR9NGshdWh12plsJlvehQpuG7SDcXg
         QD7g==
X-Gm-Message-State: AOAM533KXbQerl9kz09Qyz93p88YQ8Dih7gdQ6Ue9DluqOEcmcTsbtAa
        9Ibb57DSdtnQD6s7OFFyJDajnJiY2ZY8lWkUYoU1Dw==
X-Google-Smtp-Source: ABdhPJzzXEZAOartKWIUk4VKYdsoe1JzVQHIZIo5H4Mw9qzgIoFd8v53NzrZnggWwFLGeAUfpuC75PT0N6jsyEwefj8=
X-Received: by 2002:a92:c949:: with SMTP id i9mr2297670ilq.252.1601963706495;
 Mon, 05 Oct 2020 22:55:06 -0700 (PDT)
MIME-Version: 1.0
References: <20201005142109.796046410@linuxfoundation.org>
In-Reply-To: <20201005142109.796046410@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 6 Oct 2020 11:24:55 +0530
Message-ID: <CA+G9fYvHOu8kJhRKV5GPJmnaE_x2mrnN6myb4G4YHHW-oiKD7A@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/57] 5.4.70-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 5 Oct 2020 at 20:59, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.70 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 07 Oct 2020 14:20:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.70-rc1.gz
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

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Summary
------------------------------------------------------------------------

kernel: 5.4.70-rc1
git repo: ['https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git',
'https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc']
git branch: linux-5.4.y
git commit: 7b199c4db17f19594dcf4d24cc26c8ddff8443da
git describe: v5.4.69-58-g7b199c4db17f
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.=
y/build/v5.4.69-58-g7b199c4db17f

No regressions (compared to build v5.4.69)

No fixes (compared to build v5.4.69)


Ran 34627 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- juno-r2-compat
- juno-r2-kasan
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
* kselftest
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
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
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* perf
* v4l2-compliance
* ltp-mm-tests
* network-basic-tests
* ltp-ipc-tests
* ltp-open-posix-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org

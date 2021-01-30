Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9B2730925D
	for <lists+stable@lfdr.de>; Sat, 30 Jan 2021 06:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233830AbhA3FzJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jan 2021 00:55:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233874AbhA3FwS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Jan 2021 00:52:18 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E524C061573
        for <stable@vger.kernel.org>; Fri, 29 Jan 2021 21:43:37 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id s11so13028199edd.5
        for <stable@vger.kernel.org>; Fri, 29 Jan 2021 21:43:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0yXVbLcOAHd620JpYUZl8moLbJpXg6jwgqVqoTUEGTE=;
        b=SovhJykjW1dJ3gfTEiRvaEepyxqGHAxl8nGb8TFdO++4F+mcp03jvH79d0jHeyKagA
         pzh5Ce5i0Hqi8Q4uF9Z9ksGSX7qS3JNYtzzg8nTtsfiFpAEzeFmrsjc/bviCsB46QUyz
         XRr+fYTFS/pLdSVBhEd3PyKfNDUjxmFXJe4pooHclNtwnIekK/VX+rOluNamJgBJxQKH
         PBZGy3E1jg+BE6g9ukxt9tsLqIvx4LFSXOTN92ZjXHqpOI5sw/U51KJvhTtAPRm3eBog
         P7gNvZ4bPdUGZvsIGBjtaP0Yu7thpnb/BrNkqhHI46sUC4u6UXX6MOi1Ibq7rVKJm3h/
         qpsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0yXVbLcOAHd620JpYUZl8moLbJpXg6jwgqVqoTUEGTE=;
        b=SeUJkP/WsVROU2iqbLXjeZwm+nArBKLNnnp88+wFZcdo+8JZK/dr61QGGqWCrLE2/8
         HpGB/8A8KI6RXdPb5MKfL0A0YCdqxDsy55MrcRoedKlgpsoHd2z2n+32vZbTvOs5nrI7
         8E7lZMoDm/26nj+gdhFc4XL0NT11xn3KGUwuAfBHb6AxC7F/dZWoc3OGqpizp7jpajyP
         6+/P1KWy7hlZ9MWQtinKzL4lbFjmOx3Z/Tl1dHVFH9jLUm73q0u3HNPqvcqeV/e8HQMd
         zjWcLjAPgf/+QhVdIsX/rfByNMjM1uGMNUW8i/6qVRFBFhmsQN8L2BEBukGp116FejAB
         AFvA==
X-Gm-Message-State: AOAM531SaxlB7zjT2VYVsiLxWAxkbVpXMT94FvO5vgeg8sQ9xikGyhjO
        J5goiGekywiw9KiEaHtmWePv+XR7PKhcU2pLLqPL3A==
X-Google-Smtp-Source: ABdhPJxYuUTZP4ALDIsIjPBje8YWvwdJ7FZAmf6/2yV12PcoDU/7rX0gFy4L+KwVk/U3J7ll1kwI1oCV9sGsnNzs6bs=
X-Received: by 2002:a05:6402:3088:: with SMTP id de8mr8571642edb.221.1611985416284;
 Fri, 29 Jan 2021 21:43:36 -0800 (PST)
MIME-Version: 1.0
References: <20210129105910.685105711@linuxfoundation.org>
In-Reply-To: <20210129105910.685105711@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 30 Jan 2021 11:13:25 +0530
Message-ID: <CA+G9fYvNt7c=DXUzC1QihQROyWy6Ao65qqc-oPRLUNt3GS8vRg@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/26] 4.19.172-rc1 review
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

On Fri, 29 Jan 2021 at 16:45, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.172 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 31 Jan 2021 10:59:01 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.172-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
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

kernel: 4.19.172-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: d36f1541af5ac2e86ea3548b7da2e962e4ef5266
git describe: v4.19.171-27-gd36f1541af5a
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19=
.y/build/v4.19.171-27-gd36f1541af5a

No regressions (compared to build v4.19.171)


No fixes (compared to build v4.19.171)


Ran 48448 total tests in the following environments and test suites.

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
- nxp-ls2088
- nxp-ls2088-64k_page_size
- qemu-arm64-clang
- qemu-arm64-kasan
- qemu-x86_64-clang
- qemu-x86_64-kasan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- s390
- sparc
- x15 - arm
- x86_64
- x86-kasan
- x86_64

Test Suites
-----------
* build
* linux-log-parser
* install-android-platform-tools-r2600
* kselftest
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-securebits-tests
* perf
* fwts
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-sched-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* network-basic-tests
* v4l2-compliance
* ltp-open-posix-tests
* kvm-unit-tests
* rcutorture
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org

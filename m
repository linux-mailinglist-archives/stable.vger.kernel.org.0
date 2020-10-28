Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBC429D823
	for <lists+stable@lfdr.de>; Wed, 28 Oct 2020 23:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387641AbgJ1W34 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 18:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387592AbgJ1W3y (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Oct 2020 18:29:54 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF48C0613CF
        for <stable@vger.kernel.org>; Wed, 28 Oct 2020 15:29:54 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id r186so713251pgr.0
        for <stable@vger.kernel.org>; Wed, 28 Oct 2020 15:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DFXhmhnE0HABF0BXWy7FPG6M7auqIQQvigvYJvceh4w=;
        b=XgxDaYlcXD9VneIWZ0+tEYxjrB075Cu/ikkDKfbLtF35LmwU+N/0bMXfOuzN0z2f6t
         m3wzPAjY3WYxaz8YkjDVKl7qcN6yumeH8d4dgpDXdJbiD0QfNX7ebYT2Ctf1GMLn3/WW
         BdKBZEw/mmum2r7fTvmbRUVO0asKpizsMNN8pKM80rPyeDyzefYm9f3KobmINHM9kg2M
         dgZeXHKZbS53M0KW2ifZwOYlDqH5QwSJbckbHlIFFtxqhBA7WBOGIM5bg56a/1/kXQop
         HuMcZ21r7E0Z7Nw+cfSvrL3INEjdBOOtnw9FFlWfjNXwNt2g392uE1iy+4tPGpIbL9Zm
         bxow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DFXhmhnE0HABF0BXWy7FPG6M7auqIQQvigvYJvceh4w=;
        b=iy/Qj/Eiesa53t21+996/1ewuDUyNPVtylZwZpq9hEVjLxDxznBstoAwd48AQpevtO
         bfvGih1ZKMAtuhy6ol4P0b5tFonMd+03dZNwEK0eTghZLvwwKFgts6GuiG/BJN89IAL7
         oqhraiBxF3IWmkEuOvdhZry9fOu/IcqpskvspQEHk+PSwyNPs3xFRPocuwXnVNCYZquP
         MpVDfEeR+Vhm4y2uCtLgpSyI5euJvbZhzVtBQ+12AIZjASdrJwJqRW25b0ALHiGtAwLv
         KO0yUXM0KMHQpM6lFVeoCvJRQeZPPMmVYE2r274AIY6Sfgt8v4fd4VjN5VkXRZ62Orti
         6rYg==
X-Gm-Message-State: AOAM531Y1KSIGR6r4Rw1lNBxevJs9nAyqe8NtwC6BBhhicrsGRtX3U1N
        ogZTfVXV/Q4zl0np06pcCcHw/JmVCLePPALi9U2ru0+kqHOl3B6j
X-Google-Smtp-Source: ABdhPJwsBNCa9tGNVxqh7UFIxLXZTMNgEfqLLnBSEU/1OZJL7n0MFXc/F3fsV7zd4kQ1GDw3rwoBriJ7AAh32Ay0TSc=
X-Received: by 2002:a92:9944:: with SMTP id p65mr4688477ili.127.1603874858750;
 Wed, 28 Oct 2020 01:47:38 -0700 (PDT)
MIME-Version: 1.0
References: <20201027135430.632029009@linuxfoundation.org>
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 28 Oct 2020 14:17:27 +0530
Message-ID: <CA+G9fYsP=i9aRDxSqAZM_BvXn3xRDFHEZLT3poomjZuCrgW28g@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/264] 4.19.153-rc1 review
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

On Tue, 27 Oct 2020 at 19:52, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.153 release.
> There are 264 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 29 Oct 2020 13:53:47 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.153-rc1.gz
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

Summary
------------------------------------------------------------------------

kernel: 4.19.153-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 8919185062d40d0559c701be480cc8fa547291ed
git describe: v4.19.152-265-g8919185062d4
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19=
.y/build/v4.19.152-265-g8919185062d4

No regressions (compared to build v4.19.152)

No fixes (compared to build v4.19.152)

Ran 28857 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- nxp-ls2088
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
* kselftest
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* perf
* v4l2-compliance
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-ipc-tests
* network-basic-tests
* libhugetlbfs
* ltp-commands-tests
* ltp-fs-tests
* ltp-math-tests
* ltp-open-posix-tests
* ltp-tracing-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org

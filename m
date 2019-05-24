Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F17C629354
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 10:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389281AbfEXIna (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 May 2019 04:43:30 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:43049 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389448AbfEXIna (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 May 2019 04:43:30 -0400
Received: by mail-lj1-f193.google.com with SMTP id z5so7913987lji.10
        for <stable@vger.kernel.org>; Fri, 24 May 2019 01:43:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2UGCpA22jrVv8p9U3LtnJYy4mTfB0OkTT5zNxTX9Y9E=;
        b=WhHqJhf1qkUGoFrvbntgMG9Vtkw0hDHAVDQd3JUXLi0k8UB+6RkvzcmMi8Mf+tlyt9
         Fzx3Rm70otucFLSGs8EdzagNeJQaaXvSRCbNXtP5FUOUuUiTo/RmPmkKgsQdzMGn/uez
         85sC67xAnXMroSY8YutK3NNUBorZS+9HShW7CgjxKJEirp63fNKdf/3eqs9d0OqpG0HR
         sHuCeMpEv8E5xLJ6hd3esDb0GemTWlSkV0CA6Sf9hbttrDeZQJVOhQns68JvbiXyBDG3
         J7LK9V5wPmGbRiozveCHAMDqjvNNosKRlXMEzblKSAHl3IqcV9eAJLlV5BZxqVaRuvuG
         miCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2UGCpA22jrVv8p9U3LtnJYy4mTfB0OkTT5zNxTX9Y9E=;
        b=R1S8m7YT2H5NkTRePw/quKEPq22lcKxjXgZJ0HY9LO0LcBCtjvJ9jN7bHs4FaACWa+
         WlT/9vEid8dpzeD1KqQmgLirgrOPavTsYlX9baO0frgGCtn3x+cCsyzTnwPJ4SFyAuqW
         iCgv0WEOkrsJZt/S2XfFUjgUxU7GxHb94EqObjyLEvR2aodSg/sPCPRk4q1Pbutw+xmT
         k8N8j1hvYBUwlDw1KueH26b861gwVfa82dOG6kE0P+YS1gYCl2klR0lxSDcojR8R6FYx
         J/nq7+LG0ZeMHlv+P09YGfvLSxeWh9ZZaKXBf9AJoPCCMETKco+q6486KFe2Ui/v5APR
         8lzA==
X-Gm-Message-State: APjAAAWnYYN8NvnMVFGVSmGQBPsKVBg+QdnBg5niHTg0PiJYaRB+9xNr
        Q+ZA7IBWT4ve8xgHmFWM1lhDgEkMKIkJ/EgmBtQH+fvXL1U=
X-Google-Smtp-Source: APXvYqwjnmSEo46KGBhe5MUpoaw6uYQBmbXj0jbIUPWSD6KRHce5EuNKpxV2WFvs1OI0U9nJGdmCELgxnrJAycaNp2A=
X-Received: by 2002:a2e:b0fc:: with SMTP id h28mr33659890ljl.55.1558687407909;
 Fri, 24 May 2019 01:43:27 -0700 (PDT)
MIME-Version: 1.0
References: <20190523181710.981455400@linuxfoundation.org>
In-Reply-To: <20190523181710.981455400@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 24 May 2019 14:13:15 +0530
Message-ID: <CA+G9fYuYgDB=ta07ZeQrRgEDwddQCmWpTr9N47CPEnWC5GuS_Q@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/53] 4.9.179-stable review
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

On Fri, 24 May 2019 at 00:38, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.179 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat 25 May 2019 06:15:18 PM UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.179-rc1.gz
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

Summary
------------------------------------------------------------------------

kernel: 4.9.179-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: f6bc31d8c3be3e5ab957341b3f99f8b45fcc646e
git describe: v4.9.178-54-gf6bc31d8c3be
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.9-oe/bui=
ld/v4.9.178-54-gf6bc31d8c3be

No regressions (compared to build v4.9.178)

No fixes (compared to build v4.9.178)

Ran 21733 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
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
* ltp-containers-tests
* ltp-cpuhotplug-tests
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
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-timers-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-open-posix-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

--=20
Linaro LKFT
https://lkft.linaro.org

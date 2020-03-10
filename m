Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 690F3180620
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 19:22:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbgCJSWC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 14:22:02 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:38358 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726414AbgCJSWC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 14:22:02 -0400
Received: by mail-lj1-f193.google.com with SMTP id w1so15313799ljh.5
        for <stable@vger.kernel.org>; Tue, 10 Mar 2020 11:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7vZbJT1c2zdJKrBYgeBuzI6/cPzDdz4bNcW0b9KW6sQ=;
        b=mcd1ru1k/rA5QbVMjAethD5PDxsMYc5kUarILozIBZgDfX8IH55NQSbome9iM1kiQE
         xNLkzeSPnpWTLCrAk19vSNFDoUhDb7qrqPmihZNp/rSzIxzhSHrvz/4lWeviAonUe6zW
         M2Cmu/DYteUI+nppQxs2GG6ewJ+XeG9dtq+g43EN/EeeGzYrdG255RNBz1sjPzFaAhR6
         SGUiJ/I3vg308mIlqW41diRlTo8CDHnFRslH4rTGn9yH113XMOR4JmA6z5hOpRJsb6KK
         0SOoP4JZskCjJDXQLNVIt7Bpf2gJmYrAcqmztynHCLSFjtmOpnaiL00eo3DG9ntGUObh
         T5ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7vZbJT1c2zdJKrBYgeBuzI6/cPzDdz4bNcW0b9KW6sQ=;
        b=Xj7jeX20xurrrbfeKfSnNxam1Wy0497BVkROCOPFrusCOgWigmtJodz4SylNkGYRBy
         q+lYqv7JOlKksSPJg3/exTVpBmym8YMrSH1ImVle7eT6ZFWphCNOWuTKKEtFUDEA5+Se
         KzeJ5fi+eTvA1LsaUcIDiCkRcFVeyx60zvt2DDZtXjspCCq0Mfbd06UpXKJx8XFGi6ld
         5Y/U0JogOyz8UWihCGbMUF1vsr7W+845YSUUeiYzo5hcQ+ACtgiJyHXKXwH9TcqmmkUR
         APn2uLa6HNEMcHSUgXwi9dkl6IN73TtbQlZu9DCovQH0YnLqFoPg4e/ckhjg/T2346SA
         CQ+Q==
X-Gm-Message-State: ANhLgQ1MadOJO36g49YmWRMTpRAXuTtbGPfKVWWZ0AuLPpqQNpoUbBeN
        NGsbgvLBsZGLFXV51+N8/FQRrP9dKPMyqYEH98YBEg==
X-Google-Smtp-Source: ADFU+vv9eNtvt1X+rjAfWW2hJ3ArS5kACXlRbrqsh6vYPLgHYjFJ5LJH1QmPWo7sfbutJJHVIdNAn5ArR1my6OH2xwo=
X-Received: by 2002:a2e:9dc8:: with SMTP id x8mr12983976ljj.38.1583864518516;
 Tue, 10 Mar 2020 11:21:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200310123606.543939933@linuxfoundation.org>
In-Reply-To: <20200310123606.543939933@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 10 Mar 2020 23:51:43 +0530
Message-ID: <CA+G9fYtC6A64M_kuP-_L597ovD+NPuJ6PUcdpkcCW7hYt4=OmA@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/88] 4.9.216-stable review
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

On Tue, 10 Mar 2020 at 18:15, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.216 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 12 Mar 2020 12:34:10 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.216-rc1.gz
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

kernel: 4.9.216-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.9.y
git commit: 823586b24f3634fefd5b5e83293920023c6f008c
git describe: v4.9.215-89-g823586b24f36
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.9-oe/bui=
ld/v4.9.215-89-g823586b24f36

No regressions (compared to build v4.9.215)

No fixes (compared to build v4.9.215)

Ran 19814 total tests in the following environments and test suites.

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
* install-android-platform-tools-r2800
* kselftest
* kvm-unit-tests
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
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
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* network-basic-tests
* ltp-cap_bounds-kasan-tests
* ltp-commands-kasan-tests
* ltp-containers-kasan-tests
* ltp-cpuhotplug-kasan-tests
* ltp-crypto-kasan-tests
* ltp-dio-kasan-tests
* ltp-fcntl-locktests-kasan-tests
* ltp-filecaps-kasan-tests
* ltp-fs-kasan-tests
* ltp-fs_bind-kasan-tests
* ltp-fs_perms_simple-kasan-tests
* ltp-fsx-kasan-tests
* ltp-hugetlb-kasan-tests
* ltp-io-kasan-tests
* ltp-ipc-kasan-tests
* ltp-math-kasan-tests
* ltp-mm-kasan-tests
* ltp-nptl-kasan-tests
* ltp-pty-kasan-tests
* ltp-securebits-kasan-tests
* ltp-syscalls-kasan-tests
* ltp-open-posix-tests
* ltp-cve-kasan-tests
* ltp-sched-kasan-tests

--=20
Linaro LKFT
https://lkft.linaro.org

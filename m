Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0D712F9B4
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 16:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727701AbgACP0E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 10:26:04 -0500
Received: from mout.kundenserver.de ([212.227.126.134]:36503 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727621AbgACP0E (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jan 2020 10:26:04 -0500
Received: from mail-qk1-f182.google.com ([209.85.222.182]) by
 mrelayeu.kundenserver.de (mreue010 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1MOi1H-1j5AyU32MR-00Q8m0; Fri, 03 Jan 2020 16:26:01 +0100
Received: by mail-qk1-f182.google.com with SMTP id t129so33995430qke.10;
        Fri, 03 Jan 2020 07:26:01 -0800 (PST)
X-Gm-Message-State: APjAAAXJfxpEdBkB7XzGhdg5oWkIQBoqxo3I3NogxtBuOQTN5O2fHkfS
        vHkKZABL7H1+jYzjVexsSM8bzwi1G65HaugVt1k=
X-Google-Smtp-Source: APXvYqw5wnevAuaN2LN4c1YLinEZyD+hKfKYUMCcrCgzN//nGAYKw5prrzNRF6UgFsNumMjF27D+d3bIomT5Tv6ETuE=
X-Received: by 2002:a37:84a:: with SMTP id 71mr69963622qki.138.1578065160510;
 Fri, 03 Jan 2020 07:26:00 -0800 (PST)
MIME-Version: 1.0
References: <20200102215829.911231638@linuxfoundation.org> <CA+G9fYuPkOGKbeQ0FKKx4H0Bs-nRHALsFtwyRw0Rt5DoOCvRHg@mail.gmail.com>
In-Reply-To: <CA+G9fYuPkOGKbeQ0FKKx4H0Bs-nRHALsFtwyRw0Rt5DoOCvRHg@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 3 Jan 2020 16:25:44 +0100
X-Gmail-Original-Message-ID: <CAK8P3a1+Srey_7cUd0xfaO8HdMv5tkUcs6DeDXzcUKkUD-DnGQ@mail.gmail.com>
Message-ID: <CAK8P3a1+Srey_7cUd0xfaO8HdMv5tkUcs6DeDXzcUKkUD-DnGQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/191] 5.4.8-stable review
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Chengguang Xu <cgxu519@mykernel.net>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>, LTP List <ltp@lists.linux.it>,
        Jan Stancek <jstancek@redhat.com>,
        John Stultz <john.stultz@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:hqMeP7ozgQ1GRuFUP4PE7yu5gsGaJ6QwpQvx1dlfeKmwkrIUdJx
 4wl2VH2R4EqFrTzFQ4wnSBrlNDsUDZoFwcn5deej38TmJ6SCb8MfyH4Z2dOPXWSucmSc+eL
 1aQazJ5H8HizyzWLxqqKypAE/kxqtbDgm7FL0jpjqeY4CBOBLciNu7qdODiwnfjjM3xg3qE
 uKuOOAxGb34IuRMvXXaSQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:QGQfKnCVuTs=:ipRWGtEHWvqj0m4fDulArB
 Sl+kMcaH3Xn4ikQZa9ASS1Rg29JZY1yyXM++IheHObO4+LoaJqr4NPQm6ykIvK3dXGJ1p0Got
 jKucISL0W/kySRFqzSlat9rTQ85ia9Ieb+yD79IuQVjXTYtYDht9t5OM6b8x4jWkos9RjGA2o
 mlPS5zP1+PlHqkDYeYCnEpcR/NXShoeupysb/vrecxvvjfA0oN7N3YEGVAsj3lizExgeAvtfK
 PTEiyq12kAPatpge5uBc97uasEDu8fiOdNIHbYa4ey24lBUPATJrxpZED5l4vUF7VpAFrqD/c
 4fgQKyot4FKzUQ/MJJt1BEZSnQuVXzORSczFdFMaWldQY89AJNs/92Ocx7rfNuXwassMat8jy
 j9EoDAubgJFJLUc+RhzTifdH2CfU/+BogcHVBZTlcA/ljZd4Lhs1s8tsUldFCo+msyKgsTVBV
 /5SFcRH79EhROSYoqmseKM2sqHYMQ6Lh48hrz3050N93DBCxLYMcNq/j513l+stkXi7W3pxDN
 1CL1rb5pgShaZSLuOZyIV9QI6GBWjmjdO4hNMCseBPqVfcmkBgLsnYYQ7R3dyA9gEt+XApmgC
 oUYI8uSvFZbzVESBv2/r/NqmJqyzow1V1eCLXuqnJQ+kkyIElNKZijlUy7s6bt9zo1CsfHMfn
 xWT0ZKgsHuSuvsK+ZJpVVWFISbyXhvt4XNgmO5t5h4h7xGqvTOj7xRsKwPM1V4OodtcUOsO01
 HgJ+qN6O6wzCcDItWeiJV68Qidg82nIQHJku7AbbdxNZNuKwVvPhrxpR9CF6EhDuBiUSX5Ytb
 9GQaZKPOmHyEkhktHu+GfKe9cksLKqurJp5MBS+PJKpOvG+A98P7o6vtFoW3sTdDJHvIPr6bh
 DviKhRroBzUMgY2bzKow==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 3, 2020 at 4:03 PM Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> On Fri, 3 Jan 2020 at 03:42, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.4.8 release.
> > There are 191 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 04 Jan 2020 21:55:35 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.8-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
> LTP syscalls memfd_create04 failed on arm64 devices.
> Test PASS on arm, i386 and x86_64.
>
> We are bisecting this failure on arm64.
>
> Test case failed log,
> memfd_create04.c:68: INFO: Attempt to create file using 64kB huge page size
> memfd_create04.c:76: FAIL: memfd_create() failed unexpectedly: ENOENT (2)
>
> Strace output:
> memfd_create(\"tfile\", MFD_HUGETLB|0x40000000) = -1 ENOENT (No such
> file or directory)

-ENOENT is what you get when hugetlbfs is not mounted, so this hints to

8fc312b32b2  mm/hugetlbfs: fix error handling when setting up mounts

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?h=linux-5.4.y&id=3f549fb42a39bea3b29c0fc12afee53c4a01bec9


> Test case Description,
>
> /*
> * Test: Validating memfd_create() with MFD_HUGETLB and MFD_HUGE_x flags.
> *
> * Test cases: Attempt to create files in the hugetlbfs filesystem using
> * different huge page sizes.
> *
> * Test logic: memfd_create() should return non-negative value (fd)
> * if the system supports that particular huge page size.
> * On success, fd is returned.
> * On failure, -1 is returned with ENODEV error.
> */
>
> Test code snippet:
> <>
> check_hugepage_support(&tflag);
> tst_res(TINFO,
> "Attempt to create file using %s huge page size",
> tflag.h_size);
>
> fd = sys_memfd_create("tfile", MFD_HUGETLB | tflag.flag);
> if (fd < 0) {
> if (errno == tflag.exp_err)
> tst_res(TPASS, "Test failed as expected\n");
> else
> tst_brk(TFAIL | TERRNO,
> "memfd_create() failed unexpectedly");
> return;
> }
>
> <>
>
> Steps to reproduce:
>           - cd /opt/ltp/testcases/bin/
>           - ./memfd_create04
>
> https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/syscalls/memfd_create/memfd_create04.c#L75
>
> Test output log,
> https://lkft.validation.linaro.org/scheduler/job/1081716
>
> Test results comparison,
> https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/tests/ltp-syscalls-tests/memfd_create04
>
>
> --
> Linaro LKFT
> https://lkft.linaro.org

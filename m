Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6603A12F973
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 16:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727786AbgACPDf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 10:03:35 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:46988 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgACPDf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jan 2020 10:03:35 -0500
Received: by mail-lf1-f68.google.com with SMTP id f15so32014365lfl.13
        for <stable@vger.kernel.org>; Fri, 03 Jan 2020 07:03:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fXLuplpySrohqFP6kS7OpIEbP/zNERMePL4SR7+mMjs=;
        b=xvXL8AjzcVepvA9glzXDHT0fioLRNmbgVkJ0/9FZHbw7TOvSZOhWG2oTR3lrLr4fFS
         xvJvT3VjsTxoQlt2RRk8qYfOnwTXauUgzaMN6AZ8mmx6mawvrLaObvPuwQFI5cMsS52b
         gdkmpDZoSvX7Oz/7rwqlScIm22M68k6KgpmMNjbBvP/IDpTWp5ontHVuvJsLjq2Q+vwa
         yBmxqrzlpLByYN+vMlQtn+CadZ8L3SJZ97abkEr7kQnQxp3FTVycCcbP4yQcetMwuEoZ
         cjJkGbcIlHNVJ9MWdhHO1pHd2ru6qzdVy2xYQsefeW+tmreZ4XW4bpOuanrf/supdelY
         KmJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fXLuplpySrohqFP6kS7OpIEbP/zNERMePL4SR7+mMjs=;
        b=XJyP4dCdpw9K3xCHn+hBuZRC7WWnJViSBVqQMcWvFs8FkJyNaYCz9ldwzoa+RLvh3h
         LaqaaefX5r5zgrMGS97bJ4h1NnY/3u/nRm52kFTSUBPtYg6juZfxRjd9PlV7AJTBF1Mb
         5evARhoTJZkiKjgx6kf7iLPR4Y6B2ath3md/zDyIc6xwEm4A4eOPnoAlASog7bGNNODq
         405cPy6/qDgTXmUYJW/xEAenalX8KbE4e6nu01ddvMvdACCB4z16S96rc1V62HK5YUun
         yt3qGvhDr5VZv83zEdYSOqY3Ai+3BRycC9nHUPGEMC72TcZJ+KZ4pEhGahX9rrJzB52l
         60ZQ==
X-Gm-Message-State: APjAAAWxQaE5Pr5/2ns37SQgFMjXgVREdxrKgh9A29kJRamCucJR0OqR
        vYq3dG8QzWvQE7DUpB6SBJbi8l6BYnZd46Ft5+9wnw==
X-Google-Smtp-Source: APXvYqw4vzT9NE5JBE4750Ibpsg4DfZbpJYeAmaoiYp8s1njp31bKNa9lXROJc+TkxaJZn7Eff6d3LMnkGO/OqxXMpU=
X-Received: by 2002:a19:784:: with SMTP id 126mr49377262lfh.191.1578063813660;
 Fri, 03 Jan 2020 07:03:33 -0800 (PST)
MIME-Version: 1.0
References: <20200102215829.911231638@linuxfoundation.org>
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 3 Jan 2020 20:33:22 +0530
Message-ID: <CA+G9fYuPkOGKbeQ0FKKx4H0Bs-nRHALsFtwyRw0Rt5DoOCvRHg@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/191] 5.4.8-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
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
        Arnd Bergmann <arnd@arndb.de>,
        John Stultz <john.stultz@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 3 Jan 2020 at 03:42, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.8 release.
> There are 191 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 04 Jan 2020 21:55:35 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.8-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

LTP syscalls memfd_create04 failed on arm64 devices.
Test PASS on arm, i386 and x86_64.

We are bisecting this failure on arm64.

Test case failed log,
memfd_create04.c:68: INFO: Attempt to create file using 64kB huge page size
memfd_create04.c:76: FAIL: memfd_create() failed unexpectedly: ENOENT (2)

Strace output:
memfd_create(\"tfile\", MFD_HUGETLB|0x40000000) = -1 ENOENT (No such
file or directory)

Test case Description,

/*
* Test: Validating memfd_create() with MFD_HUGETLB and MFD_HUGE_x flags.
*
* Test cases: Attempt to create files in the hugetlbfs filesystem using
* different huge page sizes.
*
* Test logic: memfd_create() should return non-negative value (fd)
* if the system supports that particular huge page size.
* On success, fd is returned.
* On failure, -1 is returned with ENODEV error.
*/

Test code snippet:
<>
check_hugepage_support(&tflag);
tst_res(TINFO,
"Attempt to create file using %s huge page size",
tflag.h_size);

fd = sys_memfd_create("tfile", MFD_HUGETLB | tflag.flag);
if (fd < 0) {
if (errno == tflag.exp_err)
tst_res(TPASS, "Test failed as expected\n");
else
tst_brk(TFAIL | TERRNO,
"memfd_create() failed unexpectedly");
return;
}
<>

Steps to reproduce:
          - cd /opt/ltp/testcases/bin/
          - ./memfd_create04

https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/syscalls/memfd_create/memfd_create04.c#L75

Test output log,
https://lkft.validation.linaro.org/scheduler/job/1081716

Test results comparison,
https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/tests/ltp-syscalls-tests/memfd_create04


-- 
Linaro LKFT
https://lkft.linaro.org

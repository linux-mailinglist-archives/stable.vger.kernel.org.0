Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23BB321ADD1
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 06:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbgGJERu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 00:17:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbgGJERt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jul 2020 00:17:49 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43AECC08C5CE
        for <stable@vger.kernel.org>; Thu,  9 Jul 2020 21:17:49 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id q4so4900952lji.2
        for <stable@vger.kernel.org>; Thu, 09 Jul 2020 21:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GOMunx3lII6WiFhmgXs6T+sFqTi8oTyhM5FPcahBiiw=;
        b=x2EauDhpkHLZTqe4KZEHA12Eg/+hjjsWaGtUf76DIl22j4xWvuSNhdrb1CmJN7sFKA
         ZI9hXDk3LNKTzhj+MSOjESmm/PRUTbRsky5OwjMhbVOqeU46NMBofU93TgMavaTNJrff
         8ZqcFxYWALq3owf6BE5DpDkQZwxurRUvMZbJ+VlWKXYoAERkOQ35aLZigtpQe/3sGot5
         Lk0M6l199ufPUj1B9V3PO4CGbukEkl/oLLHeGM3yM9Yfi3RZ5cfqssnLWjOEQW0cKNrJ
         4hXgsG8d4wWT8i9pv2epuJcGwmog4GXGw7nqOkK99uljD1qt+f5KUsWr4TC2ivxVVgTf
         VIOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GOMunx3lII6WiFhmgXs6T+sFqTi8oTyhM5FPcahBiiw=;
        b=h+RQKG5w0+xROT0CnND/YRFUka2RNT6yKe4/9QqyxLcf4tqMdpXYX68rpN+vDqH4O1
         XrORYmi1q8zTFlKiZo1XOIK8xvHk0PYUSPZs1Q/PRwG2hZ4Q7EF/vG2mHB85SXgWYRXW
         2hzSr2XU1TGW1I6ckFivT1+nSkjHaTIHsGN1j5XonlwXnU93ZFwUf83OxpO1BaMiiobw
         LJmO+lx6JQmgRfAIBtbbTrlI+hoHsu1ZVph5nkr4LbMM03JkNMMAEvpgAcylrHq+i2nT
         D7LLGgHhu09idjhcO7yfls4CXYsJmov3Mb0HsIgZUOPsw9rFTzRGkFdO24eHUtMv0pbm
         d0pA==
X-Gm-Message-State: AOAM53106MNIYnW+n65b5AxStHayNJtZBBGncuXFNdUFUKcNsCw/T7VQ
        VCWg75fhVvWxAt4/fYIVawyWeog91K2sgcI6rOazbg==
X-Google-Smtp-Source: ABdhPJzJ5G9NeGhYRGYXrilWZEb+Io/ok8iNRSWg6aJugFsWnWQO5XiLBdPCFqnu9yYcQ3qL/dVPmgppJtVodiO8leM=
X-Received: by 2002:a2e:9089:: with SMTP id l9mr31662918ljg.431.1594354667432;
 Thu, 09 Jul 2020 21:17:47 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYt+6OeibZMD0fP=O3nqFbcN3O4xcLkjq0mpQbZJ2uxB9w@mail.gmail.com>
 <CAK8P3a0ii1Z-UG8NpwTvkmOEcOvvTo4+m9xjW0JqR6LPvUZ4=g@mail.gmail.com>
In-Reply-To: <CAK8P3a0ii1Z-UG8NpwTvkmOEcOvvTo4+m9xjW0JqR6LPvUZ4=g@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 10 Jul 2020 09:47:35 +0530
Message-ID: <CA+G9fYsoEiQ-8ECKxMqQqPZKUbTQStp6wZi7ZiJDyi0YahFAvg@mail.gmail.com>
Subject: Re: WARNING: at mm/mremap.c:211 move_page_tables in i386
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     linux- stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>,
        lkft-triage@lists.linaro.org, Chris Down <chris@chrisdown.name>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>, Fan_Yang@sjtu.edu.cn,
        bgeffon@google.com, Anshuman Khandual <anshuman.khandual@arm.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>, pugaowei@gmail.com,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Hugh Dickins <hughd@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Tejun Heo <tj@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 9 Jul 2020 at 13:55, Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Thu, Jul 9, 2020 at 7:28 AM Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> >
> > While running LTP mm test suite on i386 or qemu_i386 this kernel warning
> > has been noticed from stable 5.4 to stable 5.7 branches and mainline 5.8.0-rc4
> > and linux next.
>
> Are you able to correlate this with any particular test case in LTP, or does
> it happen for random processes?
>
> In the log you linked to, it happens once for ksm05.c and multiple times for
> thp01.c, sources here:
>
> https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/mem/ksm/ksm05.c
> https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/mem/thp/thp01.c
>
> Is it always these tests that trigger the warning, or sometimes others?

These two test cases are causing this warning multiple times on i386.

>
> When you say it happens with linux-5.4 stable, does that mean you don't see
> it with older versions? What is the last known working version?

I do not notice on stable-4.19 and below versions.
Sorry i did not get the known working commit id or version.

It started happening from stable-rc 5.0 first release.
I have evidence [1] showing it on 5.0.1

>
> I also see that you give the virtual machine 16GB of RAM, but as you are
> running a 32-bit kernel without PAE, only 2.3GB end up being available,
> and some other LTP tests in the log run out of memory.
>
> You could check if the behavior changes if you give the kernel less memory,
> e.g. 768MB (lowmem only), or enable CONFIG_X86_PAE to let it use the
> entire 16GB.

Warning is still happening after enabling PAE config.
But the oom-killer messages are gone. Thank you.

CONFIG_HIGHMEM=y
CONFIG_X86_PAE=y

full test log oom-killer messages are gone and kernel warning is still there,
https://lkft.validation.linaro.org/scheduler/job/1552606#L10357

build location:
https://builds.tuxbuild.com/puilcMcGVwzFMN5fDUhY4g/

[1] https://qa-reports.linaro.org/lkft/linux-stable-rc-5.0-oe/build/v5.0.1/testrun/1324990/suite/ltp-mm-tests/test/ksm02/log

---
[  775.646689] WARNING: CPU: 3 PID: 10858 at
/srv/oe/build/tmp-lkft-glibc/work-shared/intel-core2-32/kernel-source/mm/mremap.c:211
move_page_tables+0x553/0x570
[  775.647006] Modules linked in: fuse
[  775.647006] CPU: 3 PID: 10858 Comm: true Not tainted 5.0.1 #1
[  775.647006] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 1.10.2-1 04/01/2014
[  775.647006] EIP: move_page_tables+0x553/0x570

- Naresh

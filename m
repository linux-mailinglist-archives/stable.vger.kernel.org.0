Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C50A3219ABC
	for <lists+stable@lfdr.de>; Thu,  9 Jul 2020 10:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgGIIZv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jul 2020 04:25:51 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:49771 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbgGIIZv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jul 2020 04:25:51 -0400
Received: from mail-qk1-f181.google.com ([209.85.222.181]) by
 mrelayeu.kundenserver.de (mreue108 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1N3KY0-1ksKCc1Gdu-010OXV; Thu, 09 Jul 2020 10:25:48 +0200
Received: by mail-qk1-f181.google.com with SMTP id r22so968803qke.13;
        Thu, 09 Jul 2020 01:25:48 -0700 (PDT)
X-Gm-Message-State: AOAM5301F+bOdf+TubDVoF1UnG2iFepNCxGyQmXXymvxk6DNuL4jmWp6
        VWkwCv2+Op97jA4jCz0U4Q/lzL01rTp7oXDjN2Q=
X-Google-Smtp-Source: ABdhPJyXV7lQWgRTMyw9+0OfyvkSZbUKyqYlpR84nLWBDaf70IBhbe8ZuySwyXzLn/Mvu7wXfcuJTGuY/HrtTVDvAdw=
X-Received: by 2002:a37:b484:: with SMTP id d126mr61620523qkf.394.1594283147047;
 Thu, 09 Jul 2020 01:25:47 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYt+6OeibZMD0fP=O3nqFbcN3O4xcLkjq0mpQbZJ2uxB9w@mail.gmail.com>
In-Reply-To: <CA+G9fYt+6OeibZMD0fP=O3nqFbcN3O4xcLkjq0mpQbZJ2uxB9w@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 9 Jul 2020 10:25:31 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0ii1Z-UG8NpwTvkmOEcOvvTo4+m9xjW0JqR6LPvUZ4=g@mail.gmail.com>
Message-ID: <CAK8P3a0ii1Z-UG8NpwTvkmOEcOvvTo4+m9xjW0JqR6LPvUZ4=g@mail.gmail.com>
Subject: Re: WARNING: at mm/mremap.c:211 move_page_tables in i386
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
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
X-Provags-ID: V03:K1:D8cLPAtVmYJNHX82yXkx8yIvNgY46mlsG7SbYhlpgnrpceAfWnN
 fDyO7u7VBVkc00qpi7S1u+Z4KlvmL5e0mtCGQvGwl0Wahxbi8XFirNidOFdHnZQTbMh5EFo
 xkqt36qdmmT7GG8VkvbYEM5hwmhJzwatjwa8tcbt24JSBUfbu//9lBwgUdWmKg+B3WW228H
 3x2SMyVDaJeLJxSatEBvQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:S9AndeVjhyw=:PKm31LwmL7kkYDpBFQ/p/c
 6Vx1LAI5YigIFWBb3O8pJw4qjNp9lSIoMRYRxRg+xWPfxEgJeuSDmGL5rLebtnqMKXnryKAtx
 xbyA5n6JyrAHMrd/aGFLvcntI0hoKJTFi0iDJ+KfQPty+Ae1xAZjijiCbB2AvrldZq+kl/u0a
 BrHyAwoGkGGeBMXYuAuoV6CNfQwiU+3XyRePc0v7iOd1dMb6Hy+8VHEMJpeKDHYPrVju9zWQG
 XFyemMYXzs+E1JnaQ/P1Te1nCK1uW1Lkpi+yHugoXgr5WM5Q9tqQArmvbACcW53F/yv2nOuqf
 7Bxz1Cmf05nbSRFkqgWf/OdN10X9pXswx2P24dZ27dRdQfOvhF0g5i67UyFdQ8OtMDIa5M/Uo
 Vz+Fm8mML7sbLei6Euo8ZRF2ru+T89MkrZCCB1OUkljB3/19KF64USbYnaYUEjO0b/J2ctHx/
 KtwKsmqnKCOawZomCFdmKX2r16eEA/GBO+YdbZ5nig656Mb5Q1RxbVQyK4YpXQHw56B8IkUS8
 7X1W0gRUlx+AxkNohPmFhlm15FPWM4288Z7FqW4/QXhTVExhQIQWfMMTvDgCdMuoBBFJRXlUz
 3qbU1md5T3tVVtn2SZEsradD0buVbqRFfmwrKlhIvFTRe4j5o3pX20VuSYUxCkk4R5u6RtpvR
 JfoqhW1MkJqzg0agWrJyd1tclI1yZebK3I8WMLXgbfPMcqRqH+LWEUFNJOfycxULPzQQl4HEz
 inA+HqMtWnxQvNCPc2gavGIgHUSUHUqtdl7w92ujC27MVAfXM+wvCk3W5ECF+sx3l+iCm1Q0X
 PJEY1ImZ+WcZtgI8VzjjHmWB8SJ+yhWpAyNI9ZWhzDuB6Z8F48nmTL0NJ/vjljA5d4SnhJZ3l
 2CJSoQGSE1bvso6aWyih0rQX3Aik6kYqK6Y1W+6NfHoT4tqEmxlVLy1BCMJJBtBIAo70VmZa7
 0AKCGIMVAm9JSzCgMT9VGusY/TDXo4QLg91ii7NK06Ot+1FlF63aG
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 9, 2020 at 7:28 AM Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> While running LTP mm test suite on i386 or qemu_i386 this kernel warning
> has been noticed from stable 5.4 to stable 5.7 branches and mainline 5.8.0-rc4
> and linux next.

Are you able to correlate this with any particular test case in LTP, or does
it happen for random processes?

In the log you linked to, it happens once for ksm05.c and multiple times for
thp01.c, sources here:

https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/mem/ksm/ksm05.c
https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/mem/thp/thp01.c

Is it always these tests that trigger the warning, or sometimes others?

When you say it happens with linux-5.4 stable, does that mean you don't see
it with older versions? What is the last known working version?

I also see that you give the virtual machine 16GB of RAM, but as you are
running a 32-bit kernel without PAE, only 2.3GB end up being available,
and some other LTP tests in the log run out of memory.

You could check if the behavior changes if you give the kernel less memory,
e.g. 768MB (lowmem only), or enable CONFIG_X86_PAE to let it use the
entire 16GB.

> full test log,
> https://lkft.validation.linaro.org/scheduler/job/1541788#L9308

       Arnd

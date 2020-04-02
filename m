Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9634319C9FB
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388526AbgDBT1P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:27:15 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:38628 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388280AbgDBT1O (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:27:14 -0400
Received: by mail-lj1-f196.google.com with SMTP id v16so4512518ljg.5
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vb5tL+W1ofpBV7FsB437iOfsA6eloWUcZokuYoXnsKg=;
        b=kpG4tj3j61ZFadQA6O+YOphdJcn7p896+/C1o9Y4CaNmTgp/OepMFSzIqW0h062CJx
         5y6qkYMg40lX8/ad3OCgIsdOdV6vY6Qa9R8/tbQoG/TdnUqCnqVXxaDHpQJgMuxuGECB
         zGm6qmmzzhQpdAEkn6SlReZlGSx5uEt6A+6iVSo5XIhpbUUmrOjl/8zzSY8CbCBj4wro
         lJeCLNjoYbfwRsvNo5t52cgUHSjbyUbTay39n8FO7Vkd6Jv+ovN+5LDNLQfD3K5PZJai
         TuXyAS/lPwlovZFkVrThRy5eZGVfCtN5DVxHgiD48fkkQ8h3YAj+xHlw5zGVdmOC1aRP
         Wpdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vb5tL+W1ofpBV7FsB437iOfsA6eloWUcZokuYoXnsKg=;
        b=a5ycwqfeQ2FXbAngevgjUjK/E81Cx7i/zZYTJE+YBGKyirs0qyGdj5b+vWgllF34O+
         4Zlg2Bbemi1x8BEHfItckSE+Yk4pKqc+rZTMoSiD5Q5yme4OzGeSdwYm9i/6lLkDDQ/p
         gP7dK5VF9XrQShYecjSYjA1BxKahpyx6TADcRtQz5/t8eazvQcgrUhodaqeNHdGQOBm9
         GrbPv169bV9I//wtD3D1OrbPnLrRhtDKLNs+ecDEjx6sQ9Ct97TAM6gjtDZ3pWy5tgzA
         nlRQUEmLyO0auUyVocbDEtWlt/3nZxL35bq+WaGudremYxL9W9LEaamL3tLhAJyJzZ3q
         eSyQ==
X-Gm-Message-State: AGi0PuZCXI7UkBaeYBnArHv7VqKQfo+HbGnURqAXgrzVUnYqYRxneXav
        UyshgPqS8cpbLApaQXKKfDeyWa1H6PlRyhXt2UptoQ==
X-Google-Smtp-Source: APiQypI3DuoOpgpYgB2M6ixoczedRo87gp3LKeUyHza3n/ojjx6uN5eUZm10RFfLVnYEaouhXZ0Q0Gwyh+DUYNU5I9k=
X-Received: by 2002:a2e:3c08:: with SMTP id j8mr2946034lja.243.1585855629252;
 Thu, 02 Apr 2020 12:27:09 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYs1xStrrsvGbW7bc4h1a0Kjfz0_zn4c7LL7-bGZb0GH6g@mail.gmail.com>
 <20200402133849.mmkvekzx37kw4nsj@box>
In-Reply-To: <20200402133849.mmkvekzx37kw4nsj@box>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 3 Apr 2020 00:56:57 +0530
Message-ID: <CA+G9fYv0xNtnD=eBmxVqYqEoYTbMk6mdn04WmgSUasDw2L7uFg@mail.gmail.com>
Subject: Re: mm/mremap.c : WARNING: at mm/mremap.c:211 move_page_tables+0x5b0/0x5d0
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux- stable <stable@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        William Kucharski <william.kucharski@oracle.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Michal Hocko <mhocko@kernel.org>,
        Will Deacon <will.deacon@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        lkft-triage@lists.linaro.org,
        Mike Kravetz <mike.kravetz@oracle.com>,
        LTP List <ltp@lists.linux.it>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2 Apr 2020 at 19:08, Kirill A. Shutemov <kirill@shutemov.name> wrote:
>
> On Thu, Apr 02, 2020 at 04:49:02PM +0530, Naresh Kamboju wrote:
> > While running LTP mm thp01 test case on i386 kernel running on x86_64 device
> > the following kernel warning was noticed multiple times.
> >
>
> Interesting. I suspect it's related to 2-level page tables in this
> configuration. But I cannot immediately see how.
>
> Could you test if enabling HIGHMEM64 fixes the issue?

CONFIG_HIGHMEM64G=y

>
> Below is patch that prints some additional info:

Applied your patch and reproduced the problem,
The boot log show this warning,

[    0.261879] ************************************************************
[    0.261880] ** WARNING! WARNING! WARNING! WARNING! WARNING! WARNING!  **
[    0.261881] **                                                        **
[    0.261881] ** You are using 32-bit PTI on a 64-bit PCID-capable CPU. **
[    0.261882] ** Your performance will increase dramatically if you     **
[    0.261882] ** switch to a 64-bit kernel!                             **
[    0.261883] **                                                        **
[    0.261884] ** WARNING! WARNING! WARNING! WARNING! WARNING! WARNING!  **
[    0.261884] ************************************************************
...

Reproducing steps:
------------------------
cd /opt/ltp
./runltp -f mm

[  734.485672] ------------[ cut here ]------------
[  734.490306] WARNING: CPU: 3 PID: 32321 at mm/mremap.c:212
move_page_tables+0x7c3/0x830
[  734.498212] Modules linked in: x86_pkg_temp_thermal
[  734.503084] CPU: 3 PID: 32321 Comm: true Tainted: G        W
 5.6.2-rc1+ #14
[  734.510729] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.2 05/23/2018
[  734.518110] EIP: move_page_tables+0x7c3/0x830
[  734.522463] Code: 0c eb a7 8d 45 d8 83 4d e8 01 e8 c8 e6 01 00 e9
be f8 ff ff 8d 45 d8 31 d2 e8 59 e8 01 00 e9 a5 fc ff ff 31 db e9 81
fc ff ff <0f> 0b 8b 45 b8 e8 43 e0 fe ff ff 75 b0 ff 75 08 ff 75 cc 68
e4 50
[  734.541200] EAX: eb5f1fe8 EBX: 00400000 ECX: 2b5f1001 EDX: 2b5f1000
[  734.547456] ESI: ea5d6010 EDI: eb5f1ff0 EBP: da381e14 ESP: da381d84
[  734.553714] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00010202
[  734.560492] CR0: 80050033 CR2: b7d11f50 CR3: 2a5d6000 CR4: 003406f0
[  734.566748] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  734.573006] DR6: fffe0ff0 DR7: 00000400
[  734.576835] Call Trace:
[  734.579282]  setup_arg_pages+0x22c/0x350
[  734.583207]  ? strlcpy+0x33/0x50
[  734.586459]  load_elf_binary+0x352/0x1010
[  734.590468]  ? selinux_inode_permission+0xe5/0x1f0
[  734.595254]  search_binary_handler+0x77/0x1a0
[  734.599614]  __do_execve_file+0x5aa/0x710
[  734.603615]  sys_execve+0x21/0x30
[  734.606926]  do_fast_syscall_32+0x75/0x260
[  734.611019]  entry_SYSENTER_32+0xa5/0xf8
[  734.614942] EIP: 0xb7ef6c11
[  734.617735] Code: Bad RIP value.
[  734.620956] EAX: ffffffda EBX: bfb8dcb0 ECX: 08069420 EDX: bfb8df14
[  734.627238] ESI: 080599d4 EDI: bfb8dcb9 EBP: bfb8dd58 ESP: bfb8dc88
[  734.633499] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00000296
[  734.640276] ---[ end trace e625d4d55b8380f3 ]---
[  734.644934] vma dbc4c180 start bf801000 end c0000000
[  734.644934] next 00000000 prev 00000000 mm d0d75d40
[  734.644934] prot 25 anon_vma d0dfddc8 vm_ops 00000000
[  734.644934] pgoff bfa01 file 00000000 private_data 00000000
[  734.644934] flags:
0x118173(read|write|mayread|maywrite|mayexec|growsdown|seqread|randread|account)
[  734.674346] old_addr: 0xbfc00000, new_addr: 0xbfa00000, old_end: 0xc0000000
[  734.681322] old_pmd: 0x77923067
[  734.681322] new_pmd: 0x7796d067
[  734.684510] ------------[ cut here ]------------
[  734.692295] WARNING: CPU: 2 PID: 32321 at mm/mremap.c:212
move_page_tables+0x7c3/0x830
[  734.700241] Modules linked in: x86_pkg_temp_thermal
[  734.705128] CPU: 2 PID: 32321 Comm: true Tainted: G        W
 5.6.2-rc1+ #14
[  734.712770] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.2 05/23/2018
[  734.720156] EIP: move_page_tables+0x7c3/0x830
[  734.724506] Code: 0c eb a7 8d 45 d8 83 4d e8 01 e8 c8 e6 01 00 e9
be f8 ff ff 8d 45 d8 31 d2 e8 59 e8 01 00 e9 a5 fc ff ff 31 db e9 81
fc ff ff <0f> 0b 8b 45 b8 e8 43 e0 fe ff ff 75 b0 ff 75 08 ff 75 cc 68
e4 50
[  734.743256] EAX: eb5f1ff0 EBX: 00200000 ECX: 2b5f1001 EDX: 2b5f1000
[  734.749517] ESI: ea5d6010 EDI: eb5f1ff8 EBP: da381e14 ESP: da381d84
[  734.755776] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00010202
[  734.762553] CR0: 80050033 CR2: b7f1f4e0 CR3: 2a5d6000 CR4: 003406f0
[  734.768808] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  734.775067] DR6: fffe0ff0 DR7: 00000400
[  734.778898] Call Trace:
[  734.781344]  setup_arg_pages+0x22c/0x350
[  734.785269]  ? strlcpy+0x33/0x50
[  734.788499]  load_elf_binary+0x352/0x1010
[  734.792503]  ? selinux_inode_permission+0xe5/0x1f0
[  734.797287]  search_binary_handler+0x77/0x1a0
[  734.801639]  __do_execve_file+0x5aa/0x710
[  734.805642]  sys_execve+0x21/0x30
[  734.808953]  do_fast_syscall_32+0x75/0x260
[  734.813045]  entry_SYSENTER_32+0xa5/0xf8
[  734.816959] EIP: 0xb7ef6c11
[  734.819752] Code: Bad RIP value.
[  734.822976] EAX: ffffffda EBX: bfb8dcb0 ECX: 08069420 EDX: bfb8df14
[  734.829261] ESI: 080599d4 EDI: bfb8dcb9 EBP: bfb8dd58 ESP: bfb8dc88
[  734.835525] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00000296
[  734.842302] ---[ end trace e625d4d55b8380f4 ]---
[  734.846940] vma dbc4c180 start bf801000 end c0000000
[  734.846940] next 00000000 prev 00000000 mm d0d75d40
[  734.846940] prot 25 anon_vma d0dfddc8 vm_ops 00000000
[  734.846940] pgoff bfa01 file 00000000 private_data 00000000
[  734.846940] flags:
0x118173(read|write|mayread|maywrite|mayexec|growsdown|seqread|randread|account)
[  734.876355] old_addr: 0xbfe00000, new_addr: 0xbfc00000, old_end: 0xc0000000
[  734.883316] old_pmd: 0x77a08067


Full test log,
https://lkft.validation.linaro.org/scheduler/job/1334357#L478

- Naresh

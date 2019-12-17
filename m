Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 511E512231B
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 05:22:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbfLQEWe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 23:22:34 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:36764 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727313AbfLQEWe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 23:22:34 -0500
Received: by mail-lf1-f65.google.com with SMTP id n12so5928072lfe.3
        for <stable@vger.kernel.org>; Mon, 16 Dec 2019 20:22:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yLCgm6EIK/PewzFuy4vIAGJuhSX93YxxKWM+fKq1dL0=;
        b=cL8b7J3nglQ0EfjAy78uPCN2UhJVO/Zc03XbdN3Alhsuk2AWjMgN5Dog3GCraurf6B
         d4i3y92YpbkfhTEYNWyz21P0f7/H4m+0Hr6tQWw8jp9nYgjtfTVhPC26X0v2kZNPbQgw
         8msd7+ALkGWsuyrFRigyCwmqxmTXJfZDvEnX6DtVR+SUFgmAckOWgfsVc9XtLSsDfHnW
         oHzuaL9yvHn0G8+RoQyQG8UY8OID2DwVMA/UBQKHQap+jJaypCtTbQhzJmRtuhwwDmk/
         myzdVoU4JoKuYsTrS6HbMGtWGMIoS7QHonPk+VzuPBPlREgWab11J3LcfPDunn5Nc1Uz
         n3NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yLCgm6EIK/PewzFuy4vIAGJuhSX93YxxKWM+fKq1dL0=;
        b=QSID3LGVVn0wbudC2AW5JGnDOXxIFNaciH3RHs20NBsC47DL3jg3FKYotFNGsiPlu3
         GnNbexXxGiqqrLVltZI7pMRyYDquVXD3nxPjd4vXc8JdgWpyOLwFrLXIfFfk8PasL0Jl
         Po2aNEgNTOLiSquYoXqOdbfCxCs61FZeVE2Pui1BdYYzqVW3OOo4KlKAdIZwvuYMzAmC
         IKeLrCwc6g00V1xCk9qSQSyTtkGFJTcpqTEhBdWGtnNd8c0AiwTwclLhfooXbLFrBlq3
         xB8rZH+z/D8bn5T30bULh1daIU53BgGYE/Ze+CG0ivd4i2EH20GFaXjwKh/v0lJbSHM3
         FJ2w==
X-Gm-Message-State: APjAAAUJcyJk2R0d7ejAUXUX1vLQ93kOuBniO5wDTxDqNX4SZ02J5sqT
        S/b8C1E3DY7hTqls//YvF5CGEf5imaQ9gCShBHEDlQ==
X-Google-Smtp-Source: APXvYqziug7DlE3EmO7LVeGdDOUj+1C01+LOsNufEsD6UKVq0X27bllk44WLGsbCW8ROGEA193vtUHjVlLJwlOBN7EY=
X-Received: by 2002:a19:8a06:: with SMTP id m6mr1348555lfd.99.1576556550592;
 Mon, 16 Dec 2019 20:22:30 -0800 (PST)
MIME-Version: 1.0
References: <20191216174848.701533383@linuxfoundation.org>
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 17 Dec 2019 09:52:19 +0530
Message-ID: <CA+G9fYta8SH1EhzTSLshp1xx=MqmbSKPM2oXdV1qMSx=o2Tqsw@mail.gmail.com>
Subject: Re: [PATCH 4.14 000/267] 4.14.159-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Michal Hocko <mhocko@suse.com>, Arnd Bergmann <arnd@arndb.de>,
        william.kucharski@oracle.com, bepvte@gmail.com, rppt@linux.ibm.com,
        Jan Kara <jack@suse.cz>, rientjes@google.com,
        dan.j.williams@intel.com, Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Results from Linaro=E2=80=99s test farm.
Regressions on arm and qemu_arm.

Regressions (compared to build v4.14.158)
------------------------------------------------------------------------
x15:
  ltp-fs-tests:
    * proc01

qemu_arm:
  libhugetlbfs:
    * HUGETLB_SHM_yes-shmoverride_linked-2M-32
    * LD_PRELOAD_libhugetlbfs.so-HUGETLB_SHM_yes-shmoverride_unlinked-2M-32
    * counters.sh-2M-32
    * truncate_sigbus_versus_oom-2M-32

  ltp-fs-tests:
    * proc01

On Mon, 16 Dec 2019 at 23:21, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.159 release.
> There are 267 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 18 Dec 2019 17:41:25 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.159-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------
> Pseudo-Shortlog of commits:
>
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Linux 4.14.159-rc1

> Michal Hocko <mhocko@suse.com>
>     mm, thp, proc: report THP eligibility for each vma

LTP proc01 :
----------------
[ 1205.874471] ICMPv6: process `proc01' is using deprecated sysctl
(syscall) net.ipv6.neigh.default.base_reachable_time - use
net.ipv6.neigh.default.base_reachable_time_ms instead
[ 1205.905262] nr_pdflush_threads exported in /proc is scheduled for remova=
l
[ 1215.501494] Unable to handle kernel NULL pointer dereference at
virtual address 000001d0
[ 1215.505049] pgd =3D ea89e7c0
[ 1215.506115] [000001d0] *pgd=3D6b2fc003, *pmd=3D13f916003
[ 1215.508081] Internal error: Oops: 207 [#1] SMP ARM
[ 1215.510200] Modules linked in: crc32_arm_ce sha2_arm_ce sha256_arm
sha1_arm_ce sha1_arm aes_arm_ce crypto_simd cryptd fuse
[ 1215.515303] CPU: 2 PID: 4950 Comm: proc01 Not tainted 4.14.159-rc1 #1
[ 1215.518334] Hardware name: Generic DT based system
[ 1215.520553] task: ea874240 task.stack: eb5e8000
[ 1215.522681] PC is at transparent_hugepage_enabled+0x54/0xb4
[ 1215.525237] LR is at transparent_hugepage_enabled+0x48/0xb4
[ 1215.527831] pc : [<c060d1bc>]    lr : [<c060d1b0>]    psr: 600f0013
[ 1215.530735] sp : eb5e9d68  ip : eb5e9d68  fp : eb5e9d7c
[ 1215.533145] r10: 00000004  r9 : 00000000  r8 : 0000d6f0
[ 1215.535559] r7 : ec74ff00  r6 : eb5e9de8  r5 : c1c0e320  r4 : c1c0e320
[ 1215.538507] r3 : 00000000  r2 : 80000000  r1 : c165d6cd  r0 : 00000000
[ 1215.541498] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment=
 user
[ 1215.544839] Control: 30c5383d  Table: 6a89e7c0  DAC: dbadc0de
[ 1215.547527] Process proc01 (pid: 4950, stack limit =3D 0xeb5e8220)
[ 1215.550292] Stack: (0xeb5e9d68 to 0xeb5ea000)
....
[ 1215.631288] [<c060d1bc>] (transparent_hugepage_enabled) from
[<c06a4ba8>] (show_smap+0x298/0x454)
[ 1215.635364] [<c06a4ba8>] (show_smap) from [<c06a4da0>]
(show_tid_smap+0x1c/0x20)
[ 1215.638733] [<c06a4da0>] (show_tid_smap) from [<c065acb0>]
(seq_read+0x3c4/0x520)
[ 1215.642134] [<c065acb0>] (seq_read) from [<c062d274>] (__vfs_read+0x38/0=
x12c)
[ 1215.645410] [<c062d274>] (__vfs_read) from [<c062d404>] (vfs_read+0x9c/0=
x164)
[ 1215.648750] [<c062d404>] (vfs_read) from [<c062d9f0>] (SyS_read+0x5c/0xd=
0)
[ 1215.651906] [<c062d9f0>] (SyS_read) from [<c0408d20>]
(ret_fast_syscall+0x0/0x28)
[ 1215.655371] Code: ebff672f e3500000 1afffff7 e5943020 (e59331d0)
[ 1215.658332] ---[ end trace 6088de7e307c3c4c ]---

libhugetlbfs test suite caused this failure on arm32,
---------------------------------------------------------------------

malloc (2M: 32): [   45.815802] Unable to handle kernel NULL pointer
dereference at virtual address 000001d0
[   45.824194] pgd =3D ec174080
[   45.827020] [000001d0] *pgd=3Dac29b003, *pmd=3Dfb076003
[   45.831953] Internal error: Oops: 207 [#1] SMP ARM
[   45.836773] Modules linked in: snd_soc_simple_card
snd_soc_simple_card_utils snd_soc_core ac97_bus snd_pcm_dmaengine
snd_pcm snd_timer snd soundcore fuse
[   45.850649] CPU: 1 PID: 436 Comm: malloc Not tainted 4.14.159-rc1 #1
[   45.857039] Hardware name: Generic DRA74X (Flattened Device Tree)
[   45.863166] task: ec116a00 task.stack: ec64c000
[   45.867731] PC is at transparent_hugepage_enabled+0x54/0xb4
[   45.873333] LR is at transparent_hugepage_enabled+0x48/0xb4
[   45.878934] pc : [<c060d1bc>]    lr : [<c060d1b0>]    psr: 600b0013
[   45.885234] sp : ec64dd68  ip : ec64dd68  fp : ec64dd7c
[   45.890487] r10: 00000004  r9 : 00000000  r8 : 0000d6f0
[   45.895740] r7 : ca2a29c0  r6 : ec64dde8  r5 : c1c0e320  r4 : c1c0e320
[   45.902301] r3 : 00000000  r2 : 80000000  r1 : c165d6cd  r0 : 00000000
[   45.908864] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment=
 user
[   45.916036] Control: 30c5387d  Table: ac174080  DAC: 55555555
[   45.921813] Process malloc (pid: 436, stack limit =3D 0xec64c220)
[   45.927765] Stack: (0xec64dd68 to 0xec64e000)
..
[   46.104774] [<c060d1bc>] (transparent_hugepage_enabled) from
[<c06a4ba8>] (show_smap+0x298/0x454)
[   46.113697] [<c06a4ba8>] (show_smap) from [<c06a4d80>]
(show_pid_smap+0x1c/0x20)
[   46.121136] [<c06a4d80>] (show_pid_smap) from [<c065a9d0>]
(seq_read+0xe4/0x520)
[   46.128576] [<c065a9d0>] (seq_read) from [<c062d274>] (__vfs_read+0x38/0=
x12c)
[   46.135752] [<c062d274>] (__vfs_read) from [<c062d404>] (vfs_read+0x9c/0=
x164)
[   46.142926] [<c062d404>] (vfs_read) from [<c062d9f0>] (SyS_read+0x5c/0xd=
0)
[   46.149842] [<c062d9f0>] (SyS_read) from [<c0408d20>]
(ret_fast_syscall+0x0/0x28)
[   46.157367] Code: ebff672f e3500000 1afffff7 e5943020 (e59331d0)
[   46.163616] ---[ end trace c51b58b4d19d6cce ]---


Full test log,
https://lkft.validation.linaro.org/scheduler/job/1058080#L1126
https://lkft.validation.linaro.org/scheduler/job/1057628#L5461

--=20
Linaro LKFT
https://lkft.linaro.org

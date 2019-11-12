Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA431F8712
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 04:19:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbfKLDT4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 22:19:56 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:35779 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726910AbfKLDTz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 22:19:55 -0500
Received: by mail-lj1-f196.google.com with SMTP id r7so16071295ljg.2
        for <stable@vger.kernel.org>; Mon, 11 Nov 2019 19:19:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=maxRB8NcBCOdBpB3vpvql5jw6cqna2GrST/WafD37Ws=;
        b=Z2pv3bIkLjmKx2+CXFTEvAxLAx2G/vuXHHRQRS/bWKOz1P5wE4NIdp76VUv2+3Lr8d
         DIbmAv8MbL8om0EoBmmA6XIfGiqEBcFCbG5mqnq2SSzdkLVKy7pJblZPTXLpdj7eRmm7
         tdp78ceXIwaHipTy4Nqg2W3JJRn8HZKfenIC0cZSv6qK7C0XYl7lJMs+LSISBFpJ0Fob
         Rh2T0tzTXibRqneAkaJpY8EBejyBL+mW5YpJPg9VVa56GVJr98JgJn3DIlPg/f1i+otP
         XUOvx2kqgf3Q3aqCvab9S3LZN1diyMaRiqH0Cy9CR/6nTXvvl/Ejjo9KaaNZOs3QMQvD
         aZNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=maxRB8NcBCOdBpB3vpvql5jw6cqna2GrST/WafD37Ws=;
        b=m7G6J97+ErTXw+4YHq0Afcc+HxhesuUQY5QTRpbycJJNyJwPVSiWJdS35M2AiNDZds
         hFg0zWrQUKlt99d2gqtmmnjwr0h5z1CZ4ZQY0ObaeXbjxY+kl55WZzs4qa2YAbxwt0aC
         l4ljH3FW/Tbsb1P+LU4FDM6Wk9Qfciz9uKy9KlgkMaYrVq/j8z7E2v39D8qltyMq/Ve1
         b+SVB+1c/yW4vz8kf/0JZ7LrkLaKWfX9wPsSTbzsbN46QAC/a4J1TVbI+2BP7BVy9fRG
         9aTBn0ZvslePRzOGRVJCJnxY7VakK4Xv+zcOccxo2oeVpz8D+WRExRwsxIyO9yJdue1l
         Poqg==
X-Gm-Message-State: APjAAAUv3R1HXFi0vsEhjbDcVzJ4kiBgKoJvcMw2dfRezHVT8ViSdCjY
        2V0r5IDBtLEp58Hd3FrKuZkvNGZ62YULExrXzVsYuw==
X-Google-Smtp-Source: APXvYqwgUf7LYCc28TxWZMGWHrbsKGOJG0Ae1OrQP6ibS1jf78DkEaBndI3l+bucM8KBT8wJFtn/i/GnYDlgpIZBE28=
X-Received: by 2002:a2e:b5b7:: with SMTP id f23mr18496624ljn.236.1573528792129;
 Mon, 11 Nov 2019 19:19:52 -0800 (PST)
MIME-Version: 1.0
References: <0100016e5ae0878e-7b9d1bef-b3be-4350-8823-440929ca4a81-000000@email.amazonses.com>
 <CA+G9fYt=+ymENJg1-m=F3BF8dn7mzxvt5Di34Jw5qFLBHXA5bA@mail.gmail.com> <20191111183059.GA1140707@kroah.com>
In-Reply-To: <20191111183059.GA1140707@kroah.com>
From:   =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Date:   Mon, 11 Nov 2019 21:19:40 -0600
Message-ID: <CAEUSe7-d35WPJnx1hduji80_aym53ztQi-EkCkvu7Kf3S0Wjwg@mail.gmail.com>
Subject: Re: stable-rc 4.14.154-rc1/0d12dcf336c6: regressions detected in
 project stable v.4.14.y on OE - sanity
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Sasha Levin <sashal@kernel.org>, lkft-triage@lists.linaro.org,
        Dan Rue <dan.rue@linaro.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        linux- stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On Mon, 11 Nov 2019 at 12:58, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Mon, Nov 11, 2019 at 11:45:35PM +0530, Naresh Kamboju wrote:
> > Hi Greg,
> >
> > Regressions detected in project stable v.4.14.
> > arm64, arm, x86_64 boot failed.
> >
> > Summary
> > -----------------------------------------------------------------------=
-
> >   git branch: linux-4.14.y
> >   git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linu=
x-stable-rc.git
> >   git commit: a67492b55c53045e9c0b9969f04410723448c1ee
> >   git describe: v4.14.153-104-ga67492b55c53
> >   make_kernelversion: 4.14.154-rc1
> >   kernel-config:
> > http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/juno/lkft/linux=
-stable-rc-4.14/641/config
> >
> >
> > arm64 kernel crash log:
> > ---------------------------
> > [    0.000000] Linux version 4.14.154-rc1 (oe-user@oe-host) (gcc
> > version 7.3.0 (GCC)) #1 SMP PREEMPT Mon Nov 11 17:15:34 UTC 2019
> > [    0.000000] Boot CPU: AArch64 Processor [410fd033]
> > [    0.000000] Machine model: ARM Juno development board (r2)
> > [    0.000000] earlycon: pl11 at MMIO 0x000000007ff80000 (options '')
> > [    0.000000] bootconsole [pl11] enabled
> > [    0.000000] efi: Getting EFI parameters from FDT:
> > [    0.000000] efi: UEFI not found.
> > [    0.000000] cma: Reserved 16 MiB at 0x00000000fe000000
> > [    0.000000] NUMA: No NUMA configuration found
> > [    0.000000] NUMA: Faking a node at [mem
> > 0x0000000000000000-0x00000009ffffffff]
> > [    0.000000] NUMA: NODE_DATA [mem 0x9fffc6f80-0x9fffc8bff]
> > [    0.000000] Zone ranges:
> > [    0.000000]   DMA      [mem 0x0000000080000000-0x00000000ffffffff]
> > [    0.000000]   Normal   [mem 0x0000000100000000-0x00000009ffffffff]
> > [    0.000000] Movable zone start for each node
> > [    0.000000] Early memory node ranges
> > [    0.000000]   node   0: [mem 0x0000000080000000-0x00000000feffffff]
> > [    0.000000]   node   0: [mem 0x0000000880000000-0x00000009ffffffff]
> > [    0.000000] Initmem setup node 0 [mem 0x0000000080000000-0x00000009f=
fffffff]
> > [    0.000000] On node 0 totalpages: 2093056
> > [    0.000000]   DMA zone: 8192 pages used for memmap
> > [    0.000000]   DMA zone: 0 pages reserved
> > [    0.000000]   DMA zone: 520192 pages, LIFO batch:31
> > [    0.000000]   Normal zone: 24576 pages used for memmap
> > [    0.000000]   Normal zone: 1572864 pages, LIFO batch:31
> > [    0.000000] psci: probing for conduit method from DT.
> > [    0.000000] psci: PSCIv1.1 detected in firmware.
> > [    0.000000] psci: Using standard PSCI v0.2 function IDs
> > [    0.000000] psci: Trusted OS migration not required
> > [    0.000000] psci: SMC Calling Convention v1.0
> > [    0.000000] percpu: Embedded 25 pages/cpu s62280 r8192 d31928 u10240=
0
> > [    0.000000] pcpu-alloc: s62280 r8192 d31928 u102400 alloc=3D25*4096
> > [    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 [0] 4 [0] 5
> > [    0.000000] Detected VIPT I-cache on CPU0
> > [    0.000000] CPU features: enabling workaround for ARM erratum 845719
> > [    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 2=
060288
> > [    0.000000] Policy zone: Normal
> > [    0.000000] Kernel command line: console=3DttyAMA0,115200n8
> > root=3D/dev/nfs rw
> > nfsroot=3D10.66.16.123:/var/lib/lava/dispatcher/tmp/1004132/extract-nfs=
rootfs-jn9hl2x_,tcp,hard,intr,vers=3D3
> > rootwait earlycon=3Dpl011,0x7ff80000 debug systemd.log_target=3Dnull
> > user_debug=3D31 androidboot.hardware=3Djuno loglevel=3D9
> > sky2.mac_address=3D0x00,0x02,0xF7,0x00,0x68,0x15 ip=3Ddhcp
> > [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
> > [    0.000000] software IO TLB: mapped [mem 0xf9fff000-0xfdfff000] (64M=
B)
> > [    0.000000] Memory: 8123672K/8372224K available (12988K kernel
> > code, 1878K rwdata, 5196K rodata, 1728K init, 12356K bss, 232168K
> > reserved, 16384K cma-reserved)
> > [    0.000000] Virtual kernel memory layout:
> > [    0.000000]     modules : 0xffff000000000000 - 0xffff000008000000
> > (   128 MB)
> > [    0.000000]     vmalloc : 0xffff000008000000 - 0xffff7dffbfff0000
> > (129022 GB)
> > [    0.000000]       .text : 0xffff000008080000 - 0xffff000008d30000
> > ( 12992 KB)
> > [    0.000000]     .rodata : 0xffff000008d30000 - 0xffff000009250000
> > (  5248 KB)
> > [    0.000000]       .init : 0xffff000009250000 - 0xffff000009400000
> > (  1728 KB)
> > [    0.000000]       .data : 0xffff000009400000 - 0xffff0000095d5a00
> > (  1879 KB)
> > [    0.000000]        .bss : 0xffff0000095d5a00 - 0xffff00000a1e6dd0
> > ( 12357 KB)
> > [    0.000000]     fixed   : 0xffff7dfffe7f9000 - 0xffff7dfffec00000
> > (  4124 KB)
> > [    0.000000]     PCI I/O : 0xffff7dfffee00000 - 0xffff7dffffe00000
> > (    16 MB)
> > [    0.000000]     vmemmap : 0xffff7e0000000000 - 0xffff800000000000
> > (  2048 GB maximum)
> > [    0.000000]               0xffff7e0000000000 - 0xffff7e0026000000
> > (   608 MB actual)
> > [    0.000000]     memory  : 0xffff800000000000 - 0xffff800980000000
> > ( 38912 MB)
> > [    0.000000] Unable to handle kernel NULL pointer dereference at
> > virtual address 00000510
> > [    0.000000] Mem abort info:
> > [    0.000000]   Exception class =3D DABT (current EL), IL =3D 32 bits
> > [    0.000000]   SET =3D 0, FnV =3D 0
> > [    0.000000]   EA =3D 0, S1PTW =3D 0
> > [    0.000000] Data abort info:
> > [    0.000000]   ISV =3D 0, ISS =3D 0x00000004
> > [    0.000000]   CM =3D 0, WnR =3D 0
> > [    0.000000] [0000000000000510] user address but active_mm is swapper
> > [    0.000000] Internal error: Oops: 96000004 [#1] PREEMPT SMP
> > [    0.000000] Modules linked in:
> > [    0.000000] Process swapper (pid: 0, stack limit =3D 0xffff000009400=
000)
> > [    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 4.14.154-rc1 #1
> > [    0.000000] Hardware name: ARM Juno development board (r2) (DT)
> > [    0.000000] task: ffff000009419780 task.stack: ffff000009400000
> > [    0.000000] PC is at __rmqueue+0x3c4/0x908
> > [    0.000000] LR is at __rmqueue+0x384/0x908
> > [    0.000000] pc : [<ffff0000082594ec>] lr : [<ffff0000082594ac>]
> > pstate: 600000c5
> > [    0.000000] sp : ffff000009403b10
> > [    0.000000] x29: ffff000009403b10 x28: 0000000000000000
> > [    0.000000] x27: 000000000000000a x26: ffff80097ffc7700
> > [    0.000000] x25: 00007ff6800387c0 x24: 0000000000000000
> > [    0.000000] x23: ffff00000940f000 x22: ffff80097ffc7800
> > [    0.000000] x21: ffffffffffffff00 x20: ffff80097ffc7840
> > [    0.000000] x19: ffff0000093ef000 x18: 0000000000000001
> > [    0.000000] x17: 000000000000001c x16: 000000000000001b
> > [    0.000000] x15: 000000000000001a x14: ffff0000096833f8
> > [    0.000000] x13: ffff0000095e3198 x12: 000000000c67c24e
> > [    0.000000] x11: ffff000009419fb0 x10: ffff00000a174000
> > [    0.000000] x9 : ffff00000988b728 x8 : 0000000000000000
> > [    0.000000] x7 : ffff0000092cf3a4 x6 : 0000000000000000
> > [    0.000000] x5 : fffffffffffff1ff x4 : ffff7e0025de0020
> > [    0.000000] x3 : ffff7e0025dd0020 x2 : 000000000000000a
> > [    0.000000] x1 : 000000000000001e x0 : 0000000000000410
> > [    0.000000] Call trace:
> > [    0.000000] Exception stack(0xffff0000094039d0 to 0xffff000009403b10=
)
> > [    0.000000] 39c0:
> > 0000000000000410 000000000000001e
> > [    0.000000] 39e0: 000000000000000a ffff7e0025dd0020
> > ffff7e0025de0020 fffffffffffff1ff
> > [    0.000000] 3a00: 0000000000000000 ffff0000092cf3a4
> > 0000000000000000 ffff00000988b728
> > [    0.000000] 3a20: ffff00000a174000 ffff000009419fb0
> > 000000000c67c24e ffff0000095e3198
> > [    0.000000] 3a40: ffff0000096833f8 000000000000001a
> > 000000000000001b 000000000000001c
> > [    0.000000] 3a60: 0000000000000001 ffff0000093ef000
> > ffff80097ffc7840 ffffffffffffff00
> > [    0.000000] 3a80: ffff80097ffc7800 ffff00000940f000
> > 0000000000000000 00007ff6800387c0
> > [    0.000000] 3aa0: ffff80097ffc7700 000000000000000a
> > 0000000000000000 ffff000009403b10
> > [    0.000000] 3ac0: ffff0000082594ac ffff000009403b10
> > ffff0000082594ec 00000000600000c5
> > [    0.000000] 3ae0: ffffffffffffff00 ffff80097ffc7800
> > ffffffffffffffff ffff0000082594ac
> > [    0.000000] 3b00: ffff000009403b10 ffff0000082594ec
> > [    0.000000] [<ffff0000082594ec>] __rmqueue+0x3c4/0x908
> > [    0.000000] [<ffff000008259e98>] get_page_from_freelist+0x468/0xcb8
> > [    0.000000] [<ffff00000825aa3c>] __alloc_pages_nodemask+0x12c/0x1248
> > [    0.000000] [<ffff0000082cdba8>] new_slab+0xc0/0x568
> > [    0.000000] [<ffff0000082d5328>] __kmem_cache_create+0x2e0/0x628
> > [    0.000000] [<ffff000009271dec>] create_boot_cache+0xa8/0xdc
> > [    0.000000] [<ffff000009275b40>] kmem_cache_init+0x58/0x120
> > [    0.000000] [<ffff000009250b3c>] start_kernel+0x200/0x3d8
> > [    0.000000] Code: 8b000401 8b010800 d37df000 8b081000 (f9408000)
> > [    0.000000] random: get_random_bytes called from
> > print_oops_end_marker+0x54/0x70 with crng_init=3D0
> > [    0.000000] ---[ end trace c75a488acdeef932 ]---
> > [    0.000000] Kernel panic - not syncing: Attempted to kill the idle t=
ask!
> > [    0.000000] ---[ end Kernel panic - not syncing: Attempted to kill
> > the idle task!
> >
> >
> > Full test log link,
> > https://lkft.validation.linaro.org/scheduler/job/1004132#L482
>
> Any chance you can bisect?

Reverting 61dbb1f20417 ("mm, meminit: recalculate pcpu batch and high
limits after init completes") got the system working again.

Greetings!

Daniel D=C3=ADaz
daniel.diaz@linaro.org

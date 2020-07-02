Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C022212907
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 18:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbgGBQI7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jul 2020 12:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbgGBQI7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jul 2020 12:08:59 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7638C08C5C1;
        Thu,  2 Jul 2020 09:08:58 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id e22so24538550edq.8;
        Thu, 02 Jul 2020 09:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8Kfuc5CARnznbS/qlVEzSK3r70q6/7pjU8+G3Y0ONZI=;
        b=ZYCgLK9qiGagOawdqT3P3TYcEgNthQX8uAwqYFVMVmhWg4mEBJcJcfKopH1dxnFCZG
         d06E7zXNUBwOlwmjbZJlzAHFAr4h7440/Na31kpFSlzojkZCQG5q92KcXyBVc0MZgB4w
         Hp6Cy8oBy3wYmwaBlXQ/Ij84Bf6swq+s4cxM9Z87KrrhWpgFfHqLByP3fpkuoac/2dyM
         R+FgZQ/14l38ozg7gzJj02rfIErZMvdmqeOGEbuvqyD2C7aXi1FZkt8kWNptfgWzKt8t
         BVm2N7Mu1QZkfD6NN05GifskD6BlfGDJD0rWKI2V+/6mixyLm/w8rsPFnbg1/TqnLPG9
         fRQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8Kfuc5CARnznbS/qlVEzSK3r70q6/7pjU8+G3Y0ONZI=;
        b=lC9mTbppVQYxIgJ9yWc6lBminlTRfP6lD5Vydp+u+2GCYsMUOrN2nQYRj//mnPPNzp
         nYG+k7rALDjeOJX2snmPAJVD53aEGlP/TadzGg33Q4JFYXL0P5YanHRfGBfH4oJPQ3cp
         O4PXAZh8R0w6tl3lpAq9JzzPUFz47iya3Q/adhl6Ipia6VhxwfGmrmm2TefvE1qSGzPU
         KXIOSatJTihVnJmvz5kvkUdwu8nBPPSPHq3dkCO2OY541cRKPQ2FUu+QiJkRQkBWqFXa
         syNfhdmGr+wgZj1uys9cshOAb9xYY3GKcC4gtxb62/AP6rDK6WCMlmxFilySnsbZCqrx
         yxIg==
X-Gm-Message-State: AOAM532H1xQ/LVrYPb9XKJDmWeT65Wm2UQE4/ceZaS3FVrf7JVsa53um
        WTCKvGKuS19auMvCc/L8TWo5gcKqO1shTw6PQw==
X-Google-Smtp-Source: ABdhPJy0waChbv7GcIB7p+vu56ctYGZl91rMkT00jMJlYf9qe5Yl7H0hV7JxcPSfML8h0lgVzwXZWnf2is39PO0vCDU=
X-Received: by 2002:a50:cbcd:: with SMTP id l13mr19086813edi.384.1593706137348;
 Thu, 02 Jul 2020 09:08:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200702012202.2700645-1-sashal@kernel.org> <20200702012202.2700645-37-sashal@kernel.org>
In-Reply-To: <20200702012202.2700645-37-sashal@kernel.org>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 2 Jul 2020 09:08:45 -0700
Message-ID: <CAKywueRGSriwuMGtG53i3Bm_ek_k1LMAK0fojf9++7=ar+6u8Q@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.7 37/53] cifs: Fix double add page to memcg when cifs_readpages
To:     Sasha Levin <sashal@kernel.org>
Cc:     Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Steve French <stfrench@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

=D1=81=D1=80, 1 =D0=B8=D1=8E=D0=BB. 2020 =D0=B3. =D0=B2 18:35, Sasha Levin =
<sashal@kernel.org>:
>
> From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
>
> [ Upstream commit 95a3d8f3af9b0d63b43f221b630beaab9739d13a ]
>
> When xfstests generic/451, there is an BUG at mm/memcontrol.c:
>   page:ffffea000560f2c0 refcount:2 mapcount:0 mapping:000000008544e0ea
>        index:0xf
>   mapping->aops:cifs_addr_ops dentry name:"tst-aio-dio-cycle-write.451"
>   flags: 0x2fffff80000001(locked)
>   raw: 002fffff80000001 ffffc90002023c50 ffffea0005280088 ffff88815cda021=
0
>   raw: 000000000000000f 0000000000000000 00000002ffffffff ffff88817287d00=
0
>   page dumped because: VM_BUG_ON_PAGE(page->mem_cgroup)
>   page->mem_cgroup:ffff88817287d000
>   ------------[ cut here ]------------
>   kernel BUG at mm/memcontrol.c:2659!
>   invalid opcode: 0000 [#1] SMP
>   CPU: 2 PID: 2038 Comm: xfs_io Not tainted 5.8.0-rc1 #44
>   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_
>     073836-buildvm-ppc64le-16.ppc.4
>   RIP: 0010:commit_charge+0x35/0x50
>   Code: 0d 48 83 05 54 b2 02 05 01 48 89 77 38 c3 48 c7
>         c6 78 4a ea ba 48 83 05 38 b2 02 05 01 e8 63 0d9
>   RSP: 0018:ffffc90002023a50 EFLAGS: 00010202
>   RAX: 0000000000000000 RBX: ffff88817287d000 RCX: 0000000000000000
>   RDX: 0000000000000000 RSI: ffff88817ac97ea0 RDI: ffff88817ac97ea0
>   RBP: ffffea000560f2c0 R08: 0000000000000203 R09: 0000000000000005
>   R10: 0000000000000030 R11: ffffc900020237a8 R12: 0000000000000000
>   R13: 0000000000000001 R14: 0000000000000001 R15: ffff88815a1272c0
>   FS:  00007f5071ab0800(0000) GS:ffff88817ac80000(0000) knlGS:00000000000=
00000
>   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   CR2: 000055efcd5ca000 CR3: 000000015d312000 CR4: 00000000000006e0
>   DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>   DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>   Call Trace:
>    mem_cgroup_charge+0x166/0x4f0
>    __add_to_page_cache_locked+0x4a9/0x710
>    add_to_page_cache_locked+0x15/0x20
>    cifs_readpages+0x217/0x1270
>    read_pages+0x29a/0x670
>    page_cache_readahead_unbounded+0x24f/0x390
>    __do_page_cache_readahead+0x3f/0x60
>    ondemand_readahead+0x1f1/0x470
>    page_cache_async_readahead+0x14c/0x170
>    generic_file_buffered_read+0x5df/0x1100
>    generic_file_read_iter+0x10c/0x1d0
>    cifs_strict_readv+0x139/0x170
>    new_sync_read+0x164/0x250
>    __vfs_read+0x39/0x60
>    vfs_read+0xb5/0x1e0
>    ksys_pread64+0x85/0xf0
>    __x64_sys_pread64+0x22/0x30
>    do_syscall_64+0x69/0x150
>    entry_SYSCALL_64_after_hwframe+0x44/0xa9
>   RIP: 0033:0x7f5071fcb1af
>   Code: Bad RIP value.
>   RSP: 002b:00007ffde2cdb8e0 EFLAGS: 00000293 ORIG_RAX: 0000000000000011
>   RAX: ffffffffffffffda RBX: 00007ffde2cdb990 RCX: 00007f5071fcb1af
>   RDX: 0000000000001000 RSI: 000055efcd5ca000 RDI: 0000000000000003
>   RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000000
>   R10: 0000000000001000 R11: 0000000000000293 R12: 0000000000000001
>   R13: 000000000009f000 R14: 0000000000000000 R15: 0000000000001000
>   Modules linked in:
>   ---[ end trace 725fa14a3e1af65c ]---
>
> Since commit 3fea5a499d57 ("mm: memcontrol: convert page cache to a new
> mem_cgroup_charge() API") not cancel the page charge, the pages maybe
> double add to pagecache:
> thread1                       | thread2
> cifs_readpages
> readpages_get_pages
>  add_to_page_cache_locked(head,index=3Dn)=3D0
>                               | readpages_get_pages
>                               | add_to_page_cache_locked(head,index=3Dn+1=
)=3D0
>  add_to_page_cache_locked(head, index=3Dn+1)=3D-EEXIST
>  then, will next loop with list head page's
>  index=3Dn+1 and the page->mapping not NULL
> readpages_get_pages
> add_to_page_cache_locked(head, index=3Dn+1)
>  commit_charge
>   VM_BUG_ON_PAGE
>
> So, we should not do the next loop when any page add to page cache
> failed.
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> Acked-by: Ronnie Sahlberg <lsahlber@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Hi Sasha,

The patch description mentions the commit 3fea5a499d57 that changed
the behavior and was introduced in v5.8-rc1. I noticed that you are
targeting this patch for 4.9, 4.14, 4.19, 5.4 and 5.7 stable branches.
Are you going to backport the commit 3fea5a499d57 as well?

--
Best regards,
Pavel Shilovsky

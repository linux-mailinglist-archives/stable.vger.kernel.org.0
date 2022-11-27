Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 720BC639E37
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 00:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbiK0XZt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Nov 2022 18:25:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiK0XZs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Nov 2022 18:25:48 -0500
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA7F7D2EF
        for <stable@vger.kernel.org>; Sun, 27 Nov 2022 15:25:47 -0800 (PST)
Received: by mail-il1-f199.google.com with SMTP id w9-20020a056e021c8900b0030247910269so7263350ill.4
        for <stable@vger.kernel.org>; Sun, 27 Nov 2022 15:25:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KZRYXKUW8T1ja8sd6rnphgKyBOyFltUo8CnjTEUgeg0=;
        b=AOpUb1CFr90z2Z3oGHIj6G0fQYcVvkv2INDwf9/8sTOZeJcr9y8J4lE+5A9vhKs9Q6
         dR9wGmbZx8YRG2jwokaBwGhXWqDVib+rc9RPBa61b2F5JaHVdWm+6E7GhRwS9GcgqL7a
         DC5x6O/nNZ+5SM0d35erTMtSBmRItSYyOc09foSMMmKGRZcqg0PRa1sBuxieby1m0uay
         wt8dllF2aE6eZ/XqggAXMKdfqU9WMnkcZrMXfPDNRiOPFl4nngTnwFMN8+kiphTiJ2EQ
         DBCPKrBZz2mYXA1LMVOHuqRUGuiFzaseDRh0VcP9wB6AFNLnY7lUdcTp9k917+MzRy5E
         KU7w==
X-Gm-Message-State: ANoB5pkFFjo/76mkqsB+4adHKmfUrx4Of4NCi7oMEV0Q/rUxaUsItGWA
        fol19y4rt80Cj+agsvP2BXLd2ScHMVQ4gIOAftG6c5E7umMK
X-Google-Smtp-Source: AA0mqf6mRwdyA9KULlqMbowARjykHhNEQNmFyrSJh6fSi+bqcsmdB41OYnFEHEPnrk0F7lDsShczmhlausKMLSh97mAxHKUATX49
MIME-Version: 1.0
X-Received: by 2002:a5d:8b49:0:b0:6de:be88:9977 with SMTP id
 c9-20020a5d8b49000000b006debe889977mr12635971iot.66.1669591547085; Sun, 27
 Nov 2022 15:25:47 -0800 (PST)
Date:   Sun, 27 Nov 2022 15:25:47 -0800
In-Reply-To: <0000000000001a08ae05d5c2de52@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000158c6005ee7c13dc@google.com>
Subject: Re: [syzbot] general protection fault in gfs2_dump_glock
From:   syzbot <syzbot+c6fd14145e2f62ca0784@syzkaller.appspotmail.com>
To:     agruenba@redhat.com, cluster-devel@redhat.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        rpeterso@redhat.com, sashal@kernel.org,
        stable-commits@vger.kernel.org, stable@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    faf68e3523c2 Merge tag 'kbuild-fixes-v6.1-4' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16c3fb9b880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8d01b6e3197974dd
dashboard link: https://syzkaller.appspot.com/bug?extid=c6fd14145e2f62ca0784
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10fa1ce3880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1092ed73880000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/3bfa6577f378/disk-faf68e35.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/7bf0af58cde3/vmlinux-faf68e35.xz
kernel image: https://storage.googleapis.com/syzbot-assets/3e15d7d640b0/bzImage-faf68e35.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/e69d0b505238/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c6fd14145e2f62ca0784@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: stack-out-of-bounds in gfs2_dump_glock+0x1537/0x1b60
Read of size 8 at addr ffffc9000493fcc0 by task syz-executor301/4070

CPU: 0 PID: 4070 Comm: syz-executor301 Not tainted 6.1.0-rc6-syzkaller-00315-gfaf68e3523c2 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1b1/0x28e lib/dump_stack.c:106
 print_address_description+0x74/0x340 mm/kasan/report.c:284
 print_report+0x107/0x1f0 mm/kasan/report.c:395
 kasan_report+0xcd/0x100 mm/kasan/report.c:495
 gfs2_dump_glock+0x1537/0x1b60
 gfs2_consist_inode_i+0xf3/0x110 fs/gfs2/util.c:465
 gfs2_dirent_scan+0x535/0x650 fs/gfs2/dir.c:602
 gfs2_dirent_search+0x2ea/0xb10 fs/gfs2/dir.c:850
 gfs2_dir_search+0x8c/0x2a0 fs/gfs2/dir.c:1650
 gfs2_lookupi+0x465/0x650 fs/gfs2/inode.c:323
 __gfs2_lookup+0x8c/0x260 fs/gfs2/inode.c:870
 __lookup_slow+0x266/0x3a0 fs/namei.c:1685
 lookup_slow+0x53/0x70 fs/namei.c:1702
 walk_component+0x2e1/0x410 fs/namei.c:1993
 lookup_last fs/namei.c:2450 [inline]
 path_lookupat+0x17d/0x450 fs/namei.c:2474
 filename_lookup+0x274/0x650 fs/namei.c:2503
 user_path_at_empty+0x40/0x1a0 fs/namei.c:2876
 do_readlinkat+0x10c/0x3d0 fs/stat.c:468
 __do_sys_readlink fs/stat.c:501 [inline]
 __se_sys_readlink fs/stat.c:498 [inline]
 __x64_sys_readlink+0x7b/0x90 fs/stat.c:498
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fc648229e99
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 31 19 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fc648189208 EFLAGS: 00000246 ORIG_RAX: 0000000000000059
RAX: ffffffffffffffda RBX: 00007fc6482c0568 RCX: 00007fc648229e99
RDX: 0000000000000047 RSI: 0000000020000140 RDI: 0000000020000000
RBP: 00007fc6482c0560 R08: 00007fc648189700 R09: 0000000000000000
R10: 00007fc648189700 R11: 0000000000000246 R12: 00007fc6482c056c
R13: 00007ffc15b2f1ff R14: 00007fc648189300 R15: 0000000000022000
 </TASK>

The buggy address belongs to the virtual mapping at
 [ffffc90004938000, ffffc90004941000) created by:
 dup_task_struct+0x8b/0x490 kernel/fork.c:974

The buggy address belongs to the physical page:
page:ffffea000073ed00 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1cfb4
memcg:ffff8881481da382
flags: 0xfff00000000000(node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000000 0000000000000000 dead000000000122 0000000000000000
raw: 0000000000000000 0000000000000000 00000001ffffffff ffff8881481da382
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x102dc2(GFP_HIGHUSER|__GFP_NOWARN|__GFP_ZERO), pid 4055, tgid 4055 (syz-executor301), ts 493360110858, free_ts 493203659028
 prep_new_page mm/page_alloc.c:2539 [inline]
 get_page_from_freelist+0x742/0x7c0 mm/page_alloc.c:4291
 __alloc_pages+0x259/0x560 mm/page_alloc.c:5558
 vm_area_alloc_pages mm/vmalloc.c:2975 [inline]
 __vmalloc_area_node mm/vmalloc.c:3043 [inline]
 __vmalloc_node_range+0x8f4/0x1290 mm/vmalloc.c:3213
 alloc_thread_stack_node+0x307/0x500 kernel/fork.c:311
 dup_task_struct+0x8b/0x490 kernel/fork.c:974
 copy_process+0x637/0x4000 kernel/fork.c:2084
 kernel_clone+0x21b/0x620 kernel/fork.c:2671
 __do_sys_clone kernel/fork.c:2812 [inline]
 __se_sys_clone kernel/fork.c:2796 [inline]
 __x64_sys_clone+0x228/0x290 kernel/fork.c:2796
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1459 [inline]
 free_pcp_prepare+0x80c/0x8f0 mm/page_alloc.c:1509
 free_unref_page_prepare mm/page_alloc.c:3387 [inline]
 free_unref_page_list+0xb4/0x7b0 mm/page_alloc.c:3529
 release_pages+0x232a/0x25c0 mm/swap.c:1055
 __pagevec_release+0x7d/0xf0 mm/swap.c:1075
 pagevec_release include/linux/pagevec.h:71 [inline]
 folio_batch_release include/linux/pagevec.h:135 [inline]
 truncate_inode_pages_range+0x472/0x17f0 mm/truncate.c:373
 kill_bdev block/bdev.c:76 [inline]
 blkdev_flush_mapping+0x153/0x2c0 block/bdev.c:662
 blkdev_put_whole block/bdev.c:693 [inline]
 blkdev_put+0x4a5/0x730 block/bdev.c:953
 deactivate_locked_super+0xa7/0xf0 fs/super.c:332
 cleanup_mnt+0x494/0x520 fs/namespace.c:1186
 task_work_run+0x243/0x300 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 exit_to_user_mode_loop+0x124/0x150 kernel/entry/common.c:171
 exit_to_user_mode_prepare+0xb2/0x140 kernel/entry/common.c:203
 __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
 syscall_exit_to_user_mode+0x26/0x60 kernel/entry/common.c:296
 do_syscall_64+0x49/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Memory state around the buggy address:
 ffffc9000493fb80: 00 00 00 00 f1 f1 f1 f1 00 00 00 00 00 00 00 00
 ffffc9000493fc00: 00 f2 f2 f2 f2 f2 00 f2 f2 f2 00 00 00 00 00 00
>ffffc9000493fc80: 00 00 00 00 00 00 00 00 f3 f3 f3 f3 00 00 00 00
                                           ^
 ffffc9000493fd00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffffc9000493fd80: f1 f1 f1 f1 04 f3 f3 f3 00 00 00 00 00 00 00 00
==================================================================


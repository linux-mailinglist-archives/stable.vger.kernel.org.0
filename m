Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 656622D9A47
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 15:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731134AbgLNOsy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 09:48:54 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:40707 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407612AbgLNOso (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Dec 2020 09:48:44 -0500
Received: by mail-il1-f198.google.com with SMTP id g1so7987455ilq.7
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 06:48:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=iQ6osCsvX+pY/vfkv46SyLKYoeGekDUy36uAE1KOgCg=;
        b=XCx1HuvDZZ0NI3ETI4QR7pmJwnJyu90fiJFBEO22OxYBj6eesxEodQdMlUuAIKIaDn
         Q//DAwQt0XvXkv/sSe94Ym91lcSXsywcv2h6CV01FfGH7S9ai6HBa0yq5ABqgGORyYGW
         3rK9dnbLzRvwov+TAQ9eWKaaTlA1sJ2TL6xHMRNoxV9SQHz3RgOKPFmGNbQ/zqX/R7vx
         0hZ9A6s3GYXqd7LJ26zBXDTn1/LKVliq3IYLgDYsYo4iTCW4NsdLRT+nK2wy4tyGiY7Z
         Vo5ajy6eF2yoOwXdyhQYQeEISpoKSrvtpfLUkmYzR2F1Sl6lA9nw2NcmaHIysu3dek+0
         E5fA==
X-Gm-Message-State: AOAM531/2aT9wWud8roKLYo9TB4wNJCygQvvaiOQwJFQfWGLizMA+w68
        bIQiTPRyfF/EmsPdJ7kJHs03HtAa575oIs33L0OW/+YbHj8T
X-Google-Smtp-Source: ABdhPJz28Thz98ZstaRTtBcqoDH1wBs/0lpdWE4sqhgOspe3Gbbh81ljfM/ufnBNe/VaLL39+qX70TVdWDE+mtKr9roulJUOiqCb
MIME-Version: 1.0
X-Received: by 2002:a02:b02:: with SMTP id 2mr33587692jad.15.1607957283301;
 Mon, 14 Dec 2020 06:48:03 -0800 (PST)
Date:   Mon, 14 Dec 2020 06:48:03 -0800
In-Reply-To: <X9dDkwlOTFeo9eZ6@localhost>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000af6ec005b66dbaa2@google.com>
Subject: Re: WARNING in yurex_write/usb_submit_urb
From:   syzbot <syzbot+e87ebe0f7913f71f2ea5@syzkaller.appspotmail.com>
To:     andreyknvl@google.com, gregkh@linuxfoundation.org,
        johan@kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, stable@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
WARNING in yurex_write/usb_submit_urb

------------[ cut here ]------------
URB 00000000d1c13d63 submitted while active
WARNING: CPU: 1 PID: 12383 at drivers/usb/core/urb.c:378 usb_submit_urb+0x1228/0x14e0 drivers/usb/core/urb.c:378
Modules linked in:
CPU: 1 PID: 12383 Comm: syz-executor.2 Not tainted 5.10.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:usb_submit_urb+0x1228/0x14e0 drivers/usb/core/urb.c:378
Code: 89 de e8 1b cd 3b fc 84 db 0f 85 da f4 ff ff e8 fe d4 3b fc 4c 89 fe 48 c7 c7 20 59 e1 89 c6 05 14 8c a4 07 01 e8 a4 b3 78 03 <0f> 0b e9 b8 f4 ff ff c7 44 24 14 01 00 00 00 e9 6f f5 ff ff 41 bd
RSP: 0018:ffffc90001c9fcb8 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff888020788000 RSI: ffffffff8158c835 RDI: fffff52000393f89
RBP: 1ffff92000393fa9 R08: 0000000000000001 R09: ffff8880b9f30627
R10: 0000000000000000 R11: 0000000000000000 R12: ffff8880276ea400
R13: 00000000fffffff0 R14: ffff8880276ea4e8 R15: ffff888012dca100
FS:  00007fad9e6f7700(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005587bf0f4160 CR3: 00000000252a1000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 yurex_write+0x3f4/0x840 drivers/usb/misc/yurex.c:494
 vfs_write+0x28e/0xa30 fs/read_write.c:603
 ksys_write+0x12d/0x250 fs/read_write.c:658
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45e159
Code: 0d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fad9e6f6c68 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000045e159
RDX: 0000000000000001 RSI: 0000000020000740 RDI: 0000000000000004
RBP: 000000000119bfc0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000119bf8c
R13: 00007ffc9fc101ef R14: 00007fad9e6f79c0 R15: 000000000119bf8c


Tested on:

commit:         a256e240 usb: phy: convert comma to semicolon
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing
console output: https://syzkaller.appspot.com/x/log.txt?x=17357137500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4536e7f93c2bc8e9
dashboard link: https://syzkaller.appspot.com/bug?extid=e87ebe0f7913f71f2ea5
compiler:       gcc (GCC) 10.1.0-syz 20200507


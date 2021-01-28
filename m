Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07B2C308104
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 23:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231239AbhA1WSR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 17:18:17 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:40057 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbhA1WSB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jan 2021 17:18:01 -0500
Received: by mail-il1-f197.google.com with SMTP id v16so6005512iln.7
        for <stable@vger.kernel.org>; Thu, 28 Jan 2021 14:17:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=bm4A13bleoXfQHPA/Yuh/7a94hxryJfoV2u5z8MqU6A=;
        b=tiRmuFeHEZdMSm1sn09slpKsaKlmJN1AkF8nRQQwsN/ecNazOsJYsu8o8FnwRb/Xfg
         qvRFoopcW8q7XioABH2VIL9CFPMK9L1UnZD892vEqQZzaJ4KPz+gfxSV8zS3Evvna6XK
         +2KDmi83Gdcf0ljocX/jKMPk4EaOD4FJox5mvigN2T0bQuJP8Pzbrx3RQhudCJ+9/RkT
         va2nEtzLYBgh+O6MeTAAlM/t5n7+aQXjJib9rCC9KLBU6uJPED1dFG9T9QRg+DmAkkvw
         JL1iaW1UNe7NsX83egOWF/etDRYyeIhNTakmkBy2PmN+JiyMWNqwx5LXm54kvq+Aq9vO
         dGuw==
X-Gm-Message-State: AOAM5300mnRcLZmehSATf3BiXvGYa8ucFMlthWjpODbe2FNqTVstAa/w
        lCNGKvmJCp8/JiaR3h5lDCB8p7BwFOXbghXOktinKkr1Nehe
X-Google-Smtp-Source: ABdhPJzox9IHQNM9RKt/w1c5aG0r9TYJ0H6v4wDyngK2Y1JDEVK5QloPJZ3ViPBDfCzBJp8kcBLhaKFb36fOUd3sa05hyFGPsOAt
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2e14:: with SMTP id o20mr1292331iow.179.1611872240011;
 Thu, 28 Jan 2021 14:17:20 -0800 (PST)
Date:   Thu, 28 Jan 2021 14:17:20 -0800
In-Reply-To: <000000000000619ae405b9f8cf6e@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004a0f5305b9fd40b9@google.com>
Subject: Re: WARNING in io_uring_cancel_task_requests
From:   syzbot <syzbot+3e3d9bd0c6ce9efbc3ef@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    d03154e8 Add linux-next specific files for 20210128
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=12e976e8d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6953ffb584722a1
dashboard link: https://syzkaller.appspot.com/bug?extid=3e3d9bd0c6ce9efbc3ef
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=163f0fc8d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3e3d9bd0c6ce9efbc3ef@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 11283 at fs/io_uring.c:9042 io_uring_cancel_task_requests+0xe55/0x10c0 fs/io_uring.c:9042
Modules linked in:
CPU: 0 PID: 11283 Comm: syz-executor.4 Not tainted 5.11.0-rc5-next-20210128-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:io_uring_cancel_task_requests+0xe55/0x10c0 fs/io_uring.c:9042
Code: 00 00 e9 1c fe ff ff 48 8b 7c 24 18 e8 f4 b4 da ff e9 f2 fc ff ff 48 8b 7c 24 18 e8 e5 b4 da ff e9 64 f2 ff ff e8 eb 16 97 ff <0f> 0b e9 ed f2 ff ff e8 df b4 da ff e9 c8 f5 ff ff 4c 89 ef e8 52
RSP: 0018:ffffc90002b8f950 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff88801849d000 RCX: 0000000000000000
RDX: ffff8880277d0000 RSI: ffffffff81dbfe65 RDI: ffff88801849d0d0
RBP: ffff88801849d0e8 R08: 0000000000000000 R09: ffff8880277d0007
R10: ffffffff81dbf0df R11: 0000000000000000 R12: ffff88801849d000
R13: ffff8880277d0000 R14: ffff88803d874400 R15: ffff888028d0e018
FS:  0000000000000000(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f40244ffdb8 CR3: 0000000019c59000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 io_uring_flush+0x47b/0x6e0 fs/io_uring.c:9227
 filp_close+0xb4/0x170 fs/open.c:1295
 close_files fs/file.c:403 [inline]
 put_files_struct fs/file.c:418 [inline]
 put_files_struct+0x1cc/0x350 fs/file.c:415
 exit_files+0x7e/0xa0 fs/file.c:435
 do_exit+0xc22/0x2ae0 kernel/exit.c:820
 do_group_exit+0x125/0x310 kernel/exit.c:922
 get_signal+0x427/0x20f0 kernel/signal.c:2773
 arch_do_signal_or_restart+0x2a8/0x1eb0 arch/x86/kernel/signal.c:811
 handle_signal_work kernel/entry/common.c:147 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0x148/0x250 kernel/entry/common.c:201
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:302
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45e219
Code: Unable to access opcode bytes at RIP 0x45e1ef.
RSP: 002b:00007f0355608cf8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 000000000119bf88 RCX: 000000000045e219
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 000000000119bf88
RBP: 000000000119bf80 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000119bf8c
R13: 00007fff5130821f R14: 00007f03556099c0 R15: 000000000119bf8c


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56808443205
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 16:49:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234309AbhKBPwS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 11:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231928AbhKBPwR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Nov 2021 11:52:17 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A751EC0613F5
        for <stable@vger.kernel.org>; Tue,  2 Nov 2021 08:49:42 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 77-20020a1c0450000000b0033123de3425so2364023wme.0
        for <stable@vger.kernel.org>; Tue, 02 Nov 2021 08:49:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1/AwcpwHid/iKgE6YzMr8f5yyIr2f+Cc8JLIysr34Y4=;
        b=L8vvB/1Bpjm0RO2uM2g0eQXIJQJSD0ssSv1by4g8qLUXz6S3QGPEKjW7uKbXMh7VFk
         v+ZrtAdDuCtoI/jO2KYXNBkXG0ljpBKVpzuNh7UpBEfYa4AbhlkWmkPu6rsXO9r1DYhq
         9xI/ZQ1onPRmPQ+nPEJe4aRsfNQIOiDJbyvdkbQKIDJTN90eqNK2wC8LgdrSQlrWoUyw
         QmHepz6WV3z9EqMvZesinjAvqEq9YRVOhWvInBY3uJeHYpii9ymo7MgmqTf3s2L7nSKN
         sx0AN90QzCWRpC3DGqsQoAGRy9+cAuaGiA1q3TTItQcZ7xpd1bDbTSzoq9r1wGLzq67l
         k5nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1/AwcpwHid/iKgE6YzMr8f5yyIr2f+Cc8JLIysr34Y4=;
        b=kFbjcbKToeMdbmlKmpi1DUUA4C6FQSGEHdVk6U7Ud8EocrsCBJMzpGXVr41akCcykI
         acoFrDvUsFVSdqCmXNe83HFO7uGO/8nzTIsBqhNc8CsIJKz+H65yqwYT4HtqK5Y81+Lk
         2bNIayXW2E0deRXrmhkAzc+3S1y2bf8F7yHwhMjRtxYKiQ2bxHmK8lVi/1dxJ/f7A011
         DdNFuyrvfsMVM6Jqzpp26wL4cY6BWzCjph5hdhP/hKhaJTrWS6m3JDC9Iz1L8KQLMqzm
         I1WLIVFvi4D+/bqacNS9apHH98opvtW00VWC9t2eLYMMr/VhZm8CVUaveDbC+BgKokvb
         r8oQ==
X-Gm-Message-State: AOAM533b5qZsFJvZ4qt0pxwWFGXRtvo0iKGRtrT+0u00zJB8YiQfNGD4
        TcOLEMiay72Nj5cAdKWmRDN5CRwm9eSBjg==
X-Google-Smtp-Source: ABdhPJzkSu6IIk0Zd1e1NroUCwM1DlOaWS9XWxjhap32xHX4eVw74GoIwmnAWbTCGrK0FnU32oSx0g==
X-Received: by 2002:a1c:1fcf:: with SMTP id f198mr8025541wmf.66.1635868180926;
        Tue, 02 Nov 2021 08:49:40 -0700 (PDT)
Received: from localhost.localdomain ([95.148.6.174])
        by smtp.gmail.com with ESMTPSA id l11sm16017760wrp.61.2021.11.02.08.49.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 08:49:40 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org, asml.silence@gmail.com, axboe@kernel.dk
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        syzbot+b0003676644cf0d6acc4@syzkaller.appspotmail.com
Subject: [PATCH v5.10.y 1/1] Revert "io_uring: reinforce cancel on flush during exit"
Date:   Tue,  2 Nov 2021 15:49:30 +0000
Message-Id: <20211102154930.2282421-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 88dbd085a51ec78c83dde79ad63bca8aa4272a9d.

Causes the following Syzkaller reported issue:

BUG: kernel NULL pointer dereference, address: 0000000000000010
PGD 0 P4D 0
Oops: 0002 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 546 Comm: syz-executor631 Tainted: G    B             5.10.76-syzkaller-01178-g4944ec82ebb9 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:arch_atomic_try_cmpxchg syzkaller/managers/android-5-10/kernel/./arch/x86/include/asm/atomic.h:202 [inline]
RIP: 0010:atomic_try_cmpxchg_acquire syzkaller/managers/android-5-10/kernel/./include/asm-generic/atomic-instrumented.h:707 [inline]
RIP: 0010:queued_spin_lock syzkaller/managers/android-5-10/kernel/./include/asm-generic/qspinlock.h:82 [inline]
RIP: 0010:do_raw_spin_lock_flags syzkaller/managers/android-5-10/kernel/./include/linux/spinlock.h:195 [inline]
RIP: 0010:__raw_spin_lock_irqsave syzkaller/managers/android-5-10/kernel/./include/linux/spinlock_api_smp.h:119 [inline]
RIP: 0010:_raw_spin_lock_irqsave+0x10d/0x210 syzkaller/managers/android-5-10/kernel/kernel/locking/spinlock.c:159
Code: 00 00 00 e8 d5 29 09 fd 4c 89 e7 be 04 00 00 00 e8 c8 29 09 fd 42 8a 04 3b 84 c0 0f 85 be 00 00 00 8b 44 24 40 b9 01 00 00 00 <f0> 41 0f b1 4d 00 75 45 48 c7 44 24 20 0e 36 e0 45 4b c7 04 37 00
RSP: 0018:ffffc90000f174e0 EFLAGS: 00010097
RAX: 0000000000000000 RBX: 1ffff920001e2ea4 RCX: 0000000000000001
RDX: 0000000000000001 RSI: 0000000000000004 RDI: ffffc90000f17520
RBP: ffffc90000f175b0 R08: dffffc0000000000 R09: 0000000000000003
R10: fffff520001e2ea5 R11: 0000000000000004 R12: ffffc90000f17520
R13: 0000000000000010 R14: 1ffff920001e2ea0 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8881f7100000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000010 CR3: 000000000640f000 CR4: 00000000003506a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 prepare_to_wait+0x9c/0x290 syzkaller/managers/android-5-10/kernel/kernel/sched/wait.c:248
 io_uring_cancel_files syzkaller/managers/android-5-10/kernel/fs/io_uring.c:8690 [inline]
 io_uring_cancel_task_requests+0x16a9/0x1ed0 syzkaller/managers/android-5-10/kernel/fs/io_uring.c:8760
 io_uring_flush+0x170/0x6d0 syzkaller/managers/android-5-10/kernel/fs/io_uring.c:8923
 filp_close+0xb0/0x150 syzkaller/managers/android-5-10/kernel/fs/open.c:1319
 close_files syzkaller/managers/android-5-10/kernel/fs/file.c:401 [inline]
 put_files_struct+0x1d4/0x350 syzkaller/managers/android-5-10/kernel/fs/file.c:429
 exit_files+0x80/0xa0 syzkaller/managers/android-5-10/kernel/fs/file.c:458
 do_exit+0x6d9/0x23a0 syzkaller/managers/android-5-10/kernel/kernel/exit.c:808
 do_group_exit+0x16a/0x2d0 syzkaller/managers/android-5-10/kernel/kernel/exit.c:910
 get_signal+0x133e/0x1f80 syzkaller/managers/android-5-10/kernel/kernel/signal.c:2790
 arch_do_signal+0x8d/0x620 syzkaller/managers/android-5-10/kernel/arch/x86/kernel/signal.c:805
 exit_to_user_mode_loop syzkaller/managers/android-5-10/kernel/kernel/entry/common.c:161 [inline]
 exit_to_user_mode_prepare+0xaa/0xe0 syzkaller/managers/android-5-10/kernel/kernel/entry/common.c:191
 syscall_exit_to_user_mode+0x24/0x40 syzkaller/managers/android-5-10/kernel/kernel/entry/common.c:266
 do_syscall_64+0x3d/0x70 syzkaller/managers/android-5-10/kernel/arch/x86/entry/common.c:56
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7fc6d1589a89
Code: Unable to access opcode bytes at RIP 0x7fc6d1589a5f.
RSP: 002b:00007ffd2b5da728 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffdfc RBX: 0000000000005193 RCX: 00007fc6d1589a89
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007fc6d161142c
RBP: 0000000000000032 R08: 00007ffd2b5eb0b8 R09: 0000000000000000
R10: 00007ffd2b5da750 R11: 0000000000000246 R12: 00007fc6d161142c
R13: 00007ffd2b5da750 R14: 00007ffd2b5da770 R15: 0000000000000000
Modules linked in:
CR2: 0000000000000010
---[ end trace fe8044f7dc4d8d65 ]---
RIP: 0010:arch_atomic_try_cmpxchg syzkaller/managers/android-5-10/kernel/./arch/x86/include/asm/atomic.h:202 [inline]
RIP: 0010:atomic_try_cmpxchg_acquire syzkaller/managers/android-5-10/kernel/./include/asm-generic/atomic-instrumented.h:707 [inline]
RIP: 0010:queued_spin_lock syzkaller/managers/android-5-10/kernel/./include/asm-generic/qspinlock.h:82 [inline]
RIP: 0010:do_raw_spin_lock_flags syzkaller/managers/android-5-10/kernel/./include/linux/spinlock.h:195 [inline]
RIP: 0010:__raw_spin_lock_irqsave syzkaller/managers/android-5-10/kernel/./include/linux/spinlock_api_smp.h:119 [inline]
RIP: 0010:_raw_spin_lock_irqsave+0x10d/0x210 syzkaller/managers/android-5-10/kernel/kernel/locking/spinlock.c:159
Code: 00 00 00 e8 d5 29 09 fd 4c 89 e7 be 04 00 00 00 e8 c8 29 09 fd 42 8a 04 3b 84 c0 0f 85 be 00 00 00 8b 44 24 40 b9 01 00 00 00 <f0> 41 0f b1 4d 00 75 45 48 c7 44 24 20 0e 36 e0 45 4b c7 04 37 00
RSP: 0018:ffffc90000f174e0 EFLAGS: 00010097
RAX: 0000000000000000 RBX: 1ffff920001e2ea4 RCX: 0000000000000001
RDX: 0000000000000001 RSI: 0000000000000004 RDI: ffffc90000f17520
RBP: ffffc90000f175b0 R08: dffffc0000000000 R09: 0000000000000003
R10: fffff520001e2ea5 R11: 0000000000000004 R12: ffffc90000f17520
R13: 0000000000000010 R14: 1ffff920001e2ea0 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8881f7100000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000010 CR3: 000000000640f000 CR4: 00000000003506a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess), 1 bytes skipped:
   0:	00 00                	add    %al,(%rax)
   2:	e8 d5 29 09 fd       	callq  0xfd0929dc
   7:	4c 89 e7             	mov    %r12,%rdi
   a:	be 04 00 00 00       	mov    $0x4,%esi
   f:	e8 c8 29 09 fd       	callq  0xfd0929dc
  14:	42 8a 04 3b          	mov    (%rbx,%r15,1),%al
  18:	84 c0                	test   %al,%al
  1a:	0f 85 be 00 00 00    	jne    0xde
  20:	8b 44 24 40          	mov    0x40(%rsp),%eax
  24:	b9 01 00 00 00       	mov    $0x1,%ecx
* 29:	f0 41 0f b1 4d 00    	lock cmpxchg %ecx,0x0(%r13) <-- trapping instruction
  2f:	75 45                	jne    0x76
  31:	48 c7 44 24 20 0e 36 	movq   $0x45e0360e,0x20(%rsp)
  38:	e0 45
  3a:	4b                   	rex.WXB
  3b:	c7                   	.byte 0xc7
  3c:	04 37                	add    $0x37,%al

LINK: https://syzkaller.appspot.com/bug?extid=b0003676644cf0d6acc4
Reported-by: syzbot+b0003676644cf0d6acc4@syzkaller.appspotmail.com
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 fs/io_uring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0736487165da4..32bf80e0a3772 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8757,9 +8757,10 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 	io_cancel_defer_files(ctx, task, files);
 	io_cqring_overflow_flush(ctx, true, task, files);
 
-	io_uring_cancel_files(ctx, task, files);
 	if (!files)
 		__io_uring_cancel_task_requests(ctx, task);
+	else
+		io_uring_cancel_files(ctx, task, files);
 
 	if ((ctx->flags & IORING_SETUP_SQPOLL) && ctx->sq_data) {
 		atomic_dec(&task->io_uring->in_idle);
-- 
2.33.1.1089.g2158813163f-goog


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74CDA49BC29
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 20:35:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbiAYTfE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 14:35:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbiAYTe1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 14:34:27 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A48B6C061744
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 11:34:25 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id v3so13819535pgc.1
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 11:34:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wqkKZwea4Ntd1UMLoEnxDe91teRkaMMO7ADnYpsEdMY=;
        b=Xax9igYolzgTI16rjcvA8qDy9hafAlD+40MG99uerzRhh0xcnwKx0vFFRpRLKXYeH8
         tXPv3lZv2wlrAdPIBPf33UKrEC6hN3ZTkTy65/mll1hln7phNHyMfgImIu018DPHuTHC
         lMkw2UyJ6vdDWTzyFzUHtVqaKKSjOFKPDm+o57lPjotAHyTHwxSAa3fQooLvtqb4LXb0
         5s+Dym2nVR1PFfXPpg/9jAMYwRTxQfmTaMz7PQuafw4Le9KX3N8RI3n0SGZtqocxO4qX
         p6d6ohiKn3Z8GugQHJq2QwVTs442Q97jxAXKnld2tZVN1zn4e0zZ8FmRxhTM7HwuTF7U
         F4TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wqkKZwea4Ntd1UMLoEnxDe91teRkaMMO7ADnYpsEdMY=;
        b=tWhLMVEwudX+i8ld4vLF887hQwQ3AfhsFq5Ygo4AxpUrOfPgmSIYwzNvYK1F4GdDX6
         80z9GPld09t3omHtWo9u0PPpOiw/62XzKUTYOCEImdLPV2e8pBDHSIRdZRfBM/bYTfdh
         frpDuwmHkagbXLTpoJaCSHCWhZ2lMVIzVhliRFfgbQduk84EWdY/aLuikgWR2KnZdi1N
         stofVhBxpU/bu4mo8X9nE53XCwx8qT7XdBRR7CoJQsxiGb77zodDs508XnLMykYRla1/
         snu4sZKCLNyeqXX+kVRWnANXIp2ZfQuxrfmZXvGinE3VH1/tjWweqHOtvasJ6UeBvPBL
         bu4w==
X-Gm-Message-State: AOAM531/fc6sRwQzTjvLIsIxMUJuNioxX7VERz45RkFtL7CBdHYM8wvP
        t+s7ZwDkg9G7U4+X917VobBzJA==
X-Google-Smtp-Source: ABdhPJwKn4xsubm3B306tmrdkEHk+6IyVkLSe3+CfFCGvzbf6On+fSFVFQ3hGvWDObdK1oO/yyE/RQ==
X-Received: by 2002:a05:6a00:1312:b0:4c4:cffa:a4c0 with SMTP id j18-20020a056a00131200b004c4cffaa4c0mr19606314pfu.79.1643139265175;
        Tue, 25 Jan 2022 11:34:25 -0800 (PST)
Received: from localhost.localdomain ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id q7sm19499854pfs.32.2022.01.25.11.34.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 11:34:24 -0800 (PST)
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
To:     peterz@infradead.org
Cc:     Tadeusz Struk <tadeusz.struk@linaro.org>,
        Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Zhang Qiao <zhangqiao22@huawei.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+af7a719bc92395ee41b3@syzkaller.appspotmail.com
Subject: [PATCH v3] sched/fair: Fix fault in reweight_entity
Date:   Tue, 25 Jan 2022 11:34:03 -0800
Message-Id: <20220125193403.778497-1-tadeusz.struk@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Syzbot found a GPF in reweight_entity. This has been bisected to commit
4ef0c5c6b5ba ("kernel/sched: Fix sched_fork() access an invalid sched_task_group")

There is a race between sched_post_fork() and setpriority(PRIO_PGRP)
within a thread group that causes a null-ptr-deref in reweight_entity()
in CFS. The scenario is that the main process spawns number of new
threads, which then call setpriority(PRIO_PGRP, 0, -20), wait, and exit.
For each of the new threads the copy_process() gets invoked, which adds
the new task_struct and calls sched_post_fork() for it.

In the above scenario there is a possibility that setpriority(PRIO_PGRP)
and set_one_prio() will be called for a thread in the group that is just
being created by copy_process(), and for which the sched_post_fork() has
not been executed yet. This will trigger a null pointer dereference in
reweight_entity(), as it will try to access the run queue pointer, which
hasn't been set. This results it a crash as shown below:

KASAN: null-ptr-deref in range [0x00000000000000a0-0x00000000000000a7]
CPU: 0 PID: 2392 Comm: reduced_repro Not tainted 5.16.0-11201-gb42c5a161ea3
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1.fc35 04/01/2014
RIP: 0010:reweight_entity+0x15d/0x440
RSP: 0018:ffffc900035dfcf8 EFLAGS: 00010006
Call Trace:
<TASK>
reweight_task+0xde/0x1c0
set_load_weight+0x21c/0x2b0
set_user_nice.part.0+0x2d1/0x519
set_user_nice.cold+0x8/0xd
set_one_prio+0x24f/0x263
__do_sys_setpriority+0x2d3/0x640
__x64_sys_setpriority+0x84/0x8b
do_syscall_64+0x35/0xb0
entry_SYSCALL_64_after_hwframe+0x44/0xae
</TASK>
---[ end trace 9dc80a9d378ed00a ]---

Before the mentioned change the cfs_rq pointer for the task  has been
set in sched_fork(), which is called much earlier in copy_process(),
before the new task is added to the thread_group.
Now it is done in the sched_post_fork(), which is called after that.
To fix the issue the update_load condition passed to set_load_weight()
in set_user_nice() and __sched_setscheduler() has been changed from
always true to true if the task->state != TASK_NEW.

Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ben Segall <bsegall@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Daniel Bristot de Oliveira <bristot@redhat.com>
Cc: Zhang Qiao <zhangqiao22@huawei.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

Link: https://syzkaller.appspot.com/bug?id=9d9c27adc674e3a7932b22b61c79a02da82cbdc1
Fixes: 4ef0c5c6b5ba ("kernel/sched: Fix sched_fork() access an invalid sched_task_group")
Reported-by: syzbot+af7a719bc92395ee41b3@syzkaller.appspotmail.com
Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
---
Changes in v3:
- Removed the new check and changed the update_load condition from
  always true to true if p->state != TASK_NEW

Changes in v2:
- Added a check in set_user_nice(), and return from there if the task
  is not fully setup instead of returning from reweight_entity()
---
---
 kernel/sched/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 848eaa0efe0e..3d7ede06b971 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6921,7 +6921,7 @@ void set_user_nice(struct task_struct *p, long nice)
 		put_prev_task(rq, p);
 
 	p->static_prio = NICE_TO_PRIO(nice);
-	set_load_weight(p, true);
+	set_load_weight(p, !(READ_ONCE(p->__state) & TASK_NEW));
 	old_prio = p->prio;
 	p->prio = effective_prio(p);
 
@@ -7212,7 +7212,7 @@ static void __setscheduler_params(struct task_struct *p,
 	 */
 	p->rt_priority = attr->sched_priority;
 	p->normal_prio = normal_prio(p);
-	set_load_weight(p, true);
+	set_load_weight(p, !(READ_ONCE(p->__state) & TASK_NEW));
 }
 
 /*
-- 
2.34.1


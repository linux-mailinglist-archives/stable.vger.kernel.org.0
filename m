Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43F0A49ECE6
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 21:57:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245203AbiA0U5C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 15:57:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245158AbiA0U5B (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 15:57:01 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F768C061714
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 12:57:01 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id v74so3961134pfc.1
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 12:57:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tfXY+yoEkXRjHsPlcj+EE4YfwHLvMltbNM3WmPepjHA=;
        b=ViP7LO+i4/X8Hza5L1TLV+4t5dn6LsbwwzM+xuF427VZ6hm3nM7jfWCKefjh/+qRTM
         th0se3ZeJw+d25HTdz0fNd3X4YSWfmfU8XGrU/ru6srSikqzmOuSsbJGU1ZFwyThntYQ
         TsEJLBtNw151HP+s+5wwC8cvBJw+DXaYIMKYW1BSLHa0zkxLBacK0LkumsvGcjj7l/TU
         AUpREyLthSnm4F9S0ig/wBzlDRutKae1aZcHVWdW+XL0SJrbQ52Y7TZ5ChmVr6F4yZH3
         0l4JNZmDqOwjvCppwxH/5b7lOv64dT81vAORBp1kjkP8td+S8uQh28xNhlBZa6n/ru1O
         m92w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tfXY+yoEkXRjHsPlcj+EE4YfwHLvMltbNM3WmPepjHA=;
        b=L04B6eJS3AkSv+Gfm1Or+e+vC4X7SG+rS4HRVS69uU8+SVNytEiAFIb/WDeBsCGQp9
         dvK9XrjdxHkbgynfttwrU78Cx5tBblEhkmFJxLv+xRhmPfADofRyNpZCVSq/LxRvoxNF
         vkun++9vTyessTlaz5jMX/DhCTkK8e1vd9jsDJqm27Igsj2FR6Tb98n2JSaZG3AfS+bx
         AMMCHsaMN6FBD9nGVt3NJPnDyFr1+NYxCpkU2wb9hpcZzU3Qwypg+wiOK3w6bQ2c5HGM
         DDgEwKBxN0yfqg+3aykCg+LwPZIgDXEZxLNPDEmhvWDfE/JJhtUszMTbS2WWxPNAyeZD
         jCsQ==
X-Gm-Message-State: AOAM533kvwfsGediwRYHYVEO3hrahyh5qYX7dx+WnThFBDoKoK43YS6d
        xiPZ1KL41txwUFQDH2e3czX52g==
X-Google-Smtp-Source: ABdhPJzjNYJyU2lRmm2ARtHfs1fz4x84l4Mv3pZVcHntWHtR8Cec3OXniogqV4YqFbiWauRmgfssHQ==
X-Received: by 2002:a62:3042:: with SMTP id w63mr4562471pfw.71.1643317020815;
        Thu, 27 Jan 2022 12:57:00 -0800 (PST)
Received: from localhost.localdomain ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id nv13sm216748pjb.18.2022.01.27.12.57.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 12:57:00 -0800 (PST)
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
        Zhang Qiao <zhangqiao22@huawei.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+af7a719bc92395ee41b3@syzkaller.appspotmail.com
Subject: [PATCH v4] sched/fair: Fix fault in reweight_entity
Date:   Thu, 27 Jan 2022 12:56:23 -0800
Message-Id: <20220127205623.1258029-1-tadeusz.struk@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220125193403.778497-1-tadeusz.struk@linaro.org>
References: <20220125193403.778497-1-tadeusz.struk@linaro.org>
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
To fix the issue the remove the update_load param from the
update_load param() function and call reweight_task() only if the task
flag doesn't have the TASK_NEW flag set.

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
Cc: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

Link: https://syzkaller.appspot.com/bug?id=9d9c27adc674e3a7932b22b61c79a02da82cbdc1
Fixes: 4ef0c5c6b5ba ("kernel/sched: Fix sched_fork() access an invalid sched_task_group")
Reported-by: syzbot+af7a719bc92395ee41b3@syzkaller.appspotmail.com
Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
---
Changes in v4:
- Removed the update_load param from set_load_weight() and call
  reweight_task() based on the TASK_NEW flag

Changes in v3:
- Removed the new check and changed the update_load condition from
  always true to true if p->state != TASK_NEW

Changes in v2:
- Added a check in set_user_nice(), and return from there if the task
  is not fully setup instead of returning from reweight_entity()
---
 kernel/sched/core.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 848eaa0efe0e..a0ef4670e695 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1214,10 +1214,12 @@ int tg_nop(struct task_group *tg, void *data)
 }
 #endif
 
-static void set_load_weight(struct task_struct *p, bool update_load)
+static void set_load_weight(struct task_struct *p)
 {
 	int prio = p->static_prio - MAX_RT_PRIO;
 	struct load_weight *load = &p->se.load;
+	bool update_load = !(READ_ONCE(p->__state) & TASK_NEW);
+
 
 	/*
 	 * SCHED_IDLE tasks get minimal weight:
@@ -4406,7 +4408,7 @@ int sched_fork(unsigned long clone_flags, struct task_struct *p)
 			p->static_prio = NICE_TO_PRIO(0);
 
 		p->prio = p->normal_prio = p->static_prio;
-		set_load_weight(p, false);
+		set_load_weight(p);
 
 		/*
 		 * We don't need the reset flag anymore after the fork. It has
@@ -6921,7 +6923,7 @@ void set_user_nice(struct task_struct *p, long nice)
 		put_prev_task(rq, p);
 
 	p->static_prio = NICE_TO_PRIO(nice);
-	set_load_weight(p, true);
+	set_load_weight(p);
 	old_prio = p->prio;
 	p->prio = effective_prio(p);
 
@@ -7212,7 +7214,7 @@ static void __setscheduler_params(struct task_struct *p,
 	 */
 	p->rt_priority = attr->sched_priority;
 	p->normal_prio = normal_prio(p);
-	set_load_weight(p, true);
+	set_load_weight(p);
 }
 
 /*
@@ -9445,7 +9447,7 @@ void __init sched_init(void)
 #endif
 	}
 
-	set_load_weight(&init_task, false);
+	set_load_weight(&init_task);
 
 	/*
 	 * The boot idle thread does lazy MMU switching as well:
-- 
2.34.1


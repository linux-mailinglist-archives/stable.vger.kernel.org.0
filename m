Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41F383FCA70
	for <lists+stable@lfdr.de>; Tue, 31 Aug 2021 16:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237388AbhHaO6c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Aug 2021 10:58:32 -0400
Received: from mo1.intermailgate.com ([91.203.103.210]:41188 "EHLO
        mo1.intermailgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236081AbhHaO6b (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Aug 2021 10:58:31 -0400
Received: from localhost (localhost [127.0.0.1])
        by mo1.intermailgate.com (Postfix) with ESMTP id 9355D204A3
        for <stable@vger.kernel.org>; Tue, 31 Aug 2021 16:57:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=bof.de; s=20180522;
        t=1630421855; bh=IoAwKcdc+q/wFfv5qGzkpzYehGURggWZDTsRW19a1ms=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc;
        b=dKX+NKpPFZ0786tzFHVMlwddXLJ0UHqmnFvHO8quzDuxKGCuGKtYB7n5uJxqIP/Ar
         gvUr17pywQHVYwh/LP6qU3lb2FfvTi3x6b4kk81O7rMgWF/vMC8aqjjEJKlrOsQ3S8
         nGnrgFD2IQHdSvP1NDz6b0puMwyQYHMiZRGkHYhU=
Received: from mail-lf1-f50.google.com (unknown [162.158.183.139])
        by mo1.intermailgate.com (Postfix) with ESMTPSA id 326A82046B
        for <stable@vger.kernel.org>; Tue, 31 Aug 2021 16:57:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=bof.de; s=20180522;
        t=1630421851; bh=IoAwKcdc+q/wFfv5qGzkpzYehGURggWZDTsRW19a1ms=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc;
        b=mKpOeDatzqtMCJB9EZHtz7Pn+nQSZnx74dDUxF4C3bQccfVR1A12+Hi2pcki3zAR7
         AQaPmjxYKbCO1O3WuNUNsAHmmKvBKeJTCB2GlPFiBa87Gw2WQtxUXRAjrypJK01/rm
         MKaaG5NKPFLvathwyV4+dLnhMlyzCfxyr+z5+01w=
Received: by mail-lf1-f50.google.com with SMTP id k13so4762516lfv.2
        for <stable@vger.kernel.org>; Tue, 31 Aug 2021 07:57:31 -0700 (PDT)
X-Gm-Message-State: AOAM530e95RKmTERhlFkRi/PphUirr9yFu/SIEbemGKtbN4mjbnOjaJJ
        OK7JfdpLShc34il9HMY2ngRQCq6STadq+R+m/zE=
X-Google-Smtp-Source: ABdhPJzENr5JXWULNinTi3u+QPQZOQJwjUSuwLFFO075tQRFyz9Vz7UY71ii/lziTPtQpDeeCVrN8vvuDT590Ke2Ir8=
X-Received: by 2002:a05:6512:1686:: with SMTP id bu6mr22144338lfb.168.1630421849263;
 Tue, 31 Aug 2021 07:57:29 -0700 (PDT)
MIME-Version: 1.0
References: <61018d93.xsvXcO161PFLQFCX%bof@bof.de> <YQGXyiMb1IntqacG@kroah.com>
 <CAJ26g5S2tbDhRbWkcgRzAu0eX=FNk00P8srboOSn=jYp4saALA@mail.gmail.com> <YS3TpF8B5TA2mGFr@hirez.programming.kicks-ass.net>
In-Reply-To: <YS3TpF8B5TA2mGFr@hirez.programming.kicks-ass.net>
From:   Patrick Schaaf <bof@bof.de>
Date:   Tue, 31 Aug 2021 16:57:11 +0200
X-Gmail-Original-Message-ID: <CAJ26g5Toxq-WaRFvP9V-dNL0GXx+w5PTakcQw2stW1HteUhS3w@mail.gmail.com>
Message-ID: <CAJ26g5Toxq-WaRFvP9V-dNL0GXx+w5PTakcQw2stW1HteUhS3w@mail.gmail.com>
Subject: Re: stable 5.4.135 REGRESSION / once-a-day WARNING: at kthread_is_per_cpu+0x1c/0x20
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev,
        =?UTF-8?B?SWdvciBMb27EjWFyZXZpxIc=?= <anubis@igorloncarevic.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 31, 2021 at 9:01 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> 3a7956e25e1d ("kthread: Fix PF_KTHREAD vs to_kthread() race") munged
> into 5.4.135
>
> Never even seen a compiler, please tests.

Thanks a lot, Peter. With the addition of a little semicolon in one
place, I successfully built 5.4.143 with the patch applied, in both my
host and vm configs.

I now have two machines with identical workloads (webserver, database)
running, one with unpatched 5.4.143, the other with 5.4.143 and that
patch. Expectation is to see the WARNING on the former, but not on the
latter. Will report in a day or three about the outcome.

regards
  Patrick

Tested-By: Patrick Schaaf <bof@bof.de>

diff --git a/kernel/kthread.c b/kernel/kthread.c
index b2bac5d929d2..22750a8af83e 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -76,6 +76,25 @@ static inline struct kthread *to_kthread(struct
task_struct *k)
        return (__force void *)k->set_child_tid;
 }

+/*
+ * Variant of to_kthread() that doesn't assume @p is a kthread.
+ *
+ * Per construction; when:
+ *
+ *   (p->flags & PF_KTHREAD) && p->set_child_tid
+ *
+ * the task is both a kthread and struct kthread is persistent. However
+ * PF_KTHREAD on it's own is not, kernel_thread() can exec() (See umh.c and
+ * begin_new_exec()).
+ */
+static inline struct kthread *__to_kthread(struct task_struct *p)
+{
+       void *kthread = (__force void *)p->set_child_tid;
+       if (kthread && !(p->flags & PF_KTHREAD))
+               kthread = NULL;
+       return kthread;
+}
+
 void free_kthread_struct(struct task_struct *k)
 {
        struct kthread *kthread;
@@ -176,10 +195,11 @@ void *kthread_data(struct task_struct *task)
  */
 void *kthread_probe_data(struct task_struct *task)
 {
-       struct kthread *kthread = to_kthread(task);
+       struct kthread *kthread = __to_kthread(task);
        void *data = NULL;

-       probe_kernel_read(&data, &kthread->data, sizeof(data));
+       if (kthread)
+               probe_kernel_read(&data, &kthread->data, sizeof(data));
        return data;
 }

@@ -490,9 +510,9 @@ void kthread_set_per_cpu(struct task_struct *k, int cpu)
        set_bit(KTHREAD_IS_PER_CPU, &kthread->flags);
 }

-bool kthread_is_per_cpu(struct task_struct *k)
+bool kthread_is_per_cpu(struct task_struct *p)
 {
-       struct kthread *kthread = to_kthread(k);
+       struct kthread *kthread = __to_kthread(p);
        if (!kthread)
                return false;

@@ -1272,11 +1292,9 @@ EXPORT_SYMBOL(kthread_destroy_worker);
  */
 void kthread_associate_blkcg(struct cgroup_subsys_state *css)
 {
-       struct kthread *kthread;
+       struct kthread *kthread = __to_kthread(current);
+

-       if (!(current->flags & PF_KTHREAD))
-               return;
-       kthread = to_kthread(current);
        if (!kthread)
                return;

@@ -1298,13 +1316,10 @@ EXPORT_SYMBOL(kthread_associate_blkcg);
  */
 struct cgroup_subsys_state *kthread_blkcg(void)
 {
-       struct kthread *kthread;
+       struct kthread *kthread = __to_kthread(current);

-       if (current->flags & PF_KTHREAD) {
-               kthread = to_kthread(current);
-               if (kthread)
-                       return kthread->blkcg_css;
-       }
+       if (kthread)
+               return kthread->blkcg_css;
        return NULL;
 }
 EXPORT_SYMBOL(kthread_blkcg);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 74cb20f32f72..87d9fad9d01d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -7301,7 +7301,7 @@ int can_migrate_task(struct task_struct *p,
struct lb_env *env)
                return 0;

        /* Disregard pcpu kthreads; they are where they need to be. */
-       if ((p->flags & PF_KTHREAD) && kthread_is_per_cpu(p))
+       if (kthread_is_per_cpu(p))
                return 0;

        if (!cpumask_test_cpu(env->dst_cpu, p->cpus_ptr)) {

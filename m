Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6793811204A
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:31:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbfLCXbI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 18:31:08 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51823 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbfLCXbH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Dec 2019 18:31:07 -0500
Received: by mail-wm1-f66.google.com with SMTP id g206so5074808wme.1
        for <stable@vger.kernel.org>; Tue, 03 Dec 2019 15:31:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y8UcjpPXP0dkBwA69LJ0NpHT+UcdWSS4UtsNwrG9naw=;
        b=VVd+jIIqv/fZbl8HJH6MpkCVFVQ3wFQ8llBTT/wLdAAkbl8eW1yviv8q3DGYSciqUA
         sqa8gNx98no8UWiyhpQoojgqAfHfhgzvdCWF8IAD5vd689Ls+j7wl1Ky3dODMONQ8uwA
         bT7OCzDfYWUz1HG5ATYy2nNNLgiLeO5GIIOrSo/WqFVTTRmYGAttRnVp5rP4MFvyl6Cd
         wF8rufwLmVXWBMIHqZK7mk15Ev4ocuuSVP40yBkpnghB02WVnbnmImx3GBhNqCMJtKtF
         noYLJj9QR07uCJ2lVtSiD1KXjpVb63CKzVVrDr9nuh8tOFiJzfbNzKk+Z4uUk5PW3fYl
         W/5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y8UcjpPXP0dkBwA69LJ0NpHT+UcdWSS4UtsNwrG9naw=;
        b=JNH3+iMtftTwHV1RIQCyWaz+yuCvvnQY54rP19/+3pFZ6c6ZSZJZBCnr4tz573dTB2
         qqdUlwvc7NLtGdtP4uUil1KhbsYvAzc5bjm2CaHlaa0Y1+gs1HNoDPfWhiqzveusk/ot
         7i/QWblDfYrfoBhQ4eZRKX1GHhXOthFP4UPYOOWjBzWyzFQg26D9C/0PP0caQuynXp/m
         H6QktS2+mQDCq7YrYzfVakxUutrwbcdZZ+cY5VSdRMkt3scwHELxXLH1TxGOvzNmJpH1
         bBmBYcNZOnWVaJCG+ir1rsJytzRWfbOTXcY9AJkeQ9vaci2JC9uaGb6yS09WOwCI0iDw
         KTgQ==
X-Gm-Message-State: APjAAAUz5Wh9e9LpMUESUfo1wddWxfssKIQc9yzyxCHNncq2P2dK3FAM
        SZ58qUwmZC9G9KFtoUc+r9tgKFW0QZu4ClRXWB5mpg==
X-Google-Smtp-Source: APXvYqyGpAnPog5jh2rVlqBoxDi0Lr8PEA/g6DfdhwatQXkXFEzLOPSBSG9StDKYdaOCgZsXA7+XwrDGP69IuUohkJs=
X-Received: by 2002:a7b:cd83:: with SMTP id y3mr39136133wmj.168.1575415864420;
 Tue, 03 Dec 2019 15:31:04 -0800 (PST)
MIME-Version: 1.0
References: <CAPtwhKrmvw8wm1u_36YEoLgQ8pGe=v5xaV2RN4W6jVw3zOgeQQ@mail.gmail.com>
 <20191203230944.GA3495297@kroah.com> <CAPtwhKpZCequxTMzAcVcJ34EW4AFqNDcWuoud-D3nywpYxzx5Q@mail.gmail.com>
 <CAPtwhKqiKZtTGO_7Jpx9nEDhQu8LESvaZth4uHb5a8Ur+=65SA@mail.gmail.com>
In-Reply-To: <CAPtwhKqiKZtTGO_7Jpx9nEDhQu8LESvaZth4uHb5a8Ur+=65SA@mail.gmail.com>
From:   Xuewei Zhang <xueweiz@google.com>
Date:   Tue, 3 Dec 2019 15:30:52 -0800
Message-ID: <CAPtwhKrCY4ZWFPYsr5N3LcAJOJVStN9Qb93-zk+GFRNVsfGxgQ@mail.gmail.com>
Subject: Re: Request to backport 4929a4e6faa0 to stable tree
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Backport patch that cleanly applies for 4.19, 4.14, 4.9, 4.4 stable trees:

From 199df9edf62c339b5459fc53d4631c82a3b82f5b Mon Sep 17 00:00:00 2001
From: Xuewei Zhang <xueweiz@google.com>
Date: Thu, 3 Oct 2019 17:12:43 -0700
Subject: [PATCH] sched/fair: Scale bandwidth quota and period without losing
 quota/period ratio precision

commit 4929a4e6faa0f13289a67cae98139e727f0d4a97 upstream.

The quota/period ratio is used to ensure a child task group won't get
more bandwidth than the parent task group, and is calculated as:

  normalized_cfs_quota() = [(quota_us << 20) / period_us]

If the quota/period ratio was changed during this scaling due to
precision loss, it will cause inconsistency between parent and child
task groups.

See below example:

A userspace container manager (kubelet) does three operations:

 1) Create a parent cgroup, set quota to 1,000us and period to 10,000us.
 2) Create a few children cgroups.
 3) Set quota to 1,000us and period to 10,000us on a child cgroup.

These operations are expected to succeed. However, if the scaling of
147/128 happens before step 3, quota and period of the parent cgroup
will be changed:

  new_quota: 1148437ns,   1148us
 new_period: 11484375ns, 11484us

And when step 3 comes in, the ratio of the child cgroup will be
104857, which will be larger than the parent cgroup ratio (104821),
and will fail.

Scaling them by a factor of 2 will fix the problem.

Change-Id: I3d5f7629012ff115557a08c465a95a5239a105de
Tested-by: Phil Auld <pauld@redhat.com>
Signed-off-by: Xuewei Zhang <xueweiz@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Phil Auld <pauld@redhat.com>
Cc: Anton Blanchard <anton@ozlabs.org>
Cc: Ben Segall <bsegall@google.com>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Fixes: 2e8e19226398 ("sched/fair: Limit sched_cfs_period_timer() loop
to avoid hard lockup")
Link: https://lkml.kernel.org/r/20191004001243.140897-1-xueweiz@google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Xuewei Zhang <xueweiz@google.com>
---
 kernel/sched/fair.c | 36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index ea2d33aa1f55..773135f534ef 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3753,20 +3753,28 @@ static enum hrtimer_restart
sched_cfs_period_timer(struct hrtimer *timer)
  if (++count > 3) {
  u64 new, old = ktime_to_ns(cfs_b->period);

- new = (old * 147) / 128; /* ~115% */
- new = min(new, max_cfs_quota_period);
-
- cfs_b->period = ns_to_ktime(new);
-
- /* since max is 1s, this is limited to 1e9^2, which fits in u64 */
- cfs_b->quota *= new;
- cfs_b->quota = div64_u64(cfs_b->quota, old);
-
- pr_warn_ratelimited(
- "cfs_period_timer[cpu%d]: period too short, scaling up (new
cfs_period_us %lld, cfs_quota_us = %lld)\n",
- smp_processor_id(),
- div_u64(new, NSEC_PER_USEC),
- div_u64(cfs_b->quota, NSEC_PER_USEC));
+ /*
+ * Grow period by a factor of 2 to avoid losing precision.
+ * Precision loss in the quota/period ratio can cause __cfs_schedulable
+ * to fail.
+ */
+ new = old * 2;
+ if (new < max_cfs_quota_period) {
+ cfs_b->period = ns_to_ktime(new);
+ cfs_b->quota *= 2;
+
+ pr_warn_ratelimited(
+ "cfs_period_timer[cpu%d]: period too short, scaling up (new
cfs_period_us = %lld, cfs_quota_us = %lld)\n",
+ smp_processor_id(),
+ div_u64(new, NSEC_PER_USEC),
+ div_u64(cfs_b->quota, NSEC_PER_USEC));
+ } else {
+ pr_warn_ratelimited(
+ "cfs_period_timer[cpu%d]: period too short, but cannot scale up
without losing precision (cfs_period_us = %lld, cfs_quota_us =
%lld)\n",
+ smp_processor_id(),
+ div_u64(old, NSEC_PER_USEC),
+ div_u64(cfs_b->quota, NSEC_PER_USEC));
+ }

  /* reset count so we don't come right back in here */
  count = 0;
-- 
2.24.0.393.g34dc348eaf-goog

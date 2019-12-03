Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90068112047
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726319AbfLCXaU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 18:30:20 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38800 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbfLCXaT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Dec 2019 18:30:19 -0500
Received: by mail-wm1-f65.google.com with SMTP id p17so5798938wmi.3
        for <stable@vger.kernel.org>; Tue, 03 Dec 2019 15:30:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f91aHxajX6/f3KnCbIoNI76adRPUjukEDh9fO/UAK6I=;
        b=ROO+zq2a1CJPLhVMIDGZ7gBTko6D+GmkclJt9dpOs9oB/gmxj0IOWQL4bGmCRzemCc
         30+54ms3YO9Tay+bGmSOR1TyqDxO/ZMdbcPMSQaOHtNMAeQCHPVUdcdJ71kXE6jUBjdA
         4HxDgqzIPuTnDn9TT0ljlLY+dAYb1reeEum1gvLXlUSuedo5CGYbYUcivR8sTRrIGKfD
         NRQ0aQBiqFakYjza4z/G+ke6s+WL98MpaZRle7TyNRzARRv/ixcN/Zhg0VDOJd0z2asf
         NYEwd/Uxsf0228P/PFT4KORi5Sq3UA/KqCE3AYrTJyVQAXrrNtxp6jJzvDH5smFqyX4K
         9aVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f91aHxajX6/f3KnCbIoNI76adRPUjukEDh9fO/UAK6I=;
        b=Ngu2hWzwGL8Tcm3r4GpDo+qEjFMfd+6e1CynVdSPKiudzsRTC6gu+UEMK+3PsGp/HC
         mKvBs2D60AvawmeDAK0iBNA+9pkeSunaibfO4CCJYEF0NmeosuM69+deVOtziwgjodHF
         bz11x8mGnABL0TA0BAq8DXByWVUIuwyLq56H+aARYUjb/LWiOvlMj8ShHsrpHfb1IG9n
         emCDQPrlmwgB+/KnwYwMOuGHhGACUkoiLLlqj/+2iY6eBtKQjWS9E9eiosN2XLkppnro
         nAM1Yrzc9pOgUse77ZnqGXAP5DkN3dAUz94B2CEYCsWCB8mboRmavOrnTjtU7lN9AAfM
         fG/A==
X-Gm-Message-State: APjAAAUieRtQ4L0Yj7QcN5ydCLv2UE0HCGiktONk5/ZTKQ7o9RwEdPJK
        icQMnjLLq8/AefmQV+HKFN24kLoodtqB9AsqPWKkTYJPlD4=
X-Google-Smtp-Source: APXvYqxcJfWSneObAPZOaT7Gl1CPed+hZUlKecTGrqqLSfAN0yBRi91DwLi1bF5GRXX654I0xS524ZVE20O1HfQ9LsI=
X-Received: by 2002:a05:600c:204:: with SMTP id 4mr20445243wmi.1.1575415816436;
 Tue, 03 Dec 2019 15:30:16 -0800 (PST)
MIME-Version: 1.0
References: <CAPtwhKrmvw8wm1u_36YEoLgQ8pGe=v5xaV2RN4W6jVw3zOgeQQ@mail.gmail.com>
 <20191203230944.GA3495297@kroah.com> <CAPtwhKpZCequxTMzAcVcJ34EW4AFqNDcWuoud-D3nywpYxzx5Q@mail.gmail.com>
In-Reply-To: <CAPtwhKpZCequxTMzAcVcJ34EW4AFqNDcWuoud-D3nywpYxzx5Q@mail.gmail.com>
From:   Xuewei Zhang <xueweiz@google.com>
Date:   Tue, 3 Dec 2019 15:30:05 -0800
Message-ID: <CAPtwhKqiKZtTGO_7Jpx9nEDhQu8LESvaZth4uHb5a8Ur+=65SA@mail.gmail.com>
Subject: Re: Request to backport 4929a4e6faa0 to stable tree
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Backport patch that cleanly applies for 4.19, 4.14, 4.9, 4.4 stable trees:

From 974bb36176677c05f257a8385fb69720ae8ed071 Mon Sep 17 00:00:00 2001
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
index f77fcd37b226..f0abb8fe0ae9 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4868,20 +4868,28 @@ static enum hrtimer_restart
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
-        "cfs_period_timer[cpu%d]: period too short, scaling up (new
cfs_period_us %lld, cfs_quota_us = %lld)\n",
-                         smp_processor_id(),
-                         div_u64(new, NSEC_PER_USEC),
-                                div_u64(cfs_b->quota, NSEC_PER_USEC));
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

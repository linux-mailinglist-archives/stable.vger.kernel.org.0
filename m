Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC7A62B1EA9
	for <lists+stable@lfdr.de>; Fri, 13 Nov 2020 16:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726732AbgKMP3O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Nov 2020 10:29:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbgKMP3O (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Nov 2020 10:29:14 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D31D8C0617A6
        for <stable@vger.kernel.org>; Fri, 13 Nov 2020 07:29:13 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id d142so8461382wmd.4
        for <stable@vger.kernel.org>; Fri, 13 Nov 2020 07:29:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=HFeLGiERWAzsmh9HVZmHL/P+iKBFqwr5cwVXPsDsgrs=;
        b=bi9f79IZzAsFgacuDuYCciJJ/HtK3SAwuz2gH86bm1gAs8t1e9Cvuhu6oKYkwSz6wR
         y6BWQ9KJj4X4+DgyAea5oTDAWYPT2TCMoAgeiVj5X5ZGQ8c56DOrc/BuyRD1kDyK8f/4
         n4AvKfS3npIFgDUdmNwx+rwMFFXij2XSdItQhYHlMqDeUyALwiN/PZM5/1t6EI3KlWdx
         41dx0fk8EsWAc/K74q2MEriuQFdvGpS60emK6EYjEs+PdrM0XT7krYvCoBCjoi9VdBXA
         TZh7UuoYhimtx59g2SL+E7ecsI31ZUfMYHs6wJSDFW6BI5qCGMu7RBfYhpK6VinOQAyf
         UpEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=HFeLGiERWAzsmh9HVZmHL/P+iKBFqwr5cwVXPsDsgrs=;
        b=d4c7hhv42YyxD8P9FTrB0YXTIGOZP6wPnrdUOdNxKkFl9SASF3EW3MOqMg/2xLiDOA
         2b9PQ3eN9Tfrj2es3VfCdBXkVKA0sSmjn9NveECD0fxQ6ISfWiBdHe+Ssog5c73IZn+9
         cq3wcEpv/vib+59oVtxs3sOrazNeCD3dfAo9wGq6LsusLwLMHmoOQWwi2MLxEA2+IdwA
         1yZlwDlIu66beIwUlVwEXsTYNxeq+z3ciuXHF6FG3y/IBdhS8bhgkLVCPS6Q3JlJS4iF
         UV/ruxvo6a1LkWa0i3QISbi7GB/Jw3hcF/jtOOQEQ2HlUzK13q0H5FxnueH8/MQ3fEND
         zbKQ==
X-Gm-Message-State: AOAM533/MWqktatgz+iPvswc0LGPhBrQKWMoSk4pQp4QNc5M1DuGAqVe
        VBTGoseLxvSCPlyF8wkUuEw=
X-Google-Smtp-Source: ABdhPJw3JPQFkbYlFuUJkWGFNoyjvm07O35/Wsx8ZmG6kVc0gh1SMQj8ilQSfA3aziwhxi5k7sFMbg==
X-Received: by 2002:a1c:2041:: with SMTP id g62mr3186813wmg.118.1605281346034;
        Fri, 13 Nov 2020 07:29:06 -0800 (PST)
Received: from debian (host-92-5-241-147.as43234.net. [92.5.241.147])
        by smtp.gmail.com with ESMTPSA id o197sm10305420wme.17.2020.11.13.07.29.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 13 Nov 2020 07:29:05 -0800 (PST)
Date:   Fri, 13 Nov 2020 15:28:57 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, sashal@kernel.org
Cc:     stable@vger.kernel.org, Michael Petlan <mpetlan@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@kernel.org>,
        Wade Mealing <wmealing@redhat.com>
Subject: backport of f91072ed1b72 for v4.4.y and v4.9.y
Message-ID: <20201113152857.ude6zsnlhqnr3gqd@debian>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="tqk3ot7rug5pubvt"
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--tqk3ot7rug5pubvt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg, Sasha,

Please consider the attached backport of
f91072ed1b72 ("perf/core: Fix race in the perf_mmap_close() function")
for v4.4.y and v4.9.y.

I have sent separate backport for v4.14.y, v4.19.y and v5.4.y.


--
Regards
Sudip

--tqk3ot7rug5pubvt
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-perf-core-Fix-race-in-the-perf_mmap_close-function.patch"

From 24ef0388b57352c2be2e51ea5b92eddd625df77e Mon Sep 17 00:00:00 2001
From: Jiri Olsa <jolsa@redhat.com>
Date: Wed, 16 Sep 2020 13:53:11 +0200
Subject: [PATCH] perf/core: Fix race in the perf_mmap_close() function

commit f91072ed1b7283b13ca57fcfbece5a3b92726143 upstream

There's a possible race in perf_mmap_close() when checking ring buffer's
mmap_count refcount value. The problem is that the mmap_count check is
not atomic because we call atomic_dec() and atomic_read() separately.

  perf_mmap_close:
  ...
   atomic_dec(&rb->mmap_count);
   ...
   if (atomic_read(&rb->mmap_count))
      goto out_put;

   <ring buffer detach>
   free_uid

out_put:
  ring_buffer_put(rb); /* could be last */

The race can happen when we have two (or more) events sharing same ring
buffer and they go through atomic_dec() and then they both see 0 as refcount
value later in atomic_read(). Then both will go on and execute code which
is meant to be run just once.

The code that detaches ring buffer is probably fine to be executed more
than once, but the problem is in calling free_uid(), which will later on
demonstrate in related crashes and refcount warnings, like:

  refcount_t: addition on 0; use-after-free.
  ...
  RIP: 0010:refcount_warn_saturate+0x6d/0xf
  ...
  Call Trace:
  prepare_creds+0x190/0x1e0
  copy_creds+0x35/0x172
  copy_process+0x471/0x1a80
  _do_fork+0x83/0x3a0
  __do_sys_wait4+0x83/0x90
  __do_sys_clone+0x85/0xa0
  do_syscall_64+0x5b/0x1e0
  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Using atomic decrease and check instead of separated calls.

Tested-by: Michael Petlan <mpetlan@redhat.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Wade Mealing <wmealing@redhat.com>
Fixes: 9bb5d40cd93c ("perf: Fix mmap() accounting hole");
Link: https://lore.kernel.org/r/20200916115311.GE2301783@krava
[sudip: backport to v4.9.y by using ring_buffer]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 kernel/events/core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 7aad4d22b422..38bbec00de2d 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5069,11 +5069,11 @@ static void perf_pmu_output_stop(struct perf_event *event);
 static void perf_mmap_close(struct vm_area_struct *vma)
 {
 	struct perf_event *event = vma->vm_file->private_data;
-
 	struct ring_buffer *rb = ring_buffer_get(event);
 	struct user_struct *mmap_user = rb->mmap_user;
 	int mmap_locked = rb->mmap_locked;
 	unsigned long size = perf_data_size(rb);
+	bool detach_rest = false;
 
 	if (event->pmu->event_unmapped)
 		event->pmu->event_unmapped(event);
@@ -5104,7 +5104,8 @@ static void perf_mmap_close(struct vm_area_struct *vma)
 		mutex_unlock(&event->mmap_mutex);
 	}
 
-	atomic_dec(&rb->mmap_count);
+	if (atomic_dec_and_test(&rb->mmap_count))
+		detach_rest = true;
 
 	if (!atomic_dec_and_mutex_lock(&event->mmap_count, &event->mmap_mutex))
 		goto out_put;
@@ -5113,7 +5114,7 @@ static void perf_mmap_close(struct vm_area_struct *vma)
 	mutex_unlock(&event->mmap_mutex);
 
 	/* If there's still other mmap()s of this buffer, we're done. */
-	if (atomic_read(&rb->mmap_count))
+	if (!detach_rest)
 		goto out_put;
 
 	/*
-- 
2.11.0


--tqk3ot7rug5pubvt--

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAEC22B1E8C
	for <lists+stable@lfdr.de>; Fri, 13 Nov 2020 16:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgKMPZx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Nov 2020 10:25:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726748AbgKMPZv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Nov 2020 10:25:51 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 691D0C0613D1
        for <stable@vger.kernel.org>; Fri, 13 Nov 2020 07:25:51 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id p22so8451858wmg.3
        for <stable@vger.kernel.org>; Fri, 13 Nov 2020 07:25:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=wc6bnvr4en/PAxdX5bpIqzaTsn35DLfdfuDkeT8tHGI=;
        b=LdIBcZ7TqB7UFQaEzLyDt0C4vEUQcq6NCDaG+vmAKceamm7CiiVhta3y1Fw9IL9B5y
         dbP+zak4mlBnT3A02Gj6nFvqBnURNHwXhKRjXFZcEre45BmMeacKhdd9QAGdvVoTx+Ew
         tvyPZBBmCdj7hOt3RXpnTTDEw+8WARVm60hZes7jpyLg+Gf4jmOaMFrO5cCeM4CsPchF
         5CZVddFyvfos2Cd4sG8XH7KCYUaq65pxKi6axbFr3Qy0JvkbM7mi8ATKXKf0jx8gH+wu
         +jqCPhWy98cY/v2Mq+7FPt59UDoRnGUFTycjbcvWU5jMfXcgcUVPu9DDW8eugC78JXML
         +Z5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=wc6bnvr4en/PAxdX5bpIqzaTsn35DLfdfuDkeT8tHGI=;
        b=Y5ps8vvWwaNcsA3gy56FMaF74RbomLvIaUGgZhoqLpHKJV5TYW5wx0PKQnVeFaPZZB
         ZXjgATk7JuvdoUHNV+gLyOKDFYvPZZmnQv3399HpTBv6AIpYpkFphhtoNMED8093Kr6G
         5ajr98HGtMHwS6RRxoH8iSCck08GKSlGFso14RnCAQgJN96el7xXekQJ5cYuHkvOFbCJ
         +ae0dUPDdlf2mDCXAtIrRyR14vY13MD7hbE4qw7ybpcI8Ekt8baY6PknIigAmTSWcCaK
         wge3EKSuDzLBw7m+S+0PaBRLw//EttPHSAmjGh1whpm6WygR4piZevPIHRhZwe5KL1/w
         JQhQ==
X-Gm-Message-State: AOAM530dQduK6K4d51DhBwskIkHP72FoADbWW6UHZtdMn4V/W7Cz8PV0
        a8/Lh5mnDThVtelvNWUG+Q4=
X-Google-Smtp-Source: ABdhPJxSsr7grgPJSTVIDvTTCwRpqf6/TDZKCiiWuHlMkyJiw3336/3NOiPfTyCWfoajhWI/e6DCuQ==
X-Received: by 2002:a1c:61c2:: with SMTP id v185mr3027580wmb.152.1605281145231;
        Fri, 13 Nov 2020 07:25:45 -0800 (PST)
Received: from debian (host-92-5-241-147.as43234.net. [92.5.241.147])
        by smtp.gmail.com with ESMTPSA id o17sm10623374wmd.34.2020.11.13.07.25.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 13 Nov 2020 07:25:44 -0800 (PST)
Date:   Fri, 13 Nov 2020 15:25:42 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, sashal@kernel.org
Cc:     stable@vger.kernel.org, Michael Petlan <mpetlan@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@kernel.org>,
        Wade Mealing <wmealing@redhat.com>
Subject: backport of f91072ed1b72 for v4.14.y+
Message-ID: <20201113152542.o6ai3npqaucp425a@debian>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="idmp36us5cc2k6u5"
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--idmp36us5cc2k6u5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg, Sasha,

Please consider the attached backport of
f91072ed1b72 ("perf/core: Fix race in the perf_mmap_close() function")
for v4.14.y, v4.19.y and v5.4.y
This will not apply in v4.9.y and v4.4.y and I am sending separate backport
for that.


--
Regards
Sudip

--idmp36us5cc2k6u5
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-perf-core-Fix-race-in-the-perf_mmap_close-function.patch"

From 748956f561af23b019f329f3a8af158960820bc4 Mon Sep 17 00:00:00 2001
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
[sudip: used ring_buffer]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 kernel/events/core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 1b60f9c508c9..9f7c2da99299 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5596,11 +5596,11 @@ static void perf_pmu_output_stop(struct perf_event *event);
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
 		event->pmu->event_unmapped(event, vma->vm_mm);
@@ -5631,7 +5631,8 @@ static void perf_mmap_close(struct vm_area_struct *vma)
 		mutex_unlock(&event->mmap_mutex);
 	}
 
-	atomic_dec(&rb->mmap_count);
+	if (atomic_dec_and_test(&rb->mmap_count))
+		detach_rest = true;
 
 	if (!atomic_dec_and_mutex_lock(&event->mmap_count, &event->mmap_mutex))
 		goto out_put;
@@ -5640,7 +5641,7 @@ static void perf_mmap_close(struct vm_area_struct *vma)
 	mutex_unlock(&event->mmap_mutex);
 
 	/* If there's still other mmap()s of this buffer, we're done. */
-	if (atomic_read(&rb->mmap_count))
+	if (!detach_rest)
 		goto out_put;
 
 	/*
-- 
2.11.0


--idmp36us5cc2k6u5--

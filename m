Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5C22B068D
	for <lists+stable@lfdr.de>; Thu, 12 Nov 2020 14:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728321AbgKLNe4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Nov 2020 08:34:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728372AbgKLNez (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Nov 2020 08:34:55 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4DCAC0613D4
        for <stable@vger.kernel.org>; Thu, 12 Nov 2020 05:34:54 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id p1so5989091wrf.12
        for <stable@vger.kernel.org>; Thu, 12 Nov 2020 05:34:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :content-transfer-encoding:user-agent;
        bh=IFVvAeiLC/81wFjMzsYjDhk+mg5pgojMxomQ2AzNCcc=;
        b=kR3IA8XEdAXuNFLQuHnTst2h0KN/ZXeaUo2lBJqOLRE4fQOHgC2DolHUVrM9SFLSdf
         jt6WAff2XCfQvUl3U/Try+49bKcEyz1l2P/SM4glasEIOrtKA8AsJx2nd05S1iAbbFOS
         De3Q47cRaI2FrNYH+SwUoZbMkIWXx9Wd3OlPWF94d9Ig+WDOWclYwEV6nKARFvz9PwwZ
         if8RkOHUivoxiC83Ndb0r7bOp7TfoADDfiadGGCTMszkJ2fwGlnQabgiKJM/M9uXleGM
         FziWvLjDpEXxJJgbc2akd8IvET64b7QAjXaJLSsfbYst340X1tg3+dCDxVApFDWpHlYA
         Bwug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding:user-agent;
        bh=IFVvAeiLC/81wFjMzsYjDhk+mg5pgojMxomQ2AzNCcc=;
        b=DW/Waffd9CNkE4hos1aj7VgE+KIkoXk/YkPR05KpBFinGNSwyZCMVIwG50SQCahUwe
         gIVJReCym76LuFeSzYASY4HtSqRYFnsuyGK1OG3sJPzvHkfP/vIpn9UKWrluWyAAqh2p
         lQA7w1nJNLC3zq77GGmkg7Xl7d97Dw36fg6SD8lYJxclJCAAZWxjU3lfQwo9MvkFTfoK
         647uA58/xBuVmdOestn7j8YuMugjEt3sz6Czw2J4YNYp53Z3siu+kMNKZbORMLF8UlJ8
         8H3zeh7oZkSP5quXEoxCcck6L4v9iGujATNFeWBUp3DnpW9xJIzLHnY9dGMcSiKax6Qs
         1WzA==
X-Gm-Message-State: AOAM5311aKd4HFxyqCXUecHOHT3TK3f7k0joVfisxSW4F6JRsEfpW8o0
        87nzi0hzibasR8lmHDdFUX98btnaZFeJJg==
X-Google-Smtp-Source: ABdhPJwJU2OuWDcL4esqtm+wmdwMlVzY5KGwb+Gi58JZDnNjJPCWbmSbq3AaNoSgrxpfIArrB/mDWA==
X-Received: by 2002:a5d:4991:: with SMTP id r17mr35429132wrq.70.1605188093678;
        Thu, 12 Nov 2020 05:34:53 -0800 (PST)
Received: from debian (host-92-5-241-147.as43234.net. [92.5.241.147])
        by smtp.gmail.com with ESMTPSA id w10sm7110974wra.34.2020.11.12.05.34.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 12 Nov 2020 05:34:52 -0800 (PST)
Date:   Thu, 12 Nov 2020 13:34:51 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org,
        Sasha Levin <Alexander.Levin@microsoft.com>
Cc:     stable <stable@vger.kernel.org>, Song Liu <songliubraving@fb.com>,
        peterz@infradead.org, mingo@kernel.org, mathieu.poirier@linaro.org,
        kiyin@tencent.com, dan.carpenter@oracle.com
Subject: [v4.14.y] backport of few missed perf fixes
Message-ID: <20201112133451.s2pnt4qts7vzrk5u@debian>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="td6fbbckk2qvlmgu"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--td6fbbckk2qvlmgu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg, Sasha,

These are few missing commits for stable v4.14.y branch.

--
Regards
Sudip

--td6fbbckk2qvlmgu
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-perf-core-Fix-bad-use-of-igrab.patch"

From 9f0e03f1892dc91658dda131691495d1cd72dd47 Mon Sep 17 00:00:00 2001
From: Song Liu <songliubraving@fb.com>
Date: Tue, 17 Apr 2018 23:29:07 -0700
Subject: [PATCH 1/3] perf/core: Fix bad use of igrab()

commit 9511bce9fe8e5e6c0f923c09243a713eba560141 upstream

As Miklos reported and suggested:

 "This pattern repeats two times in trace_uprobe.c and in
  kernel/events/core.c as well:

      ret = kern_path(filename, LOOKUP_FOLLOW, &path);
      if (ret)
          goto fail_address_parse;

      inode = igrab(d_inode(path.dentry));
      path_put(&path);

  And it's wrong.  You can only hold a reference to the inode if you
  have an active ref to the superblock as well (which is normally
  through path.mnt) or holding s_umount.

  This way unmounting the containing filesystem while the tracepoint is
  active will give you the "VFS: Busy inodes after unmount..." message
  and a crash when the inode is finally put.

  Solution: store path instead of inode."

This patch fixes the issue in kernel/event/core.c.

Reviewed-and-tested-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reported-by: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: <kernel-team@fb.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Fixes: 375637bc5249 ("perf/core: Introduce address range filtering")
Link: http://lkml.kernel.org/r/20180418062907.3210386-2-songliubraving@fb.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 arch/x86/events/intel/pt.c |  4 ++--
 include/linux/perf_event.h |  2 +-
 kernel/events/core.c       | 21 +++++++++------------
 3 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
index 81fd41d5a0d9..0661227d935c 100644
--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -1190,7 +1190,7 @@ static int pt_event_addr_filters_validate(struct list_head *filters)
 		if (!filter->range || !filter->size)
 			return -EOPNOTSUPP;
 
-		if (!filter->inode) {
+		if (!filter->path.dentry) {
 			if (!valid_kernel_ip(filter->offset))
 				return -EINVAL;
 
@@ -1217,7 +1217,7 @@ static void pt_event_addr_filters_sync(struct perf_event *event)
 		return;
 
 	list_for_each_entry(filter, &head->list, entry) {
-		if (filter->inode && !offs[range]) {
+		if (filter->path.dentry && !offs[range]) {
 			msr_a = msr_b = 0;
 		} else {
 			/* apply the offset */
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 956d76744c91..41a3307a971c 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -466,7 +466,7 @@ struct pmu {
  */
 struct perf_addr_filter {
 	struct list_head	entry;
-	struct inode		*inode;
+	struct path		path;
 	unsigned long		offset;
 	unsigned long		size;
 	unsigned int		range	: 1,
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 5807fad2c405..213d5807124c 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6450,7 +6450,7 @@ static void perf_event_addr_filters_exec(struct perf_event *event, void *data)
 
 	raw_spin_lock_irqsave(&ifh->lock, flags);
 	list_for_each_entry(filter, &ifh->list, entry) {
-		if (filter->inode) {
+		if (filter->path.dentry) {
 			event->addr_filters_offs[count] = 0;
 			restart++;
 		}
@@ -7124,7 +7124,7 @@ static bool perf_addr_filter_match(struct perf_addr_filter *filter,
 				     struct file *file, unsigned long offset,
 				     unsigned long size)
 {
-	if (filter->inode != file_inode(file))
+	if (d_inode(filter->path.dentry) != file_inode(file))
 		return false;
 
 	if (filter->offset > offset + size)
@@ -8345,8 +8345,7 @@ static void free_filters_list(struct list_head *filters)
 	struct perf_addr_filter *filter, *iter;
 
 	list_for_each_entry_safe(filter, iter, filters, entry) {
-		if (filter->inode)
-			iput(filter->inode);
+		path_put(&filter->path);
 		list_del(&filter->entry);
 		kfree(filter);
 	}
@@ -8443,7 +8442,7 @@ static void perf_event_addr_filters_apply(struct perf_event *event)
 		 * Adjust base offset if the filter is associated to a binary
 		 * that needs to be mapped:
 		 */
-		if (filter->inode)
+		if (filter->path.dentry)
 			event->addr_filters_offs[count] =
 				perf_addr_filter_apply(filter, mm);
 
@@ -8516,7 +8515,6 @@ perf_event_parse_addr_filter(struct perf_event *event, char *fstr,
 {
 	struct perf_addr_filter *filter = NULL;
 	char *start, *orig, *filename = NULL;
-	struct path path;
 	substring_t args[MAX_OPT_ARGS];
 	int state = IF_STATE_ACTION, token;
 	unsigned int kernel = 0;
@@ -8620,19 +8618,18 @@ perf_event_parse_addr_filter(struct perf_event *event, char *fstr,
 					goto fail_free_name;
 
 				/* look up the path and grab its inode */
-				ret = kern_path(filename, LOOKUP_FOLLOW, &path);
+				ret = kern_path(filename, LOOKUP_FOLLOW,
+						&filter->path);
 				if (ret)
 					goto fail_free_name;
 
-				filter->inode = igrab(d_inode(path.dentry));
-				path_put(&path);
 				kfree(filename);
 				filename = NULL;
 
 				ret = -EINVAL;
-				if (!filter->inode ||
-				    !S_ISREG(filter->inode->i_mode))
-					/* free_filters_list() will iput() */
+				if (!filter->path.dentry ||
+				    !S_ISREG(d_inode(filter->path.dentry)
+					     ->i_mode))
 					goto fail;
 
 				event->addr_filters.nr_file_filters++;
-- 
2.11.0


--td6fbbckk2qvlmgu
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0002-perf-core-Fix-crash-when-using-HW-tracing-kernel-fil.patch"

From 149a3ef7a4d4bfdb7854740986b04690c5ab3409 Mon Sep 17 00:00:00 2001
From: Mathieu Poirier <mathieu.poirier@linaro.org>
Date: Mon, 16 Jul 2018 17:13:51 -0600
Subject: [PATCH 2/3] perf/core: Fix crash when using HW tracing kernel filters

commit 7f635ff187ab6be0b350b3ec06791e376af238ab upstream

In function perf_event_parse_addr_filter(), the path::dentry of each struct
perf_addr_filter is left unassigned (as it should be) when the pattern
being parsed is related to kernel space.  But in function
perf_addr_filter_match() the same dentries are given to d_inode() where
the value is not expected to be NULL, resulting in the following splat:

  Unable to handle kernel NULL pointer dereference at virtual address 0000000000000058
  pc : perf_event_mmap+0x2fc/0x5a0
  lr : perf_event_mmap+0x2c8/0x5a0
  Process uname (pid: 2860, stack limit = 0x000000001cbcca37)
  Call trace:
   perf_event_mmap+0x2fc/0x5a0
   mmap_region+0x124/0x570
   do_mmap+0x344/0x4f8
   vm_mmap_pgoff+0xe4/0x110
   vm_mmap+0x2c/0x40
   elf_map+0x60/0x108
   load_elf_binary+0x450/0x12c4
   search_binary_handler+0x90/0x290
   __do_execve_file.isra.13+0x6e4/0x858
   sys_execve+0x3c/0x50
   el0_svc_naked+0x30/0x34

This patch is fixing the problem by introducing a new check in function
perf_addr_filter_match() to see if the filter's dentry is NULL.

Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Cc: acme@kernel.org
Cc: miklos@szeredi.hu
Cc: namhyung@kernel.org
Cc: songliubraving@fb.com
Fixes: 9511bce9fe8e ("perf/core: Fix bad use of igrab()")
Link: http://lkml.kernel.org/r/1531782831-1186-1-git-send-email-mathieu.poirier@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 kernel/events/core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 213d5807124c..332ab6459b9e 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7124,6 +7124,10 @@ static bool perf_addr_filter_match(struct perf_addr_filter *filter,
 				     struct file *file, unsigned long offset,
 				     unsigned long size)
 {
+	/* d_inode(NULL) won't be equal to any mapped user-space file */
+	if (!filter->path.dentry)
+		return false;
+
 	if (d_inode(filter->path.dentry) != file_inode(file))
 		return false;
 
-- 
2.11.0


--td6fbbckk2qvlmgu
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="0003-perf-core-Fix-a-memory-leak-in-perf_event_parse_addr.patch"
Content-Transfer-Encoding: 8bit

From c78e295869eed826a5df47168bb316675f30dcaf Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?kiyin=28=E5=B0=B9=E4=BA=AE=29?= <kiyin@tencent.com>
Date: Wed, 4 Nov 2020 08:23:22 +0300
Subject: [PATCH 3/3] perf/core: Fix a memory leak in
 perf_event_parse_addr_filter()
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

commit 7bdb157cdebbf95a1cd94ed2e01b338714075d00 upstream

As shown through runtime testing, the "filename" allocation is not
always freed in perf_event_parse_addr_filter().

There are three possible ways that this could happen:

 - It could be allocated twice on subsequent iterations through the loop,
 - or leaked on the success path,
 - or on the failure path.

Clean up the code flow to make it obvious that 'filename' is always
freed in the reallocation path and in the two return paths as well.

We rely on the fact that kfree(NULL) is NOP and filename is initialized
with NULL.

This fixes the leak. No other side effects expected.

[ Dan Carpenter: cleaned up the code flow & added a changelog. ]
[ Ingo Molnar: updated the changelog some more. ]

Fixes: 375637bc5249 ("perf/core: Introduce address range filtering")
Signed-off-by: "kiyin(尹亮)" <kiyin@tencent.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
Cc: Anthony Liguori <aliguori@amazon.com>
--
 kernel/events/core.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 kernel/events/core.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 332ab6459b9e..43d7e0a6ad6f 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -8581,6 +8581,7 @@ perf_event_parse_addr_filter(struct perf_event *event, char *fstr,
 			if (token == IF_SRC_FILE || token == IF_SRC_FILEADDR) {
 				int fpos = filter->range ? 2 : 1;
 
+				kfree(filename);
 				filename = match_strdup(&args[fpos]);
 				if (!filename) {
 					ret = -ENOMEM;
@@ -8619,16 +8620,13 @@ perf_event_parse_addr_filter(struct perf_event *event, char *fstr,
 				 */
 				ret = -EOPNOTSUPP;
 				if (!event->ctx->task)
-					goto fail_free_name;
+					goto fail;
 
 				/* look up the path and grab its inode */
 				ret = kern_path(filename, LOOKUP_FOLLOW,
 						&filter->path);
 				if (ret)
-					goto fail_free_name;
-
-				kfree(filename);
-				filename = NULL;
+					goto fail;
 
 				ret = -EINVAL;
 				if (!filter->path.dentry ||
@@ -8648,13 +8646,13 @@ perf_event_parse_addr_filter(struct perf_event *event, char *fstr,
 	if (state != IF_STATE_ACTION)
 		goto fail;
 
+	kfree(filename);
 	kfree(orig);
 
 	return 0;
 
-fail_free_name:
-	kfree(filename);
 fail:
+	kfree(filename);
 	free_filters_list(filters);
 	kfree(orig);
 
-- 
2.11.0


--td6fbbckk2qvlmgu--

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E65453157F6
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 21:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233440AbhBIUsr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 15:48:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233766AbhBIUib (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Feb 2021 15:38:31 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE0FC0698CA;
        Tue,  9 Feb 2021 12:26:23 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id t2so2361988pjq.2;
        Tue, 09 Feb 2021 12:26:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2BWQkMPpxa9x04z6Kv/kh2y8uZYYBnvMqfwKV/uPs1Q=;
        b=cFA8RWjoqk7kkQ02pGbF4qLdtij5PbiMSKE4eM5V9hsvjyi0brdSTqJGBf+lNQ92UE
         BFEDL7Vhe36DdcsaMeawpTtN+1P1Qa9xck72PSmKv8MOMglClobCgYrnSDxSZw5mNxae
         pq+JkZvPjOf0nb7k67wVRO9Ib6I95pKAMsnGFWEewqcVU70eaaRD+aDNT5HVlhFBA4+X
         s0wb8jrnHXOKPemrFzOXCFJtfdM3eZrBgIwOl/Cr8DDKNxDkZFTgrmyjVaNg/SUwxFw8
         KPsTcvEsAW3WOm+XTi6fwJYzIN1IPl00dXcjnledRIxbPWT35+97pUmQYMDI/9fvrvJI
         rJwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2BWQkMPpxa9x04z6Kv/kh2y8uZYYBnvMqfwKV/uPs1Q=;
        b=BKuYav/Iwu3ZLlQJL4g992YyuGXjrvRhJYT4KYkckfYkud3e2VL/1arzzgI2TJtP65
         IhCLm6SNOZ46oHp2Z5M0Zm0qGVt0TZ8zIR9H/lYYZQgbaYBcQCOdCwTFNtNH5NrXZKmK
         N2fXqWt18fQ1Qn7YL8gL3kW5LRnFQTfx8u2x2pCBf3PeJjbKEcKXE8ByFl6bjG1QIsoW
         BsCdLrUjNU7qwa9ZFdC/ZhVvDv8jgrTPQOpeoJ9yMYrxaL05ctsNFXNtLUw/w+R0j1JM
         VjKrpgHSNWiPHkjGdH4EiYABl/GUajs6iN8EBLZsK/K1CBd+dt3JfLnjwpJn+PfOAyPf
         /NfA==
X-Gm-Message-State: AOAM532DfcMHL3D1SuH/8kV5gNeWiTZ4VvfKFeRwStGc3X4MCrutodSQ
        6ZPF6gfhsualuq3NEOcQ18RviWM5+iM=
X-Google-Smtp-Source: ABdhPJyHrA8X9zLu5UkIbU+Y4fJrKVBS8QJ6CQtDNoOsJAAGAWey4xftFRkfBc+6oi8RTpiQGJQkbw==
X-Received: by 2002:a17:902:e9c4:b029:e1:805d:7965 with SMTP id 4-20020a170902e9c4b02900e1805d7965mr22630294plk.53.1612902382975;
        Tue, 09 Feb 2021 12:26:22 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b27sm23275932pgb.82.2021.02.09.12.26.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 12:26:22 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        hannes@cmpxchg.org
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Bradley Bolen <bradleybolen@gmail.com>,
        Vladimir Davydov <vdavydov@virtuozzo.com>,
        Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Prakash Gupta <guptap@codeaurora.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michal Hocko <mhocko@kernel.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE
        CONTROLLER (MEMCG)),
        linux-mm@kvack.org (open list:CONTROL GROUP - MEMORY RESOURCE
        CONTROLLER (MEMCG))
Subject: [PATCH stable 4.9] mm: memcontrol: fix NULL pointer crash in test_clear_page_writeback()
Date:   Tue,  9 Feb 2021 12:26:15 -0800
Message-Id: <20210209202616.2257512-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>

commit 739f79fc9db1b38f96b5a5109b247a650fbebf6d upstream

Jaegeuk and Brad report a NULL pointer crash when writeback ending tries
to update the memcg stats:

    BUG: unable to handle kernel NULL pointer dereference at 00000000000003b0
    IP: test_clear_page_writeback+0x12e/0x2c0
    [...]
    RIP: 0010:test_clear_page_writeback+0x12e/0x2c0
    Call Trace:
     <IRQ>
     end_page_writeback+0x47/0x70
     f2fs_write_end_io+0x76/0x180 [f2fs]
     bio_endio+0x9f/0x120
     blk_update_request+0xa8/0x2f0
     scsi_end_request+0x39/0x1d0
     scsi_io_completion+0x211/0x690
     scsi_finish_command+0xd9/0x120
     scsi_softirq_done+0x127/0x150
     __blk_mq_complete_request_remote+0x13/0x20
     flush_smp_call_function_queue+0x56/0x110
     generic_smp_call_function_single_interrupt+0x13/0x30
     smp_call_function_single_interrupt+0x27/0x40
     call_function_single_interrupt+0x89/0x90
    RIP: 0010:native_safe_halt+0x6/0x10

    (gdb) l *(test_clear_page_writeback+0x12e)
    0xffffffff811bae3e is in test_clear_page_writeback (./include/linux/memcontrol.h:619).
    614		mod_node_page_state(page_pgdat(page), idx, val);
    615		if (mem_cgroup_disabled() || !page->mem_cgroup)
    616			return;
    617		mod_memcg_state(page->mem_cgroup, idx, val);
    618		pn = page->mem_cgroup->nodeinfo[page_to_nid(page)];
    619		this_cpu_add(pn->lruvec_stat->count[idx], val);
    620	}
    621
    622	unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
    623							gfp_t gfp_mask,

The issue is that writeback doesn't hold a page reference and the page
might get freed after PG_writeback is cleared (and the mapping is
unlocked) in test_clear_page_writeback().  The stat functions looking up
the page's node or zone are safe, as those attributes are static across
allocation and free cycles.  But page->mem_cgroup is not, and it will
get cleared if we race with truncation or migration.

It appears this race window has been around for a while, but less likely
to trigger when the memcg stats were updated first thing after
PG_writeback is cleared.  Recent changes reshuffled this code to update
the global node stats before the memcg ones, though, stretching the race
window out to an extent where people can reproduce the problem.

Update test_clear_page_writeback() to look up and pin page->mem_cgroup
before clearing PG_writeback, then not use that pointer afterward.  It
is a partial revert of 62cccb8c8e7a ("mm: simplify lock_page_memcg()")
but leaves the pageref-holding callsites that aren't affected alone.

Link: http://lkml.kernel.org/r/20170809183825.GA26387@cmpxchg.org
Fixes: 62cccb8c8e7a ("mm: simplify lock_page_memcg()")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Jaegeuk Kim <jaegeuk@kernel.org>
Tested-by: Jaegeuk Kim <jaegeuk@kernel.org>
Reported-by: Bradley Bolen <bradleybolen@gmail.com>
Tested-by: Brad Bolen <bradleybolen@gmail.com>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: <stable@vger.kernel.org>	[4.6+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[guptap@codeaurora.org: Resolved merge conflicts]
Signed-off-by: Prakash Gupta <guptap@codeaurora.org>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
This patch is present in a downstream Android tree:

https://source.mcwhirter.io/craige/bluecross/commit/d4a742865c6b69ef931694745ef54965d7c9966c

and I happened to have stumbled across the same problem too.

Johannes can you review it for correctness with respect to the 4.9
kernel? Thanks!

 include/linux/memcontrol.h | 33 ++++++++++++++++++++++++-----
 mm/memcontrol.c            | 43 +++++++++++++++++++++++++++-----------
 mm/page-writeback.c        | 14 ++++++++++---
 3 files changed, 70 insertions(+), 20 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 8b35bdbdc214..fd77f8303ab9 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -490,9 +490,21 @@ bool mem_cgroup_oom_synchronize(bool wait);
 extern int do_swap_account;
 #endif
 
-void lock_page_memcg(struct page *page);
+struct mem_cgroup *lock_page_memcg(struct page *page);
+void __unlock_page_memcg(struct mem_cgroup *memcg);
 void unlock_page_memcg(struct page *page);
 
+static inline void __mem_cgroup_update_page_stat(struct page *page,
+						 struct mem_cgroup *memcg,
+						 enum mem_cgroup_stat_index idx,
+						 int val)
+{
+	VM_BUG_ON(!(rcu_read_lock_held() || PageLocked(page)));
+
+	if (memcg && memcg->stat)
+		this_cpu_add(memcg->stat->count[idx], val);
+}
+
 /**
  * mem_cgroup_update_page_stat - update page state statistics
  * @page: the page
@@ -508,13 +520,12 @@ void unlock_page_memcg(struct page *page);
  *     mem_cgroup_update_page_stat(page, state, -1);
  *   unlock_page(page) or unlock_page_memcg(page)
  */
+
 static inline void mem_cgroup_update_page_stat(struct page *page,
 				 enum mem_cgroup_stat_index idx, int val)
 {
-	VM_BUG_ON(!(rcu_read_lock_held() || PageLocked(page)));
 
-	if (page->mem_cgroup)
-		this_cpu_add(page->mem_cgroup->stat->count[idx], val);
+	__mem_cgroup_update_page_stat(page, page->mem_cgroup, idx, val);
 }
 
 static inline void mem_cgroup_inc_page_stat(struct page *page,
@@ -709,7 +720,12 @@ mem_cgroup_print_oom_info(struct mem_cgroup *memcg, struct task_struct *p)
 {
 }
 
-static inline void lock_page_memcg(struct page *page)
+static inline struct mem_cgroup *lock_page_memcg(struct page *page)
+{
+	return NULL;
+}
+
+static inline void __unlock_page_memcg(struct mem_cgroup *memcg)
 {
 }
 
@@ -745,6 +761,13 @@ static inline void mem_cgroup_update_page_stat(struct page *page,
 {
 }
 
+static inline void __mem_cgroup_update_page_stat(struct page *page,
+						 struct mem_cgroup *memcg,
+						 enum mem_cgroup_stat_index idx,
+						 int nr)
+{
+}
+
 static inline void mem_cgroup_inc_page_stat(struct page *page,
 					    enum mem_cgroup_stat_index idx)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d4232744c59f..27b0b4f03fcd 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1638,9 +1638,13 @@ bool mem_cgroup_oom_synchronize(bool handle)
  * @page: the page
  *
  * This function protects unlocked LRU pages from being moved to
- * another cgroup and stabilizes their page->mem_cgroup binding.
+ * another cgroup.
+ *
+ * It ensures lifetime of the returned memcg. Caller is responsible
+ * for the lifetime of the page; __unlock_page_memcg() is available
+ * when @page might get freed inside the locked section.
  */
-void lock_page_memcg(struct page *page)
+struct mem_cgroup *lock_page_memcg(struct page *page)
 {
 	struct mem_cgroup *memcg;
 	unsigned long flags;
@@ -1649,18 +1653,24 @@ void lock_page_memcg(struct page *page)
 	 * The RCU lock is held throughout the transaction.  The fast
 	 * path can get away without acquiring the memcg->move_lock
 	 * because page moving starts with an RCU grace period.
-	 */
+	 *
+	 * The RCU lock also protects the memcg from being freed when
+	 * the page state that is going to change is the only thing
+	 * preventing the page itself from being freed. E.g. writeback
+	 * doesn't hold a page reference and relies on PG_writeback to
+	 * keep off truncation, migration and so forth.
+         */
 	rcu_read_lock();
 
 	if (mem_cgroup_disabled())
-		return;
+		return NULL;
 again:
 	memcg = page->mem_cgroup;
 	if (unlikely(!memcg))
-		return;
+		return NULL;
 
 	if (atomic_read(&memcg->moving_account) <= 0)
-		return;
+		return memcg;
 
 	spin_lock_irqsave(&memcg->move_lock, flags);
 	if (memcg != page->mem_cgroup) {
@@ -1676,18 +1686,18 @@ void lock_page_memcg(struct page *page)
 	memcg->move_lock_task = current;
 	memcg->move_lock_flags = flags;
 
-	return;
+	return memcg;
 }
 EXPORT_SYMBOL(lock_page_memcg);
 
 /**
- * unlock_page_memcg - unlock a page->mem_cgroup binding
- * @page: the page
+ * __unlock_page_memcg - unlock and unpin a memcg
+ * @memcg: the memcg
+ *
+ * Unlock and unpin a memcg returned by lock_page_memcg().
  */
-void unlock_page_memcg(struct page *page)
+void __unlock_page_memcg(struct mem_cgroup *memcg)
 {
-	struct mem_cgroup *memcg = page->mem_cgroup;
-
 	if (memcg && memcg->move_lock_task == current) {
 		unsigned long flags = memcg->move_lock_flags;
 
@@ -1699,6 +1709,15 @@ void unlock_page_memcg(struct page *page)
 
 	rcu_read_unlock();
 }
+
+/**
+ * unlock_page_memcg - unlock a page->mem_cgroup binding
+ * @page: the page
+ */
+void unlock_page_memcg(struct page *page)
+{
+	__unlock_page_memcg(page->mem_cgroup);
+}
 EXPORT_SYMBOL(unlock_page_memcg);
 
 /*
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 462c778b9fb5..498c924f2fcd 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2717,9 +2717,10 @@ EXPORT_SYMBOL(clear_page_dirty_for_io);
 int test_clear_page_writeback(struct page *page)
 {
 	struct address_space *mapping = page_mapping(page);
+	struct mem_cgroup *memcg;
 	int ret;
 
-	lock_page_memcg(page);
+	memcg = lock_page_memcg(page);
 	if (mapping && mapping_use_writeback_tags(mapping)) {
 		struct inode *inode = mapping->host;
 		struct backing_dev_info *bdi = inode_to_bdi(inode);
@@ -2747,13 +2748,20 @@ int test_clear_page_writeback(struct page *page)
 	} else {
 		ret = TestClearPageWriteback(page);
 	}
+	/*
+	 * NOTE: Page might be free now! Writeback doesn't hold a page
+	 * reference on its own, it relies on truncation to wait for
+	 * the clearing of PG_writeback. The below can only access
+	 * page state that is static across allocation cycles.
+	 */
 	if (ret) {
-		mem_cgroup_dec_page_stat(page, MEM_CGROUP_STAT_WRITEBACK);
+		__mem_cgroup_update_page_stat(page, memcg,
+					      MEM_CGROUP_STAT_WRITEBACK, -1);
 		dec_node_page_state(page, NR_WRITEBACK);
 		dec_zone_page_state(page, NR_ZONE_WRITE_PENDING);
 		inc_node_page_state(page, NR_WRITTEN);
 	}
-	unlock_page_memcg(page);
+	__unlock_page_memcg(memcg);
 	return ret;
 }
 
-- 
2.25.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 964CA1008A2
	for <lists+stable@lfdr.de>; Mon, 18 Nov 2019 16:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbfKRPup (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Nov 2019 10:50:45 -0500
Received: from wnew4-smtp.messagingengine.com ([64.147.123.18]:54369 "EHLO
        wnew4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726748AbfKRPuo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Nov 2019 10:50:44 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.west.internal (Postfix) with ESMTP id 616D86E0;
        Mon, 18 Nov 2019 10:50:41 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 18 Nov 2019 10:50:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=dCoE+i
        kZFpCTZGkyMYJp3T2e8t6zGYmy1wh//WSqF0I=; b=WVSsBYJNTK+5f5trc3Z17v
        f/ovFDeZbdIM1K0YG/le7QZDAfQRs0f6OaYGMyrKhUX0IYp13VEa0NLVMrlAEve6
        cziSNXw+f0a7zJ5diMX99ueY6CQvEVe1H+63qfLebHS6RG9YQ3OPKdBoXguXVYmB
        mCxbRx/LG4Ht7huyJvsU54Es34YGmHgoy2CEO5VZ7Llm8qbXpBHUKfJgdY3RA1Ix
        lJ5d4o+r4FQ9w3LJUN1SWGTbVEEzaX4lcf6PtV0cuzekr7w6RUDL5Ku60iYHUlrC
        rGM8Rk9OpF4RfosvXGYyVBh/ysC3RsZ6YJ3UqLRgTJkEE33YGJYe0nFgfn8kICGg
        ==
X-ME-Sender: <xms:zr3SXd8vBZndQsdhh0kQplrw2p9FwoBxn4qpyAAdtN2Kxowdak8mNQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudegiedgheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:zr3SXeflMPJn2DoU2_1EmKs4la-r1PtWyHQFUZw5vYHOV8AulbAKVA>
    <xmx:zr3SXak3dRjOBzIiEuOmrfBLwPl9TCPGgd1k6YVfhKqui9cX_IR2CQ>
    <xmx:zr3SXaHjGmuOuK5R0FgrwXszu2WCp_7uCsym8oNWX4FwDURf1MxHyg>
    <xmx:0L3SXV3y2MRUvaUs2UHPiKoUg6z3gLnHe6tJTtGJo3eMh0F3xOPoLoIJbTk>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7984D306005B;
        Mon, 18 Nov 2019 10:50:38 -0500 (EST)
Subject: FAILED: patch "[PATCH] mm/memory_hotplug: fix try_offline_node()" failed to apply to 4.19-stable tree
To:     david@redhat.com, akpm@linux-foundation.org,
        dan.j.williams@intel.com, gregkh@linuxfoundation.org,
        jani.nikula@intel.com, jolsa@kernel.org, keith.busch@intel.com,
        m.mizuma@jp.fujitsu.com, mhocko@suse.com, nayna@linux.ibm.com,
        osalvador@suse.de, pasha.tatashin@soleen.com, peterz@infradead.org,
        rafael@kernel.org, sfr@canb.auug.org.au, stable@vger.kernel.org,
        tangchen@cn.fujitsu.com, torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Nov 2019 16:50:36 +0100
Message-ID: <157409223621479@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2c91f8fc6c999fe10185d8ad99fda1759f662f70 Mon Sep 17 00:00:00 2001
From: David Hildenbrand <david@redhat.com>
Date: Fri, 15 Nov 2019 17:34:57 -0800
Subject: [PATCH] mm/memory_hotplug: fix try_offline_node()

try_offline_node() is pretty much broken right now:

 - The node span is updated when onlining memory, not when adding it. We
   ignore memory that was mever onlined. Bad.

 - We touch possible garbage memmaps. The pfn_to_nid(pfn) can easily
   trigger a kernel panic. Bad for memory that is offline but also bad
   for subsection hotadd with ZONE_DEVICE, whereby the memmap of the
   first PFN of a section might contain garbage.

 - Sections belonging to mixed nodes are not properly considered.

As memory blocks might belong to multiple nodes, we would have to walk
all pageblocks (or at least subsections) within present sections.
However, we don't have a way to identify whether a memmap that is not
online was initialized (relevant for ZONE_DEVICE).  This makes things
more complicated.

Luckily, we can piggy pack on the node span and the nid stored in memory
blocks.  Currently, the node span is grown when calling
move_pfn_range_to_zone() - e.g., when onlining memory, and shrunk when
removing memory, before calling try_offline_node().  Sysfs links are
created via link_mem_sections(), e.g., during boot or when adding
memory.

If the node still spans memory or if any memory block belongs to the
nid, we don't set the node offline.  As memory blocks that span multiple
nodes cannot get offlined, the nid stored in memory blocks is reliable
enough (for such online memory blocks, the node still spans the memory).

Introduce for_each_memory_block() to efficiently walk all memory blocks.

Note: We will soon stop shrinking the ZONE_DEVICE zone and the node span
when removing ZONE_DEVICE memory to fix similar issues (access of
garbage memmaps) - until we have a reliable way to identify whether
these memmaps were properly initialized.  This implies later, that once
a node had ZONE_DEVICE memory, we won't be able to set a node offline -
which should be acceptable.

Since commit f1dd2cd13c4b ("mm, memory_hotplug: do not associate
hotadded memory to zones until online") memory that is added is not
assoziated with a zone/node (memmap not initialized).  The introducing
commit 60a5a19e7419 ("memory-hotplug: remove sysfs file of node")
already missed that we could have multiple nodes for a section and that
the zone/node span is updated when onlining pages, not when adding them.

I tested this by hotplugging two DIMMs to a memory-less and cpu-less
NUMA node.  The node is properly onlined when adding the DIMMs.  When
removing the DIMMs, the node is properly offlined.

Masayoshi Mizuma reported:

: Without this patch, memory hotplug fails as panic:
:
:  BUG: kernel NULL pointer dereference, address: 0000000000000000
:  ...
:  Call Trace:
:   remove_memory_block_devices+0x81/0xc0
:   try_remove_memory+0xb4/0x130
:   __remove_memory+0xa/0x20
:   acpi_memory_device_remove+0x84/0x100
:   acpi_bus_trim+0x57/0x90
:   acpi_bus_trim+0x2e/0x90
:   acpi_device_hotplug+0x2b2/0x4d0
:   acpi_hotplug_work_fn+0x1a/0x30
:   process_one_work+0x171/0x380
:   worker_thread+0x49/0x3f0
:   kthread+0xf8/0x130
:   ret_from_fork+0x35/0x40

[david@redhat.com: v3]
  Link: http://lkml.kernel.org/r/20191102120221.7553-1-david@redhat.com
Link: http://lkml.kernel.org/r/20191028105458.28320-1-david@redhat.com
Fixes: 60a5a19e7419 ("memory-hotplug: remove sysfs file of node")
Fixes: f1dd2cd13c4b ("mm, memory_hotplug: do not associate hotadded memory to zones until online") # visiable after d0dc12e86b319
Signed-off-by: David Hildenbrand <david@redhat.com>
Tested-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Keith Busch <keith.busch@intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Nayna Jain <nayna@linux.ibm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 55907c27075b..84c4e1f72cbd 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -872,3 +872,39 @@ int walk_memory_blocks(unsigned long start, unsigned long size,
 	}
 	return ret;
 }
+
+struct for_each_memory_block_cb_data {
+	walk_memory_blocks_func_t func;
+	void *arg;
+};
+
+static int for_each_memory_block_cb(struct device *dev, void *data)
+{
+	struct memory_block *mem = to_memory_block(dev);
+	struct for_each_memory_block_cb_data *cb_data = data;
+
+	return cb_data->func(mem, cb_data->arg);
+}
+
+/**
+ * for_each_memory_block - walk through all present memory blocks
+ *
+ * @arg: argument passed to func
+ * @func: callback for each memory block walked
+ *
+ * This function walks through all present memory blocks, calling func on
+ * each memory block.
+ *
+ * In case func() returns an error, walking is aborted and the error is
+ * returned.
+ */
+int for_each_memory_block(void *arg, walk_memory_blocks_func_t func)
+{
+	struct for_each_memory_block_cb_data cb_data = {
+		.func = func,
+		.arg = arg,
+	};
+
+	return bus_for_each_dev(&memory_subsys, NULL, &cb_data,
+				for_each_memory_block_cb);
+}
diff --git a/include/linux/memory.h b/include/linux/memory.h
index 0ebb105eb261..4c75dae8dd29 100644
--- a/include/linux/memory.h
+++ b/include/linux/memory.h
@@ -119,6 +119,7 @@ extern struct memory_block *find_memory_block(struct mem_section *);
 typedef int (*walk_memory_blocks_func_t)(struct memory_block *, void *);
 extern int walk_memory_blocks(unsigned long start, unsigned long size,
 			      void *arg, walk_memory_blocks_func_t func);
+extern int for_each_memory_block(void *arg, walk_memory_blocks_func_t func);
 #define CONFIG_MEM_BLOCK_SIZE	(PAGES_PER_SECTION<<PAGE_SHIFT)
 #endif /* CONFIG_MEMORY_HOTPLUG_SPARSE */
 
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 07e5c67f48a8..3b62a9ff8ea0 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1646,6 +1646,18 @@ static int check_cpu_on_node(pg_data_t *pgdat)
 	return 0;
 }
 
+static int check_no_memblock_for_node_cb(struct memory_block *mem, void *arg)
+{
+	int nid = *(int *)arg;
+
+	/*
+	 * If a memory block belongs to multiple nodes, the stored nid is not
+	 * reliable. However, such blocks are always online (e.g., cannot get
+	 * offlined) and, therefore, are still spanned by the node.
+	 */
+	return mem->nid == nid ? -EEXIST : 0;
+}
+
 /**
  * try_offline_node
  * @nid: the node ID
@@ -1658,25 +1670,24 @@ static int check_cpu_on_node(pg_data_t *pgdat)
 void try_offline_node(int nid)
 {
 	pg_data_t *pgdat = NODE_DATA(nid);
-	unsigned long start_pfn = pgdat->node_start_pfn;
-	unsigned long end_pfn = start_pfn + pgdat->node_spanned_pages;
-	unsigned long pfn;
-
-	for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
-		unsigned long section_nr = pfn_to_section_nr(pfn);
-
-		if (!present_section_nr(section_nr))
-			continue;
+	int rc;
 
-		if (pfn_to_nid(pfn) != nid)
-			continue;
+	/*
+	 * If the node still spans pages (especially ZONE_DEVICE), don't
+	 * offline it. A node spans memory after move_pfn_range_to_zone(),
+	 * e.g., after the memory block was onlined.
+	 */
+	if (pgdat->node_spanned_pages)
+		return;
 
-		/*
-		 * some memory sections of this node are not removed, and we
-		 * can't offline node now.
-		 */
+	/*
+	 * Especially offline memory blocks might not be spanned by the
+	 * node. They will get spanned by the node once they get onlined.
+	 * However, they link to the node in sysfs and can get onlined later.
+	 */
+	rc = for_each_memory_block(&nid, check_no_memblock_for_node_cb);
+	if (rc)
 		return;
-	}
 
 	if (check_cpu_on_node(pgdat))
 		return;


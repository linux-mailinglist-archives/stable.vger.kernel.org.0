Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 403A527AFC4
	for <lists+stable@lfdr.de>; Mon, 28 Sep 2020 16:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbgI1ONM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 10:13:12 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:59715 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726310AbgI1ONM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Sep 2020 10:13:12 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id DBDFCFBF;
        Mon, 28 Sep 2020 10:13:10 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 28 Sep 2020 10:13:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=4I0ucA
        08HBR/lXbQuDjCGRudXMqGtySf4kn66NriEPQ=; b=Mkyi9wbgLOa2fTIOxXqsYE
        arLDtbTSPjli9qWcvD4DogCCfHOy9woxLALeyeczLTU7y7QtMFBMzST8knBql49d
        ombuuekd2KhJF3k9sICQLZ6mm06jsy+/mZwDyy5hDM12jrY1IViZUsRF8OT1LQtg
        A5nN8NePJW4FzAWHP25/u8OtYUQ70Vp0+B3T8kU7+gFExKlQQJwv8MixV+9LVwnr
        K0bjRB1mtOhKjXH3y4Voc8CGQJjwBu9N2DDecL3IHTv4DOeRI1A53woAIR52IJgj
        fd0XaIR4XAtrI0u8s9WnuaoijgFhSQpKI2rtoQ0UDTrH5qQJVbEhemV632CGbjhQ
        ==
X-ME-Sender: <xms:de9xX63xR5Vq4HV_cHeqc8uoq9EiYUpfpENuTo-6pP0M7Hu08n3-aw>
    <xme:de9xX9FwNUxFtZGH_CJo7snNBU6_EHxdcX9iSZF407FGuijIBoT1xCJuYOjoz9Ox_
    HCFlDoD-vnv4A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdeigdehfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:de9xXy4nKazl1zbltm7dPpf6uUuThagt12AE3265v0uFvWNTYNiX5g>
    <xmx:de9xX71uBI64s9GvNIqRhMMz4NOFlISV3IbDceTk8hzr0egFwGptsQ>
    <xmx:de9xX9G44KvmoQf9bcL2mw-yad5hXhT-4U_7myuKkyjTBZ2IpcI5cQ>
    <xmx:du9xX18hmxRkTp5fvyPqCddO0QrMhdw6ggKlbShCx9RMNg2DmBw0MhsnmmHRnV8t>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 439F03280063;
        Mon, 28 Sep 2020 10:13:09 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mm: don't rely on system state to detect hot-plug operations" failed to apply to 4.19-stable tree
To:     ldufour@linux.ibm.com, akpm@linux-foundation.org,
        cheloha@linux.ibm.com, david@redhat.com, fenghua.yu@intel.com,
        gregkh@linuxfoundation.org, mhocko@suse.com, nathanl@linux.ibm.com,
        osalvador@suse.de, rafael@kernel.org, stable@vger.kernel.org,
        tony.luck@intel.com, torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Sep 2020 16:13:15 +0200
Message-ID: <1601302395201254@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From f85086f95fa36194eb0db5cd5c12e56801b98523 Mon Sep 17 00:00:00 2001
From: Laurent Dufour <ldufour@linux.ibm.com>
Date: Fri, 25 Sep 2020 21:19:31 -0700
Subject: [PATCH] mm: don't rely on system state to detect hot-plug operations

In register_mem_sect_under_node() the system_state's value is checked to
detect whether the call is made during boot time or during an hot-plug
operation.  Unfortunately, that check against SYSTEM_BOOTING is wrong
because regular memory is registered at SYSTEM_SCHEDULING state.  In
addition, memory hot-plug operation can be triggered at this system
state by the ACPI [1].  So checking against the system state is not
enough.

The consequence is that on system with interleaved node's ranges like this:

 Early memory node ranges
   node   1: [mem 0x0000000000000000-0x000000011fffffff]
   node   2: [mem 0x0000000120000000-0x000000014fffffff]
   node   1: [mem 0x0000000150000000-0x00000001ffffffff]
   node   0: [mem 0x0000000200000000-0x000000048fffffff]
   node   2: [mem 0x0000000490000000-0x00000007ffffffff]

This can be seen on PowerPC LPAR after multiple memory hot-plug and
hot-unplug operations are done.  At the next reboot the node's memory
ranges can be interleaved and since the call to link_mem_sections() is
made in topology_init() while the system is in the SYSTEM_SCHEDULING
state, the node's id is not checked, and the sections registered to
multiple nodes:

  $ ls -l /sys/devices/system/memory/memory21/node*
  total 0
  lrwxrwxrwx 1 root root     0 Aug 24 05:27 node1 -> ../../node/node1
  lrwxrwxrwx 1 root root     0 Aug 24 05:27 node2 -> ../../node/node2

In that case, the system is able to boot but if later one of theses
memory blocks is hot-unplugged and then hot-plugged, the sysfs
inconsistency is detected and this is triggering a BUG_ON():

  kernel BUG at /Users/laurent/src/linux-ppc/mm/memory_hotplug.c:1084!
  Oops: Exception in kernel mode, sig: 5 [#1]
  LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
  Modules linked in: rpadlpar_io rpaphp pseries_rng rng_core vmx_crypto gf128mul binfmt_misc ip_tables x_tables xfs libcrc32c crc32c_vpmsum autofs4
  CPU: 8 PID: 10256 Comm: drmgr Not tainted 5.9.0-rc1+ #25
  Call Trace:
    add_memory_resource+0x23c/0x340 (unreliable)
    __add_memory+0x5c/0xf0
    dlpar_add_lmb+0x1b4/0x500
    dlpar_memory+0x1f8/0xb80
    handle_dlpar_errorlog+0xc0/0x190
    dlpar_store+0x198/0x4a0
    kobj_attr_store+0x30/0x50
    sysfs_kf_write+0x64/0x90
    kernfs_fop_write+0x1b0/0x290
    vfs_write+0xe8/0x290
    ksys_write+0xdc/0x130
    system_call_exception+0x160/0x270
    system_call_common+0xf0/0x27c

This patch addresses the root cause by not relying on the system_state
value to detect whether the call is due to a hot-plug operation.  An
extra parameter is added to link_mem_sections() detailing whether the
operation is due to a hot-plug operation.

[1] According to Oscar Salvador, using this qemu command line, ACPI
memory hotplug operations are raised at SYSTEM_SCHEDULING state:

  $QEMU -enable-kvm -machine pc -smp 4,sockets=4,cores=1,threads=1 -cpu host -monitor pty \
        -m size=$MEM,slots=255,maxmem=4294967296k  \
        -numa node,nodeid=0,cpus=0-3,mem=512 -numa node,nodeid=1,mem=512 \
        -object memory-backend-ram,id=memdimm0,size=134217728 -device pc-dimm,node=0,memdev=memdimm0,id=dimm0,slot=0 \
        -object memory-backend-ram,id=memdimm1,size=134217728 -device pc-dimm,node=0,memdev=memdimm1,id=dimm1,slot=1 \
        -object memory-backend-ram,id=memdimm2,size=134217728 -device pc-dimm,node=0,memdev=memdimm2,id=dimm2,slot=2 \
        -object memory-backend-ram,id=memdimm3,size=134217728 -device pc-dimm,node=0,memdev=memdimm3,id=dimm3,slot=3 \
        -object memory-backend-ram,id=memdimm4,size=134217728 -device pc-dimm,node=1,memdev=memdimm4,id=dimm4,slot=4 \
        -object memory-backend-ram,id=memdimm5,size=134217728 -device pc-dimm,node=1,memdev=memdimm5,id=dimm5,slot=5 \
        -object memory-backend-ram,id=memdimm6,size=134217728 -device pc-dimm,node=1,memdev=memdimm6,id=dimm6,slot=6 \

Fixes: 4fbce633910e ("mm/memory_hotplug.c: make register_mem_sect_under_node() a callback of walk_memory_range()")
Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Nathan Lynch <nathanl@linux.ibm.com>
Cc: Scott Cheloha <cheloha@linux.ibm.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20200915094143.79181-3-ldufour@linux.ibm.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/drivers/base/node.c b/drivers/base/node.c
index 508b80f6329b..50af16e68d98 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -761,14 +761,36 @@ static int __ref get_nid_for_pfn(unsigned long pfn)
 	return pfn_to_nid(pfn);
 }
 
+static int do_register_memory_block_under_node(int nid,
+					       struct memory_block *mem_blk)
+{
+	int ret;
+
+	/*
+	 * If this memory block spans multiple nodes, we only indicate
+	 * the last processed node.
+	 */
+	mem_blk->nid = nid;
+
+	ret = sysfs_create_link_nowarn(&node_devices[nid]->dev.kobj,
+				       &mem_blk->dev.kobj,
+				       kobject_name(&mem_blk->dev.kobj));
+	if (ret)
+		return ret;
+
+	return sysfs_create_link_nowarn(&mem_blk->dev.kobj,
+				&node_devices[nid]->dev.kobj,
+				kobject_name(&node_devices[nid]->dev.kobj));
+}
+
 /* register memory section under specified node if it spans that node */
-static int register_mem_sect_under_node(struct memory_block *mem_blk,
-					 void *arg)
+static int register_mem_block_under_node_early(struct memory_block *mem_blk,
+					       void *arg)
 {
 	unsigned long memory_block_pfns = memory_block_size_bytes() / PAGE_SIZE;
 	unsigned long start_pfn = section_nr_to_pfn(mem_blk->start_section_nr);
 	unsigned long end_pfn = start_pfn + memory_block_pfns - 1;
-	int ret, nid = *(int *)arg;
+	int nid = *(int *)arg;
 	unsigned long pfn;
 
 	for (pfn = start_pfn; pfn <= end_pfn; pfn++) {
@@ -785,38 +807,33 @@ static int register_mem_sect_under_node(struct memory_block *mem_blk,
 		}
 
 		/*
-		 * We need to check if page belongs to nid only for the boot
-		 * case, during hotplug we know that all pages in the memory
-		 * block belong to the same node.
-		 */
-		if (system_state == SYSTEM_BOOTING) {
-			page_nid = get_nid_for_pfn(pfn);
-			if (page_nid < 0)
-				continue;
-			if (page_nid != nid)
-				continue;
-		}
-
-		/*
-		 * If this memory block spans multiple nodes, we only indicate
-		 * the last processed node.
+		 * We need to check if page belongs to nid only at the boot
+		 * case because node's ranges can be interleaved.
 		 */
-		mem_blk->nid = nid;
-
-		ret = sysfs_create_link_nowarn(&node_devices[nid]->dev.kobj,
-					&mem_blk->dev.kobj,
-					kobject_name(&mem_blk->dev.kobj));
-		if (ret)
-			return ret;
+		page_nid = get_nid_for_pfn(pfn);
+		if (page_nid < 0)
+			continue;
+		if (page_nid != nid)
+			continue;
 
-		return sysfs_create_link_nowarn(&mem_blk->dev.kobj,
-				&node_devices[nid]->dev.kobj,
-				kobject_name(&node_devices[nid]->dev.kobj));
+		return do_register_memory_block_under_node(nid, mem_blk);
 	}
 	/* mem section does not span the specified node */
 	return 0;
 }
 
+/*
+ * During hotplug we know that all pages in the memory block belong to the same
+ * node.
+ */
+static int register_mem_block_under_node_hotplug(struct memory_block *mem_blk,
+						 void *arg)
+{
+	int nid = *(int *)arg;
+
+	return do_register_memory_block_under_node(nid, mem_blk);
+}
+
 /*
  * Unregister a memory block device under the node it spans. Memory blocks
  * with multiple nodes cannot be offlined and therefore also never be removed.
@@ -832,11 +849,19 @@ void unregister_memory_block_under_nodes(struct memory_block *mem_blk)
 			  kobject_name(&node_devices[mem_blk->nid]->dev.kobj));
 }
 
-int link_mem_sections(int nid, unsigned long start_pfn, unsigned long end_pfn)
+int link_mem_sections(int nid, unsigned long start_pfn, unsigned long end_pfn,
+		      enum meminit_context context)
 {
+	walk_memory_blocks_func_t func;
+
+	if (context == MEMINIT_HOTPLUG)
+		func = register_mem_block_under_node_hotplug;
+	else
+		func = register_mem_block_under_node_early;
+
 	return walk_memory_blocks(PFN_PHYS(start_pfn),
 				  PFN_PHYS(end_pfn - start_pfn), (void *)&nid,
-				  register_mem_sect_under_node);
+				  func);
 }
 
 #ifdef CONFIG_HUGETLBFS
diff --git a/include/linux/node.h b/include/linux/node.h
index 4866f32a02d8..014ba3ab2efd 100644
--- a/include/linux/node.h
+++ b/include/linux/node.h
@@ -99,11 +99,13 @@ extern struct node *node_devices[];
 typedef  void (*node_registration_func_t)(struct node *);
 
 #if defined(CONFIG_MEMORY_HOTPLUG_SPARSE) && defined(CONFIG_NUMA)
-extern int link_mem_sections(int nid, unsigned long start_pfn,
-			     unsigned long end_pfn);
+int link_mem_sections(int nid, unsigned long start_pfn,
+		      unsigned long end_pfn,
+		      enum meminit_context context);
 #else
 static inline int link_mem_sections(int nid, unsigned long start_pfn,
-				    unsigned long end_pfn)
+				    unsigned long end_pfn,
+				    enum meminit_context context)
 {
 	return 0;
 }
@@ -128,7 +130,8 @@ static inline int register_one_node(int nid)
 		if (error)
 			return error;
 		/* link memory sections under this node */
-		error = link_mem_sections(nid, start_pfn, end_pfn);
+		error = link_mem_sections(nid, start_pfn, end_pfn,
+					  MEMINIT_EARLY);
 	}
 
 	return error;
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 345308a8bd15..ce3e73e3a5c1 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1080,7 +1080,8 @@ int __ref add_memory_resource(int nid, struct resource *res)
 	}
 
 	/* link memory sections under this node.*/
-	ret = link_mem_sections(nid, PFN_DOWN(start), PFN_UP(start + size - 1));
+	ret = link_mem_sections(nid, PFN_DOWN(start), PFN_UP(start + size - 1),
+				MEMINIT_HOTPLUG);
 	BUG_ON(ret);
 
 	/* create new memmap entry */


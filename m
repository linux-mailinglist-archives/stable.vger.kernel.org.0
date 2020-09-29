Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9FC27D387
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 18:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728126AbgI2QXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 12:23:12 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45154 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728184AbgI2QXL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Sep 2020 12:23:11 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08TG2ZWL185255;
        Tue, 29 Sep 2020 12:23:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=Q2fDwe0V334Hs7q7rbQr16b4xXkcVJhjktmD/mZMrLE=;
 b=o5nSIXqpOtcAfWk3LxkyyMQRvGSFNcN6h4i0TCJJoTE3sZueWV13YZkrQTUvTkRIKgC+
 wTeD7EkT445aHd/J5oo6f9NkeN/1/R+p7rVem2Mx857A8yo/IfcpRxIw7I5oz+g44PBv
 +EQMQdQJWAEW3COXVpWuc+Ts51Iuv5+aGukstkLBssvEIX/6UAvGAhInopSmEsc+HWrw
 rx/oLz5ZOqW6JKqTUQ7jAiUyffZVMpky5dAxIY5atrv0tH5NfieMBrI+0hzs1yMsx/I2
 HAhgyWkNQTdSHtZyLHUwCOEOWy3lGu3qNl5XlCfPWwfQYTgnlZuH04HlFh8c9Y9//ZIz og== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33v6kbmdh7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Sep 2020 12:23:00 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08TG37HL188358;
        Tue, 29 Sep 2020 12:22:57 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33v6kbmdge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Sep 2020 12:22:57 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08TGLfnQ005465;
        Tue, 29 Sep 2020 16:22:55 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 33v5kg03qe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Sep 2020 16:22:55 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08TGMqd132964872
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Sep 2020 16:22:52 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8306942041;
        Tue, 29 Sep 2020 16:22:52 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0FA7D42047;
        Tue, 29 Sep 2020 16:22:52 +0000 (GMT)
Received: from pomme.tlslab.ibm.com (unknown [9.145.50.8])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 29 Sep 2020 16:22:51 +0000 (GMT)
From:   Laurent Dufour <ldufour@linux.ibm.com>
To:     stable@vger.kernel.org
Cc:     David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oscar Salvador <osalvador@suse.de>,
        Michal Hocko <mhocko@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Nathan Lynch <nathanl@linux.ibm.com>,
        Scott Cheloha <cheloha@linux.ibm.com>,
        Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 1/2] mm: replace memmap_context by memplug_context
Date:   Tue, 29 Sep 2020 18:22:49 +0200
Message-Id: <20200929162250.67282-1-ldufour@linux.ibm.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_07:2020-09-29,2020-09-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 adultscore=0
 clxscore=1015 mlxscore=0 mlxlogscore=999 bulkscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009290136
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Backport version to the 4.19-stable tree of:
[ Upstream commit c1d0da83358a2316d9be7f229f26126dbaa07468 ]

Patch series "mm: fix memory to node bad links in sysfs", v3.

Sometimes, firmware may expose interleaved memory layout like this:

 Early memory node ranges
   node   1: [mem 0x0000000000000000-0x000000011fffffff]
   node   2: [mem 0x0000000120000000-0x000000014fffffff]
   node   1: [mem 0x0000000150000000-0x00000001ffffffff]
   node   0: [mem 0x0000000200000000-0x000000048fffffff]
   node   2: [mem 0x0000000490000000-0x00000007ffffffff]

In that case, we can see memory blocks assigned to multiple nodes in
sysfs:

  $ ls -l /sys/devices/system/memory/memory21
  total 0
  lrwxrwxrwx 1 root root     0 Aug 24 05:27 node1 -> ../../node/node1
  lrwxrwxrwx 1 root root     0 Aug 24 05:27 node2 -> ../../node/node2
  -rw-r--r-- 1 root root 65536 Aug 24 05:27 online
  -r--r--r-- 1 root root 65536 Aug 24 05:27 phys_device
  -r--r--r-- 1 root root 65536 Aug 24 05:27 phys_index
  drwxr-xr-x 2 root root     0 Aug 24 05:27 power
  -r--r--r-- 1 root root 65536 Aug 24 05:27 removable
  -rw-r--r-- 1 root root 65536 Aug 24 05:27 state
  lrwxrwxrwx 1 root root     0 Aug 24 05:25 subsystem -> ../../../../bus/memory
  -rw-r--r-- 1 root root 65536 Aug 24 05:25 uevent
  -r--r--r-- 1 root root 65536 Aug 24 05:27 valid_zones

The same applies in the node's directory with a memory21 link in both
the node1 and node2's directory.

This is wrong but doesn't prevent the system to run.  However when
later, one of these memory blocks is hot-unplugged and then hot-plugged,
the system is detecting an inconsistency in the sysfs layout and a
BUG_ON() is raised:

  kernel BUG at /Users/laurent/src/linux-ppc/mm/memory_hotplug.c:1084!
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

This has been seen on PowerPC LPAR.

The root cause of this issue is that when node's memory is registered,
the range used can overlap another node's range, thus the memory block
is registered to multiple nodes in sysfs.

There are two issues here:

 (a) The sysfs memory and node's layouts are broken due to these
     multiple links

 (b) The link errors in link_mem_sections() should not lead to a system
     panic.

To address (a) register_mem_sect_under_node should not rely on the
system state to detect whether the link operation is triggered by a hot
plug operation or not.  This is addressed by the patches 1 and 2 of this
series.

Issue (b) will be addressed separately.

This patch (of 2):

The memmap_context enum is used to detect whether a memory operation is
due to a hot-add operation or happening at boot time.

Make it general to the hotplug operation and rename it as
meminit_context.

There is no functional change introduced by this patch

Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J . Wysocki" <rafael@kernel.org>
Cc: Nathan Lynch <nathanl@linux.ibm.com>
Cc: Scott Cheloha <cheloha@linux.ibm.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: <stable@vger.kernel.org> # 4.19.y
Link: https://lkml.kernel.org/r/20200915094143.79181-1-ldufour@linux.ibm.com
Link: https://lkml.kernel.org/r/20200915132624.9723-1-ldufour@linux.ibm.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 arch/ia64/mm/init.c    |  6 +++---
 include/linux/mm.h     |  2 +-
 include/linux/mmzone.h | 11 ++++++++---
 mm/memory_hotplug.c    |  2 +-
 mm/page_alloc.c        | 11 ++++++-----
 5 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/arch/ia64/mm/init.c b/arch/ia64/mm/init.c
index 79e5cc70f1fd..561e2573bd34 100644
--- a/arch/ia64/mm/init.c
+++ b/arch/ia64/mm/init.c
@@ -499,7 +499,7 @@ virtual_memmap_init(u64 start, u64 end, void *arg)
 	if (map_start < map_end)
 		memmap_init_zone((unsigned long)(map_end - map_start),
 				 args->nid, args->zone, page_to_pfn(map_start),
-				 MEMMAP_EARLY, NULL);
+				 MEMINIT_EARLY, NULL);
 	return 0;
 }
 
@@ -508,8 +508,8 @@ memmap_init (unsigned long size, int nid, unsigned long zone,
 	     unsigned long start_pfn)
 {
 	if (!vmem_map) {
-		memmap_init_zone(size, nid, zone, start_pfn, MEMMAP_EARLY,
-				NULL);
+		memmap_init_zone(size, nid, zone, start_pfn,
+				 MEMINIT_EARLY, NULL);
 	} else {
 		struct page *start;
 		struct memmap_init_callback_data args;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 05bc5f25ab85..83828c118b6b 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2179,7 +2179,7 @@ static inline void zero_resv_unavail(void) {}
 
 extern void set_dma_reserve(unsigned long new_dma_reserve);
 extern void memmap_init_zone(unsigned long, int, unsigned long, unsigned long,
-		enum memmap_context, struct vmem_altmap *);
+		enum meminit_context, struct vmem_altmap *);
 extern void setup_per_zone_wmarks(void);
 extern int __meminit init_per_zone_wmark_min(void);
 extern void mem_init(void);
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index fdd93a39f1fa..fa02014eba8e 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -759,10 +759,15 @@ bool zone_watermark_ok(struct zone *z, unsigned int order,
 		unsigned int alloc_flags);
 bool zone_watermark_ok_safe(struct zone *z, unsigned int order,
 		unsigned long mark, int classzone_idx);
-enum memmap_context {
-	MEMMAP_EARLY,
-	MEMMAP_HOTPLUG,
+/*
+ * Memory initialization context, use to differentiate memory added by
+ * the platform statically or via memory hotplug interface.
+ */
+enum meminit_context {
+	MEMINIT_EARLY,
+	MEMINIT_HOTPLUG,
 };
+
 extern void init_currently_empty_zone(struct zone *zone, unsigned long start_pfn,
 				     unsigned long size);
 
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index aae7ff485671..c839c4ad4871 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -733,7 +733,7 @@ void __ref move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
 	 * are reserved so nobody should be touching them so we should be safe
 	 */
 	memmap_init_zone(nr_pages, nid, zone_idx(zone), start_pfn,
-			MEMMAP_HOTPLUG, altmap);
+			 MEMINIT_HOTPLUG, altmap);
 
 	set_zone_contiguous(zone);
 }
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 5717ee66c8b3..545800433dfb 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5480,7 +5480,7 @@ void __ref build_all_zonelists(pg_data_t *pgdat)
  * done. Non-atomic initialization, single-pass.
  */
 void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zone,
-		unsigned long start_pfn, enum memmap_context context,
+		unsigned long start_pfn, enum meminit_context context,
 		struct vmem_altmap *altmap)
 {
 	unsigned long end_pfn = start_pfn + size;
@@ -5507,7 +5507,7 @@ void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zone,
 		 * There can be holes in boot-time mem_map[]s handed to this
 		 * function.  They do not exist on hotplugged memory.
 		 */
-		if (context != MEMMAP_EARLY)
+		if (context != MEMINIT_EARLY)
 			goto not_early;
 
 		if (!early_pfn_valid(pfn))
@@ -5542,7 +5542,7 @@ void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zone,
 not_early:
 		page = pfn_to_page(pfn);
 		__init_single_page(page, pfn, zone, nid);
-		if (context == MEMMAP_HOTPLUG)
+		if (context == MEMINIT_HOTPLUG)
 			SetPageReserved(page);
 
 		/*
@@ -5557,7 +5557,7 @@ void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zone,
 		 * check here not to call set_pageblock_migratetype() against
 		 * pfn out of zone.
 		 *
-		 * Please note that MEMMAP_HOTPLUG path doesn't clear memmap
+		 * Please note that MEMINIT_HOTPLUG path doesn't clear memmap
 		 * because this is done early in sparse_add_one_section
 		 */
 		if (!(pfn & (pageblock_nr_pages - 1))) {
@@ -5578,7 +5578,8 @@ static void __meminit zone_init_free_lists(struct zone *zone)
 
 #ifndef __HAVE_ARCH_MEMMAP_INIT
 #define memmap_init(size, nid, zone, start_pfn) \
-	memmap_init_zone((size), (nid), (zone), (start_pfn), MEMMAP_EARLY, NULL)
+	memmap_init_zone((size), (nid), (zone), (start_pfn), \
+			 MEMINIT_EARLY, NULL)
 #endif
 
 static int zone_batchsize(struct zone *zone)
-- 
2.28.0


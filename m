Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA964109310
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 18:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727630AbfKYRpm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 12:45:42 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:59145 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727617AbfKYRpm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Nov 2019 12:45:42 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 35C9E227AB;
        Mon, 25 Nov 2019 12:45:41 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 25 Nov 2019 12:45:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=AZBkUV
        HTIQ5e23r7gr2JhDMChby2R81fdcaVuTHg0qw=; b=UsJdWduvtOc19kTtE/8rmP
        zL73j3n1k5XFN0uVZ9xioAOFLVZzu3FSaNdiVLebDW5w7JAeJsazADWDtVuEAoOA
        +koTEvRAMVER4g+43/4MoC0SCiOdN0m7uKv+sBhqO/8bkilhlgOpJzLtrEliY6xc
        WXE7OIDxdfNI5nLcd9UWslAxa2wsl5h+ooutjR35kmySVp+5cB6hA3n6a1kUW6K4
        NU89Wq/IhKb7LSMdAijcXMF4iZTm1eSDNA2P5Ae9u2Ewrx9HpOBZGkcyIzu6IS3t
        VGEtdRoPrHLIDZULFKKOdZknjA4gw2qLfsqkruvYUBKEJCoQehLqU6nSM0XQOsHQ
        ==
X-ME-Sender: <xms:RRPcXRR1j6g53Fkj4_ZskTT1zvck70kRZFZ7VQYslf6BgRa9K3G8fQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudeiuddguddthecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecufghrlhcuvffnffculddvmdenucfjughrpefuvf
    fhfffkgggtgfesthekredttddtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihf
    ohhunhgurghtihhonhdrohhrgheqnecuffhomhgrihhnpehlkhhmlhdrohhrghdpkhgvrh
    hnvghlrdhorhhgpdhqvghmuhdqphhrohhjvggtthdrohhrghenucfkphepkeefrdekiedr
    keelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:RRPcXS_iJrHFStSNvNJuyFK1vC0mmOAlBwuwW5Q_C2IjTxS6x8xqlQ>
    <xmx:RRPcXSZKkys-P3wkF_mamDPSldyhsnY-C8pl-58VlY3ZRhqSJorIrw>
    <xmx:RRPcXTo81ZMGC3dL_fAH_oNzG7pwOnbvdvqVxkG8HgQsaJvpJR0Gbw>
    <xmx:RRPcXSp__l5JwKWDsau2RvNb5XMuj73DqrWF0G4z-5bKRW4xSzDW4Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8172A8005C;
        Mon, 25 Nov 2019 12:45:40 -0500 (EST)
Subject: FAILED: patch "[PATCH] mm/memory_hotplug: don't access uninitialized memmaps in" failed to apply to 4.19-stable tree
To:     david@redhat.com, akpm@linux-foundation.org,
        alexander.h.duyck@linux.intel.com, aneesh.kumar@linux.ibm.com,
        anshuman.khandual@arm.com, benh@kernel.crashing.org,
        borntraeger@de.ibm.com, bp@alien8.de, cai@lca.pw,
        catalin.marinas@arm.com, christophe.leroy@c-s.fr, dalias@libc.org,
        damian.tometzki@gmail.com, dan.j.williams@intel.com,
        dave.hansen@linux.intel.com, fenghua.yu@intel.com,
        gerald.schaefer@de.ibm.com, glider@google.com, gor@linux.ibm.com,
        gregkh@linuxfoundation.org, heiko.carstens@de.ibm.com,
        hpa@zytor.com, ira.weiny@intel.com, jgg@ziepe.ca,
        logang@deltatee.com, luto@kernel.org, mark.rutland@arm.com,
        mgorman@techsingularity.net, mhocko@suse.com, mingo@redhat.com,
        mpe@ellerman.id.au, osalvador@suse.de, pagupta@redhat.com,
        pasha.tatashin@soleen.com, pasic@linux.ibm.com, paulus@samba.org,
        pavel.tatashin@microsoft.com, peterz@infradead.org,
        richard.weiyang@gmail.com, richardw.yang@linux.intel.com,
        robin.murphy@arm.com, rppt@linux.ibm.com, stable@vger.kernel.org,
        steve.capper@arm.com, t-fukasawa@vx.jp.nec.com, tglx@linutronix.de,
        thomas.lendacky@amd.com, tony.luck@intel.com,
        torvalds@linux-foundation.org, vbabka@suse.cz, will@kernel.org,
        willy@infradead.org, yamada.masahiro@socionext.com,
        yaojun8558363@gmail.com, ysato@users.sourceforge.jp,
        yuzhao@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 25 Nov 2019 18:45:39 +0100
Message-ID: <1574703939202113@kroah.com>
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

From 7ce700bf11b5e2cb84e4352bbdf2123a7a239c84 Mon Sep 17 00:00:00 2001
From: David Hildenbrand <david@redhat.com>
Date: Thu, 21 Nov 2019 17:53:56 -0800
Subject: [PATCH] mm/memory_hotplug: don't access uninitialized memmaps in
 shrink_zone_span()

Let's limit shrinking to !ZONE_DEVICE so we can fix the current code.
We should never try to touch the memmap of offline sections where we
could have uninitialized memmaps and could trigger BUGs when calling
page_to_nid() on poisoned pages.

There is no reliable way to distinguish an uninitialized memmap from an
initialized memmap that belongs to ZONE_DEVICE, as we don't have
anything like SECTION_IS_ONLINE we can use similar to
pfn_to_online_section() for !ZONE_DEVICE memory.

E.g., set_zone_contiguous() similarly relies on pfn_to_online_section()
and will therefore never set a ZONE_DEVICE zone consecutive.  Stopping
to shrink the ZONE_DEVICE therefore results in no observable changes,
besides /proc/zoneinfo indicating different boundaries - something we
can totally live with.

Before commit d0dc12e86b31 ("mm/memory_hotplug: optimize memory
hotplug"), the memmap was initialized with 0 and the node with the right
value.  So the zone might be wrong but not garbage.  After that commit,
both the zone and the node will be garbage when touching uninitialized
memmaps.

Toshiki reported a BUG (race between delayed initialization of
ZONE_DEVICE memmaps without holding the memory hotplug lock and
concurrent zone shrinking).

  https://lkml.org/lkml/2019/11/14/1040

"Iteration of create and destroy namespace causes the panic as below:

      kernel BUG at mm/page_alloc.c:535!
      CPU: 7 PID: 2766 Comm: ndctl Not tainted 5.4.0-rc4 #6
      Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.11.0-0-g63451fca13-prebuilt.qemu-project.org 04/01/2014
      RIP: 0010:set_pfnblock_flags_mask+0x95/0xf0
      Call Trace:
       memmap_init_zone_device+0x165/0x17c
       memremap_pages+0x4c1/0x540
       devm_memremap_pages+0x1d/0x60
       pmem_attach_disk+0x16b/0x600 [nd_pmem]
       nvdimm_bus_probe+0x69/0x1c0
       really_probe+0x1c2/0x3e0
       driver_probe_device+0xb4/0x100
       device_driver_attach+0x4f/0x60
       bind_store+0xc9/0x110
       kernfs_fop_write+0x116/0x190
       vfs_write+0xa5/0x1a0
       ksys_write+0x59/0xd0
       do_syscall_64+0x5b/0x180
       entry_SYSCALL_64_after_hwframe+0x44/0xa9

  While creating a namespace and initializing memmap, if you destroy the
  namespace and shrink the zone, it will initialize the memmap outside
  the zone and trigger VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page),
  pfn), page) in set_pfnblock_flags_mask()."

This BUG is also mitigated by this commit, where we for now stop to
shrink the ZONE_DEVICE zone until we can do it in a safe and clean way.

Link: http://lkml.kernel.org/r/20191006085646.5768-5-david@redhat.com
Fixes: f1dd2cd13c4b ("mm, memory_hotplug: do not associate hotadded memory to zones until online")	[visible after d0dc12e86b319]
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reported-by: Toshiki Fukasawa <t-fukasawa@vx.jp.nec.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Damian Tometzki <damian.tometzki@gmail.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Halil Pasic <pasic@linux.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jun Yao <yaojun8558363@gmail.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Pankaj Gupta <pagupta@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pavel Tatashin <pavel.tatashin@microsoft.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qian Cai <cai@lca.pw>
Cc: Rich Felker <dalias@libc.org>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Steve Capper <steve.capper@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Wei Yang <richardw.yang@linux.intel.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <stable@vger.kernel.org>	[4.13+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 3b62a9ff8ea0..f307bd82d750 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -331,7 +331,7 @@ static unsigned long find_smallest_section_pfn(int nid, struct zone *zone,
 				     unsigned long end_pfn)
 {
 	for (; start_pfn < end_pfn; start_pfn += PAGES_PER_SUBSECTION) {
-		if (unlikely(!pfn_valid(start_pfn)))
+		if (unlikely(!pfn_to_online_page(start_pfn)))
 			continue;
 
 		if (unlikely(pfn_to_nid(start_pfn) != nid))
@@ -356,7 +356,7 @@ static unsigned long find_biggest_section_pfn(int nid, struct zone *zone,
 	/* pfn is the end pfn of a memory section. */
 	pfn = end_pfn - 1;
 	for (; pfn >= start_pfn; pfn -= PAGES_PER_SUBSECTION) {
-		if (unlikely(!pfn_valid(pfn)))
+		if (unlikely(!pfn_to_online_page(pfn)))
 			continue;
 
 		if (unlikely(pfn_to_nid(pfn) != nid))
@@ -415,7 +415,7 @@ static void shrink_zone_span(struct zone *zone, unsigned long start_pfn,
 	 */
 	pfn = zone_start_pfn;
 	for (; pfn < zone_end_pfn; pfn += PAGES_PER_SUBSECTION) {
-		if (unlikely(!pfn_valid(pfn)))
+		if (unlikely(!pfn_to_online_page(pfn)))
 			continue;
 
 		if (page_zone(pfn_to_page(pfn)) != zone)
@@ -471,6 +471,16 @@ static void __remove_zone(struct zone *zone, unsigned long start_pfn,
 	struct pglist_data *pgdat = zone->zone_pgdat;
 	unsigned long flags;
 
+#ifdef CONFIG_ZONE_DEVICE
+	/*
+	 * Zone shrinking code cannot properly deal with ZONE_DEVICE. So
+	 * we will not try to shrink the zones - which is okay as
+	 * set_zone_contiguous() cannot deal with ZONE_DEVICE either way.
+	 */
+	if (zone_idx(zone) == ZONE_DEVICE)
+		return;
+#endif
+
 	pgdat_resize_lock(zone->zone_pgdat, &flags);
 	shrink_zone_span(zone, start_pfn, start_pfn + nr_pages);
 	update_pgdat_span(pgdat);


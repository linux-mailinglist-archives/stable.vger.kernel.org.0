Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2295249DCF
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 14:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgHSM2R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 08:28:17 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:52449 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727019AbgHSM2R (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 08:28:17 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id DE115194284A;
        Wed, 19 Aug 2020 08:28:15 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 08:28:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=0h4XmN
        ZrVhfHqK0F9yLkEQwF11EUjbmthxF4gZDkAEs=; b=cqAjPlesnuPJTOwd6od3+2
        q7oTSp6RTo1vHTVEXXnk3+cOnq7Pt40e7WKxJRae8H9t39pP7+jfjoU4pDVdfrBH
        tvWHil4jfVDR9g5e9d5xpHCcVz2shBabWBTVj9nS9QrKiHVKMQdPjoRzewAHykBV
        i73gouXj8vNAblF43MrULbjTX3OcAD9kIks1X7x/GsRU2068ONLsL6+T826jSzRT
        uE4i7KIHM55KBhclJQKuqDzEhheT6FmS/dCOLXChmIVO5kft/DZgMKpQXoBQbh3d
        Haf7xVDsPHRNjxL6YMjL7BQrSH17sU3JUXMPSdKfWGkDm2owJp65mHV54XYgv06g
        ==
X-ME-Sender: <xms:3ho9X4CosKfaXcID8pwBL8ycK8q1cKO6sF8hmZmlJcL-EEKNytr3oQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedgfeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:3ho9X6jakLue9S8T8fq-JMyb_7zNfjXZLg4pOXnTVoX82AcNmI4C6g>
    <xmx:3ho9X7lhYDsgZWVXdR4iPlJXEtAsvH1bRjQECDag360ZZIhVHpSF3g>
    <xmx:3ho9X-w9Ram5W_s3jT2788k_k-GXm10DOQjV2efqSniATlMm-m_cPA>
    <xmx:3xo9X9oplm6AZLgxzma_6ZoRaSp-i3NDorbqD2_OjMwW0lrdUqvmwvaYyCg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1130C328005D;
        Wed, 19 Aug 2020 08:28:14 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mm/memory_hotplug: fix unpaired mem_hotplug_begin/done" failed to apply to 4.19-stable tree
To:     justin.he@arm.com, Jonathan.Cameron@Huawei.com, Kaly.Xin@arm.com,
        akpm@linux-foundation.org, bhe@redhat.com, bp@alien8.de,
        catalin.marinas@arm.com, dalias@libc.org, dan.j.williams@intel.com,
        dave.hansen@linux.intel.com, dave.jiang@intel.com,
        david@redhat.com, fenghua.yu@intel.com, hpa@zytor.com,
        hslester96@gmail.com, logang@deltatee.com, luto@kernel.org,
        masahiroy@kernel.org, mhocko@suse.com, mingo@redhat.com,
        peterz@infradead.org, rppt@linux.ibm.com, stable@vger.kernel.org,
        tglx@linutronix.de, tony.luck@intel.com,
        torvalds@linux-foundation.org, vishal.l.verma@intel.com,
        will@kernel.org, ysato@users.sourceforge.jp
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 14:28:37 +0200
Message-ID: <1597840117224138@kroah.com>
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

From b4223a510e2ab1bf0f971d50af7c1431014b25ad Mon Sep 17 00:00:00 2001
From: Jia He <justin.he@arm.com>
Date: Tue, 11 Aug 2020 18:32:20 -0700
Subject: [PATCH] mm/memory_hotplug: fix unpaired mem_hotplug_begin/done

When check_memblock_offlined_cb() returns failed rc(e.g. the memblock is
online at that time), mem_hotplug_begin/done is unpaired in such case.

Therefore a warning:
 Call Trace:
  percpu_up_write+0x33/0x40
  try_remove_memory+0x66/0x120
  ? _cond_resched+0x19/0x30
  remove_memory+0x2b/0x40
  dev_dax_kmem_remove+0x36/0x72 [kmem]
  device_release_driver_internal+0xf0/0x1c0
  device_release_driver+0x12/0x20
  bus_remove_device+0xe1/0x150
  device_del+0x17b/0x3e0
  unregister_dev_dax+0x29/0x60
  devm_action_release+0x15/0x20
  release_nodes+0x19a/0x1e0
  devres_release_all+0x3f/0x50
  device_release_driver_internal+0x100/0x1c0
  driver_detach+0x4c/0x8f
  bus_remove_driver+0x5c/0xd0
  driver_unregister+0x31/0x50
  dax_pmem_exit+0x10/0xfe0 [dax_pmem]

Fixes: f1037ec0cc8a ("mm/memory_hotplug: fix remove_memory() lockdep splat")
Signed-off-by: Jia He <justin.he@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Cc: <stable@vger.kernel.org>	[5.6+]
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chuhong Yuan <hslester96@gmail.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
Cc: Kaly Xin <Kaly.Xin@arm.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rich Felker <dalias@libc.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Link: http://lkml.kernel.org/r/20200710031619.18762-3-justin.he@arm.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 6289a909ea36..ce3d858319bd 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1757,7 +1757,7 @@ static int __ref try_remove_memory(int nid, u64 start, u64 size)
 	 */
 	rc = walk_memory_blocks(start, size, NULL, check_memblock_offlined_cb);
 	if (rc)
-		goto done;
+		return rc;
 
 	/* remove memmap entry */
 	firmware_map_remove(start, start + size, "System RAM");
@@ -1781,9 +1781,8 @@ static int __ref try_remove_memory(int nid, u64 start, u64 size)
 
 	try_offline_node(nid);
 
-done:
 	mem_hotplug_done();
-	return rc;
+	return 0;
 }
 
 /**


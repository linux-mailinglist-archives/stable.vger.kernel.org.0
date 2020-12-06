Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64E4C2D0649
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 18:26:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgLFRZA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 12:25:00 -0500
Received: from wnew4-smtp.messagingengine.com ([64.147.123.18]:57659 "EHLO
        wnew4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726043AbgLFRY7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Dec 2020 12:24:59 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.west.internal (Postfix) with ESMTP id A2CAB837;
        Sun,  6 Dec 2020 12:24:12 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 06 Dec 2020 12:24:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=JItcwb
        qleisdzutjtb6IffdEYYvbyCRFRbpwZ3ZqjOk=; b=c+VWyhEmYg/NEIse3CgHCB
        hzKRwBBZxsq8QvB9uulVUVTBEp6AzNDBvkDABqbaqSTwSlI310tiSnSYpR3tsWQy
        l9K/Id6W7nC/VR5tjG15yotcpk3oU7avgHuoP9T9R5TreLBvmjzs1CZodPAwa79G
        SPfjf0eIZ2UD5BFitmIl5yt9iNlvSekmwiJ6DHVMIjvIkeaz4o4nhNg+ks6aHZhT
        6MMdq5l0kflG2xVXpotAr7dD2hVSduWy5aJnObLEDdnl5diAzZecp/krH6MF9+kq
        JQ7pHyi3zJQaJzm32aXz7mjVs/Bp3ZxkXmfmMYcR3zIQy8POK9CD2/LH+x+POjlQ
        ==
X-ME-Sender: <xms:uRPNX7U6w-bHOtfmjgHQwGZT9pP7n8E-EIsggLLqGJ0icKd8d9r2KA>
    <xme:uRPNXzm5sATZO6h6F2BbJe6BIq60U9Bagi8NhkhE1cX9IJnk4G_234PwabaWy6LkM
    SFwMwhZCfG3GQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejvddguddtudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvffufffkofggtghogfesthekredtredtjeenucfhrhhomhepofgrrhgv
    khcuofgrrhgtiiihkhhofihskhhiqdfikphrvggtkhhiuceomhgrrhhmrghrvghksehinh
    hvihhsihgslhgvthhhihhnghhslhgrsgdrtghomheqnecuggftrfgrthhtvghrnhephefh
    feetueelvddvtedttdevieeluedtvedtfeejieelhedutdeuheduieejgfegnecuffhomh
    grihhnpehkvghrnhgvlhdrohhrghenucfkphepledurdeigedrudejtddrkeelnecuvehl
    uhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepmhgrrhhmrghrvg
    hksehinhhvihhsihgslhgvthhhihhnghhslhgrsgdrtghomh
X-ME-Proxy: <xmx:uRPNX3ZrlOs3WgwCcd3ozP2QYvO35hombQMDFhsnUpx3ZmcZn5yT7w>
    <xmx:uRPNX2UxaVDfZeXEtMGqgJ-42RexzbLXGvjua9CHGBgixkAd5Pxjjw>
    <xmx:uRPNX1mKihq3nu_4A5bJfRz3II3CLERfZ_1yebF43JFPED1pDmyMSA>
    <xmx:vBPNX7eIkEMfUc5lvOk3n_QeNAgXlimtA_Wv4u50zDK_al08hxCUGYFfpZo>
Received: from localhost.localdomain (ip5b40aa59.dynamic.kabel-deutschland.de [91.64.170.89])
        by mail.messagingengine.com (Postfix) with ESMTPA id 81FE2108005B;
        Sun,  6 Dec 2020 12:24:07 -0500 (EST)
From:   =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>
To:     xen-devel@lists.xenproject.org
Cc:     =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>, stable@vger.kernel.org,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Simon Leiner <simon@leiner.me>,
        Yan Yankovskyi <yyankovskyi@gmail.com>,
        Roger Pau Monne <roger.pau@citrix.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-kernel@vger.kernel.org (open list),
        dri-devel@lists.freedesktop.org (open list:DRM DRIVERS FOR XEN)
Subject: [PATCH] Revert "xen: add helpers to allocate unpopulated memory"
Date:   Sun,  6 Dec 2020 18:22:36 +0100
Message-Id: <20201206172242.1249689-1-marmarek@invisiblethingslab.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Organization: Invisible Things Lab
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 9e2369c06c8a181478039258a4598c1ddd2cadfa.

On a Xen PV dom0, with NVME disk, this makes the dom0 crash when starting
a domain. This looks like some bad interaction between xen-blkback and
NVME driver, both using ZONE_DEVICE. Since the author is on leave now,
revert the change until proper solution is developed.

The specific crash message is:

    general protection fault, probably for non-canonical address 0xdead000000000100: 0000 [#1] SMP NOPTI
    CPU: 1 PID: 134 Comm: kworker/u12:2 Not tainted 5.9.9-1.qubes.x86_64 #1
    Hardware name: LENOVO 20M9CTO1WW/20M9CTO1WW, BIOS N2CET50W (1.33 ) 01/15/2020
    Workqueue: dm-thin do_worker [dm_thin_pool]
    RIP: e030:nvme_map_data+0x300/0x3a0 [nvme]
    Code: b8 fe ff ff e9 a8 fe ff ff 4c 8b 56 68 8b 5e 70 8b 76 74 49 8b 02 48 c1 e8 33 83 e0 07 83 f8 04 0f 85 f2 fe ff ff 49 8b 42 08 <83> b8 d0 00 00 00 04 0f 85 e1 fe ff ff e9 38 fd ff ff 8b 55 70 be
    RSP: e02b:ffffc900010e7ad8 EFLAGS: 00010246
    RAX: dead000000000100 RBX: 0000000000001000 RCX: ffff8881a58f5000
    RDX: 0000000000001000 RSI: 0000000000000000 RDI: ffff8881a679e000
    RBP: ffff8881a5ef4c80 R08: ffff8881a5ef4c80 R09: 0000000000000002
    R10: ffffea0003dfff40 R11: 0000000000000008 R12: ffff8881a679e000
    R13: ffffc900010e7b20 R14: ffff8881a70b5980 R15: ffff8881a679e000
    FS:  0000000000000000(0000) GS:ffff8881b5440000(0000) knlGS:0000000000000000
    CS:  e030 DS: 0000 ES: 0000 CR0: 0000000080050033
    CR2: 0000000001d64408 CR3: 00000001aa2c0000 CR4: 0000000000050660
    Call Trace:
     nvme_queue_rq+0xa7/0x1a0 [nvme]
     __blk_mq_try_issue_directly+0x11d/0x1e0
     ? add_wait_queue_exclusive+0x70/0x70
     blk_mq_try_issue_directly+0x35/0xc0l[
     blk_mq_submit_bio+0x58f/0x660
     __submit_bio_noacct+0x300/0x330
     process_shared_bio+0x126/0x1b0 [dm_thin_pool]
     process_cell+0x226/0x280 [dm_thin_pool]
     process_thin_deferred_cells+0x185/0x320 [dm_thin_pool]
     process_deferred_bios+0xa4/0x2a0 [dm_thin_pool]UX
     do_worker+0xcc/0x130 [dm_thin_pool]
     process_one_work+0x1b4/0x370
     worker_thread+0x4c/0x310
     ? process_one_work+0x370/0x370
     kthread+0x11b/0x140
     ? __kthread_bind_mask+0x60/0x60<
     ret_from_fork+0x22/0x30
    Modules linked in: loop snd_seq_dummy snd_hrtimer nf_tables nfnetlink vfat fat snd_sof_pci snd_sof_intel_byt snd_sof_intel_ipc snd_sof_intel_hda_common snd_soc_hdac_hda snd_sof_xtensa_dsp snd_sof_intel_hda snd_sof snd_soc_skl snd_soc_sst_
    ipc snd_soc_sst_dsp snd_hda_ext_core snd_soc_acpi_intel_match snd_soc_acpi snd_soc_core snd_compress ac97_bus snd_pcm_dmaengine elan_i2c snd_hda_codec_hdmi mei_hdcp iTCO_wdt intel_powerclamp intel_pmc_bxt ee1004 intel_rapl_msr iTCO_vendor
    _support joydev pcspkr intel_wmi_thunderbolt wmi_bmof thunderbolt ucsi_acpi idma64 typec_ucsi snd_hda_codec_realtek typec snd_hda_codec_generic snd_hda_intel snd_intel_dspcfg snd_hda_codec thinkpad_acpi snd_hda_core ledtrig_audio int3403_
    thermal snd_hwdep snd_seq snd_seq_device snd_pcm iwlwifi snd_timer processor_thermal_device mei_me cfg80211 intel_rapl_common snd e1000e mei int3400_thermal int340x_thermal_zone i2c_i801 acpi_thermal_rel soundcore intel_soc_dts_iosf i2c_s
    mbus rfkill intel_pch_thermal xenfs
     ip_tables dm_thin_pool dm_persistent_data dm_bio_prison dm_crypt nouveau rtsx_pci_sdmmc mmc_core mxm_wmi crct10dif_pclmul ttm crc32_pclmul crc32c_intel i915 ghash_clmulni_intel i2c_algo_bit serio_raw nvme drm_kms_helper cec xhci_pci nvme
    _core rtsx_pci xhci_pci_renesas drm xhci_hcd wmi video pinctrl_cannonlake pinctrl_intel xen_privcmd xen_pciback xen_blkback xen_gntalloc xen_gntdev xen_evtchn uinput
    ---[ end trace f8d47e4aa6724df4 ]---
    RIP: e030:nvme_map_data+0x300/0x3a0 [nvme]
    Code: b8 fe ff ff e9 a8 fe ff ff 4c 8b 56 68 8b 5e 70 8b 76 74 49 8b 02 48 c1 e8 33 83 e0 07 83 f8 04 0f 85 f2 fe ff ff 49 8b 42 08 <83> b8 d0 00 00 00 04 0f 85 e1 fe ff ff e9 38 fd ff ff 8b 55 70 be
    RSP: e02b:ffffc900010e7ad8 EFLAGS: 00010246
    RAX: dead000000000100 RBX: 0000000000001000 RCX: ffff8881a58f5000
    RDX: 0000000000001000 RSI: 0000000000000000 RDI: ffff8881a679e000
    RBP: ffff8881a5ef4c80 R08: ffff8881a5ef4c80 R09: 0000000000000002
    R10: ffffea0003dfff40 R11: 0000000000000008 R12: ffff8881a679e000
    R13: ffffc900010e7b20 R14: ffff8881a70b5980 R15: ffff8881a679e000
    FS:  0000000000000000(0000) GS:ffff8881b5440000(0000) knlGS:0000000000000000
    CS:  e030 DS: 0000 ES: 0000 CR0: 0000000080050033
    CR2: 0000000001d64408 CR3: 00000001aa2c0000 CR4: 0000000000050660
    Kernel panic - not syncing: Fatal exception
    Kernel Offset: disabled

Discussion at https://lore.kernel.org/xen-devel/20201205082839.ts3ju6yta46cgwjn@Air-de-Roger/T

Cc: stable@vger.kernel.org #v5.9+
(for 5.9 it's easier to revert the original commit directly)
Signed-off-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
---
 drivers/gpu/drm/xen/xen_drm_front_gem.c |   9 +-
 drivers/xen/Kconfig                     |  10 --
 drivers/xen/Makefile                    |   1 -
 drivers/xen/balloon.c                   |   4 +-
 drivers/xen/grant-table.c               |   4 +-
 drivers/xen/privcmd.c                   |   4 +-
 drivers/xen/unpopulated-alloc.c         | 200 ------------------------
 drivers/xen/xenbus/xenbus_client.c      |   6 +-
 drivers/xen/xlate_mmu.c                 |   4 +-
 include/xen/xen.h                       |   9 --
 10 files changed, 15 insertions(+), 236 deletions(-)
 delete mode 100644 drivers/xen/unpopulated-alloc.c

diff --git a/drivers/gpu/drm/xen/xen_drm_front_gem.c b/drivers/gpu/drm/xen/xen_drm_front_gem.c
index 2f464ef2d53e..90945344daae 100644
--- a/drivers/gpu/drm/xen/xen_drm_front_gem.c
+++ b/drivers/gpu/drm/xen/xen_drm_front_gem.c
@@ -18,7 +18,6 @@
 #include <drm/drm_probe_helper.h>
 
 #include <xen/balloon.h>
-#include <xen/xen.h>
 
 #include "xen_drm_front.h"
 #include "xen_drm_front_gem.h"
@@ -100,8 +99,8 @@ static struct xen_gem_object *gem_create(struct drm_device *dev, size_t size)
 		 * allocate ballooned pages which will be used to map
 		 * grant references provided by the backend
 		 */
-		ret = xen_alloc_unpopulated_pages(xen_obj->num_pages,
-					          xen_obj->pages);
+		ret = alloc_xenballooned_pages(xen_obj->num_pages,
+					       xen_obj->pages);
 		if (ret < 0) {
 			DRM_ERROR("Cannot allocate %zu ballooned pages: %d\n",
 				  xen_obj->num_pages, ret);
@@ -153,8 +152,8 @@ void xen_drm_front_gem_free_object_unlocked(struct drm_gem_object *gem_obj)
 	} else {
 		if (xen_obj->pages) {
 			if (xen_obj->be_alloc) {
-				xen_free_unpopulated_pages(xen_obj->num_pages,
-							   xen_obj->pages);
+				free_xenballooned_pages(xen_obj->num_pages,
+							xen_obj->pages);
 				gem_free_pages_array(xen_obj);
 			} else {
 				drm_gem_put_pages(&xen_obj->base,
diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index 41645fe6ad48..ea6c1e7e3e42 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -325,14 +325,4 @@ config XEN_HAVE_VPMU
 config XEN_FRONT_PGDIR_SHBUF
 	tristate
 
-config XEN_UNPOPULATED_ALLOC
-	bool "Use unpopulated memory ranges for guest mappings"
-	depends on X86 && ZONE_DEVICE
-	default XEN_BACKEND || XEN_GNTDEV || XEN_DOM0
-	help
-	  Use unpopulated memory ranges in order to create mappings for guest
-	  memory regions, including grant maps and foreign pages. This avoids
-	  having to balloon out RAM regions in order to obtain physical memory
-	  space to create such mappings.
-
 endmenu
diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index babdca808861..c25c9a699b48 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -41,4 +41,3 @@ xen-gntdev-$(CONFIG_XEN_GNTDEV_DMABUF)	+= gntdev-dmabuf.o
 xen-gntalloc-y				:= gntalloc.o
 xen-privcmd-y				:= privcmd.o privcmd-buf.o
 obj-$(CONFIG_XEN_FRONT_PGDIR_SHBUF)	+= xen-front-pgdir-shbuf.o
-obj-$(CONFIG_XEN_UNPOPULATED_ALLOC)	+= unpopulated-alloc.o
diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index b57b2067ecbf..12d3a95bfdb4 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -653,7 +653,7 @@ void free_xenballooned_pages(int nr_pages, struct page **pages)
 }
 EXPORT_SYMBOL(free_xenballooned_pages);
 
-#if defined(CONFIG_XEN_PV) && !defined(CONFIG_XEN_UNPOPULATED_ALLOC)
+#ifdef CONFIG_XEN_PV
 static void __init balloon_add_region(unsigned long start_pfn,
 				      unsigned long pages)
 {
@@ -707,7 +707,7 @@ static int __init balloon_init(void)
 	register_sysctl_table(xen_root);
 #endif
 
-#if defined(CONFIG_XEN_PV) && !defined(CONFIG_XEN_UNPOPULATED_ALLOC)
+#ifdef CONFIG_XEN_PV
 	{
 		int i;
 
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 523dcdf39cc9..8d06bf1cc347 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -801,7 +801,7 @@ int gnttab_alloc_pages(int nr_pages, struct page **pages)
 {
 	int ret;
 
-	ret = xen_alloc_unpopulated_pages(nr_pages, pages);
+	ret = alloc_xenballooned_pages(nr_pages, pages);
 	if (ret < 0)
 		return ret;
 
@@ -836,7 +836,7 @@ EXPORT_SYMBOL_GPL(gnttab_pages_clear_private);
 void gnttab_free_pages(int nr_pages, struct page **pages)
 {
 	gnttab_pages_clear_private(nr_pages, pages);
-	xen_free_unpopulated_pages(nr_pages, pages);
+	free_xenballooned_pages(nr_pages, pages);
 }
 EXPORT_SYMBOL_GPL(gnttab_free_pages);
 
diff --git a/drivers/xen/privcmd.c b/drivers/xen/privcmd.c
index b0c73c58f987..63abe6c3642b 100644
--- a/drivers/xen/privcmd.c
+++ b/drivers/xen/privcmd.c
@@ -424,7 +424,7 @@ static int alloc_empty_pages(struct vm_area_struct *vma, int numpgs)
 	if (pages == NULL)
 		return -ENOMEM;
 
-	rc = xen_alloc_unpopulated_pages(numpgs, pages);
+	rc = alloc_xenballooned_pages(numpgs, pages);
 	if (rc != 0) {
 		pr_warn("%s Could not alloc %d pfns rc:%d\n", __func__,
 			numpgs, rc);
@@ -895,7 +895,7 @@ static void privcmd_close(struct vm_area_struct *vma)
 
 	rc = xen_unmap_domain_gfn_range(vma, numgfns, pages);
 	if (rc == 0)
-		xen_free_unpopulated_pages(numpgs, pages);
+		free_xenballooned_pages(numpgs, pages);
 	else
 		pr_crit("unable to unmap MFN range: leaking %d pages. rc=%d\n",
 			numpgs, rc);
diff --git a/drivers/xen/unpopulated-alloc.c b/drivers/xen/unpopulated-alloc.c
deleted file mode 100644
index 8c512ea550bb..000000000000
--- a/drivers/xen/unpopulated-alloc.c
+++ /dev/null
@@ -1,200 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-#include <linux/errno.h>
-#include <linux/gfp.h>
-#include <linux/kernel.h>
-#include <linux/mm.h>
-#include <linux/memremap.h>
-#include <linux/slab.h>
-
-#include <asm/page.h>
-
-#include <xen/page.h>
-#include <xen/xen.h>
-
-static DEFINE_MUTEX(list_lock);
-static LIST_HEAD(page_list);
-static unsigned int list_count;
-
-static int fill_list(unsigned int nr_pages)
-{
-	struct dev_pagemap *pgmap;
-	struct resource *res;
-	void *vaddr;
-	unsigned int i, alloc_pages = round_up(nr_pages, PAGES_PER_SECTION);
-	int ret = -ENOMEM;
-
-	res = kzalloc(sizeof(*res), GFP_KERNEL);
-	if (!res)
-		return -ENOMEM;
-
-	pgmap = kzalloc(sizeof(*pgmap), GFP_KERNEL);
-	if (!pgmap)
-		goto err_pgmap;
-
-	pgmap->type = MEMORY_DEVICE_GENERIC;
-	res->name = "Xen scratch";
-	res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
-
-	ret = allocate_resource(&iomem_resource, res,
-				alloc_pages * PAGE_SIZE, 0, -1,
-				PAGES_PER_SECTION * PAGE_SIZE, NULL, NULL);
-	if (ret < 0) {
-		pr_err("Cannot allocate new IOMEM resource\n");
-		goto err_resource;
-	}
-
-	pgmap->range = (struct range) {
-		.start = res->start,
-		.end = res->end,
-	};
-	pgmap->nr_range = 1;
-	pgmap->owner = res;
-
-#ifdef CONFIG_XEN_HAVE_PVMMU
-        /*
-         * memremap will build page tables for the new memory so
-         * the p2m must contain invalid entries so the correct
-         * non-present PTEs will be written.
-         *
-         * If a failure occurs, the original (identity) p2m entries
-         * are not restored since this region is now known not to
-         * conflict with any devices.
-         */
-	if (!xen_feature(XENFEAT_auto_translated_physmap)) {
-		xen_pfn_t pfn = PFN_DOWN(res->start);
-
-		for (i = 0; i < alloc_pages; i++) {
-			if (!set_phys_to_machine(pfn + i, INVALID_P2M_ENTRY)) {
-				pr_warn("set_phys_to_machine() failed, no memory added\n");
-				ret = -ENOMEM;
-				goto err_memremap;
-			}
-                }
-	}
-#endif
-
-	vaddr = memremap_pages(pgmap, NUMA_NO_NODE);
-	if (IS_ERR(vaddr)) {
-		pr_err("Cannot remap memory range\n");
-		ret = PTR_ERR(vaddr);
-		goto err_memremap;
-	}
-
-	for (i = 0; i < alloc_pages; i++) {
-		struct page *pg = virt_to_page(vaddr + PAGE_SIZE * i);
-
-		BUG_ON(!virt_addr_valid(vaddr + PAGE_SIZE * i));
-		list_add(&pg->lru, &page_list);
-		list_count++;
-	}
-
-	return 0;
-
-err_memremap:
-	release_resource(res);
-err_resource:
-	kfree(pgmap);
-err_pgmap:
-	kfree(res);
-	return ret;
-}
-
-/**
- * xen_alloc_unpopulated_pages - alloc unpopulated pages
- * @nr_pages: Number of pages
- * @pages: pages returned
- * @return 0 on success, error otherwise
- */
-int xen_alloc_unpopulated_pages(unsigned int nr_pages, struct page **pages)
-{
-	unsigned int i;
-	int ret = 0;
-
-	mutex_lock(&list_lock);
-	if (list_count < nr_pages) {
-		ret = fill_list(nr_pages - list_count);
-		if (ret)
-			goto out;
-	}
-
-	for (i = 0; i < nr_pages; i++) {
-		struct page *pg = list_first_entry_or_null(&page_list,
-							   struct page,
-							   lru);
-
-		BUG_ON(!pg);
-		list_del(&pg->lru);
-		list_count--;
-		pages[i] = pg;
-
-#ifdef CONFIG_XEN_HAVE_PVMMU
-		if (!xen_feature(XENFEAT_auto_translated_physmap)) {
-			ret = xen_alloc_p2m_entry(page_to_pfn(pg));
-			if (ret < 0) {
-				unsigned int j;
-
-				for (j = 0; j <= i; j++) {
-					list_add(&pages[j]->lru, &page_list);
-					list_count++;
-				}
-				goto out;
-			}
-		}
-#endif
-	}
-
-out:
-	mutex_unlock(&list_lock);
-	return ret;
-}
-EXPORT_SYMBOL(xen_alloc_unpopulated_pages);
-
-/**
- * xen_free_unpopulated_pages - return unpopulated pages
- * @nr_pages: Number of pages
- * @pages: pages to return
- */
-void xen_free_unpopulated_pages(unsigned int nr_pages, struct page **pages)
-{
-	unsigned int i;
-
-	mutex_lock(&list_lock);
-	for (i = 0; i < nr_pages; i++) {
-		list_add(&pages[i]->lru, &page_list);
-		list_count++;
-	}
-	mutex_unlock(&list_lock);
-}
-EXPORT_SYMBOL(xen_free_unpopulated_pages);
-
-#ifdef CONFIG_XEN_PV
-static int __init init(void)
-{
-	unsigned int i;
-
-	if (!xen_domain())
-		return -ENODEV;
-
-	if (!xen_pv_domain())
-		return 0;
-
-	/*
-	 * Initialize with pages from the extra memory regions (see
-	 * arch/x86/xen/setup.c).
-	 */
-	for (i = 0; i < XEN_EXTRA_MEM_MAX_REGIONS; i++) {
-		unsigned int j;
-
-		for (j = 0; j < xen_extra_mem[i].n_pfns; j++) {
-			struct page *pg =
-				pfn_to_page(xen_extra_mem[i].start_pfn + j);
-
-			list_add(&pg->lru, &page_list);
-			list_count++;
-		}
-	}
-
-	return 0;
-}
-subsys_initcall(init);
-#endif
diff --git a/drivers/xen/xenbus/xenbus_client.c b/drivers/xen/xenbus/xenbus_client.c
index fd80e318b99c..ef8b6ea8ecca 100644
--- a/drivers/xen/xenbus/xenbus_client.c
+++ b/drivers/xen/xenbus/xenbus_client.c
@@ -618,7 +618,7 @@ static int xenbus_map_ring_hvm(struct xenbus_device *dev,
 	bool leaked = false;
 	unsigned int nr_pages = XENBUS_PAGES(nr_grefs);
 
-	err = xen_alloc_unpopulated_pages(nr_pages, node->hvm.pages);
+	err = alloc_xenballooned_pages(nr_pages, node->hvm.pages);
 	if (err)
 		goto out_err;
 
@@ -659,7 +659,7 @@ static int xenbus_map_ring_hvm(struct xenbus_device *dev,
 			 addr, nr_pages);
  out_free_ballooned_pages:
 	if (!leaked)
-		xen_free_unpopulated_pages(nr_pages, node->hvm.pages);
+		free_xenballooned_pages(nr_pages, node->hvm.pages);
  out_err:
 	return err;
 }
@@ -860,7 +860,7 @@ static int xenbus_unmap_ring_hvm(struct xenbus_device *dev, void *vaddr)
 			       info.addrs);
 	if (!rv) {
 		vunmap(vaddr);
-		xen_free_unpopulated_pages(nr_pages, node->hvm.pages);
+		free_xenballooned_pages(nr_pages, node->hvm.pages);
 	}
 	else
 		WARN(1, "Leaking %p, size %u page(s)\n", vaddr, nr_pages);
diff --git a/drivers/xen/xlate_mmu.c b/drivers/xen/xlate_mmu.c
index 34742c6e189e..7b1077f0abcb 100644
--- a/drivers/xen/xlate_mmu.c
+++ b/drivers/xen/xlate_mmu.c
@@ -232,7 +232,7 @@ int __init xen_xlate_map_ballooned_pages(xen_pfn_t **gfns, void **virt,
 		kfree(pages);
 		return -ENOMEM;
 	}
-	rc = xen_alloc_unpopulated_pages(nr_pages, pages);
+	rc = alloc_xenballooned_pages(nr_pages, pages);
 	if (rc) {
 		pr_warn("%s Couldn't balloon alloc %ld pages rc:%d\n", __func__,
 			nr_pages, rc);
@@ -249,7 +249,7 @@ int __init xen_xlate_map_ballooned_pages(xen_pfn_t **gfns, void **virt,
 	if (!vaddr) {
 		pr_warn("%s Couldn't map %ld pages rc:%d\n", __func__,
 			nr_pages, rc);
-		xen_free_unpopulated_pages(nr_pages, pages);
+		free_xenballooned_pages(nr_pages, pages);
 		kfree(pages);
 		kfree(pfns);
 		return -ENOMEM;
diff --git a/include/xen/xen.h b/include/xen/xen.h
index 43efba045acc..19a72f591e2b 100644
--- a/include/xen/xen.h
+++ b/include/xen/xen.h
@@ -52,13 +52,4 @@ bool xen_biovec_phys_mergeable(const struct bio_vec *vec1,
 extern u64 xen_saved_max_mem_size;
 #endif
 
-#ifdef CONFIG_XEN_UNPOPULATED_ALLOC
-int xen_alloc_unpopulated_pages(unsigned int nr_pages, struct page **pages);
-void xen_free_unpopulated_pages(unsigned int nr_pages, struct page **pages);
-#else
-#define xen_alloc_unpopulated_pages alloc_xenballooned_pages
-#define xen_free_unpopulated_pages free_xenballooned_pages
-#include <xen/balloon.h>
-#endif
-
 #endif	/* _XEN_XEN_H */
-- 
2.25.4


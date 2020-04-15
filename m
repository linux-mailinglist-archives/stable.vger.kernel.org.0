Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E32C31A9C57
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 13:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393930AbgDOLdP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 07:33:15 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:32861 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2393941AbgDOLdC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 07:33:02 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id EDE735C015B;
        Wed, 15 Apr 2020 07:33:01 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 15 Apr 2020 07:33:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=4mV2qH
        W0EKuS9uKX4scNXxj8/lnSXqSwN1YSsMDjJ+0=; b=kWrmadoeak6mQRQr0Af8IY
        FAyJ4oQtYSd7tQEVXATuLGDhRSsWHU02ctH7eQeMRcepTgLrfRd1ob4kjRhWrHqw
        VafDa2pyCFSXjrGahCF7QVQPlNcEnvVYsjpTM1Apw8Ppo55G1KV7ZH248vtdUaxE
        AM7yG21kj8yjsu6OlTtabWkdlwuHHMrEzh036NPes6TXJGv6VnA+F12VjR1eThiG
        /4XcuRMlicJ9myZMH94BAuLdWsBzAVAmslGkhJJGXj7k7SWanW1Q8jWGxDqlP0sl
        DZJGsia9uPQe9BnZvxzD6zEYAUARUatZNdmYTxJvltVTc8kIijVANdhDgOkwn2oQ
        ==
X-ME-Sender: <xms:7fCWXneLwxm1b1dvHeDaDz3SgnYKYeluVPc5qRKW7dFNaOdsRBqR5g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfeefgdefudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhrghenucfkphepkeefrdekie
    drkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhf
    rhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:7fCWXpDrCRi7gpU_dyBQkutENUSZX54oW1teqZmKFazUmYQmMCHJFA>
    <xmx:7fCWXm_QA0o1Wn_WIoJeOXWGrey76J04qSQubhYIy7eaxfStR2fKEQ>
    <xmx:7fCWXlp-Yu1uqEgperHGypAYk5tVPI-2Tmp-l87zbu-YRVSO8LT-BA>
    <xmx:7fCWXuxZRLafznfGvYLg89s0LiM8AZsBl8WeAbqmiz7G0CTRCJivuQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 875033060062;
        Wed, 15 Apr 2020 07:33:01 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm: Remove PageReserved manipulation from drm_pci_alloc" failed to apply to 4.9-stable tree
To:     chris@chris-wilson.co.uk, alexander.deucher@amd.com,
        kirill.shutemov@linux.intel.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Apr 2020 13:32:51 +0200
Message-ID: <158695037110117@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ea36ec8623f56791c6ff6738d0509b7920f85220 Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Sun, 2 Feb 2020 17:16:31 +0000
Subject: [PATCH] drm: Remove PageReserved manipulation from drm_pci_alloc

drm_pci_alloc/drm_pci_free are very thin wrappers around the core dma
facilities, and we have no special reason within the drm layer to behave
differently. In particular, since

commit de09d31dd38a50fdce106c15abd68432eebbd014
Author: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Date:   Fri Jan 15 16:51:42 2016 -0800

    page-flags: define PG_reserved behavior on compound pages

    As far as I can see there's no users of PG_reserved on compound pages.
    Let's use PF_NO_COMPOUND here.

it has been illegal to combine GFP_COMP with SetPageReserved, so lets
stop doing both and leave the dma layer to its own devices.

Reported-by: Taketo Kabe
Bug: https://gitlab.freedesktop.org/drm/intel/issues/1027
Fixes: de09d31dd38a ("page-flags: define PG_reserved behavior on compound pages")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: <stable@vger.kernel.org> # v4.5+
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200202171635.4039044-1-chris@chris-wilson.co.uk

diff --git a/drivers/gpu/drm/drm_pci.c b/drivers/gpu/drm/drm_pci.c
index f2e43d341980..d16dac4325f9 100644
--- a/drivers/gpu/drm/drm_pci.c
+++ b/drivers/gpu/drm/drm_pci.c
@@ -51,8 +51,6 @@
 drm_dma_handle_t *drm_pci_alloc(struct drm_device * dev, size_t size, size_t align)
 {
 	drm_dma_handle_t *dmah;
-	unsigned long addr;
-	size_t sz;
 
 	/* pci_alloc_consistent only guarantees alignment to the smallest
 	 * PAGE_SIZE order which is greater than or equal to the requested size.
@@ -68,20 +66,13 @@ drm_dma_handle_t *drm_pci_alloc(struct drm_device * dev, size_t size, size_t ali
 	dmah->size = size;
 	dmah->vaddr = dma_alloc_coherent(&dev->pdev->dev, size,
 					 &dmah->busaddr,
-					 GFP_KERNEL | __GFP_COMP);
+					 GFP_KERNEL);
 
 	if (dmah->vaddr == NULL) {
 		kfree(dmah);
 		return NULL;
 	}
 
-	/* XXX - Is virt_to_page() legal for consistent mem? */
-	/* Reserve */
-	for (addr = (unsigned long)dmah->vaddr, sz = size;
-	     sz > 0; addr += PAGE_SIZE, sz -= PAGE_SIZE) {
-		SetPageReserved(virt_to_page((void *)addr));
-	}
-
 	return dmah;
 }
 
@@ -94,19 +85,9 @@ EXPORT_SYMBOL(drm_pci_alloc);
  */
 void __drm_legacy_pci_free(struct drm_device * dev, drm_dma_handle_t * dmah)
 {
-	unsigned long addr;
-	size_t sz;
-
-	if (dmah->vaddr) {
-		/* XXX - Is virt_to_page() legal for consistent mem? */
-		/* Unreserve */
-		for (addr = (unsigned long)dmah->vaddr, sz = dmah->size;
-		     sz > 0; addr += PAGE_SIZE, sz -= PAGE_SIZE) {
-			ClearPageReserved(virt_to_page((void *)addr));
-		}
+	if (dmah->vaddr)
 		dma_free_coherent(&dev->pdev->dev, dmah->size, dmah->vaddr,
 				  dmah->busaddr);
-	}
 }
 
 /**


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1D921A9C55
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 13:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393944AbgDOLdE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 07:33:04 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:48893 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404177AbgDOLdB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 07:33:01 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 513195C0153;
        Wed, 15 Apr 2020 07:33:00 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 15 Apr 2020 07:33:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=s4psJ+
        Tf+4oQzYGFrwQ4vY6zbnsuNIv7rx38Ig6zJ+4=; b=4bcBe4Ewwql0yl4ho7acES
        MZ6oXLwCeRcU8FxRoUrML5ggn1jUcvgnz7d2VNB+zGAQmsDXeePoP/vUnwk6eH/g
        dxL8W1zNtv+dD9QW6A407nx34q7ehYSVNiNT9ljvsrJorrI40kMXDI9jlF92COKw
        680IDJXLsnlWrZEFpA9Gb759bAAuLKmSXw25XSb81t92TG9oNzClEaQwenU5XUwS
        +u1p3Rh8/6EI4Aumf7z73nagkXKgtM8WLRBvLLq7/jvaZqNzmaxP0GRXFhR3Fd3a
        WSuJblKzNUCTlVkQjM/xX4Bjcd+juBAY5l405cQ5r1L8AHcopstdtfRVlRWOI8Uw
        ==
X-ME-Sender: <xms:7PCWXu_9lKHAZXNpDfAGSND-maJ1PUSlqzjPPixcnVHCthtZEdsQ-g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfeefgdefudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhrghenucfkphepkeefrdekie
    drkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhf
    rhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:7PCWXlBZyvpo4mpQiVHr_yeqAcwVR3aOO3WmDW3CMTSqa-63ax9kDw>
    <xmx:7PCWXkz8x2VZeY686xHnddFQXobUd-jmDWTF-nY7pdJVsyB5OnsHvw>
    <xmx:7PCWXvS1xh4tOYNGr5MEIK7l3PlCfJ5hBVqZBVcgx_2S_8_LFKo4Iw>
    <xmx:7PCWXjuIuDEavj0TTGKMZWftTjYN-xkAO3qvCPuAbeKEzmrtyMRWYQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E36DE3280068;
        Wed, 15 Apr 2020 07:32:59 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm: Remove PageReserved manipulation from drm_pci_alloc" failed to apply to 4.14-stable tree
To:     chris@chris-wilson.co.uk, alexander.deucher@amd.com,
        kirill.shutemov@linux.intel.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Apr 2020 13:32:50 +0200
Message-ID: <15869503706164@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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


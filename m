Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0E116FC8A
	for <lists+stable@lfdr.de>; Wed, 26 Feb 2020 11:53:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727339AbgBZKxx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Feb 2020 05:53:53 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:47993 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726329AbgBZKxx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Feb 2020 05:53:53 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 4AE2262A;
        Wed, 26 Feb 2020 05:53:52 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 26 Feb 2020 05:53:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=R/LX1I
        INAAhVrFnAYFeQHQpJUlgaU5FpN2lxLMNY7d0=; b=nKfD08q8jtaSBohGRyZkDT
        E7RsxfTrweWW+QFHsb1gfnX7GCNsGoUSObpBKNh8W1q4hM9BZNW8u28geYJPB7pD
        nBqS4Z6LEwmmOpUA5AIurlBosa6phKhqhtZC3gK0ygYXqgfUnV1lOQtJxs68B0lP
        qu/DRVWmIhE5YgNoBbQ1JOqNpNAUK0Bj0WHeePhKZx/ZHYBNebXZ1A9g3Axq3WAx
        px5v7LrjKD1O/SMUezZdSznGog2BGxTOZvFNbierPhpyyXXWyZPBZF4if+Y1BexL
        FmZ6gUObCXieSeiXPOigq4wLQ7XYuaFobwAFpanN6BBeUDwhgrKYsHio5YTpFO0w
        ==
X-ME-Sender: <xms:P05WXi_kw6HkZU9_PnR2zEcPzZFozNY6TFVbp0uwp78NkfARJRaq3w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrleeggddvvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhrghenucfkphepkeefrdekie
    drkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhf
    rhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:P05WXtZna9vKGRgF6LwfMTKoKyKs76QiLx6hPyKQkb72u85iW1glBg>
    <xmx:P05WXgtEz-aRV0wmI2fmMQDpCzNy6WNQj2XnX1XHoPmjvKsjb6NMYQ>
    <xmx:P05WXhl9e3ulNsF52WEUGRXd1qJnChBc4CsBDn3-WBvgYdufuhVCow>
    <xmx:P05WXmCBtuJjvkG7N2_yFyrF0G1dRAFciSE8qc-14H01QW3-gHfCnw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 874B23060FCB;
        Wed, 26 Feb 2020 05:53:51 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/i915: Wean off drm_pci_alloc/drm_pci_free" failed to apply to 4.14-stable tree
To:     chris@chris-wilson.co.uk, daniel.vetter@ffwll.ch,
        jani.nikula@intel.com, kirill.shutemov@linux.intel.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 26 Feb 2020 11:53:37 +0100
Message-ID: <15827144173660@kroah.com>
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

From aa3146193ae25d0fe4b96d815169a135db2e8f01 Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Sun, 2 Feb 2020 15:39:34 +0000
Subject: [PATCH] drm/i915: Wean off drm_pci_alloc/drm_pci_free

drm_pci_alloc and drm_pci_free are just very thin wrappers around
dma_alloc_coherent, with a note that we should be removing them.
Furthermore since

commit de09d31dd38a50fdce106c15abd68432eebbd014
Author: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Date:   Fri Jan 15 16:51:42 2016 -0800

    page-flags: define PG_reserved behavior on compound pages

    As far as I can see there's no users of PG_reserved on compound pages.
    Let's use PF_NO_COMPOUND here.

drm_pci_alloc has been declared broken since it mixes GFP_COMP and
SetPageReserved. Avoid this conflict by weaning ourselves off using the
abstraction and using the dma functions directly.

Reported-by: Taketo Kabe
Closes: https://gitlab.freedesktop.org/drm/intel/issues/1027
Fixes: de09d31dd38a ("page-flags: define PG_reserved behavior on compound pages")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: <stable@vger.kernel.org> # v4.5+
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20200202153934.3899472-1-chris@chris-wilson.co.uk
(cherry picked from commit c6790dc22312f592c1434577258b31c48c72d52a)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>

diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
index e68ec25fc97c..aa453953908b 100644
--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -11087,7 +11087,7 @@ static u32 intel_cursor_base(const struct intel_plane_state *plane_state)
 	u32 base;
 
 	if (INTEL_INFO(dev_priv)->display.cursor_needs_physical)
-		base = obj->phys_handle->busaddr;
+		base = sg_dma_address(obj->mm.pages->sgl);
 	else
 		base = intel_plane_ggtt_offset(plane_state);
 
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_object_types.h b/drivers/gpu/drm/i915/gem/i915_gem_object_types.h
index f64ad77e6b1e..c2174da35bb0 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_object_types.h
+++ b/drivers/gpu/drm/i915/gem/i915_gem_object_types.h
@@ -285,9 +285,6 @@ struct drm_i915_gem_object {
 
 		void *gvt_info;
 	};
-
-	/** for phys allocated objects */
-	struct drm_dma_handle *phys_handle;
 };
 
 static inline struct drm_i915_gem_object *
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_phys.c b/drivers/gpu/drm/i915/gem/i915_gem_phys.c
index b1b7c1b3038a..b07bb40edd5a 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_phys.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_phys.c
@@ -22,88 +22,87 @@
 static int i915_gem_object_get_pages_phys(struct drm_i915_gem_object *obj)
 {
 	struct address_space *mapping = obj->base.filp->f_mapping;
-	struct drm_dma_handle *phys;
-	struct sg_table *st;
 	struct scatterlist *sg;
-	char *vaddr;
+	struct sg_table *st;
+	dma_addr_t dma;
+	void *vaddr;
+	void *dst;
 	int i;
-	int err;
 
 	if (WARN_ON(i915_gem_object_needs_bit17_swizzle(obj)))
 		return -EINVAL;
 
-	/* Always aligning to the object size, allows a single allocation
+	/*
+	 * Always aligning to the object size, allows a single allocation
 	 * to handle all possible callers, and given typical object sizes,
 	 * the alignment of the buddy allocation will naturally match.
 	 */
-	phys = drm_pci_alloc(obj->base.dev,
-			     roundup_pow_of_two(obj->base.size),
-			     roundup_pow_of_two(obj->base.size));
-	if (!phys)
+	vaddr = dma_alloc_coherent(&obj->base.dev->pdev->dev,
+				   roundup_pow_of_two(obj->base.size),
+				   &dma, GFP_KERNEL);
+	if (!vaddr)
 		return -ENOMEM;
 
-	vaddr = phys->vaddr;
+	st = kmalloc(sizeof(*st), GFP_KERNEL);
+	if (!st)
+		goto err_pci;
+
+	if (sg_alloc_table(st, 1, GFP_KERNEL))
+		goto err_st;
+
+	sg = st->sgl;
+	sg->offset = 0;
+	sg->length = obj->base.size;
+
+	sg_assign_page(sg, (struct page *)vaddr);
+	sg_dma_address(sg) = dma;
+	sg_dma_len(sg) = obj->base.size;
+
+	dst = vaddr;
 	for (i = 0; i < obj->base.size / PAGE_SIZE; i++) {
 		struct page *page;
-		char *src;
+		void *src;
 
 		page = shmem_read_mapping_page(mapping, i);
-		if (IS_ERR(page)) {
-			err = PTR_ERR(page);
-			goto err_phys;
-		}
+		if (IS_ERR(page))
+			goto err_st;
 
 		src = kmap_atomic(page);
-		memcpy(vaddr, src, PAGE_SIZE);
-		drm_clflush_virt_range(vaddr, PAGE_SIZE);
+		memcpy(dst, src, PAGE_SIZE);
+		drm_clflush_virt_range(dst, PAGE_SIZE);
 		kunmap_atomic(src);
 
 		put_page(page);
-		vaddr += PAGE_SIZE;
+		dst += PAGE_SIZE;
 	}
 
 	intel_gt_chipset_flush(&to_i915(obj->base.dev)->gt);
 
-	st = kmalloc(sizeof(*st), GFP_KERNEL);
-	if (!st) {
-		err = -ENOMEM;
-		goto err_phys;
-	}
-
-	if (sg_alloc_table(st, 1, GFP_KERNEL)) {
-		kfree(st);
-		err = -ENOMEM;
-		goto err_phys;
-	}
-
-	sg = st->sgl;
-	sg->offset = 0;
-	sg->length = obj->base.size;
-
-	sg_dma_address(sg) = phys->busaddr;
-	sg_dma_len(sg) = obj->base.size;
-
-	obj->phys_handle = phys;
-
 	__i915_gem_object_set_pages(obj, st, sg->length);
 
 	return 0;
 
-err_phys:
-	drm_pci_free(obj->base.dev, phys);
-
-	return err;
+err_st:
+	kfree(st);
+err_pci:
+	dma_free_coherent(&obj->base.dev->pdev->dev,
+			  roundup_pow_of_two(obj->base.size),
+			  vaddr, dma);
+	return -ENOMEM;
 }
 
 static void
 i915_gem_object_put_pages_phys(struct drm_i915_gem_object *obj,
 			       struct sg_table *pages)
 {
+	dma_addr_t dma = sg_dma_address(pages->sgl);
+	void *vaddr = sg_page(pages->sgl);
+
 	__i915_gem_object_release_shmem(obj, pages, false);
 
 	if (obj->mm.dirty) {
 		struct address_space *mapping = obj->base.filp->f_mapping;
-		char *vaddr = obj->phys_handle->vaddr;
+		void *src = vaddr;
 		int i;
 
 		for (i = 0; i < obj->base.size / PAGE_SIZE; i++) {
@@ -115,15 +114,16 @@ i915_gem_object_put_pages_phys(struct drm_i915_gem_object *obj,
 				continue;
 
 			dst = kmap_atomic(page);
-			drm_clflush_virt_range(vaddr, PAGE_SIZE);
-			memcpy(dst, vaddr, PAGE_SIZE);
+			drm_clflush_virt_range(src, PAGE_SIZE);
+			memcpy(dst, src, PAGE_SIZE);
 			kunmap_atomic(dst);
 
 			set_page_dirty(page);
 			if (obj->mm.madv == I915_MADV_WILLNEED)
 				mark_page_accessed(page);
 			put_page(page);
-			vaddr += PAGE_SIZE;
+
+			src += PAGE_SIZE;
 		}
 		obj->mm.dirty = false;
 	}
@@ -131,7 +131,9 @@ i915_gem_object_put_pages_phys(struct drm_i915_gem_object *obj,
 	sg_free_table(pages);
 	kfree(pages);
 
-	drm_pci_free(obj->base.dev, obj->phys_handle);
+	dma_free_coherent(&obj->base.dev->pdev->dev,
+			  roundup_pow_of_two(obj->base.size),
+			  vaddr, dma);
 }
 
 static void phys_release(struct drm_i915_gem_object *obj)
diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index c2de2f45b459..5f6e63952821 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -180,7 +180,7 @@ i915_gem_phys_pwrite(struct drm_i915_gem_object *obj,
 		     struct drm_i915_gem_pwrite *args,
 		     struct drm_file *file)
 {
-	void *vaddr = obj->phys_handle->vaddr + args->offset;
+	void *vaddr = sg_page(obj->mm.pages->sgl) + args->offset;
 	char __user *user_data = u64_to_user_ptr(args->data_ptr);
 
 	/*
@@ -844,10 +844,10 @@ i915_gem_pwrite_ioctl(struct drm_device *dev, void *data,
 		ret = i915_gem_gtt_pwrite_fast(obj, args);
 
 	if (ret == -EFAULT || ret == -ENOSPC) {
-		if (obj->phys_handle)
-			ret = i915_gem_phys_pwrite(obj, args, file);
-		else
+		if (i915_gem_object_has_struct_page(obj))
 			ret = i915_gem_shmem_pwrite(obj, args);
+		else
+			ret = i915_gem_phys_pwrite(obj, args, file);
 	}
 
 	i915_gem_object_unpin_pages(obj);


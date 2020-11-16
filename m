Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25E5C2B4CC4
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 18:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731200AbgKPR2I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 12:28:08 -0500
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:50441 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730576AbgKPR2I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 12:28:08 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 7E6A839C;
        Mon, 16 Nov 2020 12:28:07 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 16 Nov 2020 12:28:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=N9gvIg
        vty+AQe1tFH714IxksLTnoz39Ndw2xheIvfGw=; b=mqyKma3C8c7YoDeAXB63gZ
        THiUc4iVgQoXjEG0yWfNz/Q7lCj95de+49trpDoeQMfNmDvxz3czWmTKD0BSFycf
        eFwumHz65Ipq2emvOkVP8CnK43j2Qym2AvLwQ5C4nlzW6WbpCj+jNBWyZDTB35r4
        JOjpzgh/tvxTOV5zwch+lrqiCz9Ae7WPfWLib3LpDJN8MIxbh0Mki9mMh2Z0FHSz
        OSnPbBnl/4WdqTpHlf6qNpzTGH6FXtFuEV7zybswEvlzMIs4EUV99IWfSt8Gwjfb
        M3YAaGnb2blV1qviBt0NcMme7SlDb2c/zHEjeF45aD1ZowicCYtfg+8V+sMqbNww
        ==
X-ME-Sender: <xms:prayX_2S2OKb_yH1Y-hM6NvTEbjtb5qpQgzx9NW65boWL9actRydiw>
    <xme:prayX-H_d1mGMyDkdyyfXtbNpUkBYWtAalfvgr4r7o9VIn1ocQU5aRTjbbDQBcH8Y
    TJbDdUVP1wvaw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudefuddguddtvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeekhffhfefgfeehfeefudeguedvvdevgffgffdtud
    eujefhhffgveeutddvtdejgfenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhr
    ghenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedvnecurf
    grrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:prayX_5wyOAKFhh8phyMUAPFwAGnwq-gkrBgJ3DqnhPj9Y7J9mTYJg>
    <xmx:prayX0285319GmUDUZahYPAGCLYhd4PmCkw5sNr5FQSBTwykrllnfw>
    <xmx:prayXyEfGGgQRGYTL7QQJJ4XzKgBwae0UOPd2hcdq1DT1BnRqcPGmQ>
    <xmx:p7ayX0MkS04xnMzr9WiYkIEab7Vk1V0z0ZTrn5nbeTNIYK2N2Il2dTmXcZ8>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6E97C3064AB0;
        Mon, 16 Nov 2020 12:28:06 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/i915/gem: Pull phys pread/pwrite implementations to the" failed to apply to 5.9-stable tree
To:     chris@chris-wilson.co.uk, matthew.auld@intel.com,
        rodrigo.vivi@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 Nov 2020 18:28:57 +0100
Message-ID: <160554773738191@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0eb0feb9aeac392edf01b525a54acde9b002312e Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Thu, 5 Nov 2020 15:49:34 +0000
Subject: [PATCH] drm/i915/gem: Pull phys pread/pwrite implementations to the
 backend

Move the specialised interactions with the physical GEM object from the
pread/pwrite ioctl handler into the phys backend.

Currently, if one is able to exhaust the entire aperture and then try to
pwrite into an object not backed by struct page, we accidentally invoked
the phys pwrite handler on a non-phys object; calamitous.

Fixes: c6790dc22312 ("drm/i915: Wean off drm_pci_alloc/drm_pci_free")
Testcase: igt/gem_pwrite/exhaustion
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Cc: stable@vger.kernel.org
Link: https://patchwork.freedesktop.org/patch/msgid/20201105154934.16022-2-chris@chris-wilson.co.uk
(cherry picked from commit 852e1b3644817f071427b83859b889c788a0cf69)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_phys.c b/drivers/gpu/drm/i915/gem/i915_gem_phys.c
index 28147aab47b9..3a4dfe2ef1da 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_phys.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_phys.c
@@ -134,6 +134,58 @@ i915_gem_object_put_pages_phys(struct drm_i915_gem_object *obj,
 			  vaddr, dma);
 }
 
+static int
+phys_pwrite(struct drm_i915_gem_object *obj,
+	    const struct drm_i915_gem_pwrite *args)
+{
+	void *vaddr = sg_page(obj->mm.pages->sgl) + args->offset;
+	char __user *user_data = u64_to_user_ptr(args->data_ptr);
+	int err;
+
+	err = i915_gem_object_wait(obj,
+				   I915_WAIT_INTERRUPTIBLE |
+				   I915_WAIT_ALL,
+				   MAX_SCHEDULE_TIMEOUT);
+	if (err)
+		return err;
+
+	/*
+	 * We manually control the domain here and pretend that it
+	 * remains coherent i.e. in the GTT domain, like shmem_pwrite.
+	 */
+	i915_gem_object_invalidate_frontbuffer(obj, ORIGIN_CPU);
+
+	if (copy_from_user(vaddr, user_data, args->size))
+		return -EFAULT;
+
+	drm_clflush_virt_range(vaddr, args->size);
+	intel_gt_chipset_flush(&to_i915(obj->base.dev)->gt);
+
+	i915_gem_object_flush_frontbuffer(obj, ORIGIN_CPU);
+	return 0;
+}
+
+static int
+phys_pread(struct drm_i915_gem_object *obj,
+	   const struct drm_i915_gem_pread *args)
+{
+	void *vaddr = sg_page(obj->mm.pages->sgl) + args->offset;
+	char __user *user_data = u64_to_user_ptr(args->data_ptr);
+	int err;
+
+	err = i915_gem_object_wait(obj,
+				   I915_WAIT_INTERRUPTIBLE,
+				   MAX_SCHEDULE_TIMEOUT);
+	if (err)
+		return err;
+
+	drm_clflush_virt_range(vaddr, args->size);
+	if (copy_to_user(user_data, vaddr, args->size))
+		return -EFAULT;
+
+	return 0;
+}
+
 static void phys_release(struct drm_i915_gem_object *obj)
 {
 	fput(obj->base.filp);
@@ -144,6 +196,9 @@ static const struct drm_i915_gem_object_ops i915_gem_phys_ops = {
 	.get_pages = i915_gem_object_get_pages_phys,
 	.put_pages = i915_gem_object_put_pages_phys,
 
+	.pread  = phys_pread,
+	.pwrite = phys_pwrite,
+
 	.release = phys_release,
 };
 
diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index d58fe1ddc3e1..58276694c848 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -179,30 +179,6 @@ int i915_gem_object_unbind(struct drm_i915_gem_object *obj,
 	return ret;
 }
 
-static int
-i915_gem_phys_pwrite(struct drm_i915_gem_object *obj,
-		     struct drm_i915_gem_pwrite *args,
-		     struct drm_file *file)
-{
-	void *vaddr = sg_page(obj->mm.pages->sgl) + args->offset;
-	char __user *user_data = u64_to_user_ptr(args->data_ptr);
-
-	/*
-	 * We manually control the domain here and pretend that it
-	 * remains coherent i.e. in the GTT domain, like shmem_pwrite.
-	 */
-	i915_gem_object_invalidate_frontbuffer(obj, ORIGIN_CPU);
-
-	if (copy_from_user(vaddr, user_data, args->size))
-		return -EFAULT;
-
-	drm_clflush_virt_range(vaddr, args->size);
-	intel_gt_chipset_flush(&to_i915(obj->base.dev)->gt);
-
-	i915_gem_object_flush_frontbuffer(obj, ORIGIN_CPU);
-	return 0;
-}
-
 static int
 i915_gem_create(struct drm_file *file,
 		struct intel_memory_region *mr,
@@ -872,8 +848,6 @@ i915_gem_pwrite_ioctl(struct drm_device *dev, void *data,
 	if (ret == -EFAULT || ret == -ENOSPC) {
 		if (i915_gem_object_has_struct_page(obj))
 			ret = i915_gem_shmem_pwrite(obj, args);
-		else
-			ret = i915_gem_phys_pwrite(obj, args, file);
 	}
 
 	i915_gem_object_unpin_pages(obj);


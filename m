Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6259D811D9
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 07:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727299AbfHEF6G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 01:58:06 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:53199 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725951AbfHEF6F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 01:58:05 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 312BE2148D;
        Mon,  5 Aug 2019 01:58:05 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 05 Aug 2019 01:58:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=umRoe+
        n4bpGncnnVYdCru/jg52mFZ2/7+/s/jVtA9nk=; b=dloG34NmfzgYo0+6sljZ5y
        UMZYEzZtq3vN8W2OmlV2W3UxKwtkQGKz5Wuew7C0VZ8I8wipnxMxYWKPXOZfsKJ0
        vDz5I72FHjeiDk0TZDi900+RsYTFbOHJmHgfGlwrXbSt6z3mv3UYizsGn8n4fMjB
        KsYScO9Jbw8deDxUcZz+u0XXRkMMndt2iwT6H2Q0irve6/fR60WTeA10MAf5Vx+R
        xOHqfFvZ8N/2TzaonI2M0Y9+f1ej5HfmpsYZhZPUNw9fsZ03jq2RXs2uNMKEdmtR
        8ScP1oq0A59pjd+6u1ZfmYd+RCogyqNp1No6DlmEiV8GsOSiDtO0NbU4G3JaFlwg
        ==
X-ME-Sender: <xms:bMVHXTJllF8CATEIFUa9kry6TEBSNyK6PNah-z39O3MMeihfGPFV8Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddtiedgledtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhgpdhkvghrnhgvlhdroh
    hrghenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhm
    pehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpeeg
X-ME-Proxy: <xmx:bcVHXcYLMboP3Jd5o0elm3jmXYnZE-Pj0HoD7KqjUJqyvuvCFDQ9FQ>
    <xmx:bcVHXdaGkb5KwhjWV9PmgUmR-RYn9h9FKUx7-EdCOEskzmdvDqFivw>
    <xmx:bcVHXUmjq_j-aiKZ8xQIorOEq2_jASXUNZAQ_iGIiz1MSDfPdHcatQ>
    <xmx:bcVHXUVSWtEmtZqSHEEkeQljRDDcBFI2nsbJnfXeh3iD2ekjQig6yQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 769AE380084;
        Mon,  5 Aug 2019 01:58:04 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915/userptr: Acquire the page lock around" failed to apply to 4.4-stable tree
To:     chris@chris-wilson.co.uk, jani.nikula@intel.com,
        tvrtko.ursulin@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 05 Aug 2019 07:57:57 +0200
Message-ID: <156498467713717@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From aa56a292ce623734ddd30f52d73f527d1f3529b5 Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Mon, 8 Jul 2019 15:03:27 +0100
Subject: [PATCH] drm/i915/userptr: Acquire the page lock around
 set_page_dirty()

set_page_dirty says:

	For pages with a mapping this should be done under the page lock
	for the benefit of asynchronous memory errors who prefer a
	consistent dirty state. This rule can be broken in some special
	cases, but should be better not to.

Under those rules, it is only safe for us to use the plain set_page_dirty
calls for shmemfs/anonymous memory. Userptr may be used with real
mappings and so needs to use the locked version (set_page_dirty_lock).

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=203317
Fixes: 5cc9ed4b9a7a ("drm/i915: Introduce mapping of user pages into video memory (userptr) ioctl")
References: 6dcc693bc57f ("ext4: warn when page is dirtied without buffers")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: stable@vger.kernel.org
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190708140327.26825-1-chris@chris-wilson.co.uk
(cherry picked from commit cb6d7c7dc7ff8cace666ddec66334117a6068ce2)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_userptr.c b/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
index 528b61678334..2caa594322bc 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
@@ -664,7 +664,15 @@ i915_gem_userptr_put_pages(struct drm_i915_gem_object *obj,
 
 	for_each_sgt_page(page, sgt_iter, pages) {
 		if (obj->mm.dirty)
-			set_page_dirty(page);
+			/*
+			 * As this may not be anonymous memory (e.g. shmem)
+			 * but exist on a real mapping, we have to lock
+			 * the page in order to dirty it -- holding
+			 * the page reference is not sufficient to
+			 * prevent the inode from being truncated.
+			 * Play safe and take the lock.
+			 */
+			set_page_dirty_lock(page);
 
 		mark_page_accessed(page);
 		put_page(page);


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B93212AB4EA
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 11:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbgKIKbt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 05:31:49 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:33243 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726176AbgKIKbt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 05:31:49 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id F002412A4;
        Mon,  9 Nov 2020 05:31:47 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 09 Nov 2020 05:31:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Vn639/
        dXx0crMSlOtwjBWuE5ncKkXp/OtosQ1PiClmI=; b=cQIydq9sCo1AWnUR0r7GGK
        oAhTYhCFUGMsg4gOShVXHMIx85Mpwy/6jCXjINdzxRiHlfdknEMypyCp/RH1LI1x
        8WG4+85eSEKGkvxHZImFvI9YVMvLXDU7rXUQN9Dg40ynHJDW8V2u6KoS5W9e/QUx
        QSGbT0VkXjbiE0NPtZiXlbe6/fRUsCQJHoTBdMZVz4z5P+mI9EQtWQdcmp7FlNt2
        uUVAWs+dQxMuTgl/Nm64W8iYs+QyOpnZtX7lhXKUpHJwe6haPueM9mM5d96J1g2Z
        mmohTz4RBBgU3kyqmM4YriImKsUmX6lPM43s8kpN7JCZdZ68hYYSXYao3aqeCgvg
        ==
X-ME-Sender: <xms:kxqpXxz35NV90tFrPGeLjJcQesbg4ORrGIx_tfePsp6g5qwEZPe8lQ>
    <xme:kxqpXxR7RiacOqs2vW9A3LsBHjay2oxgrXUmEavRoRK9DuaYABfFIeQfs5fOp8ZkI
    pLkMJl-O0m3HQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudduhedgudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepvdffgeejjeeitdeiffejieejfffghedviedujeehfe
    egvefhhfevvdefueehkeelnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:kxqpX7W3ZmRL2kuAReoP6DyUJJGY-uTz7mOcr3ASFnk15cKvd8BtYQ>
    <xmx:kxqpXzhCiJ6YaXJdv6Zr8nI2vybHnptDAXsBRxYr4xCIY6aoWlGicQ>
    <xmx:kxqpXzBGZsN8YTWhqz3ym7onQer52ZH3ISlYZUjypAQ-X7CIQjzadA>
    <xmx:kxqpX--ohky43-GKI2vRWLnvi4GpxoQUN42B87bFRyx_fsYOmrlMunAlafQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 38DC33063080;
        Mon,  9 Nov 2020 05:31:47 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/i915/gem: Flush coherency domains on first" failed to apply to 5.9-stable tree
To:     chris@chris-wilson.co.uk, joonas.lahtinen@linux.intel.com,
        matthew.auld@intel.com, matthew.william.auld@gmail.com,
        rodrigo.vivi@intel.com, stable@vger.kernel.org,
        zbigniew.kempczynski@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 Nov 2020 11:32:39 +0100
Message-ID: <160491795916258@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From 59dd13ad310793757e34afa489dd6fc8544fc3da Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Mon, 19 Oct 2020 21:38:25 +0100
Subject: [PATCH] drm/i915/gem: Flush coherency domains on first
 set-domain-ioctl
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Avoid skipping what appears to be a no-op set-domain-ioctl if the cache
coherency state is inconsistent with our target domain. This also has
the utility of using the population of the pages to validate the backing
store.

The danger in skipping the first set-domain is leaving the cache
inconsistent and submitting stale data, or worse leaving the clean data
in the cache and not flushing it to the GPU. The impact should be small
as it requires a no-op set-domain as the very first ioctl in a
particular sequence not found in typical userspace.

Reported-by: Zbigniew Kempczyński <zbigniew.kempczynski@intel.com>
Fixes: 754a25442705 ("drm/i915: Skip object locking around a no-op set-domain ioctl")
Testcase: igt/gem_mmap_offset/blt-coherency
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Matthew Auld <matthew.william.auld@gmail.com>
Cc: Zbigniew Kempczyński <zbigniew.kempczynski@intel.com>
Cc: <stable@vger.kernel.org> # v5.2+
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201019203825.10966-1-chris@chris-wilson.co.uk
(cherry picked from commit 44c2200afcd59f441b43f27829b4003397cc495d)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_domain.c b/drivers/gpu/drm/i915/gem/i915_gem_domain.c
index 7c90a63c273d..fcce6909f201 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_domain.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_domain.c
@@ -508,21 +508,6 @@ i915_gem_set_domain_ioctl(struct drm_device *dev, void *data,
 	if (!obj)
 		return -ENOENT;
 
-	/*
-	 * Already in the desired write domain? Nothing for us to do!
-	 *
-	 * We apply a little bit of cunning here to catch a broader set of
-	 * no-ops. If obj->write_domain is set, we must be in the same
-	 * obj->read_domains, and only that domain. Therefore, if that
-	 * obj->write_domain matches the request read_domains, we are
-	 * already in the same read/write domain and can skip the operation,
-	 * without having to further check the requested write_domain.
-	 */
-	if (READ_ONCE(obj->write_domain) == read_domains) {
-		err = 0;
-		goto out;
-	}
-
 	/*
 	 * Try to flush the object off the GPU without holding the lock.
 	 * We will repeat the flush holding the lock in the normal manner
@@ -560,6 +545,19 @@ i915_gem_set_domain_ioctl(struct drm_device *dev, void *data,
 	if (err)
 		goto out;
 
+	/*
+	 * Already in the desired write domain? Nothing for us to do!
+	 *
+	 * We apply a little bit of cunning here to catch a broader set of
+	 * no-ops. If obj->write_domain is set, we must be in the same
+	 * obj->read_domains, and only that domain. Therefore, if that
+	 * obj->write_domain matches the request read_domains, we are
+	 * already in the same read/write domain and can skip the operation,
+	 * without having to further check the requested write_domain.
+	 */
+	if (READ_ONCE(obj->write_domain) == read_domains)
+		goto out_unpin;
+
 	err = i915_gem_object_lock_interruptible(obj, NULL);
 	if (err)
 		goto out_unpin;


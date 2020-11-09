Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2A812AB4EB
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 11:31:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727311AbgKIKbx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 05:31:53 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:36509 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726176AbgKIKbw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 05:31:52 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id BE7A01295;
        Mon,  9 Nov 2020 05:31:51 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 09 Nov 2020 05:31:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=oXLwkd
        5oGjnXzIXcTdGufyN6NFpcnE1epClVg2CTogU=; b=QV93hn5CUqhQuj5WzEdkpn
        RerubeEOyLs2YbnqqTlKVflemvVUcteFlVcWugygi8cRQaCGRVXxsxPf46HbjDmI
        11aUgvpcOZigigFtZsS3Lo40Ab6gkTlo5j4vC3mr8eUddkp/GJd5Ke/IbEQvYyAk
        03Otr1PZKyHm+X/9RQEoG1MDJxPESKPNRXUX0w5vSUXgGun3CrYTQEd25Q4nw0D5
        WxO49D+Q6k9kgcJASX8O6tOrilJkSBtAy3Xp3gULt/A1b/00SYnMVZM1JP2yOeJN
        GeCCjB0JBsufIjbzb1ILcLU2CXfDaB7ih4P/hKeZk3AhKhyDFpUKGesmZfzlWNWA
        ==
X-ME-Sender: <xms:lxqpX0uSh5ZdB0Ima0EIrE-ovE-UltNJtz7_H1ESGTndZww-Liz8IQ>
    <xme:lxqpXxfIQhQpIH-kdka1NpiMZCjj3otoTUFy5v-p1LyVvKcQRkqC2s7wGatMA81C-
    54deNHze80x7g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudduhedgudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkefhhfefgfefheeffedugeeuvddvvefggffftdduue
    ejhffhgfevuedtvddtjefgnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:lxqpX_wzyP6UqGFH2lXi1ojRxo5TXWM_O97kD89v6wkXsAVYoq9tig>
    <xmx:lxqpX3P2JRMEmaqBBcv0_0OJ8Eo3QYqeukTL24v0h3pHsqWHbrNK1w>
    <xmx:lxqpX08F3WonMxGr7bJL-IxoVPga212cjHXnfr2yjDqvHioCVgcHEQ>
    <xmx:lxqpXyk97DK2IRba75DsDsSCo5bC23ssRaw2-9cN1fwzKwy3kLktltpG9JU>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id DE827328005D;
        Mon,  9 Nov 2020 05:31:50 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/i915: Hold onto an explicit ref to i915_vma_work.pinned" failed to apply to 5.9-stable tree
To:     chris@chris-wilson.co.uk, rodrigo.vivi@intel.com,
        stable@vger.kernel.org, tvrtko.ursulin@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 Nov 2020 11:32:51 +0100
Message-ID: <160491797180144@kroah.com>
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

From 537457a979a02a410b555fab289dcb28b588f33b Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Mon, 2 Nov 2020 16:19:31 +0000
Subject: [PATCH] drm/i915: Hold onto an explicit ref to i915_vma_work.pinned

Since __vma_release is run by a kworker after the fence has been
signaled, it is no longer protected by the active reference on the vma,
and so the alias of vw->pinned to vma->obj is also not protected by a
reference on the object. Add an explicit reference for vw->pinned so it
will always be safe.

Found by inspection.

Fixes: 54d7195f8c64 ("drm/i915: Unpin vma->obj on early error")
Reported-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: <stable@vger.kernel.org> # v5.6+
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201102161931.30031-1-chris@chris-wilson.co.uk
(cherry picked from commit bc73e5d33048b7ab5f12b11b5d923700467a8e1d)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>

diff --git a/drivers/gpu/drm/i915/i915_vma.c b/drivers/gpu/drm/i915/i915_vma.c
index ffb5287e055a..caa9b041616b 100644
--- a/drivers/gpu/drm/i915/i915_vma.c
+++ b/drivers/gpu/drm/i915/i915_vma.c
@@ -314,8 +314,10 @@ static void __vma_release(struct dma_fence_work *work)
 {
 	struct i915_vma_work *vw = container_of(work, typeof(*vw), base);
 
-	if (vw->pinned)
+	if (vw->pinned) {
 		__i915_gem_object_unpin_pages(vw->pinned);
+		i915_gem_object_put(vw->pinned);
+	}
 
 	i915_vm_free_pt_stash(vw->vm, &vw->stash);
 	i915_vm_put(vw->vm);
@@ -431,7 +433,7 @@ int i915_vma_bind(struct i915_vma *vma,
 
 		if (vma->obj) {
 			__i915_gem_object_pin_pages(vma->obj);
-			work->pinned = vma->obj;
+			work->pinned = i915_gem_object_get(vma->obj);
 		}
 	} else {
 		vma->ops->bind_vma(vma->vm, NULL, vma, cache_level, bind_flags);


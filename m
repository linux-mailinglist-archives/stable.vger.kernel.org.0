Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE2D2A824A
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 16:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731089AbgKEPep (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 10:34:45 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:59141 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730721AbgKEPep (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Nov 2020 10:34:45 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 1AE50E97;
        Thu,  5 Nov 2020 10:34:44 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 05 Nov 2020 10:34:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=YZCus1
        s+a60D8gzzF3ZfayTBG/6Dxr6YwAmo1pcdqH4=; b=Rb8Rjnj8P1Sda2Eg5SaC+3
        3WTElI2i//38rzAfs30ZPmKrTwqNWGmjriW7bnQ0v7pVx0O15pp3n95HKv5iw8Xo
        gyJlxRpe+fp+VsbfcaGJ5reZNNi7zWGJdSAKYZwGkN/ydTEDUgBboaOEP7MKPGo4
        B+16EkUT+PhHHTWlEmd/pUNVq0/VY+82u3I53x3LLVL3AwqKDKHic8Hhmo1UY+Ak
        StmwmK4XDpdu4+v+EYbM/T/scrKhm4HWQOBLe15G/7sO1IwmfQdVG8LHvgAo6Gvo
        6CiDBCdSeB2+rpvWQ1fO9fJwB4Ju0NTJ2BDSiWesLyzJu6WSKgWDB0pperCno50g
        ==
X-ME-Sender: <xms:kxukXwTmEW-6aCyYuCiLeNdA5Gqu9QEmUErAplYjZGWgozdznue4lA>
    <xme:kxukX9yj7CpAMwGWuONxX_GUGSY0-JQ9yJBmBTExkNLQxCOGzwm1RXEo8dSYu8a7B
    n1pgKFly3hefw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtjedgjeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkefhhfefgfefheeffedugeeuvddvvefggffftdduue
    ejhffhgfevuedtvddtjefgnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepieenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:kxukX93EKbAcH_fZ1sJ-mY-vEM_JljqZafuh44UbBZ_IKrUdweNKow>
    <xmx:kxukX0DMRu_AX4gYZaiGVuoJtrdQpNJTkI0e3QHXS8juN7ewhvWT6w>
    <xmx:kxukX5g76oMoSblK7h1d3oEqYdLlpe7NOcY6bUsnyCB6UHqjUcb5aQ>
    <xmx:kxukX-uo8mpUkXB3ubWiSQgDD7Q6X1gNc3i8ocGTkQWzzbZOI1RYVb5xJAY>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5BB983280393;
        Thu,  5 Nov 2020 10:34:43 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/i915/gem: Support parsing of oversize batches" failed to apply to 4.19-stable tree
To:     chris@chris-wilson.co.uk, jon.bloomfield@intel.com,
        matthew.auld@intel.com, mika.kuoppala@linux.intel.com,
        rodrigo.vivi@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 05 Nov 2020 16:35:28 +0100
Message-ID: <160459052820153@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From d5e8782129c22036425f29f9b6a254895482d7bd Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Thu, 15 Oct 2020 12:59:54 +0100
Subject: [PATCH] drm/i915/gem: Support parsing of oversize batches

Matthew Auld noted that on more recent systems (such as the parser for
gen9) we may have objects that are larger than expected by the GEM uAPI
(i.e. greater than u32). These objects would have incorrect implicit
batch lengths, causing the parser to reject them for being incomplete,
or worse.

Based on a patch by Matthew Auld.

Reported-by: Matthew Auld <matthew.auld@intel.com>
Fixes: 435e8fc059db ("drm/i915: Allow parsing of unsized batches")
Testcase: igt/gem_exec_params/larger-than-life-batch
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: Jon Bloomfield <jon.bloomfield@intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Cc: stable@vger.kernel.org
Link: https://patchwork.freedesktop.org/patch/msgid/20201015115954.871-1-chris@chris-wilson.co.uk
(cherry picked from commit 57b2d834bf235daab388c3ba12d035c820ae09c6)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
index 4b09bcd70cf4..1904e6e5ea64 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
@@ -287,8 +287,8 @@ struct i915_execbuffer {
 	u64 invalid_flags; /** Set of execobj.flags that are invalid */
 	u32 context_flags; /** Set of execobj.flags to insert from the ctx */
 
+	u64 batch_len; /** Length of batch within object */
 	u32 batch_start_offset; /** Location within object of batch */
-	u32 batch_len; /** Length of batch within object */
 	u32 batch_flags; /** Flags composed for emit_bb_start() */
 	struct intel_gt_buffer_pool_node *batch_pool; /** pool node for batch buffer */
 
@@ -871,6 +871,10 @@ static int eb_lookup_vmas(struct i915_execbuffer *eb)
 
 	if (eb->batch_len == 0)
 		eb->batch_len = eb->batch->vma->size - eb->batch_start_offset;
+	if (unlikely(eb->batch_len == 0)) { /* impossible! */
+		drm_dbg(&i915->drm, "Invalid batch length\n");
+		return -EINVAL;
+	}
 
 	return 0;
 
@@ -2424,7 +2428,7 @@ static int eb_parse(struct i915_execbuffer *eb)
 	struct drm_i915_private *i915 = eb->i915;
 	struct intel_gt_buffer_pool_node *pool = eb->batch_pool;
 	struct i915_vma *shadow, *trampoline, *batch;
-	unsigned int len;
+	unsigned long len;
 	int err;
 
 	if (!eb_use_cmdparser(eb)) {
@@ -2449,6 +2453,8 @@ static int eb_parse(struct i915_execbuffer *eb)
 	} else {
 		len += I915_CMD_PARSER_TRAMPOLINE_SIZE;
 	}
+	if (unlikely(len < eb->batch_len)) /* last paranoid check of overflow */
+		return -EINVAL;
 
 	if (!pool) {
 		pool = intel_gt_get_buffer_pool(eb->engine->gt, len);


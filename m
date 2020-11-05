Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0197E2A81C9
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 16:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730977AbgKEPD2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 10:03:28 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:48949 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730465AbgKEPD2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Nov 2020 10:03:28 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 50A5A79A;
        Thu,  5 Nov 2020 10:03:27 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 05 Nov 2020 10:03:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=kAKlBD
        9ff3E02xkgf5DXkCMSdW/wdIbCiCasnJOAgt8=; b=ObOCMD11w8/zpk3uN9kUhJ
        4kVaIvSKWF2SlMFuJ8aXh8yIeWOFvGocuIgPTIkS85Pt8z/yAaVfuA7ord7lzoES
        9M+lD5pcz2cQDs92mF156aD01UFjrXZ+hs7nWCjQJbho6baUsjnozlpk4QlfhDvb
        1e5qXasFuTcXkE7kv/fhWN2A7GVssa1ws1SXkATHjL/DGDOTnBbUjCwgjVjfi8q0
        ogIZuIrHvYaCGssBtAebs2hW0w2nBTBo7alThOMfUaLncgWrTO3OQjG8HZyD7Eku
        xQIpsQkaT2vd91970JVRFR9eeJ9Ql3RlSyxInMi8q7DXjrVGKObHd5DhS9gOiUdA
        ==
X-ME-Sender: <xms:PhSkXxm0ny4EYjQKd41GNYJcPqgmeClF-e6_-HP2iQjeSq7O_bgJXQ>
    <xme:PhSkX81A0FKqyr-qIDIY22LxOCaIRzmwlsYb_DeONjp9OZYJafj6uKkaTgH0ik0cX
    c4euJfeZb-wQg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtjedgjedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkefhhfefgfefheeffedugeeuvddvvefggffftdduue
    ejhffhgfevuedtvddtjefgnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepfeenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:PhSkX3odQNf_0KwSfD-3rhnXuhf55Du1mrxiaTI2M1QD2D1aK3WYSg>
    <xmx:PhSkXxmVI37Kcjxwbm1VH1XTN1uCQ96BJdcnxW1y_Kyqs3GDBhaqAA>
    <xmx:PhSkX_21agq2Uq0bmmhy2pHEegKLLeDLzS8mESicCnHQqxc_ndxteA>
    <xmx:PhSkX6Qz60XyTB18kX6mtqVzXtMnOKvnhRAEmiZhqUgsRDN2-7_GqvX3oQE>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2A0C33060062;
        Thu,  5 Nov 2020 10:03:26 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/i915: Avoid mixing integer types during batch copies" failed to apply to 4.9-stable tree
To:     chris@chris-wilson.co.uk, jared.candelaria@intel.com,
        jon.bloomfield@intel.com, joonas.lahtinen@linux.intel.com,
        mika.kuoppala@linux.intel.com, rodrigo.vivi@intel.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 05 Nov 2020 16:04:07 +0100
Message-ID: <1604588647134103@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From c60b93cd4862d108214a14e655358ea714d7a12a Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Mon, 28 Sep 2020 22:59:42 +0100
Subject: [PATCH] drm/i915: Avoid mixing integer types during batch copies

Be consistent and use unsigned long throughout the chunk copies to
avoid the inherent clumsiness of mixing integer types of different
widths and signs. Failing to take acount of a wider unsigned type when
using min_t can lead to treating it as a negative, only for it flip back
to a large unsigned value after passing a boundary check.

Fixes: ed13033f0287 ("drm/i915/cmdparser: Only cache the dst vmap")
Testcase: igt/gen9_exec_parse/bb-large
Reported-by: "Candelaria, Jared" <jared.candelaria@intel.com>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: "Candelaria, Jared" <jared.candelaria@intel.com>
Cc: "Bloomfield, Jon" <jon.bloomfield@intel.com>
Cc: <stable@vger.kernel.org> # v4.9+
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200928215942.31917-1-chris@chris-wilson.co.uk
(cherry picked from commit b7eeb2b4132ccf1a7d38f434cde7043913d1ed3c)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
index 5509946f1a1d..4b09bcd70cf4 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
@@ -2267,8 +2267,8 @@ struct eb_parse_work {
 	struct i915_vma *batch;
 	struct i915_vma *shadow;
 	struct i915_vma *trampoline;
-	unsigned int batch_offset;
-	unsigned int batch_length;
+	unsigned long batch_offset;
+	unsigned long batch_length;
 };
 
 static int __eb_parse(struct dma_fence_work *work)
@@ -2338,6 +2338,9 @@ static int eb_parse_pipeline(struct i915_execbuffer *eb,
 	struct eb_parse_work *pw;
 	int err;
 
+	GEM_BUG_ON(overflows_type(eb->batch_start_offset, pw->batch_offset));
+	GEM_BUG_ON(overflows_type(eb->batch_len, pw->batch_length));
+
 	pw = kzalloc(sizeof(*pw), GFP_KERNEL);
 	if (!pw)
 		return -ENOMEM;
diff --git a/drivers/gpu/drm/i915/i915_cmd_parser.c b/drivers/gpu/drm/i915/i915_cmd_parser.c
index 5ac4a999f05a..e88970256e8e 100644
--- a/drivers/gpu/drm/i915/i915_cmd_parser.c
+++ b/drivers/gpu/drm/i915/i915_cmd_parser.c
@@ -1136,7 +1136,7 @@ find_reg(const struct intel_engine_cs *engine, u32 addr)
 /* Returns a vmap'd pointer to dst_obj, which the caller must unmap */
 static u32 *copy_batch(struct drm_i915_gem_object *dst_obj,
 		       struct drm_i915_gem_object *src_obj,
-		       u32 offset, u32 length)
+		       unsigned long offset, unsigned long length)
 {
 	bool needs_clflush;
 	void *dst, *src;
@@ -1166,8 +1166,8 @@ static u32 *copy_batch(struct drm_i915_gem_object *dst_obj,
 		}
 	}
 	if (IS_ERR(src)) {
+		unsigned long x, n;
 		void *ptr;
-		int x, n;
 
 		/*
 		 * We can avoid clflushing partial cachelines before the write
@@ -1184,7 +1184,7 @@ static u32 *copy_batch(struct drm_i915_gem_object *dst_obj,
 		ptr = dst;
 		x = offset_in_page(offset);
 		for (n = offset >> PAGE_SHIFT; length; n++) {
-			int len = min_t(int, length, PAGE_SIZE - x);
+			int len = min(length, PAGE_SIZE - x);
 
 			src = kmap_atomic(i915_gem_object_get_page(src_obj, n));
 			if (needs_clflush)
@@ -1414,8 +1414,8 @@ static bool shadow_needs_clflush(struct drm_i915_gem_object *obj)
  */
 int intel_engine_cmd_parser(struct intel_engine_cs *engine,
 			    struct i915_vma *batch,
-			    u32 batch_offset,
-			    u32 batch_length,
+			    unsigned long batch_offset,
+			    unsigned long batch_length,
 			    struct i915_vma *shadow,
 			    bool trampoline)
 {
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 72a9449b674e..eef9a821c49c 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -1949,8 +1949,8 @@ void intel_engine_init_cmd_parser(struct intel_engine_cs *engine);
 void intel_engine_cleanup_cmd_parser(struct intel_engine_cs *engine);
 int intel_engine_cmd_parser(struct intel_engine_cs *engine,
 			    struct i915_vma *batch,
-			    u32 batch_offset,
-			    u32 batch_length,
+			    unsigned long batch_offset,
+			    unsigned long batch_length,
 			    struct i915_vma *shadow,
 			    bool trampoline);
 #define I915_CMD_PARSER_TRAMPOLINE_SIZE 8


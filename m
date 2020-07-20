Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83B15225E92
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 14:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728200AbgGTMbJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 08:31:09 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:33987 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727989AbgGTMbI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jul 2020 08:31:08 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id A311D1940ECC;
        Mon, 20 Jul 2020 08:31:07 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 20 Jul 2020 08:31:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=F4agvs
        4woiduRLmH6SkkXt5oFsOL5h8IQLrHtap72zQ=; b=lqiAwcqUtnKhmLHTYBxj7R
        NEG46Bud/wwmfoZJ+rMdkB+OGZnJ+/Oo2Y+/h3Gbmdg8+7ndxvjsMlSjeoYJzabA
        0eWTxxmuzb7FTjxzL9ii+ZUHCQJy70xhQqxZGwH1AT5IFUggddkmlgqZscElSFiF
        gDUE0bU0yD+fBlx+gmyczms8cbL49x5Ihm5FyT/aKUFRxxfT3f5YI3l0D1s8xCXD
        EVHCoYkf2y37eKTJQyYD6iGCk7CkMbBk6vOlNORWtbKN2z3OmNzvLqJbYHkCUdtk
        fDJ646ejXfKZcf+Nbnkcc7AaLzSlRbT3PzghmcrmvOLTSwJaIFZITAwh5dt/Pypw
        ==
X-ME-Sender: <xms:i44VX9SEHAuEB4ZTWma6RXVLLoPi_Y3SYq91gSXdbzKdB4HAVaJy8g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrgeeggddvjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeekhffhfefgfeehfeefudeguedvvdevgffgffdtudeuje
    fhhffgveeutddvtdejgfenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhrghen
    ucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepvdenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:i44VX2wi4e0cXxIdx-GpMdFfD6QJh_CnlmyOUubqFi3CNbUy-w_1-Q>
    <xmx:i44VXy0Iuehi2CoTiFP9EujQtsD8Jf3kNt0hsBqFSCp5poE9jkRR8g>
    <xmx:i44VX1BVgCj7yqLOk7j_Mf1M3PKqxS7KuPpTphVvSGKuzKp5DiRgKQ>
    <xmx:i44VX-IdvDUXh2ULeVOccs9B9P32CULgG16MRk02dIzYwFOi6cir5A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C9AD730600A9;
        Mon, 20 Jul 2020 08:31:06 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915/gt: Only swap to a random sibling once upon creation" failed to apply to 5.4-stable tree
To:     chris@chris-wilson.co.uk, jani.nikula@intel.com,
        stable@vger.kernel.org, tvrtko.ursulin@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Jul 2020 14:31:17 +0200
Message-ID: <159524827717179@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 110f9efa858f584c6bed177cd48d0c0f526940e1 Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Mon, 13 Jul 2020 17:05:49 +0100
Subject: [PATCH] drm/i915/gt: Only swap to a random sibling once upon creation

The danger in switching at random upon intel_context_pin is that the
context may still actually be inflight, as it will not be scheduled out
until a context switch after it is complete -- that may be a long time
after we do a final intel_context_unpin.

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/2118
Fixes: 6d06779e8672 ("drm/i915: Load balancing across a virtual engine")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: <stable@vger.kernel.org> # v5.3+
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200713160549.17344-1-chris@chris-wilson.co.uk
(cherry picked from commit 90a987205c6cf74116a102ed446d22d92cdaf915)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>

diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
index d270d2db6f0a..cb07e1d2a353 100644
--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -5396,13 +5396,8 @@ static void virtual_engine_initial_hint(struct virtual_engine *ve)
 	 * typically be the first we inspect for submission.
 	 */
 	swp = prandom_u32_max(ve->num_siblings);
-	if (!swp)
-		return;
-
-	swap(ve->siblings[swp], ve->siblings[0]);
-	if (!intel_engine_has_relative_mmio(ve->siblings[0]))
-		virtual_update_register_offsets(ve->context.lrc_reg_state,
-						ve->siblings[0]);
+	if (swp)
+		swap(ve->siblings[swp], ve->siblings[0]);
 }
 
 static int virtual_context_alloc(struct intel_context *ce)
@@ -5415,15 +5410,9 @@ static int virtual_context_alloc(struct intel_context *ce)
 static int virtual_context_pin(struct intel_context *ce)
 {
 	struct virtual_engine *ve = container_of(ce, typeof(*ve), context);
-	int err;
 
 	/* Note: we must use a real engine class for setting up reg state */
-	err = __execlists_context_pin(ce, ve->siblings[0]);
-	if (err)
-		return err;
-
-	virtual_engine_initial_hint(ve);
-	return 0;
+	return __execlists_context_pin(ce, ve->siblings[0]);
 }
 
 static void virtual_context_enter(struct intel_context *ce)
@@ -5770,6 +5759,7 @@ intel_execlists_create_virtual(struct intel_engine_cs **siblings,
 
 	ve->base.flags |= I915_ENGINE_IS_VIRTUAL;
 
+	virtual_engine_initial_hint(ve);
 	return &ve->context;
 
 err_put:


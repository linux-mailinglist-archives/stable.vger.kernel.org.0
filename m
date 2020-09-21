Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9EFC27229D
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 13:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgIULf6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 07:35:58 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:33015 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726326AbgIULf5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Sep 2020 07:35:57 -0400
X-Greylist: delayed 310 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Sep 2020 07:35:57 EDT
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id C72D7A9C;
        Mon, 21 Sep 2020 07:30:46 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 21 Sep 2020 07:30:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=AXcPvl
        9mq8NaLpPu95552MxmWKoiC0ilXCF1Mxomuwo=; b=D4SexDYWWPrMY2EUc3LfmH
        +3gSiSVz239M5V5mNbHhjDRZggjfprpaLCJcSl11WBgmnb6FBm8KSCshKNDYNVuR
        3pHkT/IWiRGd6VZOpFFR9PCIykmkoqs2ECVw2hqlNdC8XxTfzEcnjARh+sxcIrZN
        JFY+wAEA/42nlDYSQGbBioWxO5D+Z6rmcKlcT+XGb8KPIx/LP/8xVlzF3UrjeevP
        oc8ZWpXe5XMsFToekkrCCFo1DjE/jW2PJjIxA8MoZ/R8pNixonG4VdCYtGvCIYf5
        Kozwu/NifT0mbAW73Ldwn9pn2LlMHicHIV5nol9lmTNBvTtkR1UzIu6inyedDzMA
        ==
X-ME-Sender: <xms:5Y5oX1RHy11apQwL5qDeO9vntWKeeHnp9_PyhKD1TmGPoG0FcLe0mw>
    <xme:5Y5oX-zyCHMuScK0me-dLD8OeR30JpY_HDssJv-n1--m0XFrW9zJDX9ymgAX6OxP3
    -ZSdzJM9qPVVQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddvgdegudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeekhffhfefgfeehfeefudeguedvvdevgffgffdtudeuje
    fhhffgveeutddvtdejgfenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhrghen
    ucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:5Y5oX63O_5U3hTib2dVKXDVPM0F5Wjte62u4BnA6C0B8OmsX4vxJsQ>
    <xmx:5Y5oX9DZ-YN3kaWTG40N57d7LotL91yYlQZtZuxH7iQbibCEwm0jzg>
    <xmx:5Y5oX-hhFhOF0qot4zOa9uGc6ygT5OaxqZZWAugW6e2MGj-FuyAoSg>
    <xmx:5o5oXwYi42KI_Hzi7z7EkiySgET4gUQEWZ0UeDpt8Vgo0FRrgKoJzF063sw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 054D83064674;
        Mon, 21 Sep 2020 07:30:44 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915/gem: Delay tracking the GEM context until it is" failed to apply to 5.4-stable tree
To:     chris@chris-wilson.co.uk, cq.tang@intel.com, jani.nikula@intel.com,
        joonas.lahtinen@linux.intel.com, mika.kuoppala@linux.intel.com,
        rodrigo.vivi@intel.com, stable@vger.kernel.org,
        tvrtko.ursulin@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 21 Sep 2020 13:31:09 +0200
Message-ID: <1600687869951@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From e7d95527f27a6d9edcffbd74eee38e5cb6b91785 Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Thu, 30 Jul 2020 10:28:56 +0100
Subject: [PATCH] drm/i915/gem: Delay tracking the GEM context until it is
 registered

Avoid exposing a partially constructed context by deferring the
list_add() from the initial construction to the end of registration.
Otherwise, if we peek into the list of contexts from inside debugfs, we
may see the partially constructed context and chase down some dangling
incomplete pointers.

Reported-by: CQ Tang <cq.tang@intel.com>
Fixes: 3aa9945a528e ("drm/i915: Separate GEM context construction and registration to userspace")
References: f6e8aa387171 ("drm/i915: Report the number of closed vma held by each context in debugfs")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: CQ Tang <cq.tang@intel.com>
Cc: <stable@vger.kernel.org> # v5.2+
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200730092856.23615-1-chris@chris-wilson.co.uk
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
(cherry picked from commit eb4dedae920a07c485328af3da2202ec5184fb17)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_context.c b/drivers/gpu/drm/i915/gem/i915_gem_context.c
index d0bdb6d447ed..efc4ba34c06e 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_context.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_context.c
@@ -713,6 +713,7 @@ __create_context(struct drm_i915_private *i915)
 	ctx->i915 = i915;
 	ctx->sched.priority = I915_USER_PRIORITY(I915_PRIORITY_NORMAL);
 	mutex_init(&ctx->mutex);
+	INIT_LIST_HEAD(&ctx->link);
 
 	spin_lock_init(&ctx->stale.lock);
 	INIT_LIST_HEAD(&ctx->stale.engines);
@@ -740,10 +741,6 @@ __create_context(struct drm_i915_private *i915)
 	for (i = 0; i < ARRAY_SIZE(ctx->hang_timestamp); i++)
 		ctx->hang_timestamp[i] = jiffies - CONTEXT_FAST_HANG_JIFFIES;
 
-	spin_lock(&i915->gem.contexts.lock);
-	list_add_tail(&ctx->link, &i915->gem.contexts.list);
-	spin_unlock(&i915->gem.contexts.lock);
-
 	return ctx;
 
 err_free:
@@ -931,6 +928,7 @@ static int gem_context_register(struct i915_gem_context *ctx,
 				struct drm_i915_file_private *fpriv,
 				u32 *id)
 {
+	struct drm_i915_private *i915 = ctx->i915;
 	struct i915_address_space *vm;
 	int ret;
 
@@ -949,8 +947,16 @@ static int gem_context_register(struct i915_gem_context *ctx,
 	/* And finally expose ourselves to userspace via the idr */
 	ret = xa_alloc(&fpriv->context_xa, id, ctx, xa_limit_32b, GFP_KERNEL);
 	if (ret)
-		put_pid(fetch_and_zero(&ctx->pid));
+		goto err_pid;
+
+	spin_lock(&i915->gem.contexts.lock);
+	list_add_tail(&ctx->link, &i915->gem.contexts.list);
+	spin_unlock(&i915->gem.contexts.lock);
+
+	return 0;
 
+err_pid:
+	put_pid(fetch_and_zero(&ctx->pid));
 	return ret;
 }
 


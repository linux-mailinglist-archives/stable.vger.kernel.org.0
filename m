Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9129D24ED33
	for <lists+stable@lfdr.de>; Sun, 23 Aug 2020 14:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbgHWM3I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Aug 2020 08:29:08 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:37775 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727843AbgHWM3H (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Aug 2020 08:29:07 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id BD536194120D;
        Sun, 23 Aug 2020 08:29:06 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sun, 23 Aug 2020 08:29:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=gNDnjS
        OXYCjg7kRwhcB7gWK6zbs1r0icYRRML+NY6n0=; b=HSDxEmoKMC+tR+epbLDQBi
        EA/QHFjAjC8xtyWAuOJc2jU3uhJUfhCnOAZLlOXnjY4sQ8MghNnhdi1UB2FDZYse
        JBwMWHG1cPDtJ2Mf0zTBdn2oVC0EHynzOZEHWdQP0x2IsQj+36FKMteLxNxldeAj
        PHe8XZp4TLZb/KO+lisXHUN/YKwGj+I7MwWz+AQqe8CjKE17VAL9AcAEkmbEsjDY
        uZ0U8yD45CP9nQ0t9hOpaCnwcqzJImMQQ93ZubM5iTbQo0BpOkMrOCQ/dFy6Co0e
        chFuCvf2tfEsKoGqEm1xf9NwCo17bCwDjvS+B66jgCGJZKJGKmJ0QoXhw3G7+bRQ
        ==
X-ME-Sender: <xms:EmFCX5PwdtU5bSlZuQiiangilSmeOZUNGMP7r2f7zRT5O3RDh6oMvQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudduiedgheefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkefhhfefgfefheeffedugeeuvddvvefggffftdduue
    ejhffhgfevuedtvddtjefgnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurf
    grrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:EmFCX7-cQkmAjvH6z7GK1YSU-4UmbhcgVyoGAcc4SWyIko1vjvIWZA>
    <xmx:EmFCX4SvpCMWUoob9GZEdlOIr20d792o1RS2UKytDDQ36MZgMLqoow>
    <xmx:EmFCX1u_Yq2QvWbASz-kC5FJ2AH-lfSbRasGEsWXhQ-LlI6IOiYL-Q>
    <xmx:EmFCXxE7EveEEddL-B4q9fgV5L4w6Zz0JzTwNffvRWezQmLJh5V_gQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 300D23280063;
        Sun, 23 Aug 2020 08:29:06 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915: Provide the perf pmu.module" failed to apply to 5.8-stable tree
To:     chris@chris-wilson.co.uk, jani.nikula@intel.com,
        rodrigo.vivi@intel.com, tvrtko.ursulin@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Aug 2020 14:29:26 +0200
Message-ID: <159818576610439@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.8-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From df3ab3cb7eae63c6eb7c9aebcc196a75d59f65dd Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Thu, 16 Jul 2020 10:46:43 +0100
Subject: [PATCH] drm/i915: Provide the perf pmu.module

Rather than manually implement our own module reference counting for perf
pmu events, finally realise that there is a module parameter to struct
pmu for this very purpose.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: stable@vger.kernel.org
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200716094643.31410-1-chris@chris-wilson.co.uk
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
(cherry picked from commit 27e897beec1c59861f15d4d3562c39ad1143620f)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>

diff --git a/drivers/gpu/drm/i915/i915_pmu.c b/drivers/gpu/drm/i915/i915_pmu.c
index 28bc5f13ae52..056994224c6b 100644
--- a/drivers/gpu/drm/i915/i915_pmu.c
+++ b/drivers/gpu/drm/i915/i915_pmu.c
@@ -445,8 +445,6 @@ static void i915_pmu_event_destroy(struct perf_event *event)
 		container_of(event->pmu, typeof(*i915), pmu.base);
 
 	drm_WARN_ON(&i915->drm, event->parent);
-
-	module_put(THIS_MODULE);
 }
 
 static int
@@ -538,10 +536,8 @@ static int i915_pmu_event_init(struct perf_event *event)
 	if (ret)
 		return ret;
 
-	if (!event->parent) {
-		__module_get(THIS_MODULE);
+	if (!event->parent)
 		event->destroy = i915_pmu_event_destroy;
-	}
 
 	return 0;
 }
@@ -1130,6 +1126,7 @@ void i915_pmu_register(struct drm_i915_private *i915)
 	if (!pmu->base.attr_groups)
 		goto err_attr;
 
+	pmu->base.module	= THIS_MODULE;
 	pmu->base.task_ctx_nr	= perf_invalid_context;
 	pmu->base.event_init	= i915_pmu_event_init;
 	pmu->base.add		= i915_pmu_event_add;


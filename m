Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE5EF2B4CB8
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 18:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732743AbgKPR0S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 12:26:18 -0500
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:46683 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731210AbgKPR0S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 12:26:18 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 29C7539C;
        Mon, 16 Nov 2020 12:26:17 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 16 Nov 2020 12:26:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=meGSAM
        igWrzVdOSlEkKonba92QnlP/XLiA4+htsip8M=; b=FPwXl9p3PzsA+aAI7dI97i
        y1xi7HVbZ+NaTH/Ff6SKqoy3vbvKytEugS5ySML0f9J+1E7upVrGCw/SHIXGKxi4
        M08xoex392gRTSGjMPcC12GZf4ASRzndDfVwLJSFslJAKqP3Pql+POx3emPpafSG
        rlA0V+zXHoKRt8Z9+5uERuGyze564cYsnMfDmqiI9rvYZHH+DcywKgweEUy5wPqT
        hsLkrHt6WDDsddeDfYL96FEC6GpHy7QpAshBn4/tIjcH45BdBjZKAqjfnNcdTgDq
        JOVWtWbu2B/uIwvLPILalevzk7M1NNexN2JNT6DuQeRSZQgDJjCNyJqc6uNlS+GQ
        ==
X-ME-Sender: <xms:OLayX-1YqgppPuffk0EpPUzsYMdmzr8cCN_ulzrF8JnG9PcOCX68NA>
    <xme:OLayXxHn3l4v10PblCGVx1PzM2qbqu-Nftcfuo5aTzARsy-mJns-iWtXJ-kFHbv8R
    kMG0YUa3gaHhQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudefuddguddtvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeekhffhfefgfeehfeefudeguedvvdevgffgffdtud
    eujefhhffgveeutddvtdejgfenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhr
    ghenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurf
    grrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:OLayX24AjmE6jQFBp7c7719u4IAV8tVSKYEiP_3PrzPmMlrGeCILyQ>
    <xmx:OLayX_1uJCzys2AIlOoIqmwPlrxAJDrXISXOYIhrjZRTKDw3WbWYng>
    <xmx:OLayXxFUunpACZafvxsIFLAl2mXGSpkbWi05pCH-xfMea9hx49GU6w>
    <xmx:OLayX1jkmQw_IKi8DDfeJdmW3nJ7aKqtC2NEytxQhk2o1DOmGMR9C5Aj2vo>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id EBB8D3064AA6;
        Mon, 16 Nov 2020 12:26:15 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/i915: Correctly set SFC capability for video engines" failed to apply to 5.4-stable tree
To:     venkata.s.dhanalakota@intel.com, chris@chris-wilson.co.uk,
        daniele.ceraolospurio@intel.com, matthew.d.roper@intel.com,
        rodrigo.vivi@intel.com, stable@vger.kernel.org,
        tvrtko.ursulin@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 Nov 2020 18:27:06 +0100
Message-ID: <1605547626149115@kroah.com>
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

From 5ce6861d36ed5207aff9e5eead4c7cc38a986586 Mon Sep 17 00:00:00 2001
From: Venkata Sandeep Dhanalakota <venkata.s.dhanalakota@intel.com>
Date: Thu, 5 Nov 2020 17:18:42 -0800
Subject: [PATCH] drm/i915: Correctly set SFC capability for video engines

SFC capability of video engines is not set correctly because i915
is testing for incorrect bits.

Fixes: c5d3e39caa45 ("drm/i915: Engine discovery query")
Cc: Matt Roper <matthew.d.roper@intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Venkata Sandeep Dhanalakota <venkata.s.dhanalakota@intel.com>
Signed-off-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: <stable@vger.kernel.org> # v5.3+
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Link: https://patchwork.freedesktop.org/patch/msgid/20201106011842.36203-1-daniele.ceraolospurio@intel.com
(cherry picked from commit ad18fa0f5f052046cad96fee762b5c64f42dd86a)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>

diff --git a/drivers/gpu/drm/i915/gt/intel_engine_cs.c b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
index 5bfb5f7ed02c..efdeb7b7b2a0 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_cs.c
+++ b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
@@ -371,7 +371,8 @@ static void __setup_engine_capabilities(struct intel_engine_cs *engine)
 		 * instances.
 		 */
 		if ((INTEL_GEN(i915) >= 11 &&
-		     engine->gt->info.vdbox_sfc_access & engine->mask) ||
+		     (engine->gt->info.vdbox_sfc_access &
+		      BIT(engine->instance))) ||
 		    (INTEL_GEN(i915) >= 9 && engine->instance == 0))
 			engine->uabi_capabilities |=
 				I915_VIDEO_AND_ENHANCE_CLASS_CAPABILITY_SFC;


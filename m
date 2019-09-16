Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BAB2B3D82
	for <lists+stable@lfdr.de>; Mon, 16 Sep 2019 17:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388978AbfIPPSe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Sep 2019 11:18:34 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:60931 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388505AbfIPPSd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Sep 2019 11:18:33 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 00DCA6C1;
        Mon, 16 Sep 2019 11:18:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 16 Sep 2019 11:18:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=0Wt/pY
        93Q3rDDp1/4tfHg6ZAUXDiL/3m40Vm3wiazT8=; b=OSMFTwKEaUqda7o+Oy30bU
        c03o1tP0J4MWY7sRsoE77A+0K213IQvWUxvjPhHoy4l8JA9fEya4QksE0qskRhxx
        ttqUm2aSzf/2qKjoLpB20tOpQEIslK2UDm7tcagzI7xenWXxntqr3KCI0pp35TP0
        D3NIVlbwvUys0gor1JYDe0CPVwYHhoyZUsMQLcWViRgLgH2mlwDow+hB4d6dvWP/
        QtyId8Smy2wSfTd90CJvF34v83sZRTs1Uqq0HzY1ivJK+j6rB0PY7dS5MtlUP1ri
        7EDp91xfny/0hrhgIOQVwFvr+KxV6F2FR0DWkWVgJctQiliWmw3BHXP2eo6CeATw
        ==
X-ME-Sender: <xms:yKd_XQRqLFIasSPegIOXbWm61EU4UXBRrzzvczcg_QQD0F93oQlokQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudefgdekjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhrghenucfkphepkeefrdekie
    drkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdr
    tghomhenucevlhhushhtvghrufhiiigvpeef
X-ME-Proxy: <xmx:yKd_XVl3KTas5nbSXT-oCMr_EXPAfTGUFpWOXiNkh95_Qt9ZhVB_WA>
    <xmx:yKd_XZNfMu9S707ClaCKMjl7bD1bNkrYFEW5JJ5Oqv3-oQgb152hmg>
    <xmx:yKd_Xd0bmdr0ZtCSQ-Vw5tCLn8MvOUOQfcZkFvywaS44FB7hqC6B-Q>
    <xmx:yKd_XdcsbfeWLlSyjgexoeR_krw76mWwDDjm3r5FIKjktGSOxReE3A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1FD5D80068;
        Mon, 16 Sep 2019 11:18:32 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915: Restore relaxed padding (OCL_OOB_SUPPRES_ENABLE)" failed to apply to 4.4-stable tree
To:     chris@chris-wilson.co.uk, jani.nikula@intel.com,
        jason@jlekstrand.net, mika.kuoppala@linux.intel.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 Sep 2019 17:18:28 +0200
Message-ID: <15686471088323@kroah.com>
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

From 2eb0964eec5f1d99f9eaf4963eee267acc72b615 Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Wed, 4 Sep 2019 11:07:07 +0100
Subject: [PATCH] drm/i915: Restore relaxed padding (OCL_OOB_SUPPRES_ENABLE)
 for skl+

This bit was fliped on for "syncing dependencies between camera and
graphics". BSpec has no recollection why, and it is causing
unrecoverable GPU hangs with Vulkan compute workloads.

From BSpec, setting bit5 to 0 enables relaxed padding requirements for
buffers, 1D and 2D non-array, non-MSAA, non-mip-mapped linear surfaces;
and *must* be set to 0h on skl+ to ensure "Out of Bounds" case is
suppressed.

Reported-by: Jason Ekstrand <jason@jlekstrand.net>
Suggested-by: Jason Ekstrand <jason@jlekstrand.net>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=110998
Fixes: 8424171e135c ("drm/i915/gen9: h/w w/a: syncing dependencies between camera and graphics")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Tested-by: denys.kostin@globallogic.com
Cc: Jason Ekstrand <jason@jlekstrand.net>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: <stable@vger.kernel.org> # v4.1+
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190904100707.7377-1-chris@chris-wilson.co.uk
(cherry picked from commit 9d7b01e93526efe79dbf75b69cc5972b5a4f7b37)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>

diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c b/drivers/gpu/drm/i915/gt/intel_workarounds.c
index 98dfb086320f..99e8242194c0 100644
--- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
@@ -308,11 +308,6 @@ static void gen9_ctx_workarounds_init(struct intel_engine_cs *engine,
 			  FLOW_CONTROL_ENABLE |
 			  PARTIAL_INSTRUCTION_SHOOTDOWN_DISABLE);
 
-	/* Syncing dependencies between camera and graphics:skl,bxt,kbl */
-	if (!IS_COFFEELAKE(i915))
-		WA_SET_BIT_MASKED(HALF_SLICE_CHICKEN3,
-				  GEN9_DISABLE_OCL_OOB_SUPPRESS_LOGIC);
-
 	/* WaEnableYV12BugFixInHalfSliceChicken7:skl,bxt,kbl,glk,cfl */
 	/* WaEnableSamplerGPGPUPreemptionSupport:skl,bxt,kbl,cfl */
 	WA_SET_BIT_MASKED(GEN9_HALF_SLICE_CHICKEN7,


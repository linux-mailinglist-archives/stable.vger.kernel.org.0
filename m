Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF64B3D80
	for <lists+stable@lfdr.de>; Mon, 16 Sep 2019 17:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388974AbfIPPSb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Sep 2019 11:18:31 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:43481 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388505AbfIPPSb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Sep 2019 11:18:31 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 2EF296E6;
        Mon, 16 Sep 2019 11:18:30 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 16 Sep 2019 11:18:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=YJ+xwe
        sCB66tARjyPwGZFD5H/ZzHja5GOk3elh651zg=; b=tFe/JvaAoF5x8qqxOvOJwn
        iILUnUCVzdIgBX/hYZvroeM9qnGW9/Pgkji9hCBMUmeUPS+ezqU6nboppkj2WM4W
        jpepuNrKThcQBPW/C8Ftj0PDoG8oRb6ecFRb5CauopEml5EWJFBPsbqS/YlIqLkI
        WOVznYt5qf5ma/c8uR+99nq7ppFHPWPP77KSK1/vPlZOpx7Wix3anZ0t0f3VbC3q
        FurSfswzZV8ZSTzDShw0vyRNvZBjfGRe3JtD/hVaRRm9FtKa7V/PUR8F0Q3XqQxj
        fI+rtDEff+VXrfh8YzZmvy6YB5MvGGb2CwybKoF26+kJ6F2EVUoW8m4vg0LQ0iUA
        ==
X-ME-Sender: <xms:xad_XYgA3MF50UjSpZPLarhtn-Gpjs9XU9L2hGRMQQxvlSj4PqDBgA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudefgdekjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhrghenucfkphepkeefrdekie
    drkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdr
    tghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:xad_XV5d16LsaeaRoZSi9sbPgLacaRC8vHlYQPbE8209F0L8cnwZ9g>
    <xmx:xad_XdpFacKFs6AL8ru7tksyO53NKHDPO-irA5CDdJD7apCniQltpA>
    <xmx:xad_XbVpL9m6mPP1jkXXhFNqPkep8OiHDvKNYqt3Gr7hq9w0jifocA>
    <xmx:xad_XQBebuVLh9qmkx6JJnBVjUCtzBFkqpG5jcoG8eT4W5Gwy6hj5Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 774E0D60062;
        Mon, 16 Sep 2019 11:18:29 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915: Restore relaxed padding (OCL_OOB_SUPPRES_ENABLE)" failed to apply to 4.14-stable tree
To:     chris@chris-wilson.co.uk, jani.nikula@intel.com,
        jason@jlekstrand.net, mika.kuoppala@linux.intel.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 Sep 2019 17:18:26 +0200
Message-ID: <15686471069344@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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


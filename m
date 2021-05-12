Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81F4437B995
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 11:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbhELJts (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 05:49:48 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:37283 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230019AbhELJtr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 05:49:47 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 80E1B148A;
        Wed, 12 May 2021 05:48:39 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 12 May 2021 05:48:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=1Y90C3
        lNBR06ISMwGP4w79j8LT8zRaI8Iz6LqdI3lBc=; b=r3mlHgC5ABTvFRbYtc3U9Y
        Kj7nQQ/I4lCVaZjtFUit46nCHbWqscY2EOdBfxaL8j05RakLChR5ok2RMaDWl+AJ
        HSUxpqK4pmiaKMV8zBFipZyDnK9Ux+MD4VqjGJ/WalHQOqAM8vNb0i/v4yb9HCtL
        tUTsgFO5F6VbxAO1zz/6pqaFJP2ZkCVFraNPHOH/j7WwXIIDXGa5iIATMm3n1EsE
        Fgzvy0xtsjPhu6Ybje+dLcmvDv4fKfGPr/lpXrOE+OjkeMz/EgJCg1OvJhUlm1mi
        B8gtbejO6gYvrxfWXP5CM843bgVnhJf270j/0tLenIqCLIxNEaqgXxrL4Z4Nnx2Q
        ==
X-ME-Sender: <xms:dqSbYJt5zvuFOkaMbcSc6hiGeBYRE3WjwGDYAkeTWm15NxS3oLjSKw>
    <xme:dqSbYCclBYUIKcf3eI3pbydiLfLbP-WbGkqbmbKQwjp0tU6ZiXBj03uQSYRtS-SkV
    6lVY_Jfy9ulpA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepvdffgeejjeeitdeiffejieejfffghedviedujeehfe
    egvefhhfevvdefueehkeelnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:dqSbYMwz5kuY2mp0ffwzIAYrPtViFwk4NcmLj3XCdwPGgeneOubfzw>
    <xmx:dqSbYAPCgBD3xDK6lXdgjcgDbxBnFsmEFy0Ew2ohTdGjdMETw9tkDA>
    <xmx:dqSbYJ8RKWYaGK8WD4jiO2073wP3ig9OonUUlj6_LnBMlf2tHHQmiQ>
    <xmx:d6SbYLnq3hvBW6vlYNNGSWy1JQQs6zRzdtzZLrawfQwYyHIHFCGY-KEGhaI>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 05:48:38 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915: Disable LTTPR support when the LTTPR rev < 1.4" failed to apply to 5.12-stable tree
To:     imre.deak@intel.com, stable@vger.kernel.org,
        ville.syrjala@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 11:48:36 +0200
Message-ID: <162081291668163@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.12-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1663ad4936e0679443a315fe342f99636a2420dd Mon Sep 17 00:00:00 2001
From: Imre Deak <imre.deak@intel.com>
Date: Wed, 17 Mar 2021 20:49:01 +0200
Subject: [PATCH] drm/i915: Disable LTTPR support when the LTTPR rev < 1.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

By the specification the 0xF0000 - 0xF02FF range is only valid if the
LTTPR revision at 0xF0000 is at least 1.4. Disable the LTTPR support
otherwise.

Fixes: 7b2a4ab8b0ef ("drm/i915: Switch to LTTPR transparent mode link training")
Cc: <stable@vger.kernel.org> # v5.11
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210317184901.4029798-4-imre.deak@intel.com

diff --git a/drivers/gpu/drm/i915/display/intel_dp_link_training.c b/drivers/gpu/drm/i915/display/intel_dp_link_training.c
index f14ac2694183..7d4e6f3e7e93 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_link_training.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_link_training.c
@@ -100,17 +100,23 @@ static bool intel_dp_read_lttpr_common_caps(struct intel_dp *intel_dp)
 		return false;
 
 	if (drm_dp_read_lttpr_common_caps(&intel_dp->aux,
-					  intel_dp->lttpr_common_caps) < 0) {
-		intel_dp_reset_lttpr_common_caps(intel_dp);
-		return false;
-	}
+					  intel_dp->lttpr_common_caps) < 0)
+		goto reset_caps;
 
 	drm_dbg_kms(&dp_to_i915(intel_dp)->drm,
 		    "LTTPR common capabilities: %*ph\n",
 		    (int)sizeof(intel_dp->lttpr_common_caps),
 		    intel_dp->lttpr_common_caps);
 
+	/* The minimum value of LT_TUNABLE_PHY_REPEATER_FIELD_DATA_STRUCTURE_REV is 1.4 */
+	if (intel_dp->lttpr_common_caps[0] < 0x14)
+		goto reset_caps;
+
 	return true;
+
+reset_caps:
+	intel_dp_reset_lttpr_common_caps(intel_dp);
+	return false;
 }
 
 static bool


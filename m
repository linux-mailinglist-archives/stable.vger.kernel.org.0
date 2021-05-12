Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1298837B996
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 11:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbhELJtz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 05:49:55 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:43715 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230019AbhELJtz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 05:49:55 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 726DD1461;
        Wed, 12 May 2021 05:48:47 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 12 May 2021 05:48:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=tjUVkF
        48ldXFWxK1UznoHo1xJsrB5mtWR07KqMtTedk=; b=odBF78O7LOEJrCFVrr+K29
        SK2WcuePb1MhC3eutpiTGfdQR0gOm906Ul3zo3gQmhd8YL4jyUM11Ut/ImYkHRgK
        gizSAxeSkBUpRv7C9TwabYgnlSV5u7pxv5+LxKyWvDZhS04RvxxVfJ68UR3OurGa
        XZqMqcNOQlBD6PfokjwfbJjYRZTTM22khLKZOadPvfLTpXwV7SEv3usq/uCA/mI+
        98RFd0XXgQ1GDM8sRIxiIrVmnrpQZaJAtvALROi8y64lg33ct33OqnuQ9BDTU8Pe
        SORzBfA1hHR6/P76+K8nxK0zZdz4iXO5oV4aB2bFBFV0yGZaWLHORX/oBAvQ1t7w
        ==
X-ME-Sender: <xms:fqSbYFDP-InT-KnEBQjCVfTT_qYplFE-BwO3ny83PuKsH6yrkhyw5g>
    <xme:fqSbYDhB6A7fWIty59rWX0vRA_HycO7hZ1C1x4INqCaR6Uin5ggUSJWTLtz5tIGl1
    q8WCnuZblSFhQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepvdffgeejjeeitdeiffejieejfffghedviedujeehfe
    egvefhhfevvdefueehkeelnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:fqSbYAltfKowpc02A0GAl_I2FWABEeyXoWRFF9EgNT-0JCRxVaCn5w>
    <xmx:fqSbYPzuH_iokhTRklAWph-8r7ldcWrQz87dAfgT1dVT4a-WbF-lDA>
    <xmx:fqSbYKTt4mqmVw4h91jRWYxKD7BjjCTB7auXPhAzf-fnigNOdj1KmQ>
    <xmx:f6SbYNJdT_vO_StAIvHi9ZIlOBTXkgB_qSkFN_SAPjaNQqabzhGB3QJukkk>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 05:48:46 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915: Disable LTTPR support when the LTTPR rev < 1.4" failed to apply to 5.11-stable tree
To:     imre.deak@intel.com, stable@vger.kernel.org,
        ville.syrjala@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 11:48:36 +0200
Message-ID: <1620812916239218@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.11-stable tree.
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


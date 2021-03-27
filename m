Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 111A134B788
	for <lists+stable@lfdr.de>; Sat, 27 Mar 2021 15:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbhC0OUT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Mar 2021 10:20:19 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:41491 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230015AbhC0OUN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 27 Mar 2021 10:20:13 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 93FDA163E;
        Sat, 27 Mar 2021 10:20:12 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 27 Mar 2021 10:20:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=B9oGdd
        cNhsuYlMqG3Rjyt8QDXbIYNj0Awvgsu2FdlG8=; b=LpFgmyI8DZjtQNwn+vInbD
        4tE+eKSlZ0AghweTLJhYhzgQPuDzzjks6hSfXPSZJ6haBM329DnUjcmdLMVzGPPC
        Q75dcfJlxuIXBstXmpPsYZqVZFPx9tZErNZXd6SpqQNaNLy8qG/LBtyFxpeiBU6a
        PyaNZKZvbBX5sdGCUpwrFjBGf3yJMEUwoo1m2wqfnSyYJVjNQdjTT09Iw5HK2fln
        A0/m6aCxxSnnOWvOAGWnjdgwR9Z7SDxJ8HGOQrjG9CMQbEkt9wtQpnJwdzlT6prR
        MWsYVerwRG3tWexsXzg5yfWglH6D3diW42riRagyTVEXilRMx8sTJ8wRf/lK89zA
        ==
X-ME-Sender: <xms:HD9fYJe5zRNFbrtM_PPXxz1RHGk4JUw2gCcMdvTOkb7c699N_P5RPw>
    <xme:HD9fYHPLf5Trt9JfoP0e20lQ0rmq4ndwFopilmM-NRIdDG9J8WeoB4MLZs88nvkKp
    PXPKsESwSOl5A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudehgedgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepvdffgeejjeeitdeiffejieejfffghedviedujeehfe
    egvefhhfevvdefueehkeelnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:HD9fYChKl0o9km7_q8Wx1QLSHBOodbEBjWf7nAYn98izK_rjte-paA>
    <xmx:HD9fYC_vzQBk518jzG60vk5zd8z5ym1cOQ9maNuscYdYXckWDNTPng>
    <xmx:HD9fYFvVKtq5u9HG5mt4c4XG2v95v9uXgGeKy8AYPGoq7opsbh4w4w>
    <xmx:HD9fYGURPOBQxpo9HWw9Hq_O6wUmzaDneQ-yPhnO9ylasggBFJDZ25hfckE>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id CEF011080057;
        Sat, 27 Mar 2021 10:20:11 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915: Disable LTTPR support when the LTTPR rev < 1.4" failed to apply to 5.11-stable tree
To:     imre.deak@intel.com, rodrigo.vivi@intel.com,
        stable@vger.kernel.org, ville.syrjala@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 27 Mar 2021 15:20:10 +0100
Message-ID: <1616854810240220@kroah.com>
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

From ab03631087f5c296030dd86265ea02dcdacc6802 Mon Sep 17 00:00:00 2001
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
(cherry picked from commit 1663ad4936e0679443a315fe342f99636a2420dd)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>

diff --git a/drivers/gpu/drm/i915/display/intel_dp_link_training.c b/drivers/gpu/drm/i915/display/intel_dp_link_training.c
index c10e81a3d64f..be6ac0dd846e 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_link_training.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_link_training.c
@@ -99,17 +99,23 @@ static bool intel_dp_read_lttpr_common_caps(struct intel_dp *intel_dp)
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


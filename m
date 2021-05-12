Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54BD137B985
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 11:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbhELJsX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 05:48:23 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:59965 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230019AbhELJsX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 05:48:23 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id C12D21401;
        Wed, 12 May 2021 05:47:14 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 12 May 2021 05:47:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=JpTvB9
        q5+5SS+eQYpKhJOj9F0O4g8v/c+zWd5FagLy0=; b=c044FiIiwWkLxvWN+G9PMr
        znYEvho1nb9Z7O6TEDBRM8iq/XsJ2GFELieHLZ7EtMoy6Wb+mKsE38c/2r2L57II
        v0OQptiVRe4cUyMwsHh7RinXyrJ2EkDu+MZr+t2KBEvD9PpVci7A0Xk1rDegW9L5
        iCgebrdtdKv2Qk24VSBMGmeBTeDr62gmXky+9D6lLPs8lGRlfAAmCedrW7ZF/JAj
        pRM97Y8pzNmbrHIDJpG+iQ2vzdZA7aTIcBmbm7fiXHolVPuIsQ1ndua9RBftYwfK
        LTQvApdtH2VHvi2SCNdjad0DE9qAslGz3FgJh06uM3hFwKA+sOw55+yCoLkmg9JA
        ==
X-ME-Sender: <xms:IaSbYLr6lFpQO_D0gU0VaAhoGiee_YVGx8El-vSHmDSbmLosrSRmjw>
    <xme:IaSbYFr5HyIo3k1iJevBzK0_9o7acyBxkjtb4xFMssA4Cj9xzTOe78XM-EbDGH9r8
    m3mrh-LHDP29w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepvdffgeejjeeitdeiffejieejfffghedviedujeehfe
    egvefhhfevvdefueehkeelnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:IqSbYINf_COfxzHVM9u9M2pdHAUX5GTptW-RUe4aDpSG0iJGJ85-Zw>
    <xmx:IqSbYO7I6_tQK7MeijWW202-gv0s-2rOtW7nqIdRzac9PZqJyJudRg>
    <xmx:IqSbYK4llvUwVVv1xin9PRvngSAkuuOtRGYDcL_mm7DlymnV1dPvKg>
    <xmx:IqSbYF0nk1VXIa1Q0ziuHQ_aTOnkrSA8KgDlHHOcMSlULlrH1Eqoepgt4Ms>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 05:47:13 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915/ilk-glk: Fix link training on links with LTTPRs" failed to apply to 5.11-stable tree
To:     imre.deak@intel.com, mail@bodograumann.de,
        santiago.zarate@suse.com, stable@vger.kernel.org, tiwai@suse.de,
        ville.syrjala@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 11:47:12 +0200
Message-ID: <162081283213412@kroah.com>
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

From 984982f3ef7b240cd24c2feb2762d81d9d8da3c2 Mon Sep 17 00:00:00 2001
From: Imre Deak <imre.deak@intel.com>
Date: Wed, 17 Mar 2021 20:48:59 +0200
Subject: [PATCH] drm/i915/ilk-glk: Fix link training on links with LTTPRs
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The spec requires to use at least 3.2ms for the AUX timeout period if
there are LT-tunable PHY Repeaters on the link (2.11.2). An upcoming
spec update makes this more specific, by requiring a 3.2ms minimum
timeout period for the LTTPR detection reading the 0xF0000-0xF0007
range (3.6.5.1).

Accordingly disable LTTPR detection until GLK, where the maximum timeout
we can set is only 1.6ms.

Link training in the non-transparent mode is known to fail at least on
some SKL systems with a WD19 dock on the link, which exposes an LTTPR
(see the References below). While this could have different reasons
besides the too short AUX timeout used, not detecting LTTPRs (and so not
using the non-transparent LT mode) fixes link training on these systems.

While at it add a code comment about the platform specific maximum
timeout values.

v2: Add a comment about the g4x maximum timeout as well. (Ville)

Reported-by: Takashi Iwai <tiwai@suse.de>
Reported-and-tested-by: Santiago Zarate <santiago.zarate@suse.com>
Reported-and-tested-by: Bodo Graumann <mail@bodograumann.de>
References: https://gitlab.freedesktop.org/drm/intel/-/issues/3166
Fixes: b30edfd8d0b4 ("drm/i915: Switch to LTTPR non-transparent mode link training")
Cc: <stable@vger.kernel.org> # v5.11
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210317184901.4029798-2-imre.deak@intel.com

diff --git a/drivers/gpu/drm/i915/display/intel_dp_aux.c b/drivers/gpu/drm/i915/display/intel_dp_aux.c
index eaebf123310a..10fe17b7280d 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_aux.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_aux.c
@@ -133,6 +133,7 @@ static u32 g4x_get_aux_send_ctl(struct intel_dp *intel_dp,
 	else
 		precharge = 5;
 
+	/* Max timeout value on G4x-BDW: 1.6ms */
 	if (IS_BROADWELL(dev_priv))
 		timeout = DP_AUX_CH_CTL_TIME_OUT_600us;
 	else
@@ -159,6 +160,12 @@ static u32 skl_get_aux_send_ctl(struct intel_dp *intel_dp,
 	enum phy phy = intel_port_to_phy(i915, dig_port->base.port);
 	u32 ret;
 
+	/*
+	 * Max timeout values:
+	 * SKL-GLK: 1.6ms
+	 * CNL: 3.2ms
+	 * ICL+: 4ms
+	 */
 	ret = DP_AUX_CH_CTL_SEND_BUSY |
 	      DP_AUX_CH_CTL_DONE |
 	      DP_AUX_CH_CTL_INTERRUPT |
diff --git a/drivers/gpu/drm/i915/display/intel_dp_link_training.c b/drivers/gpu/drm/i915/display/intel_dp_link_training.c
index 19ba7c7cbaab..c0e25c75c105 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_link_training.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_link_training.c
@@ -82,6 +82,18 @@ static void intel_dp_read_lttpr_phy_caps(struct intel_dp *intel_dp,
 
 static bool intel_dp_read_lttpr_common_caps(struct intel_dp *intel_dp)
 {
+	struct drm_i915_private *i915 = dp_to_i915(intel_dp);
+
+	if (intel_dp_is_edp(intel_dp))
+		return false;
+
+	/*
+	 * Detecting LTTPRs must be avoided on platforms with an AUX timeout
+	 * period < 3.2ms. (see DP Standard v2.0, 2.11.2, 3.6.6.1).
+	 */
+	if (INTEL_GEN(i915) < 10)
+		return false;
+
 	if (drm_dp_read_lttpr_common_caps(&intel_dp->aux,
 					  intel_dp->lttpr_common_caps) < 0) {
 		memset(intel_dp->lttpr_common_caps, 0,
@@ -127,9 +139,6 @@ int intel_dp_lttpr_init(struct intel_dp *intel_dp)
 	bool ret;
 	int i;
 
-	if (intel_dp_is_edp(intel_dp))
-		return 0;
-
 	ret = intel_dp_read_lttpr_common_caps(intel_dp);
 	if (!ret)
 		return 0;


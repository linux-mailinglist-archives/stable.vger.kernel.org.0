Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61E16312F55
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 11:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232537AbhBHKou (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 05:44:50 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:52491 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232254AbhBHKmj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 05:42:39 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id C59C499C;
        Mon,  8 Feb 2021 05:41:27 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 08 Feb 2021 05:41:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Xxbuak
        9Qj+P8NkuHyKfwt1+y94kc2anDBGzhJZ685BU=; b=u4nuRm9F2v1h4tX04+uusv
        7mayqiOp5U4J0vgaLZimIcqT/JIT85xsozxXpXJ8Evugd2Dx6wdBTHtQe97jHsVt
        GOnF/RGROK4KN/2NMUshZBqSQnNG0ekmDncXjXcqFuSHbKEgAQNrQg+ghH2aFz7T
        k3YW8XGgFih/RTm/EY0GYBgU0pfMQEFrjS311PjRCEzxaWwPnR9J9z8grCqYc5r+
        Xwl/bBkkRVs7btndykDjdkMsZM6QSe9Isb+BAJHD997mtXFLsczQkhLBo0F0pxPP
        btbZAfycUGcTKNruzH+8o+HzgIVAYqAHrC4nEjA4f7QZ7nA3uFRsvfz8uHVonXpg
        ==
X-ME-Sender: <xms:VhUhYBDCcxinBDpL3H22c3NTM80uJjWk2EkpUxATBHPfDjpTeqLdCw>
    <xme:VhUhYPeB2ZiLKn7-N4kHDTrtpb5re-Ru9vq_8eSceWhMMjjQZ4_jHlN39Gn4nFEqN
    FxeaS9dg3jw8A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrheefgddujecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    ejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpedvffegjeejiedtieffjeeijeffgfehvdeiudejheefge
    evhffhvedvfeeuheekleenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhrghen
    ucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:VhUhYJc1OSKJGGCxEfMykfiip81iEmwLQ9EN7bqF3QOBXdHUcl_bhQ>
    <xmx:VhUhYDhoYBMA5g9mHS0v4lKD0j2ClKsTnzzNqDZx-Grb0hWT6gpc3A>
    <xmx:VhUhYFS5TZA3K7_iMugv6QX0W5ArGrLfMI-EcErGtxCXDZ-vDz-LAg>
    <xmx:VxUhYPNo6L-zeuHBPdR9vpwaboou3jGpQi1hBuMifs6m3t43WqBjaXnM5uk>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 34245108005B;
        Mon,  8 Feb 2021 05:41:26 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/i915: Skip vswing programming for TBT" failed to apply to 5.10-stable tree
To:     ville.syrjala@linux.intel.com, imre.deak@intel.com,
        jani.nikula@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 08 Feb 2021 11:41:19 +0100
Message-ID: <16127808794868@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From eaf5bfe37db871031232d2bf2535b6ca92afbad8 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>
Date: Thu, 28 Jan 2021 17:59:44 +0200
Subject: [PATCH] drm/i915: Skip vswing programming for TBT
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

In thunderbolt mode the PHY is owned by the thunderbolt controller.
We are not supposed to touch it. So skip the vswing programming
as well (we already skipped the other steps not applicable to TBT).

Touching this stuff could supposedly interfere with the PHY
programming done by the thunderbolt controller.

Cc: stable@vger.kernel.org
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210128155948.13678-1-ville.syrjala@linux.intel.com
Reviewed-by: Imre Deak <imre.deak@intel.com>
(cherry picked from commit f8c6b615b921d8a1bcd74870f9105e62b0bceff3)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>

diff --git a/drivers/gpu/drm/i915/display/intel_ddi.c b/drivers/gpu/drm/i915/display/intel_ddi.c
index bf17365857ca..e1e3ac12f979 100644
--- a/drivers/gpu/drm/i915/display/intel_ddi.c
+++ b/drivers/gpu/drm/i915/display/intel_ddi.c
@@ -2754,6 +2754,9 @@ static void icl_mg_phy_ddi_vswing_sequence(struct intel_encoder *encoder,
 	int n_entries, ln;
 	u32 val;
 
+	if (enc_to_dig_port(encoder)->tc_mode == TC_PORT_TBT_ALT)
+		return;
+
 	ddi_translations = icl_get_mg_buf_trans(encoder, crtc_state, &n_entries);
 	if (level >= n_entries) {
 		drm_dbg_kms(&dev_priv->drm,
@@ -2890,6 +2893,9 @@ tgl_dkl_phy_ddi_vswing_sequence(struct intel_encoder *encoder,
 	u32 val, dpcnt_mask, dpcnt_val;
 	int n_entries, ln;
 
+	if (enc_to_dig_port(encoder)->tc_mode == TC_PORT_TBT_ALT)
+		return;
+
 	ddi_translations = tgl_get_dkl_buf_trans(encoder, crtc_state, &n_entries);
 
 	if (level >= n_entries)


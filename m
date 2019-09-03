Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C36EA7309
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 21:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725955AbfICTDO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 15:03:14 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:41215 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725882AbfICTDO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Sep 2019 15:03:14 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id A3671210AC;
        Tue,  3 Sep 2019 15:03:13 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 03 Sep 2019 15:03:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=DL83Cb
        DbETmtiajbaKf6vXPTh53UlSVAPx4gx3dbiFY=; b=mQh+fqYHkfuXK5tU1e1aDD
        yeflIO54U97MynQMQTWIhqAcgk+uMhkGBPRuh09PV6/s0rcAQFwPRQnJTFOln4D1
        uO6wDcbiFyBiTz954lSivQDbV0Cot8viITBNYjjUI/lntYfGSPfYtGl34c1vNv8G
        gbXB/N6KCkFRr3biKUAXMqPmNDTdIlKXOpcRY4g1KWwKo7f0iXymM3BN37JjnZZ1
        tBFM2mamROz/+Xx39Yl6brk7WIQ729oCb6JeG9FwWrM93Gqy63+CQckyQxj0otFO
        A1xMXnW+C3pBnQS6ZKp+8EQyIO3mCCkyQ2RF/6Z5lE/Zl0TtBy2W2K2C8EvwolxA
        ==
X-ME-Sender: <xms:8bhuXXfxoIslGR6XDS0DTA4lGL2WVVWEPTgkQKlg4iZE1QdJvK6MCA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudejfedguddtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhrghenucfkphepkeefrd
    ekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgr
    hhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:8bhuXXfyHHSCLhBGef3fQ9mmAQ-P0Kg0EBaK71E1pCxRrCCPhn6tDg>
    <xmx:8bhuXffSIie4_FApPxCsYmc0RkV7ZSHQTQzF0FK5x7ga2xYji4MpIQ>
    <xmx:8bhuXQncUL_PD5VQaFlSFeW1sMoqEGk2ydDkUS_AAN4ALlZPmSoznA>
    <xmx:8bhuXSJsczGUVu4dVSNBJ-mM4SsJNoOAWB1NMx2wa4A__aMwjp58pw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4E1B8D6005A;
        Tue,  3 Sep 2019 15:03:13 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915/dp: Fix DSC enable code to use cpu_transcoder" failed to apply to 5.2-stable tree
To:     manasi.d.navare@intel.com, jani.nikula@intel.com,
        jani.nikula@linux.intel.com, maarten.lankhorst@linux.intel.com,
        stable@vger.kernel.org, ville.syrjala@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Sep 2019 21:03:12 +0200
Message-ID: <156753739120970@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.2-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5b6eefd667847ca6bd6925f7bd1afcecc457c889 Mon Sep 17 00:00:00 2001
From: Manasi Navare <manasi.d.navare@intel.com>
Date: Wed, 21 Aug 2019 14:59:50 -0700
Subject: [PATCH] drm/i915/dp: Fix DSC enable code to use cpu_transcoder
 instead of encoder->type

This patch fixes the intel_configure_pps_for_dsc_encoder() function to use
cpu_transcoder instead of encoder->type to select the correct DSC registers
that was wrongly used in the original patch for one DSC register isntance.

Fixes: 7182414e2530 ("drm/i915/dp: Configure i915 Picture parameter Set registers during DSC enabling")
Cc: Ville Syrjala <ville.syrjala@linux.intel.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: <stable@vger.kernel.org> # v5.0+
Signed-off-by: Manasi Navare <manasi.d.navare@intel.com>
Reviewed-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190821215950.24223-1-manasi.d.navare@intel.com
(cherry picked from commit d4c61c4a16decd8ace8660f22c81609a539fccba)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>

diff --git a/drivers/gpu/drm/i915/display/intel_vdsc.c b/drivers/gpu/drm/i915/display/intel_vdsc.c
index ffec807b8960..f413904a3e96 100644
--- a/drivers/gpu/drm/i915/display/intel_vdsc.c
+++ b/drivers/gpu/drm/i915/display/intel_vdsc.c
@@ -541,7 +541,7 @@ static void intel_configure_pps_for_dsc_encoder(struct intel_encoder *encoder,
 	pps_val |= DSC_PIC_HEIGHT(vdsc_cfg->pic_height) |
 		DSC_PIC_WIDTH(vdsc_cfg->pic_width / num_vdsc_instances);
 	DRM_INFO("PPS2 = 0x%08x\n", pps_val);
-	if (encoder->type == INTEL_OUTPUT_EDP) {
+	if (cpu_transcoder == TRANSCODER_EDP) {
 		I915_WRITE(DSCA_PICTURE_PARAMETER_SET_2, pps_val);
 		/*
 		 * If 2 VDSC instances are needed, configure PPS for second


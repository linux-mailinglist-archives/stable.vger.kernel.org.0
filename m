Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13937261FB6
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 22:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbgIHUGH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 16:06:07 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:45329 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730356AbgIHPVx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Sep 2020 11:21:53 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id DF4013A7;
        Tue,  8 Sep 2020 08:36:17 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 08 Sep 2020 08:36:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Ni13fB
        1iW6o8bCI0xHQDN2lGlA6wTEiSQMdQuHroRrc=; b=bXCms11ACZegYZ/Fayj9kD
        /wUgffYpmKP+Hy3qcsGCS1IiHgSxBZPyauY7+0ZBnb1AtZCFwHstEjguDhju/UZ1
        w4bMwhps8bBWIM6aHDSgH33j3yiQuZQvdPC+l7s0HndaQz1K3ItF/OzxXJEctt+A
        tYk2cIPtZ6c1CmJMXYedcIKlCTPH4ZUVaaKHj1LNHHrsIfei8GTmaYq31Dh3YGlw
        EPgmffmhJsvj+TKSmoVrDMWd571lMvUcUhti0UVNBven2gkMI66Fwu3VXw1yo+pC
        ePWG3DMjmTHNxdYBfl5/E2yf57AEu0DOUlXb8v6suKxkcMPyW3vuHokqcq/RkB/w
        ==
X-ME-Sender: <xms:wXpXXzFWl16f0E1gBY2mWt0tvf-qMWNvj8yAIx7bQ4DcycSq6kVHxg>
    <xme:wXpXXwXVAXnx6Ix7xNjjxRMRX8PEifefqgam-Heq6yLuZ0wuJd4XJNKE0Tc_t1R3K
    vtRs08emx_PnA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehfedgfeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkefhhfefgfefheeffedugeeuvddvvefggffftdduue
    ejhffhgfevuedtvddtjefgnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepvdenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:wXpXX1KJJtnoi1fAVrKPIK78kpdGFFr6HmUWfBcdLP2exJYItf8pRA>
    <xmx:wXpXXxGQQw2ZsEkoJa7ymkrjRR0JHZpk2oA21LPSepoM1ReNQAahDg>
    <xmx:wXpXX5VhIyMYDAuvcbSCVc26k_2wW4WjbdbmGL9mh_FcrcNl6Eh8Pg>
    <xmx:wXpXX7KpukyMGuMLFp5EIAwq7nHT8qudWzGoAg7fuIyqiE45_nS0qE_FacM>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 27F0B306467D;
        Tue,  8 Sep 2020 08:36:17 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915: Clear the repeater bit on HDCP disable" failed to apply to 4.19-stable tree
To:     seanpaul@chromium.org, chris@chris-wilson.co.uk,
        daniel.vetter@ffwll.ch, jani.nikula@intel.com,
        jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com,
        ramalingam.c@intel.com, rodrigo.vivi@intel.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Sep 2020 14:36:30 +0200
Message-ID: <15995685902343@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 57537b4e1d37002ed8cbd0a9be082104749e9d8f Mon Sep 17 00:00:00 2001
From: Sean Paul <seanpaul@chromium.org>
Date: Tue, 18 Aug 2020 11:38:50 -0400
Subject: [PATCH] drm/i915: Clear the repeater bit on HDCP disable

On HDCP disable, clear the repeater bit. This ensures if we connect a
non-repeater sink after a repeater, the bit is in the state we expect.

Fixes: ee5e5e7a5e0f ("drm/i915: Add HDCP framework + base implementation")
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Ramalingam C <ramalingam.c@intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Sean Paul <seanpaul@chromium.org>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: intel-gfx@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v4.17+
Reviewed-by: Ramalingam C <ramalingam.c@intel.com>
Signed-off-by: Sean Paul <seanpaul@chromium.org>
Signed-off-by: Ramalingam C <ramalingam.c@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200818153910.27894-3-sean@poorly.run
(cherry picked from commit 2cc0c7b520bf8ea20ec42285d4e3d37b467eb7f9)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>

diff --git a/drivers/gpu/drm/i915/display/intel_hdcp.c b/drivers/gpu/drm/i915/display/intel_hdcp.c
index 6189b7583277..1a0d49af2a08 100644
--- a/drivers/gpu/drm/i915/display/intel_hdcp.c
+++ b/drivers/gpu/drm/i915/display/intel_hdcp.c
@@ -795,6 +795,7 @@ static int _intel_hdcp_disable(struct intel_connector *connector)
 	struct intel_hdcp *hdcp = &connector->hdcp;
 	enum port port = dig_port->base.port;
 	enum transcoder cpu_transcoder = hdcp->cpu_transcoder;
+	u32 repeater_ctl;
 	int ret;
 
 	drm_dbg_kms(&dev_priv->drm, "[%s:%d] HDCP is being disabled...\n",
@@ -810,6 +811,11 @@ static int _intel_hdcp_disable(struct intel_connector *connector)
 		return -ETIMEDOUT;
 	}
 
+	repeater_ctl = intel_hdcp_get_repeater_ctl(dev_priv, cpu_transcoder,
+						   port);
+	intel_de_write(dev_priv, HDCP_REP_CTL,
+		       intel_de_read(dev_priv, HDCP_REP_CTL) & ~repeater_ctl);
+
 	ret = hdcp->shim->toggle_signalling(dig_port, false);
 	if (ret) {
 		drm_err(&dev_priv->drm, "Failed to disable HDCP signalling\n");


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF3E26123F
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 16:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729037AbgIHN6s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 09:58:48 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:44175 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729767AbgIHN6W (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Sep 2020 09:58:22 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 5F71DEB3;
        Tue,  8 Sep 2020 08:36:02 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 08 Sep 2020 08:36:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ZtKWOR
        D0YGNPtRB8TLRmgx7XdwYWXqAXKLsg83LIBMM=; b=ddyf4UUk6FmTwZrLaVdEhF
        gjd5FSQ2p79cD7iO/dWC2h3bHMi89zlp/HaEYJjUzVYhz1x3sIbkgqr5zvx92aaf
        Gg82Dbvm81nnrtu4sMygvYckPS4F1i6lxARNQTZFka41SBR+uu1HALDasf+vHeBB
        SDH4zNPm3G/oCOsXyYTz9Si630fwPr9O5NP3pQ9hd9Z/8TZL1AmtO/4vbEngBFR+
        nQh/qM4Ky+KlY0x9r3b4ezr67hnj+WDDRipKQ8T7MGJ/9jDQdmOyIq3vJL+hPIhn
        z1GSk5J84NVJu8Mgri+1r9K2dI9gdRdeXUIfP/jmxu9h9EPpxdneDFk1zIPoaSdg
        ==
X-ME-Sender: <xms:sHpXXwXLDxwu_V7W0YxN7n1AWmiZGhvb_sPumlCkCr8oNjHPkrc22A>
    <xme:sHpXX0kLsukTUQaiu4YojRSpSkGwvGNMUX7bah7hgE401tcq6J6dXBp6WQgkzTMUu
    VbMGxRBB4mZvA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehfedgfeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkefhhfefgfefheeffedugeeuvddvvefggffftdduue
    ejhffhgfevuedtvddtjefgnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:sHpXX0a8niOE90Wx0zvdoCNBjkW7YdzUt-wTQH3wHx7tIZ1SUkJ0OA>
    <xmx:sHpXX_V5KFHxCtyunk6JlbwoOhTWS_lvcJZjscZyyx1qOLvzeFRLKw>
    <xmx:sHpXX6nP7QvNsNXtfNor8Yz_pLp5qJ7HJDdBwiq0dmGhcZiiwbgQGQ>
    <xmx:sXpXX4b7ScmcEHAMiOWF9C-xLbAaXkEHnj0kb92uDI-oQ8JKwE1clSzD1j0>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id D191D3064682;
        Tue,  8 Sep 2020 08:35:59 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915: Fix sha_text population code" failed to apply to 4.19-stable tree
To:     seanpaul@chromium.org, chris@chris-wilson.co.uk,
        daniel.vetter@ffwll.ch, jani.nikula@intel.com,
        jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com,
        ramalingam.c@intel.com, rodrigo.vivi@intel.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Sep 2020 14:36:13 +0200
Message-ID: <15995685737489@kroah.com>
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

From 9ab57658a608f879469ffa22b723c4539c05a58f Mon Sep 17 00:00:00 2001
From: Sean Paul <seanpaul@chromium.org>
Date: Tue, 18 Aug 2020 11:38:49 -0400
Subject: [PATCH] drm/i915: Fix sha_text population code

This patch fixes a few bugs:

1- We weren't taking into account sha_leftovers when adding multiple
   ksvs to sha_text. As such, we were or'ing the end of ksv[j - 1] with
   the beginning of ksv[j]

2- In the sha_leftovers == 2 and sha_leftovers == 3 case, bstatus was
   being placed on the wrong half of sha_text, overlapping the leftover
   ksv value

3- In the sha_leftovers == 2 case, we need to manually terminate the
   byte stream with 0x80 since the hardware doesn't have enough room to
   add it after writing M0

The upside is that all of the HDCP supported HDMI repeaters I could
find on Amazon just strip HDCP anyways, so it turns out to be _really_
hard to hit any of these cases without an MST hub, which is not (yet)
supported. Oh, and the sha_leftovers == 1 case works perfectly!

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
Link: https://patchwork.freedesktop.org/patch/msgid/20200818153910.27894-2-sean@poorly.run
(cherry picked from commit 1f0882214fd0037b74f245d9be75c31516fed040)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>

diff --git a/drivers/gpu/drm/i915/display/intel_hdcp.c b/drivers/gpu/drm/i915/display/intel_hdcp.c
index 89a4d294822d..6189b7583277 100644
--- a/drivers/gpu/drm/i915/display/intel_hdcp.c
+++ b/drivers/gpu/drm/i915/display/intel_hdcp.c
@@ -336,8 +336,10 @@ int intel_hdcp_validate_v_prime(struct intel_connector *connector,
 
 		/* Fill up the empty slots in sha_text and write it out */
 		sha_empty = sizeof(sha_text) - sha_leftovers;
-		for (j = 0; j < sha_empty; j++)
-			sha_text |= ksv[j] << ((sizeof(sha_text) - j - 1) * 8);
+		for (j = 0; j < sha_empty; j++) {
+			u8 off = ((sizeof(sha_text) - j - 1 - sha_leftovers) * 8);
+			sha_text |= ksv[j] << off;
+		}
 
 		ret = intel_write_sha_text(dev_priv, sha_text);
 		if (ret < 0)
@@ -435,7 +437,7 @@ int intel_hdcp_validate_v_prime(struct intel_connector *connector,
 		/* Write 32 bits of text */
 		intel_de_write(dev_priv, HDCP_REP_CTL,
 			       rep_ctl | HDCP_SHA1_TEXT_32);
-		sha_text |= bstatus[0] << 24 | bstatus[1] << 16;
+		sha_text |= bstatus[0] << 8 | bstatus[1];
 		ret = intel_write_sha_text(dev_priv, sha_text);
 		if (ret < 0)
 			return ret;
@@ -450,17 +452,29 @@ int intel_hdcp_validate_v_prime(struct intel_connector *connector,
 				return ret;
 			sha_idx += sizeof(sha_text);
 		}
+
+		/*
+		 * Terminate the SHA-1 stream by hand. For the other leftover
+		 * cases this is appended by the hardware.
+		 */
+		intel_de_write(dev_priv, HDCP_REP_CTL,
+			       rep_ctl | HDCP_SHA1_TEXT_32);
+		sha_text = DRM_HDCP_SHA1_TERMINATOR << 24;
+		ret = intel_write_sha_text(dev_priv, sha_text);
+		if (ret < 0)
+			return ret;
+		sha_idx += sizeof(sha_text);
 	} else if (sha_leftovers == 3) {
-		/* Write 32 bits of text */
+		/* Write 32 bits of text (filled from LSB) */
 		intel_de_write(dev_priv, HDCP_REP_CTL,
 			       rep_ctl | HDCP_SHA1_TEXT_32);
-		sha_text |= bstatus[0] << 24;
+		sha_text |= bstatus[0];
 		ret = intel_write_sha_text(dev_priv, sha_text);
 		if (ret < 0)
 			return ret;
 		sha_idx += sizeof(sha_text);
 
-		/* Write 8 bits of text, 24 bits of M0 */
+		/* Write 8 bits of text (filled from LSB), 24 bits of M0 */
 		intel_de_write(dev_priv, HDCP_REP_CTL,
 			       rep_ctl | HDCP_SHA1_TEXT_8);
 		ret = intel_write_sha_text(dev_priv, bstatus[1]);
diff --git a/include/drm/drm_hdcp.h b/include/drm/drm_hdcp.h
index c6bab4986a65..fe58dbb46962 100644
--- a/include/drm/drm_hdcp.h
+++ b/include/drm/drm_hdcp.h
@@ -29,6 +29,9 @@
 /* Slave address for the HDCP registers in the receiver */
 #define DRM_HDCP_DDC_ADDR			0x3A
 
+/* Value to use at the end of the SHA-1 bytestream used for repeaters */
+#define DRM_HDCP_SHA1_TERMINATOR		0x80
+
 /* HDCP register offsets for HDMI/DVI devices */
 #define DRM_HDCP_DDC_BKSV			0x00
 #define DRM_HDCP_DDC_RI_PRIME			0x08


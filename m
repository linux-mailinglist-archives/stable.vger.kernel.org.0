Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ABB4171280
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 09:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728484AbgB0I0r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 03:26:47 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:50699 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728454AbgB0I0r (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 03:26:47 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 1F84B69B;
        Thu, 27 Feb 2020 03:26:46 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 27 Feb 2020 03:26:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=YyW/uU
        MOtHxBgvgAeyr330ANKEbgzjDmVtdRN+fsdtI=; b=dOzPmnMOkjpCFGH3Mj9I/r
        DZZnB1WdcB9u3DIy6k3XLnUsMLdW6+lSrb1gijE/3pHiq+x+e5h40ZESSLecwNU/
        DjSXjgHxNRj2WUZJoMpt05TNi38E/mWqjjvMOkcDTH8+Toy6SO4Co1TJFIRAMejg
        RqW6jH0bQtel00oA30U3n5wKplAZBjukonCPl1/g1Mv/WM3hSjjjA0jgqLHqaDQI
        qFZn0A6SdqCfX3IJBAh/zTCcb1i3g0yWoOp0CMQ9sKxUwM0OBp7SwvdDauV26l5L
        w0QC4g6UPoh2jLSnHl6Ky304XNm2vX+fsoPHZNM3tQ9ggFIa69HUS5ckr3ml5fWQ
        ==
X-ME-Sender: <xms:RX1XXpvcciyIXvIUHFLK_Tot_7kerKdtnhH6xNLdXoyMfnnTs4lktg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrleehgdduvdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhgnecukfhppeekfedrke
    eirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhl
    fhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:RX1XXpzFJh2pGqNIijz9RC3Ivsk5JhqHQXZtVvwlfCipb_KSPy1MTQ>
    <xmx:RX1XXva6ofwrZR-IfhyOfUkK70ouAbd5Fj2f2Zt20q92L-4gg6GPSQ>
    <xmx:RX1XXqTDv_W71jQbGgblsYvLix5poaxzegje2N1BR4lG2qEkqxD6hQ>
    <xmx:RX1XXnQblbSBrRt5bzMa7xjWzmMNxznVC3DAEXY-N0R_p6XZ2IcY7Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 088B230610DB;
        Thu, 27 Feb 2020 03:26:44 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/i915/dsc: force full modeset whenever DSC is enabled at" failed to apply to 5.5-stable tree
To:     jani.nikula@intel.com, manasi.d.navare@intel.com,
        matthew.d.roper@intel.com, vandita.kulkarni@intel.com,
        ville.syrjala@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 27 Feb 2020 09:26:43 +0100
Message-ID: <158279200313130@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.5-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2e0a576511f656933adfe56ef03b9cf3e64b21b7 Mon Sep 17 00:00:00 2001
From: Jani Nikula <jani.nikula@intel.com>
Date: Thu, 13 Feb 2020 16:04:11 +0200
Subject: [PATCH] drm/i915/dsc: force full modeset whenever DSC is enabled at
 probe

We lack full state readout of DSC config, which may lead to DSC enable
using a config that's all zeros, failing spectacularly. Force full
modeset and thus compute config at probe to get a sane state, until we
implement DSC state readout. Any fastset that did appear to work with
DSC at probe, worked by coincidence. [1] is an example of a change that
triggered the issue on TGL DSI DSC.

[1] http://patchwork.freedesktop.org/patch/msgid/20200212150102.7600-1-ville.syrjala@linux.intel.com

Cc: Manasi Navare <manasi.d.navare@intel.com>
Cc: Vandita Kulkarni <vandita.kulkarni@intel.com>
Cc: Ville Syrjala <ville.syrjala@linux.intel.com>
Cc: stable@vger.kernel.org
Fixes: fbacb15ea814 ("drm/i915/dsc: add basic hardware state readout support")
Acked-by: Matt Roper <matthew.d.roper@intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200213140412.32697-3-stanislav.lisovskiy@intel.com
(cherry picked from commit a4277aa398d76db109d6b8420934f68daf69a6c3)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>

diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
index 064dd99bbc49..e68ec25fc97c 100644
--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -17433,6 +17433,24 @@ static int intel_initial_commit(struct drm_device *dev)
 			 * have readout for pipe gamma enable.
 			 */
 			crtc_state->uapi.color_mgmt_changed = true;
+
+			/*
+			 * FIXME hack to force full modeset when DSC is being
+			 * used.
+			 *
+			 * As long as we do not have full state readout and
+			 * config comparison of crtc_state->dsc, we have no way
+			 * to ensure reliable fastset. Remove once we have
+			 * readout for DSC.
+			 */
+			if (crtc_state->dsc.compression_enable) {
+				ret = drm_atomic_add_affected_connectors(state,
+									 &crtc->base);
+				if (ret)
+					goto out;
+				crtc_state->uapi.mode_changed = true;
+				drm_dbg_kms(dev, "Force full modeset for DSC\n");
+			}
 		}
 	}
 


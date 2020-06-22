Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCEA1203EB4
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 20:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730362AbgFVSFq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 14:05:46 -0400
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:32793 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730356AbgFVSFq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jun 2020 14:05:46 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 10D2AFBC;
        Mon, 22 Jun 2020 14:05:45 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 22 Jun 2020 14:05:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=C1llMb
        xI5P4lcfzGdsT2NhoYfjwqslYSfPYCm5oCyB4=; b=gahe4uRGWfcjNv+IUvBhmr
        7ldXYjdY1EkLyI3bMfcTmw3aPZ22mVToBsxlC379Zx3Uq7+C18qXwfLSld9LDg/B
        deqdSw5B64TuFX7h2QgyagRxNh/Lkvm58vfyi74cG1cPgqkHsySHv7OlOZnBwDcj
        X/oxxcFmJ6Zz8oQ5jZa17HCRnL81ZvHurfpjcLNno9eHyacmibH1vJAiOIsfyEqC
        LkFe3BljqLWINe0txmEAQEZCA90+Fd/HcDsj0sArVd3RHM3XKjRhH5qWglG/UX22
        yPnGKWkXf4dEW73Bv8miqw/eswGBIQEWo63pBpDDnPT6qQY6n4Bzi5YVceDjrRaw
        ==
X-ME-Sender: <xms:-PLwXkLg7lx3nEBJUwDQmWC6DWONiGni17c5FhhJiBfy0B5rz9mDUQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudekvddguddvvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpedvffegjeejiedtieffjeeijeffgfehvdeiudejhe
    efgeevhffhvedvfeeuheekleenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhr
    ghenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepfeenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:-PLwXkLk_m84XGmJUN91E0_NlUdNeM2tNtgzNYP3Fmi-AzB1736jiQ>
    <xmx:-PLwXkvU0lCEz4VHI20rcSP6gIfSEHNBkDbUam7mE4wPHvTWGUcaew>
    <xmx:-PLwXhYyh9hxMcx58bRP1kDtkWD5lyTNzQmFkhwfrdFvejFsvyf8RQ>
    <xmx:-PLwXl2d7ira6-otu2WKKBjIYHSnTeVss03Ak8rh5zge-Yd4JYOdOnw5iTk>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4B01B3280059;
        Mon, 22 Jun 2020 14:05:44 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/dp_mst: Increase ACT retry timeout to 3s" failed to apply to 4.14-stable tree
To:     lyude@redhat.com, sean@poorly.run, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Jun 2020 20:05:35 +0200
Message-ID: <1592849135240232@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From 873a95e0d59ac06901ae261dda0b7165ffd002b8 Mon Sep 17 00:00:00 2001
From: Lyude Paul <lyude@redhat.com>
Date: Fri, 3 Apr 2020 15:47:15 -0400
Subject: [PATCH] drm/dp_mst: Increase ACT retry timeout to 3s
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Currently we only poll for an ACT up to 30 times, with a busy-wait delay
of 100µs between each attempt - giving us a timeout of 2900µs. While
this might seem sensible, it would appear that in certain scenarios it
can take dramatically longer then that for us to receive an ACT. On one
of the EVGA MST hubs that I have available, I observed said hub
sometimes taking longer then a second before signalling the ACT. These
delays mostly seem to occur when previous sideband messages we've sent
are NAKd by the hub, however it wouldn't be particularly surprising if
it's possible to reproduce times like this simply by introducing branch
devices with large LCTs since payload allocations have to take effect on
every downstream device up to the payload's target.

So, instead of just retrying 30 times we poll for the ACT for up to 3ms,
and additionally use usleep_range() to avoid a very long and rude
busy-wait. Note that the previous retry count of 30 appears to have been
arbitrarily chosen, as I can't find any mention of a recommended timeout
or retry count for ACTs in the DisplayPort 2.0 specification. This also
goes for the range we were previously using for udelay(), although I
suspect that was just copied from the recommended delay for link
training on SST devices.

Changes since v1:
* Use readx_poll_timeout() instead of open-coding timeout loop - Sean
  Paul
Changes since v2:
* Increase poll interval to 200us - Sean Paul
* Print status in hex when we timeout waiting for ACT - Sean Paul

Signed-off-by: Lyude Paul <lyude@redhat.com>
Fixes: ad7f8a1f9ced ("drm/helper: add Displayport multi-stream helper (v0.6)")
Cc: Sean Paul <sean@poorly.run>
Cc: <stable@vger.kernel.org> # v3.17+
Reviewed-by: Sean Paul <sean@poorly.run>
Link: https://patchwork.freedesktop.org/patch/msgid/20200406221253.1307209-4-lyude@redhat.com

diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index e7a5bd3e6015..8942ab98ab64 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -27,6 +27,7 @@
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/seq_file.h>
+#include <linux/iopoll.h>
 
 #if IS_ENABLED(CONFIG_DRM_DEBUG_DP_MST_TOPOLOGY_REFS)
 #include <linux/stacktrace.h>
@@ -4438,43 +4439,53 @@ static int drm_dp_dpcd_write_payload(struct drm_dp_mst_topology_mgr *mgr,
 	return ret;
 }
 
+static int do_get_act_status(struct drm_dp_aux *aux)
+{
+	int ret;
+	u8 status;
+
+	ret = drm_dp_dpcd_readb(aux, DP_PAYLOAD_TABLE_UPDATE_STATUS, &status);
+	if (ret < 0)
+		return ret;
+
+	return status;
+}
 
 /**
  * drm_dp_check_act_status() - Polls for ACT handled status.
  * @mgr: manager to use
  *
  * Tries waiting for the MST hub to finish updating it's payload table by
- * polling for the ACT handled bit.
+ * polling for the ACT handled bit for up to 3 seconds (yes-some hubs really
+ * take that long).
  *
  * Returns:
  * 0 if the ACT was handled in time, negative error code on failure.
  */
 int drm_dp_check_act_status(struct drm_dp_mst_topology_mgr *mgr)
 {
-	int count = 0, ret;
-	u8 status;
-
-	do {
-		ret = drm_dp_dpcd_readb(mgr->aux,
-					DP_PAYLOAD_TABLE_UPDATE_STATUS,
-					&status);
-		if (ret < 0) {
-			DRM_DEBUG_KMS("failed to read payload table status %d\n",
-				      ret);
-			return ret;
-		}
-
-		if (status & DP_PAYLOAD_ACT_HANDLED)
-			break;
-		count++;
-		udelay(100);
-	} while (count < 30);
-
-	if (!(status & DP_PAYLOAD_ACT_HANDLED)) {
-		DRM_DEBUG_KMS("failed to get ACT bit %d after %d retries\n",
-			      status, count);
+	/*
+	 * There doesn't seem to be any recommended retry count or timeout in
+	 * the MST specification. Since some hubs have been observed to take
+	 * over 1 second to update their payload allocations under certain
+	 * conditions, we use a rather large timeout value.
+	 */
+	const int timeout_ms = 3000;
+	int ret, status;
+
+	ret = readx_poll_timeout(do_get_act_status, mgr->aux, status,
+				 status & DP_PAYLOAD_ACT_HANDLED || status < 0,
+				 200, timeout_ms * USEC_PER_MSEC);
+	if (ret < 0 && status >= 0) {
+		DRM_DEBUG_KMS("Failed to get ACT after %dms, last status: %02x\n",
+			      timeout_ms, status);
 		return -EINVAL;
+	} else if (status < 0) {
+		DRM_DEBUG_KMS("Failed to read payload table status: %d\n",
+			      status);
+		return status;
 	}
+
 	return 0;
 }
 EXPORT_SYMBOL(drm_dp_check_act_status);


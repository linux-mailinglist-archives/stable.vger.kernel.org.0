Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6030382C48
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 14:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234804AbhEQMhh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 08:37:37 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:35395 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229734AbhEQMhh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 08:37:37 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.west.internal (Postfix) with ESMTP id 9BB11A52;
        Mon, 17 May 2021 08:36:18 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 17 May 2021 08:36:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=7W8R6B
        kE/G3ScYWtBYOZde3T8yx1om4c8hNwvKu4rq4=; b=cmHR5/Rx9h7qGccDVS+MCT
        VldL2UlXZ7mq6agIh98xqi3aFonqU8ts68hT0QCart7kqrN2rR8AoYC3kAXwVVs5
        cWgFA2+xnX2xRbv43QG4D2oImfANEP+SaLn9TDtoqgXzOZePSnNl2OYtNzbNHdaP
        XuljJkJ6U0+80Ew5c8+FzKeA2Px3ScZMCsSHcFbOLn3Z76WRsInZ7jAtJnQbhb57
        V1TA3MG8xM5p6/e7t6TBAHs8Pcz+0pDNC5T4sr4V+65+5oVES7PxHVG+HQ/8KELD
        bnCs2gU/4WXyYmoroOVKtKvJIQEbS7JiE45MUf11GTfS/40KUNpigtB4CRJffeDg
        ==
X-ME-Sender: <xms:QWOiYAStXy6-b3EBEPesEGgiruMYN45jHzeBUYd08032xubKxL3kzw>
    <xme:QWOiYNxe1PMOVDIB-pteY8IT7GREbqZdIdLsciIlt_eKc0xNuuNXlRqa9WLoxwMNN
    lHd7Mtj-eumKw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeihedgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:QWOiYN1j1tCTNDPUx2RMTQKgIA9icz9jVm-QrrM4Whp_Wjrgt72j6w>
    <xmx:QWOiYEB_oIN47oPm9DE2Q8Pmrga7Jrre1Z2LT5FK24CVYu8CkQXCZg>
    <xmx:QWOiYJhy7UhHk-3p5LCqbWTCJVxh7EHOpPvc7rEmEuWxK5BHZgULSg>
    <xmx:QmOiYJYyUOa1ttzmK00QEdPZuGjAGRRO58aZzorZQSUF0qdwtP-JbLwM5j0>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 17 May 2021 08:36:17 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/msm/dp: check sink_count before update is_connected" failed to apply to 5.10-stable tree
To:     khsieh@codeaurora.org, robdclark@chromium.org, swboyd@chromium.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 May 2021 14:36:15 +0200
Message-ID: <16212549754014@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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

From d9aa6571b28ba0022de1e48801ff03a1854c7ef2 Mon Sep 17 00:00:00 2001
From: Kuogee Hsieh <khsieh@codeaurora.org>
Date: Wed, 21 Apr 2021 16:37:35 -0700
Subject: [PATCH] drm/msm/dp: check sink_count before update is_connected
 status

Link status is different from display connected status in the case
of something like an Apple dongle where the type-c plug can be
connected, and therefore the link is connected, but no sink is
connected until an HDMI cable is plugged into the dongle.
The sink_count of DPCD of dongle will increase to 1 once an HDMI
cable is plugged into the dongle so that display connected status
will become true. This checking also apply at pm_resume.

Changes in v4:
-- none

Fixes: 94e58e2d06e3 ("drm/msm/dp: reset dp controller only at boot up and pm_resume")
Reported-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Tested-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Kuogee Hsieh <khsieh@codeaurora.org>
Fixes: 8ede2ecc3e5e ("drm/msm/dp: Add DP compliance tests on Snapdragon Chipsets")
Link: https://lore.kernel.org/r/1619048258-8717-2-git-send-email-khsieh@codeaurora.org
Signed-off-by: Rob Clark <robdclark@chromium.org>

diff --git a/drivers/gpu/drm/msm/dp/dp_display.c b/drivers/gpu/drm/msm/dp/dp_display.c
index 5a39da6e1eaf..0ba71c7a8dd4 100644
--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -586,10 +586,8 @@ static int dp_connect_pending_timeout(struct dp_display_private *dp, u32 data)
 	mutex_lock(&dp->event_mutex);
 
 	state = dp->hpd_state;
-	if (state == ST_CONNECT_PENDING) {
-		dp_display_enable(dp, 0);
+	if (state == ST_CONNECT_PENDING)
 		dp->hpd_state = ST_CONNECTED;
-	}
 
 	mutex_unlock(&dp->event_mutex);
 
@@ -669,10 +667,8 @@ static int dp_disconnect_pending_timeout(struct dp_display_private *dp, u32 data
 	mutex_lock(&dp->event_mutex);
 
 	state =  dp->hpd_state;
-	if (state == ST_DISCONNECT_PENDING) {
-		dp_display_disable(dp, 0);
+	if (state == ST_DISCONNECT_PENDING)
 		dp->hpd_state = ST_DISCONNECTED;
-	}
 
 	mutex_unlock(&dp->event_mutex);
 
@@ -1272,7 +1268,12 @@ static int dp_pm_resume(struct device *dev)
 
 	status = dp_catalog_link_is_connected(dp->catalog);
 
-	if (status)
+	/*
+	 * can not declared display is connected unless
+	 * HDMI cable is plugged in and sink_count of
+	 * dongle become 1
+	 */
+	if (status && dp->link->sink_count)
 		dp->dp_display.is_connected = true;
 	else
 		dp->dp_display.is_connected = false;


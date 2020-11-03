Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA9632A4A1F
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 16:43:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbgKCPng (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 10:43:36 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:44919 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727923AbgKCPng (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 10:43:36 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 925211942AFB;
        Tue,  3 Nov 2020 10:43:34 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 10:43:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=BHyFZ8
        //ML6QbrLVnFEquFg++BYUAnibKu6LXFEPrVM=; b=GjBJoCFnNtG0N98ctcg9jI
        pqxu5NLNyiGsicPSGIIR8Lf+Xm6I/7xqr3Rq8GddrE4AMNobKoeAsEsulVPm7EZS
        I8YY0j4c5YQqhlzP3GZkZBTO3ZolDl9hSWbZ0A2mtmVRfoymlUdTfk3csz0FmMXX
        fChj0zXSNWKkTGgK7Ip3R8fwaB5Hz5hzwoDbx77epnIoRUpkC3JUxCq1OBIWhd8X
        9zeEMtkhwNEoCwcttk1JEKJWrvpOHyyz2lJ6AoQHuEJWe/PtemNUfBsq/MpMDTku
        hbreX4+Rqdy3RVEvIwviZ8TUT+7WRCGzHzcuCSY58utFi+a0AT3/nYVzvL009ORQ
        ==
X-ME-Sender: <xms:pnqhX3nC8uMyiEYuW-mA7dxHry2L408NWLe9Cn38X7nfSEfsPCVFrw>
    <xme:pnqhX62fl6ZcSqa2yKMMwkAjrKKAq4K1njY7hz7n84UivUodtRT6ArM42OlBhp0lY
    17fPQZNC260jg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgjeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepheenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:pnqhX9rC4FjSe6NgvMkUzaZ831GPaApLJk2Drhx29aoont8wQDlNtw>
    <xmx:pnqhX_k-nriMAstBKnU80gvuy1BgQoO1MMeuMkrgssiQj-3TsVpt5w>
    <xmx:pnqhX11KxP8YK-8SiFBgKdOg7dbUxBG1TK7BbcNlW0UWJLNRndRysA>
    <xmx:pnqhXzBmuSH7lkzJOmZ0uk0FaOwFL7LUteXcDwejiP38QImraOYBbg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 159DA3064683;
        Tue,  3 Nov 2020 10:43:33 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/amd/display: [FIX] update clock under two conditions" failed to apply to 5.9-stable tree
To:     Lewis.Huang@amd.com, Martin.Leung@amd.com, Qingqing.zhuo@amd.com,
        alexander.deucher@amd.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 16:44:27 +0100
Message-ID: <16044182673022@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 12dbd1f7578feb51bc95e5a90eb617889cc0b04e Mon Sep 17 00:00:00 2001
From: Lewis Huang <Lewis.Huang@amd.com>
Date: Wed, 16 Sep 2020 17:13:11 -0400
Subject: [PATCH] drm/amd/display: [FIX] update clock under two conditions

[Why]
Update clock only when non-seamless boot stream exists
creates regression on multiple scenerios.

[How]
Update clock in two conditions
1. Non-seamless boot stream exist.
2. Stream_count = 0

Fixes: 598c13b21e25 ("drm/amd/display: update clock when non-seamless boot stream exist")
Signed-off-by: Lewis Huang <Lewis.Huang@amd.com>
Reviewed-by: Martin Leung <Martin.Leung@amd.com>
Acked-by: Qingqing Zhuo <Qingqing.zhuo@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: <stable@vger.kernel.org>

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 1efc823c2a14..7e74ddc1c708 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -1286,7 +1286,8 @@ static enum dc_status dc_commit_state_no_check(struct dc *dc, struct dc_state *c
 			dc->optimize_seamless_boot_streams++;
 	}
 
-	if (context->stream_count > dc->optimize_seamless_boot_streams)
+	if (context->stream_count > dc->optimize_seamless_boot_streams ||
+		context->stream_count == 0)
 		dc->hwss.prepare_bandwidth(dc, context);
 
 	disable_dangling_plane(dc, context);
@@ -1368,7 +1369,8 @@ static enum dc_status dc_commit_state_no_check(struct dc *dc, struct dc_state *c
 
 	dc_enable_stereo(dc, context, dc_streams, context->stream_count);
 
-	if (context->stream_count > dc->optimize_seamless_boot_streams) {
+	if (context->stream_count > dc->optimize_seamless_boot_streams ||
+		context->stream_count == 0) {
 		/* Must wait for no flips to be pending before doing optimize bw */
 		wait_for_no_pipes_pending(dc, context);
 		/* pplib is notified if disp_num changed */


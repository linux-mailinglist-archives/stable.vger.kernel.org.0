Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB3E3203EC1
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 20:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730099AbgFVSGp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 14:06:45 -0400
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:48111 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730046AbgFVSGp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jun 2020 14:06:45 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 8147712F0;
        Mon, 22 Jun 2020 14:06:44 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 22 Jun 2020 14:06:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=GUOx65
        OpwcE1pSMlukkgUvOxAli3Kt8SpbZ6P8xBjpk=; b=MJkW0wEapt/oMxs6szRJji
        Ae87jAahqg1yELWZ5kUgeFj+0GzI67idwNiWwp7/sSa75lYKQ5GJbi/EhlL2yT0p
        L/ybj/QlF+UNhdIoM6KaNIPyFbBnei5ONpy1HI0A0Box8vnK7GY9E8+Sclgpa0KX
        AkLsoIP9+p1fCmW5kLRzXhPP3uPCFH5zSV4zFuhgY9jT6BGunU9HDaPLVuIgHvV0
        pomiydemHxpLqZvNyB7XLd0snl+C9sc8k3fUSj/DdMturKz1rmPTFy+r0HwV6Xeh
        XpRVZvlkWWxbNSMDZsVR3/Jy624Tr/G9D8VN0LuWBaSTohOAjDV9bA3aHvHFb9Ug
        ==
X-ME-Sender: <xms:M_PwXsb80N-guB9Y-jDGObmcc5BNXJ7FNLm5Uo_HKoMLHkAxZc8nPg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudekvddguddvvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeekhffhfefgfeehfeefudeguedvvdevgffgffdtud
    eujefhhffgveeutddvtdejgfenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhr
    ghenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepieenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:M_PwXnagkxHJuHMyJzfIEt2c8Z6rUXrSqRueNHlDrLKlePvamMrbtw>
    <xmx:M_PwXm-uLVYkDtcjy-rid2Th_RNqNM76GMasi_-BAUH1Gr8yMx_vAA>
    <xmx:M_PwXmprYhFrzMEg7VxGC_ckiuSsyCVid393IEzmGjsCgD2Xs__MMQ>
    <xmx:NPPwXhEsg98nKk27H8C1GAjH40JV8dt9eBVHymkxeQgVKMT92tyPPPtSknM>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 90EFD328005A;
        Mon, 22 Jun 2020 14:06:43 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/amdgpu/display: use blanked rather than plane state for" failed to apply to 5.4-stable tree
To:     alexander.deucher@amd.com, nicholas.kazlauskas@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Jun 2020 20:06:38 +0200
Message-ID: <15928491981887@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b7f839d292948142eaab77cedd031aad0bfec872 Mon Sep 17 00:00:00 2001
From: Alex Deucher <alexander.deucher@amd.com>
Date: Tue, 2 Jun 2020 17:22:48 -0400
Subject: [PATCH] drm/amdgpu/display: use blanked rather than plane state for
 sync groups

We may end up with no planes set yet, depending on the ordering, but we
should have the proper blanking state which is either handled by either
DPG or TG depending on the hardware generation.  Check both to determine
the proper blanked state.

Bug: https://gitlab.freedesktop.org/drm/amd/issues/781
Fixes: 5fc0cbfad45648 ("drm/amd/display: determine if a pipe is synced by plane state")
Cc: nicholas.kazlauskas@amd.com
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 45cfb7c45566..b4e2053bca9f 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -1016,9 +1016,17 @@ static void program_timing_sync(
 			}
 		}
 
-		/* set first pipe with plane as master */
+		/* set first unblanked pipe as master */
 		for (j = 0; j < group_size; j++) {
-			if (pipe_set[j]->plane_state) {
+			bool is_blanked;
+
+			if (pipe_set[j]->stream_res.opp->funcs->dpg_is_blanked)
+				is_blanked =
+					pipe_set[j]->stream_res.opp->funcs->dpg_is_blanked(pipe_set[j]->stream_res.opp);
+			else
+				is_blanked =
+					pipe_set[j]->stream_res.tg->funcs->is_blanked(pipe_set[j]->stream_res.tg);
+			if (!is_blanked) {
 				if (j == 0)
 					break;
 
@@ -1039,9 +1047,17 @@ static void program_timing_sync(
 				status->timing_sync_info.master = false;
 
 		}
-		/* remove any other pipes with plane as they have already been synced */
+		/* remove any other unblanked pipes as they have already been synced */
 		for (j = j + 1; j < group_size; j++) {
-			if (pipe_set[j]->plane_state) {
+			bool is_blanked;
+
+			if (pipe_set[j]->stream_res.opp->funcs->dpg_is_blanked)
+				is_blanked =
+					pipe_set[j]->stream_res.opp->funcs->dpg_is_blanked(pipe_set[j]->stream_res.opp);
+			else
+				is_blanked =
+					pipe_set[j]->stream_res.tg->funcs->is_blanked(pipe_set[j]->stream_res.tg);
+			if (!is_blanked) {
 				group_size--;
 				pipe_set[j] = pipe_set[group_size];
 				j--;


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5400E2A4A5D
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 16:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbgKCPxN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 10:53:13 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:60043 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726581AbgKCPxN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 10:53:13 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 0CE45D4E;
        Tue,  3 Nov 2020 10:53:11 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 10:53:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=OW0N6o
        hqfBcRSEv9Pq3NLQFlRcdJ0Ycd5Cj7+qHe85A=; b=orCBdbCSDdI1DAYvkP56Yg
        GCO/0WnpOkfVDQ+tRqm7SN1Bn9i+u619uDsFiBby8iQuhe/9twN0SKMQnrTflHW8
        g3iLlxdjNkIAUwNuWwBZejwFuBko3OkA5ujiTPpOVtPELZ6BpIIc0WRh8fY0/sau
        Dln2OmkIH2zlg0pZPpGmjKc9l8HmV5RYITRzvOW+w1bQGVzeCyWPCVhlsJEPEd2R
        B9pWeaYgRigPVp/yzr6rAcwtyktHn2nAs7oPnNUTW2DLNBFACiuy4e2cbzo+Df5m
        +ymFPJzPRTPdu+gErXuujmn+hWGFc0z/rzGeWqT3gcBVuIhR3Owbiu21EQFf8UPw
        ==
X-ME-Sender: <xms:53yhXyitkMkz3Dp7eNOY4ZLRDuQVK74dNwFKnOteyS5R4broBL0pXg>
    <xme:53yhXzDGAWc-QhZugPW1brLYIhT82KQh-EpPzE81zlE8spJVnUv6rTeVdnurk3meJ
    LYZNPoE0mHa7g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgjeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:53yhX6HacL_h7pDoHpFOrtc6nwKrdTr4yn-YvIKKfKsFTVCDzjPEJw>
    <xmx:53yhX7QoyVYbV7zjyBrA8babpQz59uJFiACIDz7yrIqzo2iDsvjAsA>
    <xmx:53yhX_zQa4hy40RKdAJPd7UrM3lGPbhsvVR6xb_jBUiD1Zw2FgYV7A>
    <xmx:53yhX4oWkelqEZyHpqpHnhxsI7KrRRWdF-xzHOH8UpdSy9Rr6maF2CWAHTQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1BBFF3064610;
        Tue,  3 Nov 2020 10:53:11 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/amd/display: prevent null pointer access" failed to apply to 5.9-stable tree
To:     Dmytro.Laktyushkin@amd.com, alexander.deucher@amd.com,
        aurabindo.pillai@amd.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 16:54:05 +0100
Message-ID: <1604418845254136@kroah.com>
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

From 140b2ef1c28d3f5a5fc767368eaa8b45afc5bf1f Mon Sep 17 00:00:00 2001
From: Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
Date: Thu, 15 Oct 2020 14:49:56 -0400
Subject: [PATCH] drm/amd/display: prevent null pointer access

Prevent null pointer access when checking odm tree.

Signed-off-by: Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
Acked-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: <stable@vger.kernel.org>

diff --git a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c
index 24fb39a11e5d..2455d210ccf6 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c
@@ -2105,12 +2105,12 @@ static bool dcn30_internal_validate_bw(
 
 		if (split[i]) {
 			if (odm) {
-				if (split[i] == 4 && old_pipe->next_odm_pipe->next_odm_pipe)
+				if (split[i] == 4 && old_pipe->next_odm_pipe && old_pipe->next_odm_pipe->next_odm_pipe)
 					old_index = old_pipe->next_odm_pipe->next_odm_pipe->pipe_idx;
 				else if (old_pipe->next_odm_pipe)
 					old_index = old_pipe->next_odm_pipe->pipe_idx;
 			} else {
-				if (split[i] == 4 && old_pipe->bottom_pipe->bottom_pipe &&
+				if (split[i] == 4 && old_pipe->bottom_pipe && old_pipe->bottom_pipe->bottom_pipe &&
 						old_pipe->bottom_pipe->bottom_pipe->plane_state == old_pipe->plane_state)
 					old_index = old_pipe->bottom_pipe->bottom_pipe->pipe_idx;
 				else if (old_pipe->bottom_pipe &&
@@ -2150,10 +2150,12 @@ static bool dcn30_internal_validate_bw(
 				goto validate_fail;
 			newly_split[pipe_4to1->pipe_idx] = true;
 
-			if (odm && old_pipe->next_odm_pipe->next_odm_pipe->next_odm_pipe)
+			if (odm && old_pipe->next_odm_pipe && old_pipe->next_odm_pipe->next_odm_pipe
+					&& old_pipe->next_odm_pipe->next_odm_pipe->next_odm_pipe)
 				old_index = old_pipe->next_odm_pipe->next_odm_pipe->next_odm_pipe->pipe_idx;
-			else if (!odm && old_pipe->bottom_pipe->bottom_pipe->bottom_pipe &&
-						old_pipe->bottom_pipe->bottom_pipe->bottom_pipe->plane_state == old_pipe->plane_state)
+			else if (!odm && old_pipe->bottom_pipe && old_pipe->bottom_pipe->bottom_pipe &&
+					old_pipe->bottom_pipe->bottom_pipe->bottom_pipe &&
+					old_pipe->bottom_pipe->bottom_pipe->bottom_pipe->plane_state == old_pipe->plane_state)
 				old_index = old_pipe->bottom_pipe->bottom_pipe->bottom_pipe->pipe_idx;
 			else
 				old_index = -1;


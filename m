Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1105B2A4A1D
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 16:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728220AbgKCPnK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 10:43:10 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:34855 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726690AbgKCPnK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 10:43:10 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id B2F9919425C7;
        Tue,  3 Nov 2020 10:43:08 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 10:43:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=4SaJxU
        Xc0UnNPNPGUPI/UbRFMIax6t7lNsHBvhY6ZEY=; b=qobuRHiAR2Uf6XXyF5ZfM/
        i8qZWN5qFVIIEV1cu3ltGxel5mndnkYXnLEiwok0Ip/vtNfWLHoPVf73mtSd6nMD
        jXqelBN3jIYUBx4Z8VfsECHtNDuFcV6wTRMvvhqk5S43fYco4EUYqoAqO11MbI2t
        ZuEAzvRn5XlER81GkGWN3EYX+CnYYtXq0ofEfnDppVjty5Kji4yYMNf9BJ77D4+U
        fZwJLXexVlgX4OIm5tpjQOBWlesy9sglGGsg/GTrTDEa3vG+vLFBNJ3LfoCPASTR
        7FMuR/9BinuWwuiIU3I7noDRaXDkDGB6ujGnhjImHq+ko56PfMvmY2iPdMlhdHYw
        ==
X-ME-Sender: <xms:jHqhXwYlLH7OJ7-xHDIJ_C-aQJ5E1YB6xZUknKYtkUviDaiv7g7Tww>
    <xme:jHqhX7ZDjf-FFKXduAK0zEY-piwGu9Vi7xnx-2mNt6rjZpmuMWm9yJm1sPiOMGCWn
    ohj1eyyVicsdA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgjeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:jHqhX6-wI_HV2l1-xhnuDkA_pGHyxXGCH786z0ASpnm7L283MG0LDQ>
    <xmx:jHqhX6rgJqW9jNPprxphFkVp5b64chf0EHZM349KUIhvlAS-6dfRkA>
    <xmx:jHqhX7ooYgTDR5F0KaF06TWmRUpRh4XB4qnXhpXF9Ct5D5HEuL4KXQ>
    <xmx:jHqhXy3Tn63UxB_IeHxpkzfUGDIben8uaFrzhPOK3Br3a16t1dLVbQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 498BA328005D;
        Tue,  3 Nov 2020 10:43:08 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/amd/display: Fix ODM policy implementation" failed to apply to 5.9-stable tree
To:     Wesley.Chalmers@amd.com, Aric.Cyr@amd.com,
        alexander.deucher@amd.com, qingqing.zhuo@amd.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 16:44:02 +0100
Message-ID: <16044182424102@kroah.com>
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

From 25b315817216eaac93ca880d736b359ababae61a Mon Sep 17 00:00:00 2001
From: Wesley Chalmers <Wesley.Chalmers@amd.com>
Date: Tue, 8 Sep 2020 16:22:25 -0400
Subject: [PATCH] drm/amd/display: Fix ODM policy implementation

[WHY]
Only the leftmost ODM pipe should be offset when scaling. A previous
code change was intended to implement this policy, but a section of code
was overlooked.

Signed-off-by: Wesley Chalmers <Wesley.Chalmers@amd.com>
Reviewed-by: Aric Cyr <Aric.Cyr@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: <stable@vger.kernel.org>

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index 4cea9344d8aa..e430148e47cf 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -785,14 +785,15 @@ static void calculate_recout(struct pipe_ctx *pipe_ctx)
 	/*
 	 * Only the leftmost ODM pipe should be offset by a nonzero distance
 	 */
-	if (!pipe_ctx->prev_odm_pipe)
+	if (!pipe_ctx->prev_odm_pipe) {
 		data->recout.x = stream->dst.x;
-	else
-		data->recout.x = 0;
-	if (stream->src.x < surf_clip.x)
-		data->recout.x += (surf_clip.x - stream->src.x) * stream->dst.width
+		if (stream->src.x < surf_clip.x)
+			data->recout.x += (surf_clip.x - stream->src.x) * stream->dst.width
 						/ stream->src.width;
 
+	} else
+		data->recout.x = 0;
+
 	data->recout.width = surf_clip.width * stream->dst.width / stream->src.width;
 	if (data->recout.width + data->recout.x > stream->dst.x + stream->dst.width)
 		data->recout.width = stream->dst.x + stream->dst.width - data->recout.x;

